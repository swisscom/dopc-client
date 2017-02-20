#
# DOPc CLI Command Exec
#
require 'table_print'

module Dopc
  module Cli
    def self.print_execs(execs)
      execs = [execs] unless execs.kind_of?(Array)
      tp.set :max_width, 1000
      tp(execs)
    end

    def self.command_exec(base)
      base.class_eval do
        desc 'Manage plan executions'
        command :execution do |c|
          c.desc 'List all executions'
          c.command :list do |sc|
            sc.action do |global_options, options, args|
              response = api(global_options, :get, 'executions')
              print_execs(response)
            end
          end
          c.arg '<execution_id>'
          c.desc 'Get an executions'
          c.command :get do |sc|
            sc.action do |global_options, options, args|
              execution = args[0]
              help_now!('Specify an execution to get') unless execution
              response = api(global_options, :get, "executions/#{execution}")
              print_execs(response)
            end
          end
          c.arg '<execution_id>'
          c.desc "Get an execution's log"
          c.command :log do |sc|
            sc.action do |global_options, options, args|
              execution = args[0]
              help_now!('Specify an execution to get the log from') unless execution
              response = api(global_options, :get, "executions/#{execution}/log")
              puts response
            end
          end
          c.arg '<execution_id>'
          c.desc 'Remove an execution, does only work if it\'s not running'
          c.command :remove do |sc|
            sc.action do |global_options, options, args|
              execution = args[0]
              help_now!('Specify an execution to remove') unless execution
              response = api(global_options, :delete, "executions/#{execution}")
              puts "Removed execution '#{response['id']}'"
              print_execs(response)
            end
          end
          c.desc 'Clear executions'
          c.command :clear do |sc|
            sc.flag [:s, :status], :multiple => true, :desc => 'Remove only executions with this status(es)', :default_value => 'done'
            sc.flag [:p, :plan], :desc => 'Remove only executions of this plan'
            sc.flag [:a, :age], :desc => 'Remove only executions created at least <age> seconds ago'
            sc.action do |global_options, options, args|
              payload = {statuses: Array(options[:status])}
              payload.merge!({plan: options[:plan]}) if options[:plan]
              payload.merge!({age: Integer(options[:age])}) if options[:age]
              response = api(global_options, :delete, "executions", payload)
              puts "Removed executions:"
              print_execs(response)
            end
          end
          command_exec_task(c, :setup,    'Setup a plan (deploy nodes and run steps)')
          command_exec_task(c, :teardown, 'Teardown a plan (Undeploy nodes and reset step state)')
          command_exec_task(c, :deploy,   'Deploy the nodes of a plan')
          command_exec_task(c, :undeploy, 'Undeploy the nodes of a plan')
          command_exec_task(c, :run,      'Run the steps in a plan')
        end
      end
    end

    def self.command_exec_task(c, task, desc)
      c.arg_name '<plan_name>'
      c.desc desc
      c.command task do |sc|
        command_exec_run_options(sc) if [:run, :setup].include?(task)
        command_exec_undeploy_options(sc) if [:undeploy, :teardown].include?(task)
        DopCommon::Cli.node_select_options(sc)
        sc.action do |global_options, options, args|
          name = args[0]
          options[:run_for_nodes] = DopCommon::Cli.parse_node_select_options(options).to_h
          help_now!('Specify a plan name') unless name
          payload = {plan: name, task: task, run_options: options}
          response = api(global_options, :post, "executions", payload)
          puts "Added execution '#{response['id']}'"
        end
      end
    end

    def self.command_exec_run_options(sc)
      sc.desc 'Show only stuff the run would do but don\'t execute commands (verify commands will still be executed)'
      sc.default_value false
      sc.switch [:noop, :n]

      sc.desc 'Select the step set to run (if nothing is specified it will try to run the step set "default")'
      sc.default_value 'default'
      sc.arg_name 'STEPSET'
      sc.flag [:step_set, :s]
    end

    def self.command_exec_undeploy_options(sc)
      sc.desc 'Remove data disks from the state and cloud provider.'
      sc.switch [:rmdisk, :r], :default_value => false
    end

  end
end
