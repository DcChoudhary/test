# Recursive
def factorial(num)
  return 1 if num <= 1

  num * factorial(num - 1)
end

factorial(5)

# Iterative

def factorial_iterative(num)
  result = 1
  (2..num).each { |n| result *= n }
end
