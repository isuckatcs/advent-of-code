# frozen_string_literal: true

def safe?(report)
  diffs = report.each_cons(2).map { |x, y| y - x }
  diffs.map { |x| x <=> 0 }.uniq.length == 1 && diffs.all? { |e| (1..3).member? e.abs }
end

def part1(reports)
  reports.count { |r| safe? r }
end

def part2(reports)
  reports.count { |r| (0...r.length).any? { |i| safe?(r[0...i] + r[i + 1..]) } }
end

reports = ARGF.each_line.map { |line| line.split(/\s+/).map(&:to_i) }

puts part1 reports
puts part2 reports
