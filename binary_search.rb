def calculate_mid(low, high)
  (low + high) / 2
end

def binary_search(arr, target)
  low = 0
  high = arr.size - 1

  while low <= high
    mid = calculate_mid(low, high)

    if arr[mid] == target
      return mid
    elsif target < arr[mid]
      high = mid - 1
    else
      low = mid + 1
    end
  end
  nil
end

arr = [2, 4, 6, 8, 10, 12, 14, 16, 18]
target = 14
print binary_search(arr, target)
