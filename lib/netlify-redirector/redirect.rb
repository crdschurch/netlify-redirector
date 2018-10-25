module NetlifyRedirector
  class Redirect
    attr_accessor :path, :dest, :status, :context

    def initialize(arr)
      @path, @dest, @status, @context = arr
    end

    def to_s
      path = self.class.replace(@path)
      dest = self.class.replace(@dest)
      "#{path}\t#{dest}\t#{@status}"
    end

    def context_included?
      @context.nil? || @context.split(',').include?(deployment_context)
    end

    def deployment_context
      if ENV['CONTEXT'].nil? || ENV['CONTEXT'] == 'production'
        ENV['BRANCH'].nil? ? self.class.git_branch : ENV['BRANCH']
      elsif ENV['CONTEXT'] == 'deploy-preview'
        # If deploy preview, build against 'development' branch
        'development'
      else
        ENV['CONTEXT']
      end
    end

    def error
      unless context_included?
        if deployment_context.nil?
          "#{@path} specified context but none was defined."
        else
          "#{@path} did not match context '#{deployment_context}'."
        end
      end
    end

    def self.replace(str)
      if matches = str.match(/(\$\{env\:(.*)})/)
        str.gsub matches[1], ENV[matches[2]]
      else
        str
      end
    rescue
      str
    end

    def self.git_branch
      `git rev-parse --abbrev-ref HEAD | tr -d '\n'`
    end

  end
end