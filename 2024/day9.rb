# frozen_string_literal: true

def part1(disk_map)
  files, free_space = disk_map.chars.each_with_index.partition { |_, i| i.even? }.map { |a| a.map { |c, _| c.to_i } }

  b = 0
  e = files.size - 1

  checksum = []
  until files[b].zero?
    checksum += Array.new(files[b], b)

    free_space[b].times do
      e -= 1 while files[e].zero? && e > b
      break if e == b

      checksum << e
      files[e] -= 1
    end

    b += 1
  end

  checksum.each_with_index.map { |e, i| e * i }.sum
end

def part2(disk_map)
  checksum = disk_map.chars.map(&:to_i).each_with_index.map { |c, i| i.even? ? [c, i / 2] : [c, -1] }

  (0...checksum.size).reverse_each do |i|
    file_size, file = checksum[i]
    next if file == -1

    hole_index = checksum.index { |s, e| e == -1 && s >= file_size }
    next unless hole_index && hole_index < i

    hole_size, = checksum[hole_index]
    checksum[hole_index] = [file_size, file]
    checksum[i][1] = -1

    checksum.insert(hole_index + 1, [hole_size - file_size, -1]) if hole_size != file_size
  end

  checksum.map { |cnt, el| Array.new(cnt, el == -1 ? 0 : el) }.flatten.each_with_index.map { |e, i| e * i }.sum
end

disk_map = readline(chomp: true)

puts part1 disk_map
puts part2 disk_map
