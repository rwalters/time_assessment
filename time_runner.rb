#!/usr/bin/env ruby

require_relative 'time_helper'

current_time = ARGV[0]
minutes_to_add = ARGV[1]

puts TimeHelper.AddMinutes(current_time, minutes_to_add)
