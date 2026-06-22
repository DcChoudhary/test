require 'logger'

class InvalidLineError < StandardError; end

def line_from_file(filename, pattern)
  File.foreach(filename) do |line|
    return line.chomp if line.match?(/#{pattern}/i)
  end

  raise InvalidLineError,
        "Pattern '#{pattern}' not found in file '#{filename}'"
end

if ARGV.size < 2
  warn 'Usage: ruby line_from_file.rb <filename> <pattern>'
  exit(1)
end

filename, pattern = ARGV

if filename.strip.empty? || pattern.strip.empty?
  warn 'Please pass both filename and pattern'
  exit(1)
end

# Don't required in the samll script, put it here just for practice
logger = Logger.new($stdout)
logger.info("Start processing file: #{filename}")

begin
  puts line_from_file(filename, pattern)
rescue Errno::ENOENT, InvalidLineError => e
  warn e.message
  exit 1
end
