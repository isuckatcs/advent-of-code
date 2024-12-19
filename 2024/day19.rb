# frozen_string_literal: true

def try_parse(patterns, towel, cache)
  return 1 if towel.empty?
  return cache[towel] if cache[towel]

  cnt = patterns.filter { |p| towel.start_with? p }.map { |p| try_parse patterns, towel.delete_prefix(p), cache }.sum
  cache[towel] = cnt

  cnt
end

def part1(patterns, towels)
  towels.count { |t| try_parse(patterns, t, {}) != 0 }
end

def part2(patterns, towels)
  towels.sum { |t| try_parse patterns, t, {} }
end

input = readlines(chomp: true)

patterns = input[0].split ', '
towels = input[2..]

puts part1 patterns, towels
puts part2 patterns, towels
