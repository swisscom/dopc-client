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
      {accept: :json}.merge headers
    end

    def request(method, path, payload = nil)
      response = RestClient::Request.execute(method: method, url: url(path), headers: headers(payload ? {content_type: :json} : {}), payload: (payload ? payload.to_json : nil))
      return response.body
    end

  end
end
