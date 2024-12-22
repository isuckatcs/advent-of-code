# frozen_string_literal: true

MOD = 16_777_216

def evolve_secret(num)
  num ^= num * 64
  num ^= (num % MOD) / 32
  num ^= (num % MOD) * 2048
  num % MOD
end

def part1(secrets)
  secrets.map { |s| 2000.times.map { s = evolve_secret(s) }.last }.sum
end

def part2(secrets)
  prices = secrets.map { |s| ([s] + 2000.times.map { s = evolve_secret(s) }[...-1]).map { |n| n % 10 } }
  diffs = prices.map { |p| p.each_cons(2).map { |a, b| b - a } }

  cache = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = [] } }
  diffs.each_with_index { |d, di| d.each_cons(4).each_with_index { |e, i| cache[e][di] << prices[di][i + 4] } }

  cache.map { |_, ps| ps.map { |_, p| p[0] }.sum }.max
end

secrets = readlines(chomp: true).map(&:to_i)

puts part1 secrets
puts part2 secrets
