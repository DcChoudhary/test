#!/usr/bin/env ruby

require_relative '../command_processor'

processor = CommandProcessor.new

loop do
  print '>'

  input = gets
  break if input.nil?

  command, *args = input.chomp.split
  next if command.nil?
  break if command == 'exit'

  processor.process(command, args)
end
