print 'Enter a number'

n = gets.to_i

begin
  result = 100 / n
rescue ZeroDivisionError => e
  puts e.message
  puts 'Your number did not work,  was it zero???'
  exit
end

puts "100/#{n} is #{result}"

def open_file
  print 'Enter the name of file you want to open'

  filename = gets.chomp
  begin
    fh = File.open(filename)
  rescue StandardError
    puts "Couldn't open your file"
    return
  end
  yield fh
  fh.close
end

def fussy_method(x)
  raise 'I need a number under 10' if x > 10

  puts "#{x} is pass as an argument"
end

begin
  fussy_method(20)
rescue StandardError => e
  puts e.inspect
  puts e.class
  puts e.backtrace
  puts 'That was not an acceptable number'
end
