# frozen_string_literal: true

def diagonal(word_search, start_row, start_col)
  row_it_count = word_search.count - (start_row + 1)
  col_it_count = word_search[0].length - (start_col + 1)
  it_count = [row_it_count, col_it_count].min

  (0..it_count).collect { |i| word_search[start_row + i][start_col + i] }.flatten
end

def inv_diagonal(word_search, start_row, start_col)
  row_it_count = word_search.count - (start_row + 1)
  col_it_count = start_col
  it_count = [row_it_count, col_it_count].min

  (0..it_count).collect { |i| word_search[start_row + i][start_col - i] }.flatten
end

def part1(ws)
  scan_xmas = proc { |l| l.scan(/XMAS/).length }
  get_diagonals = proc { |i| [diagonal(ws, 0, i), diagonal(ws, i, 0)].map(&:join) }
  get_inv_diagonals = proc { |i| [inv_diagonal(ws, i, ws.count - 1), inv_diagonal(ws, 0, i)].map(&:join) }

  lines = ws.flatten
  cols = ws.map(&:chars).transpose.map(&:join).flatten
  diags = (0...ws.count).collect { |i| [get_diagonals.call(i), get_inv_diagonals.call(i)] }.flatten[1...-1]

  to_check = [lines, cols, diags].flatten
  to_check.map { |l| scan_xmas.call(l) + scan_xmas.call(l.reverse) }.sum
end

def part2(ws)
  maybe_valid = ws.each_with_index.map do |l, i|
    l.chars.each_with_index.filter_map do |c, j|
      r = j - 1..j + 1
      in_range = i - 1 >= 0 && i + 1 < ws.count && !r.begin.negative? && r.end < ws.count
      [ws[i - 1][r], ws[i][r], ws[i + 1][r]] if in_range && c == 'A'
    end
  end.flatten(1)

  maybe_valid.count do |m|
    d = diagonal(m, 0, 0).join
    id = inv_diagonal(m, 0, 2).join

    scan_mas = proc { |l| l =~ /MAS/ }
    [d, id].all? { |e| scan_mas.call(e) || scan_mas.call(e.reverse) }
  end
end

word_search = readlines.map(&:chomp)

puts part1 word_search
puts part2 word_search
