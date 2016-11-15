require 'time'

module Dopc::Util

  def self.ago(time)
    ago = Time.now - Time.parse(time)
    secs = ago.to_int
    mins = secs / 60
    hours = mins / 60
    days = hours / 24
    if days > 0
      "#{days}d"
    elsif hours > 0
      "#{hours}h"
    elsif mins > 0
      "#{mins}m"
    else
      "#{secs}s"
    end
  end

end
