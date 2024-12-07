# frozen_string_literal: true

class Integer
  def concat(other)
    (to_s + other.to_s).to_i
  end
end

def solve(result, arr, ops)
  return result == arr[0] if arr.length == 1

  ops.map { |o| solve result, arr.drop(2).unshift([arr[0], arr[1]].inject(o)), ops }.any?
end

def part1(equations)
  equations.filter { |r, a| solve r, a, %i[* +] }.map { |r, _| r }.sum
end

def part2(equations)
  equations.filter { |r, a| solve r, a, %i[* + concat] }.map { |r, _| r }.sum
end

equations = readlines(chomp: true).map { |l| l.split(':') }.map { |s, e| [s.to_i, e.split.map(&:chomp).map(&:to_i)] }

puts part1 equations
puts part2 equations
