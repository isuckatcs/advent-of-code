#include <cassert>
#include <iostream>
#include <queue>
#include <set>
#include <string>
#include <vector>

size_t getReachedPlotCount(const std::vector<std::string> &garden,
                           size_t steps) {
  std::pair<int, int> start;
  for (size_t r = 0; r < garden.size(); ++r) {
    if (auto c = garden[r].find('S'); c != std::string::npos) {
      start = {r, c};
      break;
    }
  }

  std::set<std::pair<int, int>> visited;
  std::queue<std::pair<int, int>> q;

  q.emplace(start);
  q.emplace(-1, -1);

  size_t step = 0;
  while (!q.empty()) {
    auto [r, c] = q.front();
    q.pop();

    if (r == -1 && c == -1) {
      if (step == steps)
        break;

      ++step;
      visited.clear();

      if (!q.empty())
        q.emplace(-1, -1);

      continue;
    }

    if (!visited.emplace(r, c).second)
      continue;

    const static std::pair<int, int> dirs[] = {
        {1, 0}, {-1, 0}, {0, -1}, {0, 1}};

    for (auto &&[dr, dc] : dirs) {
      int nr = r + dr;
      int nc = c + dc;

      if (nr < 0 || nr >= garden.size() || nc < 0 || nc >= garden[0].size() ||
          garden[nr][nc] == '#')
        continue;

      q.emplace(nr, nc);
    }
  }

  return visited.size();
}

size_t part1(const std::vector<std::string> &garden) {
  return getReachedPlotCount(garden, 64);
}

size_t part2(const std::vector<std::string> &garden) {
  assert(garden.size() == 131 && garden[0].size() == 131 &&
         "unexpected input size");

  size_t n = 26501365;

  size_t oddCovered = getReachedPlotCount(garden, 131);
  size_t oddDiamond = getReachedPlotCount(garden, 65);

  size_t evenCovered = getReachedPlotCount(garden, 130);
  size_t evenDiamond = getReachedPlotCount(garden, 64);

  size_t repetition = (2 * n + 1) / garden[0].size();
  size_t dist = (repetition - 1) / 2;

  size_t totalOdd = dist + 1 + (dist + 1) * dist;
  size_t totalEven = dist + (dist - 1) * dist;

  return totalOdd * oddCovered + totalEven * evenCovered -
         (dist + 1) * (oddCovered - oddDiamond) +
         dist * (evenCovered - evenDiamond);
}

int main() {
  std::vector<std::string> garden;

  std::string buffer;
  while (std::getline(std::cin, buffer))
    garden.emplace_back(buffer);

  std::cerr << part1(garden) << '\n';
  std::cerr << part2(garden) << '\n';

  return 0;
}
