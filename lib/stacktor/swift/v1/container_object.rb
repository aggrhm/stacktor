module Stacktor

  module Swift

    module V1

      class ContainerObject < Core::Resource

        def name
          data['name']
        end

        def container_name
          data['container_name']
        end

        def etag
          data['hash'] || headers['ETag']
        end

        def content_length
          bytes = data['bytes'] || headers['Content-Length']
          bytes ? bytes.to_i : nil
        end

        def content_type
          type = data['content_type'] || headers['Content-Type']
          return nil if type.nil?
          return type.split(";").first
        end

        def last_modified
          t = data['last_modified'] || headers['Last-Modified']
          return nil if t.nil?
          return Time.parse(t)
        end

        def metadata
          ret = {}
          headers.each do |k,v|
            h = k.downcase.strip
            if h.start_with?("x-object-meta-")
              mk = h.split('-').last
              ret[mk] = v
            end
          end
          return ret
        end

        ## TRANSACTIONS

        def read
          result = @client.get_object_content(container_name: self.container_name, object_name: self.name)
          if result[:success]
            return result[:body]
          else
            raise result[:body]
          end
        end

        def stream(&block)
          result = @client.get_object_content(container_name: self.container_name, object_name: self.name) do |bytes|
            block.call(bytes)
          end
          if result[:success]
            return result[:body]
          else
            raise result[:body]
          end
        end

        def write_to_file(path)
          File.open(path, 'wb') do |fw|
            self.stream do |bytes|
              fw.write bytes
            end
          end
        end

        def reload
          result = @client.get_object_metadata(container_name: self.container_name, object_name: self.name)
          if result[:success]
            self.handle_data(result[:body], headers: result[:response])
          else
            raise result[:body]
          end
        end

        def delete
          result = @client.delete_object(container_name: self.container_name, object_name: self.name)
          if result[:success]
            return result
          else
            raise result[:body]
          end
        end

      end

    end

  end

end
