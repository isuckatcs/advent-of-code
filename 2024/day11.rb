# frozen_string_literal: true

def sim(stone, limit, time, cache)
  cached = cache[stone][time]
  return cached if cached

  if time == limit
    cache[stone][time] = 1
    return 1
  end

  res = if stone.zero?
          sim(1, limit, time + 1, cache)
        elsif (digits = Math.log10(stone).to_i + 1) && digits.even?
          fst, snd = stone.divmod(10**(digits / 2))
          sim(fst, limit, time + 1, cache) + sim(snd, limit, time + 1, cache)
        else
          sim(stone * 2024, limit, time + 1, cache)
        end

  cache[stone][time] = res
  res
end

def part1(stones)
  cache = Hash.new { |hsh, key| hsh[key] = {} }
  stones.map { |stone| sim stone, 25, 0, cache }.sum
end

def part2(stones)
  cache = Hash.new { |hsh, key| hsh[key] = {} }
  stones.map { |stone| sim stone, 75, 0, cache }.sum
end

stones = readline(chomp: true).split.map(&:to_i)

puts part1 stones
puts part2 stones
