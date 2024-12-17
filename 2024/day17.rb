# frozen_string_literal: true

def combo(registers, operand)
  case operand
  when 0..3
    operand
  when 4..6
    registers[operand - 4]
  else
    throw NotImplementedError
  end
end

def exec(registers, program)
  dv = proc { |operand| registers[0] / (1 << combo(registers, operand)) }
  out = []

  ip = 0
  while ip < program.length
    op, operand = program[ip]

    case op
    when 0
      registers[0] = dv.call operand
    when 1
      registers[1] ^= operand
    when 2
      registers[1] = combo(registers, operand) % 8
    when 3
      next ip = operand if registers[0] != 0
    when 4
      registers[1] ^= registers[2]
    when 5
      out << combo(registers, operand) % 8
    when 6
      registers[1] = dv.call operand
    when 7
      registers[2] = dv.call operand
    else
      throw NotImplementedError
    end

    ip += 1
  end

  out
end

def part1(registers, program)
  exec(registers, program).join ','
end

def part2(program)
  p = program.flatten.reverse
  d = 1 << program.filter_map { |o, c| c if o.zero? }[0]

  q = [[0, 0]]
  until q.empty?
    ans, i = q.shift

    return ans if i == p.length

    (0..d - 1).map { |m| ans * d + m }.filter { |a| exec([a, 0, 0], program).first == p[i] }.each { |a| q << [a, i + 1] }
  end
end

nums = readlines(chomp: true).join.scan(/\d+/).map(&:to_i)
registers = nums[0...3].map(&:to_i)
program = nums[3..].each_slice(2).to_a

puts part1 registers, program
puts part2 program
