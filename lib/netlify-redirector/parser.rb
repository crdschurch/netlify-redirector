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
      log "Writing _redirects..."
      @output = File.new(@dest, "w")
      @redirs.each do |redir|
        if redir.context_included?
          log redir.to_s if @debug
          @output.puts(redir.to_s)
        else
          log "\s\s#{redir.error}"
        end
        @total += 1
      end
      @output.close
      log "#{@total} rows written to #{@dest} file"
    end

    private

    def log(str)
        if @debug
          puts "#{str}\n"
        end
      end

  end
end