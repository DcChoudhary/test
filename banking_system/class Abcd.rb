class Abcd
  class << self
    def greeting
      hello
    end

    private

    def hello
      puts 'hello'
    end
  end
end

Abcd.hello

class Deep
  def public_method
    puts 'public'
    private_method
    protected_method
  end

  private

  def private_method
    puts 'private'
  end

  protected

  def protected_method
    puts 'protected'
  end
end

Deep.new.public_method
