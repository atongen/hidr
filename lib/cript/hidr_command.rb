require 'cript'
require 'optparse'

module Cript
  class HidrCommand

    attr_reader :options

    def initialize(argv)
      @argv = argv.dup

      @options = {
        mode:    nil,
        infile:  '-',
        outfile: '-',
        force:   false,
        b0:      '0',
        b1:      '1',
        debug:   false
      }

      parse!
    end

    def run!
      validate_mode
      hidr = build_hidr
      data = read_data
      get_writer do |writer|
        if @options[:mode] == 'hide'
          writer.print hidr.hide(data)
        else
          writer.print hidr.show(data)
        end
      end
    end

    private

    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: hidr [options]"

        opts.separator ""
        opts.separator "Mode:"
        opts.on("-h", "--hide", "hide mode") { @options[:mode] = 'hide' }
        opts.on("-s", "--show", "show mode") { @options[:mode] = 'show' }

        opts.separator ""
        opts.separator "Bits:"
        opts.on("-0", "--zero CHAR", "zero char (default: '#{@options[:b0]}')") { |char| @options[:b0] = char }
        opts.on("-1", "--one CHAR", "one char (default: '#{@options[:b1]}')") { |char| @options[:b1] = char }
        opts.on("-b", "--builtin BUILTIN", "built-in binary set (overrides zero and one, options: #{Cript::Hidr::CHARS.keys.join(', ')})") { |builtin| @options[:builtin] = builtin.to_s.strip.to_sym }

        opts.separator ""
        opts.separator "Files:"
        opts.on("-i", "--infile FILE", "infile (default: '#{@options[:infile]}')") { |file| @options[:infile] = file }
        opts.on("-o", "--outfile FILE", "outfile (default: '#{@options[:outfile]}')") { |file| @options[:outfile] = file }
        opts.on("-f", "--force", "force overwrite outfile (default: #{@options[:force]})") { @options[:force] = true }

        opts.separator ""
        opts.separator "Common options:"

        opts.on_tail("-D", "--debug", "Set debugging on") { @options[:debug] = true }
        opts.on_tail("-H", "--help", "Show this message") { puts opts; exit }
        opts.on_tail('-v', '--version', "Show version") { puts Cript::VERSION; exit }
      end
    end

    def parse!
      parser.parse!(@argv)
    end

    # run methods

    def validate_mode
      unless %w{ hide show }.include?(@options[:mode])
        STDERR.puts "Mode (show or hide) is required."
        exit 1
      end
    end

    def build_hidr
      if @options[:builtin]
        if Cript::Hidr::CHARS.keys.include?(@options[:builtin])
          Cript::Hidr.send(@options[:builtin])
        else
          STDERR.puts "Invalid builtin: #{@options[:builtin]}"
          exit 1
        end
      else
        Cript::Hidr.new(b0: @options[:b0], b1: @options[:b1])
      end
    end

    def read_data
      if @options[:infile] == '-'
        # requires ARGV clear
        STDIN.read
      elsif File.file?(@options[:infile])
        File.read(@options[:infile])
      else
        STDERR.puts "Invalid infile: #{@options[:infile]}"
        exit 1
      end
    end

    def get_writer
      begin
        if @options[:outfile] == '-'
          writer = STDOUT
        elsif File.file?(@options[:outfile])
          if @options[:force]
            writer = File.open(@options[:outfile], 'wb')
          else
            STDERR.puts "Not overwriting file without force"
            exit 1
          end
        else
          writer = File.open(@options[:outfile], 'wb')
        end

        yield(writer)
      rescue => e
        STDERR.puts "Error writing data: #{e}"
        exit 1
      ensure
        # clean-up
        if writer && @options[:outfile] != '-'
          writer.close
        end
      end
    end

  end
end
