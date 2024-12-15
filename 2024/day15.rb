# frozen_string_literal: true

require 'set'

def extract_grid_data(grid)
  walls = Set.new
  boxes = Set.new
  robot = []

  grid.each_with_index do |row, y|
    row.chars.each_with_index do |col, x|
      walls << [x, y] if col == '#'
      boxes << [x, x + (col == '[' ? 1 : 0), y] if %w(O [).include?(col)
      robot = [x, y] if col == '@'
    end
  end

  [robot, walls, boxes]
end

def boxes_to_move(pos, dir, boxes, walls)
  queue = [pos]
  visited = Set.new
  move = Set.new

  until queue.empty?
    pos = queue.shift
    new_pos = [pos[0] + dir[0], pos[1] + dir[1]]

    return nil if walls.include? new_pos
    next if visited.include? new_pos

    visited << pos

    box = boxes.find { |bx, ex, y| bx <= new_pos[0] && new_pos[0] <= ex && y == new_pos[1] }
    next unless box

    queue << [box[0], box[2]] << [box[1], box[2]]
    move << box
  end

  move.uniq
end

def solve(moves, robot, walls, boxes)
  moves.chars.each do |move|
    dir = { '^' => [0, -1], 'v' => [0, 1], '>' => [1, 0], '<' => [-1, 0] }[move]
    boxes_to_move = boxes_to_move robot, dir, boxes, walls
    next unless boxes_to_move

    boxes_to_move.each { |box| boxes.delete box }
    boxes_to_move.each { |bx, ex, y| boxes << [bx + dir[0], ex + dir[0], y + dir[1]] }

    robot = [robot[0] + dir[0], robot[1] + dir[1]]
  end

  boxes.map { |x, _, y| 100 * y + x }.sum
end

def part1(grid, moves)
  solve moves, *extract_grid_data(grid)
end

def part2(grid, moves)
  grid = grid.map do |row|
    row.chars.map do |cell|
      next '##' if cell == '#'
      next '[]' if cell == 'O'
      next '..' if cell == '.'
      next '@.' if cell == '@'
    end.join
  end

  solve moves, *extract_grid_data(grid)
end

input = readlines(chomp: true)

split = input.find_index(&:empty?)
grid = input[0...split]
moves = input[split + 1..].join

puts part1 grid, moves
puts part2 grid, moves
