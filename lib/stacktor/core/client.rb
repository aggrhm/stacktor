module Stacktor

  module Core

    class Client

      def initialize(options={})
        @settings = options
      end

      def settings
        @settings
      end

      def before_request(&block)
        @before_request_fn = block
      end

      def url
        @settings[:url]
      end

      def url=(val)
        @settings[:url] = val
      end

      ##
      # Executes request, running any handlers beforehand
      # and setting headers as necessary
      #
      # params:
      #   req - request to process
      def execute_request(opts)
        if !@before_request_fn.nil?
          @before_request_fn.call(opts, self)
        end
        opts[:url] = self.url + opts[:path]
        opts[:headers] = build_headers.merge( (opts[:headers] || {}) )
        req = Request.new(opts)
        resp = req.execute
      end

      def build_headers
        {}
      end

    end

  end

end
