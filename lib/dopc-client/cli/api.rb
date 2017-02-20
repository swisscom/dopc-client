module Dopc
  module Cli

    def self.api(options, method, path, payload = nil)
      client = Dopc::ApiClient.new(options[:url], options[:api], options[:auth_token], options[:insecure])
      begin
        body = client.request(method, path, payload)
        return body.empty? ? {} : JSON.parse(body)
      rescue RestClient::Exception => e
        resp = e.response
        if resp
          error = "HTTP #{resp.code}"
          if resp.body and !resp.body.empty?
            begin
              json = JSON.parse(resp.body)
              error += ": #{json['error']}" if json.has_key?('error')
            rescue JSON::ParserError
              error += ": #{resp.body.to_s}"
            end
          else
            error += ": #{resp.inspect}"
          end
        else
          error = e.to_s
        end
        exit_now!(error, 1)
      end
    end

  end
end
