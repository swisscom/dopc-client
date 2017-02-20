#
# DOPc CLI Command Plan
#

module Dopc
  module Cli

    def self.command_plan(base)
      base.class_eval do
        desc 'Manage plans'
        command :plan do |c|
          c.desc 'List all plans'
          c.command :list do |sc|
            sc.action do |global_options, options, args|
              response = api(global_options, :get, 'plans')
              response['plans'].each{|p| puts p['name'] }
            end
          end
          c.arg '<plan_name>'
          c.desc 'Get a plan'
          c.command :get do |sc|
            sc.flag [:v, :version], :desc => 'Get specific version of plan (if not specified then get latest version)'
            sc.action do |global_options, options, args|
              plan = args[0]
              help_now!('Specify plan to retrieve') unless plan
              payload = options[:v] ? {version: options[:v]} : nil
              response = api(global_options, :get, "plans/#{plan}", payload)
              content = Base64.decode64(response['content'])
              puts content
            end
          end
          c.arg '<plan_name>'
          c.desc 'Get version list of a plan'
          c.command :versions do |sc|
            sc.action do |global_options, options, args|
              plan = args[0]
              help_now!('Specify plan to retrieve') unless plan
              response = api(global_options, :get, "plans/#{plan}/versions")
              response['versions'].each{|v| puts v['name']}
            end
          end
          c.arg '<file>'
          c.desc 'Add a plan from file'
          c.command :add do |sc|
            sc.action do |global_options, options, args|
              file = args[0]
              help_now!('Specify plan file to add') unless file
              content = Base64.encode64(DopCommon::PreProcessor.load_plan(file))
              payload = {content: content}
              response = api(global_options, :post, 'plans', payload)
              puts "Added plan '#{response['name']}'"
            end
          end
          c.arg '<plan_name_or_file>'
          c.desc 'Update a plan from a file'
          c.command :update do |sc|
            sc.switch [:c, :clear], :desc => 'Remove current DOPi state and start with clean state'
            sc.switch [:i, :ignore], :desc => 'Ignore update and just set new version'
            sc.action do |global_options, options, args|
              plan = args[0]
              help_now!('Specify plan name or file to update from') unless plan
              if File.file?(plan)
                content = Base64.encode64(DopCommon::PreProcessor.load_plan(file))
                payload = {content: content}
              else
                payload = {plan: plan}
              end
              payload['clear'] = true if options[:clear]
              payload['ignore'] = true if options[:ignore]
              response = api(global_options, :put, 'plans', payload)
              puts "Updated plan '#{response['name']}'"
            end
          end
          c.arg '<plan_name>'
          c.desc 'Delete a plan'
          c.command :delete do |sc|
            sc.action do |global_options, options, args|
              plan = args[0]
              help_now!('Specify plan to delete') unless plan
              response = api(global_options, :delete, "plans/#{plan}")
              puts "Deleted plan '#{response['name']}'"
            end
          end
          c.arg '<plan_name>'
          c.desc 'Reset the state of a plan'
          c.command :reset do |sc|
            sc.switch [:f, :force], :desc => "Force state reset"
            sc.action do |global_options, options, args|
              plan = args[0]
              help_now!('Specify plan to reset') unless plan
              response = api(global_options, :put, "plans/#{plan}/reset", {force: options[:force]})
            end
          end
          c.arg '<plan_name>'
          c.desc 'Get the current run state of a plan'
          c.command :state do |sc|
            sc.action do |global_options, options, args|
              plan = args[0]
              help_now!('Specify plan to get state from') unless plan
              response = api(global_options, :get, "plans/#{plan}/state")
              puts response['state']
            end
          end
        end
      end
    end

  end
end
