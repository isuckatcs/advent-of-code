#include <iostream>
#include <optional>
#include <queue>
#include <set>
#include <string>
#include <vector>

using Point = std::pair<int, int>;
using Dir = std::pair<int, int>;
using Edge = std::pair<int, int>;

const static Dir DIRS[] = {{1, 0}, {-1, 0}, {0, -1}, {0, 1}};

static std::optional<Point> stepInDir(const std::vector<std::string> &map,
                                      const Point &pos, const Dir &dir) {
  int nr = pos.first + dir.first;
  int nc = pos.second + dir.second;

  if (nr < 0 || nr >= map.size() || nc < 0 || nc >= map[0].size() ||
      map[nr][nc] == '#')
    return std::nullopt;

  return {{nr, nc}};
}

size_t traverse(const std::vector<std::string> &map, const Point &pos,
                size_t steps, std::set<Point> &visited) {

  if (!visited.emplace(pos).second)
    return 0;

  const auto &[r, c] = pos;
  const auto cur = map[r][c];
  size_t res = 0;

  if (r == map.size() - 1)
    res = steps;
  else if (cur == '>')
    res = traverse(map, {r, c + 1}, steps + 1, visited);
  else if (cur == '^')
    res = traverse(map, {r - 1, c}, steps + 1, visited);
  else if (cur == '<')
    res = traverse(map, {r, c - 1}, steps + 1, visited);
  else if (cur == 'v')
    res = traverse(map, {r + 1, c}, steps + 1, visited);
  else
    for (auto &&d : DIRS)
      if (const auto &nd = stepInDir(map, pos, d))
        res = std::max(res, traverse(map, *nd, steps + 1, visited));

  visited.erase(pos);
  return res;
}

size_t part1(const std::vector<std::string> &map) {
  std::set<Point> visited;
  return traverse(map, {0, map[0].find('.')}, 0, visited);
}

size_t traverse2(std::vector<std::set<Edge>> &map, int pos, size_t steps,
                 std::set<int> &visited) {

  if (!visited.emplace(pos).second)
    return 0;

  if (pos == map.size() - 1) {
    visited.erase(pos);
    return steps;
  }

  size_t out = 0;
  for (auto &&[dst, w] : map.at(pos))
    out = std::max(out, traverse2(map, dst, steps + w, visited));

  visited.erase(pos);
  return out;
}

size_t part2(std::vector<std::string> map) {
  std::vector<std::pair<int, Point>> pois;

  pois.push_back({pois.size(), {0, map[0].find('.')}});
  for (size_t r = 0; r < map.size(); ++r) {
    for (size_t c = 0; c < map[0].size(); ++c) {
      if (map[r][c] != '.')
        continue;

      int roads = 0;
      for (auto &&d : DIRS)
        if (stepInDir(map, {r, c}, d))
          ++roads;

      if (roads > 2)
        pois.emplace_back(pois.size(), Point(r, c));
    }
  }
  pois.emplace_back(pois.size(), Point(map.size() - 1, map.back().find('.')));

  std::vector<std::set<Edge>> edges(pois.size());
  for (auto &&[pid, pp] : pois) {
    std::set<Point> visited;

    std::queue<std::pair<int, Point>> q;
    q.emplace(0, pp);

    while (!q.empty()) {
      auto [s, p] = q.front();
      q.pop();

      int pid2 = -1;
      for (auto &&[id, p2] : pois) {
        if (id != pid && p == p2)
          pid2 = id;
      }

      if (pid2 != -1) {
        edges[pid].emplace(pid2, s);
        edges[pid2].emplace(pid, s);
        continue;
      }

      if (!visited.emplace(p).second)
        continue;

      for (auto &&d : DIRS)
        if (const auto &nd = stepInDir(map, p, d))
          q.emplace(s + 1, *nd);
    }
  }

  std::set<int> visited;
  return traverse2(edges, 0, 0, visited);
}

int main() {
  std::vector<std::string> map;

  std::string buffer;
  while (std::getline(std::cin, buffer))
    map.emplace_back(buffer);

  std::cerr << part1(map) << '\n';
  std::cerr << part2(map) << '\n';

  return 0;
}
