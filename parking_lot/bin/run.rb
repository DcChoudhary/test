#!/usr/bin/env ruby

require_relative '../command_processor'

processor = CommandProcessor.new
loop do
  print '> '
  command, *args = gets.chomp.split(' ')
  break if command.nil? || command == 'exit'

  begin
    processor.process(command, args)
  rescue CommandProcessor::InvalidCommandError => e
    puts e.message
  end
end
