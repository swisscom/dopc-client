#
# DOPi CLI gloable options
#

class DopcClient
  module Cli

    def self.global_options(base)
      base.class_eval do
        desc 'URL where DOPc service runs'
        default_value 'http://localhost:3000'
        arg_name 'endpoint'
        flag [:e, :endpoint]

        desc 'API version to use when talking to DOPc service'
        default_value 1
        arg_name 'api_version'
        flag [:a, :api_version]

        desc 'Authentication token to use with DOPc service'
        default_value ''
        arg_name 'auth_token'
        flag [:o, :auth_token], :mask => true

        desc 'Verify peer certificate when doing SSL'
        default_value true
        switch [:i, :verify_ssl]
      end
    end

  end
end
