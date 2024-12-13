# frozen_string_literal: true

def solve(equation)
  a1, a2, b1, b2, c1, c2 = equation

  # a1 * x + b1 * y = c1
  #   -> b1 * y = c1 - a1 * x
  #   -> y = (c1 - a1 * x) / b1
  # a2 * x + b2 * y = c2
  #   -> a2 * x + b2 * (c1 - a1 * x) / b1 = c2
  #   -> a2 * x + (b2 * c1 - b2 * a1 * x) / b1 = c2
  #   -> b1 * a2 * x + b2 * c1 - b2 * a1 * x = c2 * b1
  #   -> b1 * a2 * x - b2 * a1 * x = c2 * b1 - b2 * c1
  #   -> x (b1 * a2 - b2 * a1) = c2 * b1 - b2 * c1
  #   -> x = (c2 * b1 - b2 * c1) / (b1 * a2 - b2 * a1)

  x, m = (c2 * b1 - b2 * c1).divmod(b1 * a2 - b2 * a1)
  return nil if m != 0

  y, m = (c1 - a1 * x).divmod b1
  return nil if m != 0

  3 * x + y
end

def part1(equations)
  equations.filter_map { |e| solve e }.sum
end

def part2(equations)
  equations.map { |e| e[0..3] + e[4..5].map { |c| c + 10_000_000_000_000 } }.filter_map { |e| solve e }.sum
end

equations = readlines(chomp: true).each_slice(4).map(&:join).map { |e| e.scan(/(\d+)/).flatten.map(&:to_i) }

puts part1 equations
puts part2 equations
