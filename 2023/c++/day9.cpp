#include <iostream>
#include <ranges>
#include <sstream>
#include <string>
#include <vector>

int part1(const std::vector<std::vector<int>> &sequences) {
  int out = 0;
  for (auto &&s : sequences)
    out += s.back();

  return out;
};

int part2(const std::vector<std::vector<int>> &sequences) {
  int out = 0;
  for (auto &&s : sequences | std::ranges::views::reverse)
    out = s.front() - out;

  return out;
}

int main() {

  int part1Sum = 0;
  int part2Sum = 0;

  std::string line;
  while (std::getline(std::cin, line)) {
    std::stringstream ss(line);

    std::vector<std::vector<int>> sequences(1);

    int n = 0;
    while (ss >> n) {
      sequences[0].emplace_back(n);
    }

    while (true) {
      std::vector<int> tmp;
      bool allZeroes = true;

      for (size_t i = 0; i < sequences.back().size() - 1; ++i) {
        int diff = sequences.back()[i + 1] - sequences.back()[i];
        allZeroes &= diff == 0;
        tmp.emplace_back(diff);
      }

      if (allZeroes)
        break;

      sequences.emplace_back(std::move(tmp));
    }

    part1Sum += part1(sequences);
    part2Sum += part2(sequences);
  }

  std::cout << part1Sum << '\n';
  std::cout << part2Sum << '\n';

  return 0;
}
