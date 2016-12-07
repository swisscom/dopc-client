require 'json'
require 'rest-client'
require 'openssl'

module Dopc
  class ApiClient

    def initialize(base_url, api_version, auth_token = nil, insecure = false)
      @base_url = base_url
      @api_version = api_version
      @auth_token = auth_token
      @insecure = insecure
    end

    def url(path)
      "#{@base_url}/api/v#{@api_version}#{'/' unless path.start_with?('/')}#{path}"
    end

    def headers(opts = {})
      headers = {accept: :json, content_type: :json}
      headers.merge!({authorization: "Token token=\"#{@auth_token}\""}) if @auth_token
      headers.merge(opts)
    end

    def request(method, path, payload = nil)
      response = RestClient::Request.execute(method: method, url: url(path), headers: headers, payload: (payload ? payload.to_json : nil), verify_ssl: (@insecure ? OpenSSL::SSL::VERIFY_NONE : OpenSSL::SSL::VERIFY_PEER))
      return response.body
    end

  end
end
