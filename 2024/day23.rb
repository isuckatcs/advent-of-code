# frozen_string_literal: true

require 'set'

def part1(connections)
  maybe_historians = connections.filter { |k, _| k.start_with? 't' }

  triples = maybe_historians.flat_map do |f, to|
    to.flat_map { |t| to.filter_map { |t2| [f, t, t2] if t != t2 && connections[t].include?(t2) } }
  end

  triples.map(&:sort).uniq.length
end

def part2(connections)
  largest_set = Set.new

  all_visited = Set.new
  connections.each_key do |from|
    q = [[Set.new([from]), Set.new([from] + connections[from])]]

    until q.empty?
      visited, intersection = q.shift

      if visited.length == intersection.length
        largest_set = intersection if intersection.length > largest_set.length
        next
      end
      next if intersection.empty? || all_visited.include?([intersection, visited.length])

      all_visited << [intersection, visited.length]
      intersection.each { |i| q << [visited + [i], intersection & ([i] + connections[i])] unless visited.include? i }
    end
  end

  largest_set.sort.join ','
end

input = readlines(chomp: true).map { |c| c.split('-') }

connections = Hash.new { |h, k| h[k] = [] }
input.each do |from, to|
  connections[from] << to
  connections[to] << from
end

puts part1 connections
puts part2 connections
