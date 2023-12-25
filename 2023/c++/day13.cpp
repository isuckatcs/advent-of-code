#include <iostream>
#include <ranges>
#include <string>
#include <vector>

size_t part1(const std::vector<std::string> &block) {
  auto getMirror = [](const std::vector<std::string> &block,
                      const std::vector<size_t> &reflections) {
    for (auto &&r : reflections) {
      bool mirror = true;

      for (size_t i : std::views::iota(0U, r)) {
        size_t opposite = r + (r - i) - 1;

        if (opposite >= block.size())
          continue;

        mirror &= block[i] == block[opposite];
      }

      if (mirror)
        return r;
    }

    return static_cast<size_t>(0);
  };

  std::vector<size_t> reflRows;

  for (size_t i : std::views::iota(0U, block.size() - 1))
    if (block[i] == block[i + 1])
      reflRows.emplace_back(i + 1);

  if (auto r = getMirror(block, reflRows))
    return r * 100;

  std::vector<std::string> rotated;

  for (size_t i : std::views::iota(0U, block[0].size())) {
    std::string col;

    for (auto &&r : block)
      col += r[i];

    rotated.emplace_back(std::move(col));
  }

  std::vector<size_t> reflCols;

  for (size_t i : std::views::iota(0U, rotated.size() - 1))
    if (rotated[i] == rotated[i + 1])
      reflCols.emplace_back(i + 1);

  return getMirror(rotated, reflCols);
};

size_t part2(const std::vector<std::string> &block) {
  auto countDiff = [](const std::string &a, const std::string &b) {
    size_t diff = 0;

    for (size_t i : std::views::iota(0U, a.size()))
      diff += a[i] != b[i];

    return diff;
  };

  auto getMirror = [&countDiff](const std::vector<std::string> &block,
                                const std::vector<size_t> &reflections) {
    for (auto &&r : reflections) {
      bool correction = false;
      bool mirror = true;

      for (size_t i : std::views::iota(0U, r)) {
        size_t opposite = r + (r - i) - 1;

        if (opposite >= block.size())
          continue;

        auto diff = countDiff(block[i], block[opposite]);

        mirror &= diff == 0 || (diff == 1 && !correction);
        correction |= diff;
      }

      if (mirror && correction)
        return r;
    }

    return static_cast<size_t>(0);
  };

  std::vector<size_t> reflRows;

  for (size_t i : std::views::iota(0U, block.size() - 1))
    if (countDiff(block[i], block[i + 1]) <= 1)
      reflRows.emplace_back(i + 1);

  if (auto r = getMirror(block, reflRows))
    return r * 100;

  std::vector<std::string> rotated;

  for (size_t i : std::views::iota(0U, block[0].size())) {
    std::string col;

    for (auto &&r : block)
      col += r[i];

    rotated.emplace_back(std::move(col));
  }

  std::vector<size_t> reflCols;

  for (size_t i : std::views::iota(0U, rotated.size() - 1))
    if (countDiff(rotated[i], rotated[i + 1]) <= 1)
      reflCols.emplace_back(i + 1);

  return getMirror(rotated, reflCols);
};

int main() {

  size_t part1Sum = 0;
  size_t part2Sum = 0;

  std::vector<std::string> block;
  std::string line;
  while (std::getline(std::cin, line)) {
    if (!line.empty()) {
      block.emplace_back(line);
      continue;
    }

    part1Sum += part1(block);
    part2Sum += part2(block);
    block.clear();
  }

  part1Sum += part1(block);
  part2Sum += part2(block);

  std::cout << part1Sum << '\n';
  std::cout << part2Sum << '\n';

  return 0;
}
