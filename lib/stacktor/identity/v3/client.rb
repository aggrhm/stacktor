module Stacktor
  module Identity
    module V3

      class Client < Stacktor::Core::Client

        def authenticate_token(opts)
          path = "/auth/tokens"
          data = {
            auth: {
              identity: {
                methods: ["password"],
                password: {
                  user: {
                    domain: {
                      name: opts[:domain] || "Default"
                    },
                    name: opts[:username],
                    password: opts[:password]
                  }
                }
              },
              scope: {
                project: {
                  id: opts[:project_id] || opts[:tenant_id]
                }
              }
            }
          }
          resp = self.execute_request(
            path: path,
            method: "POST",
            data: data
          )
          #puts resp.inspect
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
            token = Token.new(resp[:body], self)
            token.headers['X-Subject-Token'] = resp[:response]['X-Subject-Token']
            resp[:token] = token
          end
        end

      end


    end
  end
end
