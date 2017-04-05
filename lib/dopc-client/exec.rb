#
# This class implements the manipulation of plans via the api
#
require 'base64'

class DopcClient
  class Exec < DopcClient

    def self.list
      @api_client.request(:get, 'executions')
    end

    def self.add(plan_name, task, options)
      payload = {plan: plan_name, task: task, run_options: options}
      id = @api_client.request(:post, "executions", payload)['id']
      get(id)
    end

    # removes multiple execs
    #
    # options:
    # {
    #   :statuses => ['done', 'new', ..], # exec states to remove
    #   :plan     => 'myplan',            # only remove for plan state
    #   :age      => 123,                 # older than amount of seconds ago
    # }
    def self.clear(options = {})
      @api_client.request(:delete, "executions", options)
    end

    def self.get(id)
      Exec.new(@api_client, id)
    end

    attr_reader :id

    def initialize(api_client, id)
      @api_client = api_client
      @id         = id
    end

    def show
      @api_client.request(:get, "executions/#{@id}")
    end

    def log
      response = @api_client.request(:get, "executions/#{@id}/log")
      response['log']
    end

    def remove
      @api_client.request(:delete, "executions/#{@id}")
    end

  end
end
