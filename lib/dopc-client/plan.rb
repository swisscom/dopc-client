#
# This class implements the manipulation of plans via the api
#
require 'base64'

class DopcClient
  class Plan < DopcClient

    # will return an array of plan names in the remote plan store
    def self.list
      response = @api_client.request(:get, 'plans')
      response['plans'].map{|p| p['name'] }
    end

    # upload and add a local plan file to the remote plan store
    def self.add(plan)
      payload = {content: Base64.encode64(render(plan))}
      plan_name = @api_client.request(:post, 'plans', payload)['name']
      get(plan_name)
    end

    def self.render(plan)
      if File.file?(plan)
        DopCommon::PreProcessor.load_plan(plan)
      elsif plan.kind_of?(Hash)
        plan.to_s
      else
        plan
      end
    end

    # upload a local plan file to the remote plan store and update an
    # existing plan
    #
    # plan can be a file a string or a hash
    #
    # options {
    #   :clear  => false  # remove all dopi state information
    #   :ignore => false  # don't try to update the state and just update the version number
    # }
    #
    def self.update(plan, options = {})
      payload = options.merge({content: Base64.encode64(render(plan))})
      plan_name = @api_client.request(:put, 'plans', payload)['name']
      get(plan_name)
    end

    # will return a plan object for a plan in the remote plan store
    def self.get(plan_name)
      Plan.new(@api_client, plan_name)
    end

    attr_reader :name

    def initialize(api_client, name)
      @api_client = api_client
      @name       = name
    end

    def versions
      @api_client.request(:get, "plans/#{@name}/versions")['versions']
    end

    def show(version = nil)
      payload = {:version => version}
      response = @api_client.request(:get, "plans/#{@name}", payload)
      Base64.decode64(response['content'])
    end

    # TODO: implement
    def diff(from, to = :latest)
    end

    # TODO: implement node state
    # TODO: implement dopv state
    def state(node = :all)
      response = @api_client.request(:get, "plans/#{@name}/state")
      response['state']
    end

    def reset(force = false)
      payload = {force: force}
      @api_client.request(:put, "plans/#{@name}/reset", payload)
    end

    # TODO: implement
    def export_state(state_file)
    end

    # TODO: implement
    def import_state(state_file)
    end

    # TODO: implement
    def exec(method, run_options = {})
    end

    def remove
      @api_client.request(:delete, "plans/#{@name}")
    end

    def exec(task, options)
      Exec.add(@name, task, options)
    end

  end
end
