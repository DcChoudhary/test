# Accessing the command line arguments
filename = ARGV[0]

puts "Processing file #{filename}"

# Handling multiple arguments
ARGV.each_with_index do |arg, index|
  puts "Argument #{index + 1}: #{arg}"
end

# handling mutiple arguments without loop
first = ARGV[0]
second = ARGV[1]
third = ARGV[2]

puts "first argument: #{first}"
puts "Second argument: #{second}"
puts "Third argument:  #{third}"

##
# Handling the CLI arguments with optparse(OptionParser)
# Use optparse for the complex CLI tools
require 'optparse'

options = {}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: command_lin_argument.rb [options]'

  opts.on('-f FILE', '--file', 'File name') do |file|
    options[:file] = file
  end
end

parser.parse!

begin
  raise OptionParser::MissingArgument, '--file' unless options[:file]
rescue OptionParser::ParseError => e
  puts e.message
  puts parser
  exit 1
end
puts options

##
# Another example
#

require 'optparse'

options = { verbose: false, count: 1 }

OptionParser.new do |opts|
  opts.on('-v', '--verbose', 'Increase verbosity') do |v|
    options[:verbose] = v
  end

  opts.on('-c N', '--count=N', Integer, 'Repeat N times') do |n|
    options[:count] = n
  end
end.parse!

puts "Running #{options[:count]} times" if options[:verbose]
