module Stacktor

  module Identity

    module V3

      class Token < Core::Resource

        def id
          self.headers['X-Subject-Token']
        end
        def expires_at
          str = self.data["token"]["expires_at"]
          Time.parse(str)
        end
        def expired?
          self.expires_at < Time.now
        end

        def valid?
          !self.expired?
        end

        def endpoint_url_for_service_type(type, interface=:public)
          svc = self.data['token']['catalog'].select{|s| s['type'] == type}.first
          return nil if svc.nil?
          ep = svc['endpoints'].select{|e| e['interface'] == interface.to_s}.first
          return nil if ep.nil?
          return ep['url']
        end

      end

    end

  end

end

