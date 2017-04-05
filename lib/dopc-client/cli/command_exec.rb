#
# DOPc CLI Command Exec
#
require 'table_print'

class DopcClient
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
              execs = Exec.list
              print_execs(execs)
            end
          end

          c.arg '<execution_id>'
          c.desc 'Get an executions'
          c.command :get do |sc|
            sc.action do |global_options, options, args|
              id = args[0]
              help_now!('Specify an execution id to get') unless id
              plan_exec = Exec.get(id).show
              print_execs(plan_exec)
            end
          end

          c.arg '<execution_id>'
          c.desc "Get an execution's log"
          c.command :log do |sc|
            sc.action do |global_options, options, args|
              id = args[0]
              help_now!('Specify an execution to get the log from') unless id
              puts Exec.get(id).log
            end
          end

          c.arg '<execution_id>'
          c.desc 'Remove an execution, does only work if it\'s not running'
          c.command :remove do |sc|
            sc.action do |global_options, options, args|
              id = args[0]
              help_now!('Specify an execution to remove') unless id
              Exec.get(id).remove
              puts "Removed execution '#{@id}'"
            end
          end

          c.desc 'Clear executions'
          c.command :clear do |sc|
            sc.flag [:s, :status],
              :multiple      => true,
              :desc          => 'Remove only executions with this status(es)',
              :default_value => 'done'
            sc.flag [:p, :plan],
              :desc => 'Remove only executions of this plan'
            sc.flag [:a, :age],
              :desc => 'Remove only executions created at least <age> seconds ago'
            sc.action do |global_options, options, args|
              opts = {}
              opts[:statuses] = Array(options[:status])
              opts[:plan]     = options[:plan] if options[:plan]
              opts[:age]      = Integer(options[:age]) if options[:age]
              execs = Exec.clear(opts)
              puts "Removed executions:"
              print_execs(execs)
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
          plan_name = args[0]
          help_now!("Specify plan to execute #{task}") unless plan_name
          options[:run_for_nodes] = DopCommon::Cli.parse_node_select_options(options).to_h
          plan_exec = Exec.add(plan_name, task, options)
          puts "Added #{task} execution with id '#{plan_exec.id}'"
          print_execs(plan_exec.show)
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
