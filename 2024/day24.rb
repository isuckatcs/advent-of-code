# frozen_string_literal: true

def topological_sort(n, connections, sorted)
  return if sorted.include? n

  connections.filter { |_, v| v.include?(n) }.each_key { |k| topological_sort(k, connections, sorted) }
  sorted << n
end

def part1(values, connections)
  sorted = []
  values.each_key { |v| topological_sort v, connections, sorted }

  ops = { 'AND' => :&, 'OR' => :|, 'XOR' => :^ }
  sorted.reverse.each do |n|
    next unless connections.include? n

    l, op, r = connections[n]
    values[n] = values[l].send(ops[op], values[r])
  end

  values.filter { |k, _| k.start_with? 'z' }.sort.reverse.map { |a| a[1] }.join.to_i(2)
end

def find_pattern(connections, pattern)
  connections.find { |_, v| v.sort == pattern.sort }&.at(0)
end

def swap_connections(connections, from, to)
  connections[from], connections[to] = connections[to], connections[from]
  [to, from]
end

# Hand-tailored for inputs in the form of
#   z0 = x0 ^ y0
#   c = x0 & y0
#
#   repeat
#     tz = x_n ^ y_n
#     z_n = tz ^ c
#     tc1 = x_n & y_n
#     tc2 = tz & c
#     c = tc1 | tc2
def part2(values, connections)
  swaps = []

  c = find_pattern(connections, ['AND', 'x00', 'y00'])

  values.keys.filter { |k| k.start_with?('x') && k != 'x00' }.each do |x|
    y = "y#{x[1..]}"

    tz = find_pattern(connections, ['XOR', x, y])
    z = find_pattern(connections, ['XOR', tz, c])

    # hand-tailored case #1 - z_n is swapped with some other node
    swaps << swap_connections(connections, z, "z#{x[1..]}") if z && !z.start_with?('z')

    tc1 = find_pattern(connections, ['AND', x, y])

    # hand-tailored case #2 - tz and tc1 are swapped
    swaps << [(tc1, tz = swap_connections(connections, tc1, tz))] unless z

    tc2 = find_pattern(connections, ['AND', tz, c])
    c = find_pattern(connections, ['OR', tc1, tc2])
  end

  swaps.flatten.sort.join ','
end

input = readlines(chomp: true)
empty = input.find_index(&:empty?)

values = input[0...empty].map { |v| v.split ':' }.to_h.transform_values(&:to_i)
connections = input[empty + 1...].map { |v| v.split ' -> ' }.map { |s| [s[1], s[0].split(' ')] }.to_h

puts part1 values, connections
puts part2 values, connections
