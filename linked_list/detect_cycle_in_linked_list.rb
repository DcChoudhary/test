# https://leetcode.com/problems/linked-list-cycle

# Definition for singly-linked list.
class ListNode
  attr_accessor :val, :next

  def initialize(val)
    @val = val
    @next = nil
  end
end

def hasCycle(head)
  # early exit
  return false if head.nil? || head.next.nil?

  slow = head
  fast = head

  while fast&.next
    slow = slow.next
    fast = fast.next.next
    return true if slow == fast
  end
  false
end

node = nil
hasCycle(node)
