require 'json'
require 'rest-client'
require 'openssl'

class DopcClient
  class ApiClient

    def initialize(options)
      @options = options
      raise 'API endpoint has to be spezified!' unless options[:endpoint]
      raise 'API version does not exist' unless [1].include?(options[:api_version])
      raise 'Invalid authentication  method' unless [:token].include? options[:auth_method]
      if options[:auth_method] == :token
        raise 'You have to provide an auth token' unless options[:auth_token]
      end
    end

    def url(path)
      "#{@options[:endpoint]}/api/v#{@options[:api_version]}#{'/' unless path.start_with?('/')}#{path}"
    end

    def headers(opts = {})
      headers = {accept: :json, content_type: :json}
      headers.merge!({authorization: "Token token=\"#{@options[:auth_token]}\""}) if @options[:auth_method] == :token
      headers.merge(opts)
    end

    def request(method, path, payload = nil)
      response = RestClient::Request.execute(
        method:     method,
        url:        url(path),
        headers:    headers,
        payload:    (payload ? payload.to_json : nil),
        verify_ssl: (@options[:verify_ssl] ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE),
      )
      body = response.body
      body.empty? ? {} : JSON.parse(body)
    rescue RestClient::Exception => e
      resp = e.response
      error = e.to_s
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
      end
      raise error
    end

  end
end
