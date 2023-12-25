#include <cstring>
#include <iostream>
#include <queue>
#include <string>
#include <utility>
#include <vector>

enum Dir : uint8_t { UP, DOWN, LEFT, RIGHT };

struct Data {
  size_t dist;
  int r;
  int c;
  int s;
  Dir d;
};

template <> struct std::greater<Data> {
  bool operator()(const Data &lhs, const Data &rhs) const {
    return lhs.dist > rhs.dist;
  }
};

size_t part1(const std::vector<std::string> &blocks) {

  bool visited[150][150][4][4];
  std::memset((void *)&visited, 0, sizeof(visited));

  std::priority_queue<Data, std::vector<Data>, std::greater<Data>> q;

  q.emplace(blocks[0][1] - '0', 0, 1, 1, RIGHT);
  q.emplace(blocks[1][0] - '0', 1, 0, 1, DOWN);

  while (!q.empty()) {
    auto [w, r, c, s, d] = q.top();
    q.pop();

    if (r == blocks.size() - 1 && c == blocks[0].size() - 1)
      return w;

    if (visited[r][c][d][s])
      continue;

    visited[r][c][d][s] = true;

    static std::pair<int, int> vd[] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    static Dir nds[4][2] = {
        {LEFT, RIGHT}, {LEFT, RIGHT}, {UP, DOWN}, {UP, DOWN}};

    if (s < 3) {
      auto [vr, vc] = vd[d];
      auto nr = r + vr;
      auto nc = c + vc;

      if (nr >= 0 && nr < blocks.size() && nc >= 0 && nc < blocks[0].size())
        q.emplace(w + blocks[nr][nc] - '0', nr, nc, s + 1, d);
    }

    for (auto &&nd : nds[d]) {
      auto [vr, vc] = vd[nd];
      auto nr = r + vr;
      auto nc = c + vc;

      if (nr < 0 || nr >= blocks.size() || nc < 0 || nc >= blocks[0].size())
        continue;

      q.emplace(w + blocks[nr][nc] - '0', nr, nc, 1, nd);
    }
  }

  return 0;
}

size_t part2(const std::vector<std::string> &blocks) {
  bool visited[200][200][4][10];
  std::memset((void *)&visited, 0, sizeof(visited));

  std::priority_queue<Data, std::vector<Data>, std::greater<Data>> q;

  q.emplace(blocks[0][1] - '0', 0, 1, 1, RIGHT);
  q.emplace(blocks[1][0] - '0', 1, 0, 1, DOWN);

  while (!q.empty()) {

    auto [w, r, c, s, d] = q.top();
    q.pop();

    if (r == blocks.size() - 1 && c == blocks[0].size() - 1 && s >= 4)
      return w;

    if (visited[r][c][d][s])
      continue;

    visited[r][c][d][s] = true;

    static std::pair<int, int> vd[] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    static Dir nds[4][2] = {
        {LEFT, RIGHT}, {LEFT, RIGHT}, {UP, DOWN}, {UP, DOWN}};

    if (s < 10) {
      auto [vr, vc] = vd[d];
      auto nr = r + vr;
      auto nc = c + vc;

      if (nr >= 0 && nr < blocks.size() && nc >= 0 && nc < blocks[0].size())
        q.emplace(w + blocks[nr][nc] - '0', nr, nc, s + 1, d);

      if (s < 4)
        continue;
    }

    for (auto &&nd : nds[d]) {
      auto [vr, vc] = vd[nd];
      auto nr = r + vr;
      auto nc = c + vc;

      if (nr < 0 || nr >= blocks.size() || nc < 0 || nc >= blocks[0].size())
        continue;

      q.emplace(w + blocks[nr][nc] - '0', nr, nc, 1, nd);
    }
  }

  return 0;
};

int main() {
  std::vector<std::string> blocks;

  std::string line;
  while (std::getline(std::cin, line))
    blocks.emplace_back(line);

  std::vector<std::vector<bool>> v(blocks.size(),
                                   std::vector<bool>(blocks[0].size(), false));
  std::cout << part1(blocks) << '\n';
  std::cout << part2(blocks) << '\n';

  return 0;
}
