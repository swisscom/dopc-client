#
# DOPi CLI gloable options
#

module Dopc
  module Cli

    def self.global_options(base)
      base.class_eval do
        desc 'URL where DOPc service runs'
        default_value 'http://localhost:3000'
        arg_name 'url'
        flag [:u, :url]

        desc 'API version to use when talking to DOPc service'
        default_value '1'
        arg_name 'api'
        flag [:a, :api]

        desc 'Authentication token to use with DOPc service'
        default_value ''
        arg_name 'token'
        flag [:t, :auth_token], :mask => true

        desc 'Do not verify peer certificate when doing SSL'
        switch [:i, :insecure]

        desc 'Show debug output'
        switch [:d, :debug]

        desc 'Show stacktrace on crash'
        switch [:trace]
      end
    end

  end
end
