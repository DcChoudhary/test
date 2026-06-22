class InvalidLineError < StandardError; end

def line_from_file(filename, pattern)
  fh = File.open(filename)
  begin
    line = fh.gets
    # we are matching the string with the regular expression i is used for case in-sensetive
    raise InvalidLineError, 'Invalid line' unless line.match?(/#{pattern}/i)
  ensure
    fh.close
  end
  line
end

begin
  line_from_file(filename, pattern)
rescue InvalidLineError => e
  puts e.message
  exit 1
end
