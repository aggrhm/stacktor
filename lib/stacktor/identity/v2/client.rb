
module Stacktor

  module Identity

    module V2

      class Client < Stacktor::Core::Client

        def authenticate_token(opts)
          path = "/tokens"
          data = {
            auth: {
              tenantId: opts[:tenant_id],
              passwordCredentials: {
                username: opts[:username],
                password: opts[:password]
              }
            }
          }
          resp = self.execute_request(
            path: path,
            method: "POST",
            data: data
          )
          parse_token(resp)
          return resp
        end

        private

        def build_headers
          {
            'Content-Type' => 'application/json'
          }
        end

        def parse_token(resp)
          if resp[:success]
            resp[:token] = Token.new(resp[:body], self)
          end
        end

      end

    end

  end

end
