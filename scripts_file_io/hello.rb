#!/usr/bin/env ruby
# A simple ruby script

puts 'Hello, Automation world!'

# Reading the full file and load the full file in memory
# content = File.read('simple.txt')
# puts content

# Does not load the full file in the memory but it read line by line or chunk of file
File.open('simple.txt') do |file|
  file.each_line do |row| # file.each do |row|
    puts row
  end
end

File.foreach('simple.txt') do |line|
  puts line unless line.strip.empty?
end

# Writing into the file
# Use this when you have all the content ready, becasue write will overide the existing data

text = <<~EOT
  First line
  Second line
EOT

# File.write('simple.txt', 'Hello simple file')
File.write('simple.txt', text)

# File.open('simple.txt', 'w') do |file|
#   file.puts('This is the first line')
#   file.puts 'Second line'
#   file.puts 'Third line'
# end
