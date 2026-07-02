# Recursive

def fib_recursive(num)
  return 0 if num <= 0
  return 1 if num == 1

  fib_recursive(num - 1) + fib_recursive(num - 2)
end

fib_recursive(3)
