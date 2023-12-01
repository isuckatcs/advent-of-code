#include <algorithm>
#include <iostream>
#include <map>
#include <numeric>
#include <ranges>
#include <string>
#include <vector>

bool isDigit(char c) { return c >= '0' && c <= '9'; };

size_t part1(const std::vector<std::string> &lines) {
  auto lineToSum = [](const std::string &line) {
    auto view = line                                  //
                | std::ranges::views::filter(isDigit) //
                | std::ranges::views::transform([](char c) { return c - '0'; });

    return 10 * view.front() + view.back();
  };

  auto partialSums = lines | std::ranges::views::transform(lineToSum);
  return std::accumulate(partialSums.begin(), partialSums.end(),
                         static_cast<size_t>(0));
}

size_t part2(const std::vector<std::string> &lines) {
  static const std::map<std::string, int> keywords = {
      {"one", 1}, {"two", 2},   {"three", 3}, {"four", 4}, {"five", 5},
      {"six", 6}, {"seven", 7}, {"eight", 8}, {"nine", 9}};

  size_t sum = 0;
  for (auto &&line : lines) {
    std::vector<int> digits;

    size_t i = 0;
    auto indexedView = line | std::ranges::views::transform([&](char c) {
                         return std::make_pair(c, i++);
                       });

    for (auto &&[c, idx] : indexedView) {
      if (isDigit(c)) {
        digits.emplace_back(c - '0');
        continue;
      }

      for (auto n : {3, 4, 5}) {
        const auto &substr = line.substr(idx, n);

        if (keywords.count(substr)) {
          digits.emplace_back(keywords.at(substr));
          break;
        }
      }
    }

    sum += 10 * digits.front() + digits.back();
  }

  return sum;
};

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
