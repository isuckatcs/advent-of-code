# frozen_string_literal: true

def part1(schematics)
  heights = schematics.each_slice(8).map { |s| [s[0][0], s[0...7].map(&:chars).transpose.map { |c| c.count('#') - 1 }] }
  locks, keys = heights.partition { |h| h[0] == '#' }.map { |p| p.map { |_, h| h } }
  keys.product(locks).uniq.count { |p| p.transpose.map { |x| x.reduce(:+) }.all? { |x| x <= 5 } }
end

def part2
  0
end

schematics = readlines(chomp: true)

puts part1 schematics
puts part2
