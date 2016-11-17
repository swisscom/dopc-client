require 'json'
require 'rest-client'

module Dopc
  class ApiClient

    def initialize(base_url, api_version, insecure)
      @base_url = base_url
      @api_version = api_version
      @insecure = insecure
    end

    def url(path)
      "#{@base_url}/api/v#{@api_version}#{'/' unless path.start_with?('/')}#{path}"
    end

    def headers(headers = {})
      {accept: :json, content_type: :json}.merge headers
    end

    def request(method, path, payload = nil)
      response = RestClient::Request.execute(method: method, url: url(path), headers: headers, payload: (payload ? payload.to_json : nil), verify_ssl: !@insecure)
      return response.body
    end

  end
end
