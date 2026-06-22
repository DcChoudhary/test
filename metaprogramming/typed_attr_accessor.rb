# frozen_string_literal: true

##
# This module creates getter and setter for the given attributes with the type check at the time of value setting.
module TypedAttrAccessor
  def typed_attr_accessor(name, type = nil)
    raise ArgumentError, 'Please pass the attribute name' if name.empty?
    raise ArgumentError, 'Please pass the type as well' if type.nil?

    # Getter
    define_method(name) do
      instance_variable_get("@#{name}")
    end

    define_method("#{name}=") do |val|
      raise TypeError, "Expected #{type}, got #{val.class}" unless val.is_a?(type)

      instance_variable_set("@#{name}", val)
    end
  end
end


class User
  extend TypedAttrAccessor

  typed_attr_accessor :name, String
  typed_attr_accessor :age, Integer
  typed_attr_accessor :hobbies, Array
end

user = User.new

print 'Enter user name: '
user.name = gets.chomp

print 'Enter user age: '
user.age = gets.chomp.to_i

print 'Enter hobbies(multiple values accepted separated by space): '
user.hobbies = gets.chomp.split(' ')

# user.name = 'Foo'
# user.age = 40
# user.hobbies = %w[footbal coding]

puts user.inspect
