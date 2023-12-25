#include <iostream>
#include <map>
#include <ranges>
#include <string>
#include <utility>
#include <vector>

size_t part1(const std::vector<std::string> &block) {
  size_t northWeight = 0;

  for (size_t c : std::views::iota(0U, block[0].size())) {
    size_t stop = 0;

    for (auto r : std::views::iota(0U, block.size())) {
      if (block[r][c] == '#') {
        stop = r + 1;
        continue;
      }

      if (block[r][c] == 'O') {
        northWeight += block.size() - stop;
        ++stop;
      }
    }
  }

  return northWeight;
};

size_t part2(std::vector<std::string> block) {
  std::map<size_t, size_t> valToIter;
  std::vector<size_t> iters;

  size_t cycleIdx = 0;
  size_t cycleBase = 0;
  size_t prevCycleEnd = 0;
  bool detectCycle = false;

  int rowCount = block.size();
  int colCount = block[0].size();

  size_t target = 1e9;
  for (size_t n = 0; n < target; ++n) {

    size_t northWeight = 0;

    // Tilt north
    for (size_t c : std::views::iota(0, colCount)) {
      size_t stop = 0;

      for (auto r : std::views::iota(0, rowCount)) {
        if (block[r][c] == '#') {
          stop = r + 1;
          continue;
        }

        if (block[r][c] == 'O') {
          std::swap(block[r][c], block[stop][c]);
          ++stop;
        }
      }
    }

    // Tilt west
    for (auto r : std::views::iota(0, rowCount)) {
      size_t stop = 0;

      for (size_t c : std::views::iota(0, colCount)) {
        if (block[r][c] == '#') {
          stop = c + 1;
          continue;
        }

        if (block[r][c] == 'O') {
          std::swap(block[r][c], block[r][stop]);
          ++stop;
        }
      }
    }

    // Tilt south
    for (size_t c : std::views::iota(0, colCount)) {
      size_t stop = rowCount - 1;

      for (size_t r : std::views::iota(0, rowCount) | std::views::reverse) {
        if (block[r][c] == '#') {
          stop = r - 1;
          continue;
        }

        if (block[r][c] == 'O') {
          std::swap(block[r][c], block[stop][c]);
          northWeight += rowCount - stop;
          --stop;
        }
      }
    }

    // Tilt east
    for (auto r : std::views::iota(0, rowCount)) {
      size_t stop = colCount - 1;

      for (size_t c : std::views::iota(0, colCount) | std::views::reverse) {
        if (block[r][c] == '#') {
          stop = c - 1;
          continue;
        }

        if (block[r][c] == 'O') {
          std::swap(block[r][c], block[r][stop]);
          --stop;
        }
      }
    }

    if (detectCycle) {
      detectCycle = northWeight == iters[cycleIdx + 1];
      ++cycleIdx;
    }

    if (valToIter.contains(northWeight)) {
      if (detectCycle) {
        if (iters[cycleBase] == northWeight) {
          if (prevCycleEnd == valToIter[northWeight]) {
            break;
          }
          prevCycleEnd = n;
        }

      } else {
        cycleBase = valToIter[northWeight];
        cycleIdx = cycleBase;
        detectCycle = true;
      }
    }

    valToIter[northWeight] = n;
    iters.emplace_back(northWeight);
  }

  if (detectCycle) {
    auto diff = iters.size() - prevCycleEnd;
    auto mod = (target - prevCycleEnd - 1) % diff;

    return iters[prevCycleEnd + mod];
  }

  return iters[target - 1];
};

int main() {
  std::vector<std::string> block;

  std::string line;
  while (std::getline(std::cin, line))
    block.emplace_back(line);

  std::cout << part1(block) << '\n';
  std::cout << part2(std::move(block)) << '\n';

  return 0;
}
