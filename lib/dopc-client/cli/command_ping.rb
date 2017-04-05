#
# DOPi CLI gloable options
#

class DopcClient
  module Cli

    def self.command_ping(base)
      base.class_eval do
        desc 'Ping the API'
        command :ping do |c|
          c.action do |global_options, options, args|
            response = api(global_options, :get, 'ping')
            puts response['pong']
          end
        end
      end
    end

  end
end
