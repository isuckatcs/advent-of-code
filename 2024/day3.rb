# frozen_string_literal: true

def part1(memory)
  memory.scan(/mul\((\d*),(\d*)\)/).map { |x, y| x.to_i * y.to_i }.sum
end

def part2(memory)
  part1 "do#{memory}".split(/(don't)|(do)/).drop(1).each_slice(2).filter { |e, _| e != "don't" }.join
end

memory = readlines.join

puts part1 memory
puts part2 memory
