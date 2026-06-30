# https://leetcode.com/problems/trapping-rain-water

# [0,1,0,2,1,0,1,3,2,1,2,1]
def trap(height)
  l_max = 0
  r_max = 0
  left = 0
  right = height - 1

  while left < right
    if l_max < left
      l_max += 1
    else
      left += 1
    end
  end
end
