#include <iostream>
#include <set>
#include <string>
#include <utility>
#include <vector>

size_t part1(const std::vector<std::string> &grid) {
  std::vector<std::pair<int, int>> galaxies;
  std::set<int> occupiedCols;
  std::set<int> occupiedRows;

  for (size_t i = 0; i < grid.size(); ++i) {
    for (size_t j = 0; j < grid[i].size(); ++j) {
      if (grid[i][j] == '#') {
        galaxies.emplace_back(i, j);
        occupiedRows.emplace(i);
        occupiedCols.emplace(j);
      }
    }
  }

  size_t totalDist = 0;
  for (size_t i = 0; i < galaxies.size(); ++i) {
    for (size_t j = i + 1; j < galaxies.size(); ++j) {
      auto [a, b] = galaxies[i];
      auto [c, d] = galaxies[j];

      if (a > c)
        std::swap(a, c);

      if (b > d)
        std::swap(b, d);

      size_t dist = c - a + d - b;

      for (int k = a; k < c; ++k)
        dist += !occupiedRows.contains(k);
      for (int k = b; k < d; ++k)
        dist += !occupiedCols.contains(k);

      totalDist += dist;
    }
  }

  return totalDist;
};

size_t part2(const std::vector<std::string> &grid) {
  std::vector<std::pair<int, int>> galaxies;
  std::set<int> occupiedCols;
  std::set<int> occupiedRows;

  for (size_t i = 0; i < grid.size(); ++i) {
    for (size_t j = 0; j < grid[i].size(); ++j) {
      if (grid[i][j] == '#') {
        galaxies.emplace_back(i, j);
        occupiedRows.emplace(i);
        occupiedCols.emplace(j);
      }
    }
  }

  size_t totalDist = 0;
  for (size_t i = 0; i < galaxies.size(); ++i) {
    for (size_t j = i + 1; j < galaxies.size(); ++j) {
      auto [a, b] = galaxies[i];
      auto [c, d] = galaxies[j];

      if (a > c)
        std::swap(a, c);

      if (b > d)
        std::swap(b, d);

      size_t dist = c - a + d - b;

      for (int k = a; k < c; ++k) {
        if (!occupiedRows.contains(k))
          dist += 1e6 - 1;
      }

      for (int k = b; k < d; ++k) {
        if (!occupiedCols.contains(k))
          dist += 1e6 - 1;
      }

      totalDist += dist;
    }
  }

  return totalDist;
};

int main() {

  std::vector<std::string> grid;
  std::string line;

  while (std::getline(std::cin, line))
    grid.emplace_back(std::move(line));

  std::cout << part1(grid) << '\n';
  std::cout << part2(grid) << '\n';

  return 0;
}
