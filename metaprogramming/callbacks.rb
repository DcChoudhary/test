# frozen_string_literal: true

# rubocop:disable all
module Callbacks
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def before_actions
      @before_actions ||= []
    end

    def after_actions
      @after_actions ||= []
    end

    def before_action(callback)
      before_actions << callback
    end

    def after_action(callback)
      after_actions << callback
    end

    def around_action(callback)
      before_actions << callback
      after_actions << callback
    end

    def method_added(method_name)
      return if @_wrapping
      return if before_actions.include?(method_name)
      return if after_actions.include?(method_name)

      @_wrapping = true
      alias_method :"original_#{method_name}", method_name
      
      define_method(method_name) do |*args, &block|
        self.class.before_actions.each do |before_action|
          send(before_action)
        end
        
        send(:"original_#{method_name}", *args, &block)

        self.class.after_actions.each do |after_action|
          send(after_action)
        end
      end

      @_wrapping = false
    end
  end
end


class User
  include Callbacks

  before_action :start_proccessing
  after_action :stop_proccessing
  around_action :status_check

  def index
    puts 'index'
  end

  private
  def start_proccessing
    puts 'processing'
  end

  def stop_proccessing
    puts 'finished'
  end

  def status_check
    puts "status_check"
  end
end


user = User.new

user.index