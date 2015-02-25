require 'net/http'

module Stacktor

  module Core

    class Request

      def self.connection_for(uri)
        @connections ||= {}

        host = uri.host
        port = uri.port
        secure = uri.scheme == 'https'

        if @connections[ [host, port, secure] ].nil?
          c = Net::HTTP.new(host, port)
          c.use_ssl = secure
          c.verify_mode = OpenSSL::SSL::VERIFY_NONE
          c.start
          @connections[ [host, port, secure] ] = c
        else
          c = @connections[ [host, port, secure] ]
        end
        return c
      end

      def initialize(opts)
        @options = opts
      end

      def options
        @options
      end

      def url
        @options[:url]
      end
      def method
        @options[:method]
      end
      def headers
        @options[:headers]
      end
      def data
        @options[:data]
      end
      def response=(resp)
        @resp = resp
      end
      def response
        @resp
      end
      def do_stream_response?
        !@options[:response_handler].nil?
      end

      def success?
        @resp && !@resp.code.match(/^20.$/).nil?
      end


      def execute
        data = self.data
        uri = URI(self.url)
        conn = self.class.connection_for(uri)
        req_kls = Net::HTTP.const_get(self.method.capitalize)
        headers = self.headers
        resp_fn = @options[:response_handler]

        if self.method == "GET"
          uri.query = data.to_query unless data.nil?
          req = req_kls.new(uri.request_uri, headers)
        else
          data_reg = data_stream = nil
          if data.is_a?(Hash)
            data_reg = data.to_json
          elsif data.respond_to?(:read)
            data_stream = data
            headers['Content-Length'] = data.size.to_s
          else
            data_reg = data
          end
          req = req_kls.new(uri.path, headers)
          req.body_stream = data_stream unless data_stream.nil?
          req.body = data_reg unless data_reg.nil?
        end
        if resp_fn.nil?
          @resp = conn.request(req)
        else
          @resp = conn.request(req) do |r|
            r.read_body do |bytes|
              resp_fn.call(bytes)
            end
          end
        end
        return self.to_response_hash
      end

      def to_response_hash
        return nil if @resp.nil?
        success = self.success?
        ret = {success: success, code: @resp.code, request: self, response: @resp}
        if self.do_stream_response? && success
          ret[:body] = nil
        else
          ret[:body] = @resp.body
        end
        return ret
      end

    end

  end

end
