# frozen_string_literal: true

def part1(left, right)
  (left.sort.zip right.sort).map { |l, r| (l - r).abs }.sum 0
end

def part2(left, right)
  left.map { |e| (right.count e) * e }.sum 0
end

left = []; right = []

ARGF.each_line do |line|
  nums = line.split(/\s+/).map(&:to_i)
  left << nums[0]; right << nums[1]
end

puts part1(left, right)
puts part2(left, right)
