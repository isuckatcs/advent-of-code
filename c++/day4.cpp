#include <iostream>
#include <set>
#include <sstream>
#include <string>
#include <vector>

size_t part1(const std::string &line) {
  std::stringstream ss(line);
  std::set<int> winningNumbers;

  // Game X:
  int id = 0;
  std::string str;
  ss >> str >> id;
  ss.get();

  size_t score = 0;

  int n = 0;
  while (ss >> n) {
    winningNumbers.emplace(n);
  }

  ss.clear();
  ss >> str;

  while (ss >> n) {
    if (winningNumbers.contains(n)) {
      score = score == 0 ? 1 : (score << 1);
    }
  }

  return score;
};

size_t part2(const std::string &line, size_t totalLines) {
  std::stringstream ss(line);

  // Game X:
  int id = 0;
  std::string str;
  ss >> str >> id;
  ss.get();

  static std::vector<int> cache(totalLines + 1, 0);
  ++cache[id];

  std::set<int> winningNumbers;

  int n = 0;
  while (ss >> n) {
    winningNumbers.emplace(n);
  }

  ss.clear();
  ss >> str;

  int cnt = 1;
  while (ss >> n) {
    if (winningNumbers.contains(n) && id + cnt <= totalLines) {
      cache[id + cnt] += cache[id];
      ++cnt;
    }
  }

  return cache[id];
}

int main() {
  std::vector<std::string> lines;

  std::string line;
  while (std::getline(std::cin, line)) {
    lines.emplace_back(line);
  }

  size_t part1Sum = 0;
  size_t part2Sum = 0;

  for (auto &&line : lines) {
    part1Sum += part1(line);
    part2Sum += part2(line, lines.size());
  }

  std::cout << part1Sum << '\n';
  std::cout << part2Sum << '\n';

  return 0;
}
