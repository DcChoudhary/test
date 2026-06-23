#!/usr/bin/env ruby

require_relative '../command_processor'

processor = CommandProcessor.new

loop do
  print '> '
  command, *args = gets.chomp.split(' ')
  next if command.nil?
  break if command == 'exit'

  processor.process(command, args)
end
