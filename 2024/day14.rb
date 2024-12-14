# frozen_string_literal: true

def step(robots, width, height, time)
  robots.map { |px, py, vx, vy| [(px + vx * time) % width, (py + vy * time) % height] }
end

def part1(robots, wide, tall, time)
  final = step(robots, wide, tall, time)

  half_x = wide / 2
  half_y = tall / 2

  quadrants = [(0...half_x), (half_x + 1...wide)].product([(0...half_y), (half_y + 1...tall)])
  quadrants.map { |rx, ry| final.count { |x, y| rx.include?(x) && ry.include?(y) } }.reduce(:*)
end

def part2(robots, wide, tall)
  (0...).find do |i|
    tiles = Array.new(tall, 0).map { |_| Array.new(wide, '.') }
    arrangement = step(robots, wide, tall, i)
    arrangement.each { |c, r| tiles[r][c] = '#' }

    tiles.any? { |t| t.join =~ /########/ }
  end
end

robots = readlines(chomp: true).map { |e| e.scan(/(-?\d+)/).flatten.map(&:to_i) }

puts part1 robots, 101, 103, 100
puts part2 robots, 101, 103
