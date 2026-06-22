#!/usr/bin/env ruby

# Run the command and get the result
output = `ls -alh`
puts output

# Or use the system method for more control
system('ls', '-la')

if $?.success?
  puts 'command succeeded'
else
  puts $?.inspect
  puts "command failed with status #{$?.exitstatus}"
end

# Using the open3 library
# For more control over command execution

require 'open3'

stdout, stderr, status = Open3.capture3('ls', '-alh')

if status.success?
  puts "command suceeded with #{stdout}"
else
  puts "Command failed with status #{status}, and error #{stderr}"
end
