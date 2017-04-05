#
# DOPc CLI Command Plan
#

class DopcClient
  module Cli

    def self.command_plan(base)
      base.class_eval do
        desc 'Manage plans'
        command :plan do |c|

          c.desc 'List all plans'
          c.command :list do |sc|
            sc.action do |global_options, options, args|
              puts Plan.list
            end
          end

          c.arg '<plan_name>'
          c.desc 'Get a plan'
          c.command :get do |sc|
            sc.flag [:v, :version], :desc => 'Get specific version of plan (if not specified then get latest version)'
            sc.action do |global_options, options, args|
              plan_name = args[0]
              help_now!('Specify plan name to retrieve') unless plan_name
              puts Plan.get(plan_name).show(options[:version])
            end
          end

          c.arg '<plan_name>'
          c.desc 'Get version list of a plan'
          c.command :versions do |sc|
            sc.action do |global_options, options, args|
              plan_name = args[0]
              help_now!('Specify plan to retrieve') unless plan_name
              puts Plan.get(plan_name).versions
            end
          end

          c.arg '<file>'
          c.desc 'Add a plan from file'
          c.command :add do |sc|
            sc.action do |global_options, options, args|
              plan_file = args[0]
              help_now!('Specify plan file to add') unless plan_file
              plan_name = Plan.add(plan_file).name
              puts "Added plan '#{plan_name}' to the remote plan store"
            end
          end

          c.arg '<plan_name_or_file>'
          c.desc 'Update a plan from a file'
          c.command :update do |sc|
            sc.switch [:c, :clear], :desc => 'Remove current DOPi state and start with clean state'
            sc.switch [:i, :ignore], :desc => 'Ignore update and just set new version'
            sc.action do |global_options, options, args|
              plan_file = args[0]
              help_now!('Specify plan name or file to update from') unless plan_file
              plan_name = Plan.update(plan_file, options).name
              puts "Updated plan '#{plan_name}' in the remote plan store"
            end
          end

          c.arg '<plan_name>'
          c.desc 'remove a plan from the plan store'
          c.command :remove do |sc|
            sc.action do |global_options, options, args|
              plan_name = args[0]
              help_now!('Specify plan name to delete') unless plan_name
              Plan.get(plan_name).remove
              puts "Removed plan '#{plan_name}' from the remote plan store"
            end
          end

          c.arg '<plan_name>'
          c.desc 'Reset the state of a plan'
          c.command :reset do |sc|
            sc.switch [:f, :force], :desc => "Force state reset"
            sc.action do |global_options, options, args|
              plan_name = args[0]
              help_now!('Specify plan to reset') unless plan_name
              Plan.get(plan_name).reset
              puts "State of plan '#{plan_name}' was reset"
            end
          end
          c.arg '<plan_name>'
          c.desc 'Get the current run state of a plan'
          c.command :state do |sc|
            sc.action do |global_options, options, args|
              plan_name = args[0]
              help_now!('Specify plan to get state from') unless plan_name
              puts Plan.get(plan_name).state
            end
          end
        end
      end
    end

  end
end
