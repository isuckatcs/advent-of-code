# frozen_string_literal: true

def part1(rules, updates)
  right = updates.filter { |u| u.all? { |n| rules[n].filter_map { |s| u.index(s) }.all? { |i| u.index(n) < i } } }
  right.map { |r| r[r.length / 2.0].to_i }.sum
end

def part2(rules, updates)
  wrong = updates.filter { |u| u.any? { |n| rules[n].filter_map { |s| u.index(s) }.any? { |i| u.index(n) > i } } }
  ordered = wrong.map { |w| w.map { |n| [n, rules[n].filter_map { |s| w.index(s) }.length] } }
  fixed = ordered.map { |o| o.sort_by! { |_, n| n }.reverse!.map { |a, _| a} }
  fixed.map { |r| r[r.length / 2.0].to_i }.sum
end

lines = readlines(chomp: true).filter { |l| !l.empty? }

rules_to_process, updates = lines.partition { |l| l.include? '|' }
updates = updates.map { |u| u.split ',' }

rules = Hash.new { |hash, key| hash[key] = [] }
rules_to_process.map { |r| r.split('|') }.each { |l, r| rules[l] << r }

puts part1 rules, updates
puts part2 rules, updates
