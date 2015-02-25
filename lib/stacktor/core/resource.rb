module Stacktor

  module Core

    class Resource

      attr_accessor :data, :client

      def initialize(data, client, opts={})
        @client = client
        self.handle_data(data, opts)
      end

      def handle_data(data, opts={})
        if data.is_a?(String)
          data = JSON.parse(data)
        end
        @data = data || {}
        @options = opts
        @options[:headers] ||= {}
      end

      def [](field)
        @data[field.to_s] || @options[:headers][field.to_s]
      end
      def []=(field,val)
        @data[field.to_s]=val
      end

      def headers
        @options[:headers]
      end

      def method_missing(method, *args, &block)
        return self[method]
      end

    end

  end

end
