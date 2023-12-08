#include <iostream>
#include <map>
#include <numeric>
#include <ranges>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

size_t part1(const std::vector<std::string> &lines) {
  std::string dirs = lines[0];
  std::map<std::string, std::pair<std::string, std::string>> m;

  for (auto &&line : lines | std::ranges::views::drop(2)) {
    std::stringstream ss(line);
    std::string base;
    std::string left;
    std::string right;

    ss >> base;
    // eat ' = '
    ss >> left;

    ss >> left;
    ss >> right;

    left = left.substr(1, left.size() - 2);
    right.pop_back();

    m[base] = {left, right};
  }

  std::string curNode = "AAA";
  size_t i = 0;
  size_t steps = 0;

  while (curNode != "ZZZ") {
    curNode = (dirs[i] == 'L') ? m[curNode].first : m[curNode].second;

    i = (i + 1) % dirs.size();
    ++steps;
  }

  return steps;
};

size_t part2(const std::vector<std::string> &lines) {
  std::string dirs = lines[0];
  std::map<std::string, std::pair<std::string, std::string>> m;
  std::vector<std::string> curNodes;

  for (auto &&line : lines | std::ranges::views::drop(2)) {
    std::stringstream ss(line);
    std::string base;
    std::string left;
    std::string right;

    ss >> base;
    // eat ' = '
    ss >> left;

    ss >> left;
    ss >> right;

    left = left.substr(1, left.size() - 2);
    right.pop_back();

    m[base] = {left, right};

    if (base[2] == 'A') {
      curNodes.emplace_back(base);
    }
  }

  size_t lcm = 1;

  for (auto &node : curNodes) {
    size_t i = 0;
    size_t steps = 0;

    while (node[2] != 'Z') {
      node = (dirs[i] == 'L') ? m[node].first : m[node].second;

      i = (i + 1) % dirs.size();
      ++steps;
    }

    lcm = std::lcm(lcm, steps);
  }

  return lcm;
}

int main() {
  std::vector<std::string> lines;

  std::string line;
  while (std::getline(std::cin, line)) {
    lines.emplace_back(line);
  }

  std::cout << part1(lines) << '\n';
  std::cout << part2(lines) << '\n';

  return 0;
}
