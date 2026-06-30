# https://leetcode.com/problems/container-with-most-water

def max_area(height)
  left = 0
  right = height.size - 1
  most_water = 0

  while left < right
    width = right - left
    shorter = [height[left], height[right]].min
    most_water = [most_water, shorter * width].max

    height[left] < height[right] ? left += 1 : right -= 1
  end

  most_water
end

height = [1, 8, 6, 2, 5, 4, 8, 3, 7]
max_area(height)
