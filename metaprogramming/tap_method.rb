# rubocop:disable all

# Implementation of the ruby tap method
class Object
  def tap
    yield(self)

    self
  end
end



# Implementation of the ruby struct class

class MyStruct
  def self.new(*attrs, &block)
    klass = Class.new do
      define_method(:initialize) do |*vals|
        attrs.zip(vals).each do |attr, val|
          instance_variable_set("@#{attr}", val)
        end
      end

      attrs.each do |attr|
        define_method(attr) { instance_variable_get("@#{attr}") }
      
        define_method("#{attr}=") do |val|
          instance_variable_set("@#{attr}", val)
        end
      end
    end

    klass.class_eval(&block) if block_given?
  end
end





# Implementation of HTML DSL 

class HTML
  self.new(&block)

  end
end





local_variable = 'local variable'


SomeKlass = Class.new do
  puts self
  puts local_variable
  
  define_method :foo do
    puts self
    puts local_variable
  end
end





class SomeKlass
  puts local_variable

  def foo
    puts local_variable
  end
end




# Rails enviroment configure class 


module TestApp
  class Application
    config = {}
    
    class << self
      def configure(&block)
        instance_eval(&block)
      end

      def conf
        config
      end
    end
  end
end





TestApp::Application.configure do
  config[:cache_classes] = true

  config[:considere_all_request_local] =  false
end



# implement scope
module CustomScopeExtension
  def custom_scope(name, body)
    define_singleton_method(name) do |*args|
      result = body.call(*args)

      # Return all if the result is nil
      result ? merge(result) : all
    end
  end
end


# In rails project create a file inside a initializer to load this model when activesupport loads.


ActiveSupport.on_load(:active_record) do
  extend CustomScopeExtension
end