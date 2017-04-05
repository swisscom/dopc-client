require 'dop_common'
require 'dopc-client/version'
require 'dopc-client/api_client'
require 'dopc-client/plan'
require 'dopc-client/exec'

class DopcClient

  # This initializes a new client for a dopc endpoint which
  # is specified in the options hash. Valid options are:
  #
  # {
  #   :endpoint    => 'dopc.example.com', # (required) dopc endpoint url
  #   :api_version => 1,                  # (optional) api version (default is: 1)
  #   :auth_method => :token,             # (optional) only simple :token method available for now (default: :token)
  #   :auth_token  => 'mysecret',         # (required if auth_method='token') auth token
  #   :verify_ssl  => true,               # (optional) verify ssl cert (default is: true)
  # }
  #
  def self.connection(options)
    defaults = {
      :endpoint    => 'http://localhost:3000',
      :api_version => 1,
      :auth_method => :token,
      :verify_ssl  => :true,
    }
    @api_client = DopcClient::ApiClient.new(defaults.merge(options))
  end

end
