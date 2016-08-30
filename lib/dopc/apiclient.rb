require 'json'
require 'rest-client'

module Dopc
  class ApiClient

    def initialize(base_url, api_version)
      @base_url = base_url
      @api_version = api_version
    end

    def url(path)
      "#{@base_url}/api/v#{@api_version}#{'/' unless path.start_with?('/')}#{path}"
    end

    def headers(headers = {})
      {accept: :json, content_type: :json}.merge headers
    end

    def request(method, path, payload = {})
      response = RestClient::Request.execute(method: method, url: url(path), headers: headers, payload: payload.to_json)
      return response.body
    end

  end
end
