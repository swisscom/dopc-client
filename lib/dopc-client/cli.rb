#!/usr/bin/env ruby

require 'gli'
require 'dop_common'
require 'dop_common/cli/node_selection'
require 'dop_common/cli/log'
require 'dop_common/cli/global_options'
require 'dopc-client'
require 'dopc-client/cli/global_options'
require 'dopc-client/cli/print'
#require 'dopc-client/cli/command_ping'
require 'dopc-client/cli/command_plan'
require 'dopc-client/cli/command_exec'

class DopcClient
  module Cli
    include GLI::App
    extend self

    program_desc 'CLI client for DOPc. For general errors the client will exit with 1, for usage errors with 64.'
    version DopcClient::VERSION

    config_file DopCommon.config.config_file

    subcommand_option_handling :normal
    arguments :strict

    DopCommon::Cli.global_options(self)
    global_options(self)

    pre do |global,command,options,args|
      DopCommon.configure = global
      ENV['GLI_DEBUG'] = 'true' if global[:trace] == true
      DopCommon::Cli.initialize_logger('dopc-client.log', global[:log_level], global[:verbosity], global[:trace])
      RestClient.log = DopCommon.log
      DopcClient::Plan.connection(global)
      DopcClient::Exec.connection(global)
      true
    end

    #command_ping(self)
    command_plan(self)
    command_exec(self)
  end
end
