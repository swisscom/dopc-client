require 'table_print'

module Dopc
  module Cli

    def self.exec_header
      ['ID', 'Plan', 'Task', 'Status', 'Created', 'Wait', 'Run', 'Options'].join(',')
    end

    def self.exec_string(hash)
      puts hash.inspect
      tp(hash)
    end

  end
end
