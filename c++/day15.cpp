#include <iostream>
#include <ranges>
#include <string>
#include <vector>

size_t part1(const std::string &sequence) {
  size_t res = 0;

  for (auto &&s : sequence | std::views::split(',')) {
    std::string_view sv(&s.front(), std::ranges::distance(s));

    size_t hash = 0;
    for (auto &&c : sv) {
      hash += c;
      hash *= 17;
      hash %= 256;
    }
    res += hash;
  }

  return res;
};

size_t part2(const std::string &sequence) {
  std::vector<std::pair<std::string, int>> boxes[256];

  for (auto &&s : sequence | std::views::split(',')) {
    std::string_view sv(&s.front(), std::ranges::distance(s));

    char delim = sv.back() == '-' ? '-' : '=';
    auto labelSplit = std::views::split(sv, delim).front();
    auto label = std::string_view(&labelSplit.front(),
                                  std::ranges::distance(labelSplit));

    size_t hash = 0;
    for (auto &&c : label) {
      hash += c;
      hash *= 17;
      hash %= 256;
    }

    auto &box = boxes[hash];

    auto it = box.begin();
    while (it != box.end() && it->first != label)
      ++it;

    if (sv.back() == '-') {
      if (it != box.end())
        box.erase(it);

      continue;
    }

    int val = sv.back() - '0';
    if (it != box.end())
      it->second = val;
    else
      box.emplace_back(label, val);
  }

  size_t total = 0;
  for (auto &&i : std::views::iota(0, 256)) {
    if (boxes[i].empty())
      continue;

    for (auto &&j : std::views::iota(0U, boxes[i].size()))
      total += (i + 1) * (j + 1) * boxes[i][j].second;
  }

  return total;
};

int main() {

  std::string line;
  std::getline(std::cin, line);

  std::cout << part1(line) << '\n';
  std::cout << part2(line) << '\n';

  return 0;
}
