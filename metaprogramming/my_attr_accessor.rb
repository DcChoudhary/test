# frozen_string_literal: true

##
# This module is responsible for create getter and setter of the provided attrs
module MyAttrAccessor
  def my_attr_accessor(*args)
    raise ArgumentError, 'Please pass atleast one attribute' if args.empty?

    args.each do |arg|
      # setter
      define_method("#{arg}=") do |val|
        instance_variable_set("@#{arg}", val)
      end

      # getter
      define_method(arg) do
        instance_variable_get("@#{arg}")
      end
    end
  end
end

class User
  extend MyAttrAccessor

  my_attr_accessor :name, :email
end

user = User.new
user1 = User.new

user.name = 'Foo'
user.email = 'foo@example.com'

user1.name = 'Bar'
user1.email = 'bar@example.com'

puts user.name
puts user.email

puts user1.name
puts user1.email
