#!/usr/env/bin ruby

processor = CommandProcessor.new

loop do
  print '> '
  command, *args = gets.chomp.split(' ')

  break if command.nil? || command == 'exit'

  processor.process(command, args)
end
