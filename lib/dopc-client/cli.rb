#!/usr/bin/env ruby

require 'gli'
require 'base64'
require 'rest-client'
require 'etc'

require 'dop_common'
require 'dop_common/cli/node_selection'
require 'dopc-client'
require 'dopc-client/cli/global_options'
require 'dopc-client/cli/api'
require 'dopc-client/cli/print'
require 'dopc-client/cli/command_ping'
require 'dopc-client/cli/command_plan'
require 'dopc-client/cli/command_exec'

module Dopc
  module Cli
    include GLI::App
    extend self

    program_desc 'CLI client for DOPc. For general errors the client will exit with 1, for usage errors with 64.'
    version Dopc::VERSION

    USER = Etc.getpwuid(Process.uid)
    CONFIG_FILE = USER.name == 'root' ? File.join('etc', 'dopc', 'dopc-client.conf') : File.join(USER.dir, '.dop', 'dopc-client.conf')

    config_file CONFIG_FILE

    subcommand_option_handling :normal
    arguments :strict

    global_options(self)

    pre do |global,command,options,args|
      ENV['GLI_DEBUG'] = 'true' if global[:trace]
      RestClient.log = 'stderr' if global[:debug]
      true
    end

    command_ping(self)
    command_plan(self)
    command_exec(self)
  end
end
