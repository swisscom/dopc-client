require 'time'

module Dopc::Util

  def self.duration(t1, t2 = Time.now)
    t1 = Time.parse(t1) if t1.is_a?(String)
    t2 = Time.parse(t2) if t2.is_a?(String)
    ago = t2 - t1
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

  def self.pretty_time(t)
    t = Time.parse(t) if t.is_a?(String)
    ago = Time.now - t
    days = ago / (24*3600)
    if days > 365
      t.strftime('%Y-%m-%d')
    elsif days > 1
      t.strftime('%m-%d %H:%M:%S')
    else
      t.strftime('%H:%M:%S')
    end
  end

end
