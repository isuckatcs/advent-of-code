#include <cassert>
#include <deque>
#include <iostream>
#include <map>
#include <set>
#include <string>
#include <vector>

int part1(const std::vector<std::string> &grid,
          const std::pair<int, int> &start) {
  std::set<std::pair<int, int>> visited;
  std::deque<std::pair<int, int>> q;

  q.emplace_back(start);
  visited.emplace(start);
  q.emplace_back(-1, -1);

  size_t steps = 0;
  while (!q.empty()) {
    auto [r, c] = q.front();
    q.pop_front();

    if (r == -1 && c == -1) {
      ++steps;

      if (!q.empty())
        q.emplace_back(-1, -1);

      continue;
    }

    static int vr[] = {0, 0, 1, -1};
    static int vc[] = {1, -1, 0, 0};
    static std::string dest[] = {"-J7", "-FL", "|LJ", "|F7"};
    static std::string orig[] = {"S-FL", "S-J7", "S|F7", "S|JL"};

    for (size_t i = 0; i < 4; ++i) {
      int tr = r + vr[i];
      int tc = c + vc[i];

      if (tr < 0 || tr >= grid.size()                      //
          || tc < 0 || tc >= grid[tr].size()               //
          || orig[i].find(grid[r][c]) == std::string::npos //
      )
        continue;

      if (dest[i].find(grid[tr][tc]) != std::string::npos &&
          visited.emplace(tr, tc).second)
        q.emplace_back(tr, tc);
    }
  }

  return steps - 1;
};

int part2(std::vector<std::string> grid, const std::pair<int, int> &start) {
  int vr[] = {0, 0, 1, -1};
  int vc[] = {1, -1, 0, 0};

  std::set<std::pair<int, int>> visited;
  std::deque<std::pair<int, int>> q;

  q.emplace_back(start);
  visited.emplace(start);
  q.emplace_back(-1, -1);

  // BFS to find the loop.
  uint8_t startDirs = 0;
  while (!q.empty()) {
    auto [r, c] = q.front();
    q.pop_front();

    if (r == -1 && c == -1) {
      if (!q.empty())
        q.emplace_back(-1, -1);

      continue;
    }

    for (size_t i = 0; i < 4; ++i) {
      static std::string dest[] = {"-J7", "-FL", "|LJ", "|F7"};
      static std::string orig[] = {"S-FL", "S-J7", "S|F7", "S|JL"};

      int tr = r + vr[i];
      int tc = c + vc[i];

      if (tr < 0 || tr >= grid.size()                      //
          || tc < 0 || tc >= grid[tr].size()               //
          || orig[i].find(grid[r][c]) == std::string::npos //
      )
        continue;

      if (dest[i].find(grid[tr][tc]) != std::string::npos &&
          visited.emplace(tr, tc).second) {

        if (grid[r][c] == 'S')
          startDirs |= (1U << i);

        q.emplace_back(tr, tc);
      }
    }
  }

  // Replace 'S' with the correct pipe.
  switch (startDirs) {
  case 0b0101:
    grid[start.first][start.second] = 'F';
    break;
  case 0b1001:
    grid[start.first][start.second] = 'L';
    break;
  case 0b0110:
    grid[start.first][start.second] = '7';
    break;
  case 0b1010:
    grid[start.first][start.second] = 'J';
    break;
  case 0b0011:
    grid[start.first][start.second] = '-';
    break;
  case 0b1100:
    grid[start.first][start.second] = '|';
    break;
  default:
    assert(false && "Unreachable");
  }

  // Scale up the map by inserting empty cells between pipes.
  std::vector<std::string> scaledGrid;
  scaledGrid.emplace_back(grid[0].size() * 2 + 1, '.');

  for (size_t i = 0; i < grid.size(); ++i) {
    using namespace std::string_literals;

    std::string tmp = ".";
    for (size_t j = 0; j < grid[i].size(); ++j) {
      if (!visited.contains({i, j})) {
        tmp += "..";
        continue;
      }

      tmp += grid[i][j];
      tmp += "FL-"s.find(grid[i][j]) != std::string::npos ? '-' : '.';
    }

    scaledGrid.emplace_back(tmp);
    scaledGrid.emplace_back(tmp);

    for (auto &t : scaledGrid.back()) {
      t = "F7|"s.find(t) != std::string::npos ? '|' : '.';
    };
  }

  // BFS to find the outside cells.
  visited.clear();
  q.clear();

  q.emplace_back(0, 0);
  visited.emplace(0, 0);
  q.emplace_back(-1, -1);

  while (!q.empty()) {
    auto [r, c] = q.front();
    q.pop_front();

    if (r == -1 && c == -1) {
      if (!q.empty())
        q.emplace_back(-1, -1);

      continue;
    }

    for (size_t i = 0; i < 4; ++i) {
      int tr = r + vr[i];
      int tc = c + vc[i];

      if (tr < 0 || tr >= scaledGrid.size()        //
          || tc < 0 || tc >= scaledGrid[tr].size() //
      )
        continue;

      if (scaledGrid[tr][tc] == '.' && visited.emplace(tr, tc).second)
        q.emplace_back(tr, tc);
    }
  }

  // Scale the map down and check for unvisited tiles.
  size_t cnt = 0;
  for (size_t i = 1; i < scaledGrid.size(); i += 2) {
    for (size_t j = 1; j < scaledGrid[i].size(); j += 2)
      cnt += !visited.contains({i, j}) && scaledGrid[i][j] == '.';
  }

  return cnt;
};

int main() {

  std::vector<std::string> grid;
  std::pair<int, int> start;

  std::string line;
  while (std::getline(std::cin, line)) {
    if (auto pos = line.find('S'); pos != std::string::npos)
      start = {grid.size(), pos};

    grid.emplace_back(std::move(line));
  }

  std::cout << part1(grid, start) << '\n';
  std::cout << part2(grid, start) << '\n';

  return 0;
}
