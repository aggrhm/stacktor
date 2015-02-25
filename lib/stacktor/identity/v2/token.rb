module Stacktor

  module Identity

    module V2

      class Token < Core::Resource

        def id
          self.data["access"]["token"]["id"]
        end
        def expires_at
          str = self.data["access"]["token"]["expires"]
          Time.parse(str)
        end
        def expired?
          self.expires_at < Time.now
        end

        def valid?
          !self.expired?
        end

        def endpoint_url_for_service_type(type, level=:public)
          svc = self.data['access']['serviceCatalog'].select{|s| s['type'] == type}.first
          return nil if svc.nil?
          return svc['endpoints'][0]["#{level.to_s}URL"]
        end

      end

    end

  end

end
