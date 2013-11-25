require 'cript'
require 'optparse'

module Cript
  class CriptCommand

    attr_reader :options

    def initialize(argv)
      @argv = argv.dup

      @options = {
        mode:    nil,
        infile:  '-',
        outfile: '-',
        public:  File.join(ENV['HOME'], '.ssh/id_rsa.pub'),
        private: File.join(ENV['HOME'], '.ssh/id_rsa'),
        force:   false,
        debug:   false
      }

      parse!
    end

    def run!
      cripter = build_cripter
      data = read_data
      get_writer do |writer|
        if @options[:mode] == 'encrypt'
          writer.print cripter.encrypt(data)
        else
          writer.print cripter.decrypt(data)
        end
      end
    end

    private

    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: cript [options]"

        opts.separator ""
        opts.separator "Mode:"
        opts.on("-e", "--encrypt", "encrypt mode") { @options[:mode] = 'encrypt' }
        opts.on("-d", "--decrypt", "decrypt mode") { @options[:mode] = 'decrypt' }

        opts.separator ""
        opts.separator "Keys:"
        opts.on("--private PRIVATE", "private key path (default: #{@options[:private]})") { |priv| @options[:private] = priv }
        opts.on("--public PUBLIC", "public key path (default: #{@options[:public]})") { |pub| @options[:public] = pub }

        opts.separator ""
        opts.separator "Files:"
        opts.on("-i", "--infile FILE", "infile (default: '#{@options[:infile]}')") { |file| @options[:infile] = file }
        opts.on("-o", "--outfile FILE", "outfile (default: '#{@options[:outfile]}')") { |file| @options[:outfile] = file }
        opts.on("-f", "--force", "force overwrite outfile (default: #{@options[:force]})") { @options[:force] = true }

        opts.separator ""
        opts.separator "Common options:"

        opts.on_tail("-D", "--debug", "Set debugging on") { @options[:debug] = true }
        opts.on_tail("-h", "--help", "Show this message") { puts opts; exit }
        opts.on_tail('-v', '--version', "Show version") { puts Cript::VERSION; exit }
      end
    end

    def parse!
      parser.parse!(@argv)
    end

    # run methods

    def build_cripter
      if @options[:mode] == 'encrypt'
        Cript::Simple.new(public_key_path: @options[:public])
      elsif @options[:mode] == 'decrypt'
        Cript::Simple.new(private_key_path: @options[:private])
      else
        STDERR.puts "Mode is required (encrypt or decrypt)"
        exit 1
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
