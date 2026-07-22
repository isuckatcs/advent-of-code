#include <iostream>
#include <vector>

std::vector<int> evaluate(std::vector<int> program) {
  int ip = 0;

  while (ip < program.size()) {
    int opcode = program[ip];
    if (opcode == 99)
      return program;

    int p1 = program[ip + 1];
    int p2 = program[ip + 2];
    int p3 = program[ip + 3];

    if (opcode == 1)
      program[p3] = program[p1] + program[p2];
    else if (opcode == 2)
      program[p3] = program[p1] * program[p2];

    ip += 4;
  }

  return program;
}

int part1(std::vector<int> program) {
  program[1] = 12;
  program[2] = 2;

  return evaluate(program)[0];
}

int part2(std::vector<int> program) {
  for (int noun = 0; noun <= 99; ++noun) {
    for (int verb = 0; verb <= 99; ++verb) {
      auto memory = program;

      memory[1] = noun;
      memory[2] = verb;

      if (evaluate(memory)[0] == 19690720)
        return 100 * noun + verb;
    }
  }

  return -1;
}

int main() {
  std::vector<int> program;

  int opcode;
  std::cin >> opcode;
  program.emplace_back(opcode);

  while (std::cin.ignore()) {
    std::cin >> opcode;
    program.emplace_back(opcode);
  }

  std::cout << part1(program) << '\n';
  std::cout << part2(program) << '\n';

  return 0;
}