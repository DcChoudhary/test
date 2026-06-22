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
