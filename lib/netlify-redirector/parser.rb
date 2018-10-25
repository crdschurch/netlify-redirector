module NetlifyRedirector
  class Parser

    attr_accessor :output, :src, :dest, :csv, :debug, :redirs

    def initialize(dest_dir=nil)
      FileUtils.mkdir_p dest_dir unless dest_dir.nil?
      @dest = File.join(dest_dir || Dir.pwd, '_redirects')
      @src = File.join(Dir.pwd, 'redirects.csv')
      @redirs = []
      @total = 0
      @debug = true
      setup()
    end

    def setup
      @csv = CSV.read(src)
      @redirs = @csv.collect do |row|
        Redirect.new(row)
      end
    end

    def write!
      log "Writing _redirects...", :green
      @output = File.new(@dest, "w")
      @redirs.each do |redir|
        if redir.context_included?
          printf colorized_s, redir.path, redir.dest, redir.status if @debug
          @output.puts(redir.to_s)
        else
          log "\s\s#{redir.error}", :red
        end
        @total += 1
      end
      @output.close
      log "#{@total} rows written to _redirects file", :green
    end

    private

      # Returns the length of the longest lines in our CSV
      # so we can format the build output real nice
      def tabs
        [
          Redirect.replace(@csv.collect(&:first).max_by(&:length)).length + 3,
          Redirect.replace(@csv.collect{|row| row.drop(1).each_slice(2).map(&:first) }.flatten.max_by(&:length)).length + 15
        ]
      end

      def colorized_s
        ColorizedString.new("\s\s%-#{tabs[0]}s %-#{tabs[1]}s %s\n").send(:yellow)
      end

      def log(str, color=nil)
        if @debug
          STDOUT.write color ? ColorizedString.new(str).send(color) : str
          STDOUT.write("\n")
        end
      end

  end
end