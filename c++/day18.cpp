#include <iostream>
#include <map>
#include <queue>
#include <sstream>
#include <string>
#include <vector>

// Brute-force flood fill.
size_t part1(const std::vector<std::string> &moves) {
  std::vector<std::string> ground(1000, std::string(1000, '.'));
  std::pair<int, int> currentTile = {300, 300};

  for (auto &&m : moves) {
    std::istringstream ss(m);

    char dir = 'U';
    int steps = 0;
    ss >> dir >> steps;

    const static std::map<char, std::pair<int, int>> dirs{
        {'U', {-1, 0}},
        {'D', {1, 0}},
        {'L', {0, -1}},
        {'R', {0, 1}},
    };

    auto [r, c] = currentTile;
    auto [vr, vc] = dirs.at(dir);

    while (steps > 0) {
      r += vr;
      c += vc;
      ground[r][c] = '#';
      --steps;
    }
    currentTile = {r, c};
  }

  std::queue<std::pair<int, int>> q;
  std::vector<std::vector<bool>> visited(
      ground.size(), std::vector<bool>(ground[0].size(), false));
  q.emplace(0, 0);
  visited[0][0] = true;

  size_t cnt = 1;
  while (!q.empty()) {
    auto [r, c] = q.front();
    q.pop();

    const static std::pair<int, int> dirs[] = {
        {-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    for (auto [vr, vc] : dirs) {
      auto nr = r + vr;
      auto nc = c + vc;

      if (nr < 0 || nr >= ground.size() || nc < 0 || nc >= ground[0].size())
        continue;

      if (visited[nr][nc])
        continue;

      visited[nr][nc] = true;

      if (ground[nr][nc] == '.') {
        ++cnt;
        q.emplace(nr, nc);
      }
    }
  }

  return ground.size() * ground[0].size() - cnt;
}

// A faster but overengineered algorithm.
size_t part2(const std::vector<std::string> &moves) {
  std::map<int, std::vector<std::pair<int, char>>> row2point;
  std::map<int, std::vector<std::pair<int, char>>> col2point;

  int curRow = 0;
  int curCol = 0;
  bool up = moves.back()[0] == 'U';
  bool right = moves[0][0] == 'R';

  for (auto &&m : moves) {
    std::stringstream ss(m);

    char eatChar = 'U';
    int eatSteps = 0;
    std::string hcode;
    ss >> eatChar >> eatSteps >> hcode;

    std::string hdist = hcode.substr(2, 5);
    int dir = hcode[7] - '0';
    int dist = 0;

    ss.clear();
    ss.str("");
    ss << std::hex << hdist;
    ss >> dist;

    // Step (1): Figure out the corners.
    if (dir == 3) {
      char corner = right ? 'J' : 'L';
      row2point[curRow].emplace_back(curCol, corner);
      col2point[curCol].emplace_back(curRow, corner);

      up = true;
      curRow -= dist;
    } else if (dir == 1) {
      char corner = right ? '7' : 'F';
      row2point[curRow].emplace_back(curCol, corner);
      col2point[curCol].emplace_back(curRow, corner);

      curRow += dist;
      up = false;
    } else if (dir == 0) {
      char corner = up ? 'F' : 'L';
      row2point[curRow].emplace_back(curCol, corner);
      col2point[curCol].emplace_back(curRow, corner);

      right = true;
      curCol += dist;
    } else if (dir == 2) {
      char corner = up ? '7' : 'J';
      row2point[curRow].emplace_back(curCol, corner);
      col2point[curCol].emplace_back(curRow, corner);

      right = false;
      curCol -= dist;
    }
  }

  // Step (2): Insert additional walls where needed.
  for (auto &[r, v] : row2point)
    std::sort(v.begin(), v.end());

  for (auto &[c, v] : col2point)
    std::sort(v.begin(), v.end());

  for (auto &[r, cs] : row2point) {
    std::vector<std::pair<int, char>> newWalls;

    for (auto &&[c, rs] : col2point) {
      auto it =
          std::upper_bound(rs.begin(), rs.end(), std::pair<int, char>(r, '.'));

      if (it != rs.begin() && it != rs.end() &&
          (it->second == 'J' || it->second == 'L'))
        newWalls.emplace_back(c, '|');
    }

    cs.insert(cs.end(), newWalls.begin(), newWalls.end());
    std::sort(cs.begin(), cs.end());
  }

  // Step (3): Remove the unneeded walls.
  for (auto &[r, v] : row2point) {
    std::vector<std::pair<int, char>> filtered;

    for (auto &&[c, w] : v)
      if (filtered.empty() || filtered.back().first != c)
        filtered.emplace_back(c, w);

    v = filtered;
  }

  // Step (4): Calculate and concatenate the areas of rectangles.
  size_t total = 0;
  std::vector<int> chunks;
  int prevR = -1;
  for (auto [r, v] : row2point) {

    // Figure out, in which colums the current row is going to continue and
    // compute the area of those chunks.
    if (prevR != -1) {
      for (size_t i = 0; i < chunks.size(); i += 2)
        total +=
            static_cast<size_t>(r - prevR) * (chunks[i + 1] - chunks[i] + 1);
    }

    chunks.clear();
    for (auto &&[c, w] : v)
      if (w == 'F' || w == '|' || w == '7')
        chunks.emplace_back(c);

    // Figure out the covered tiles in the current row.
    bool inside = true;
    bool rotated = false;
    int curI = 0;
    for (size_t i = 1; i < v.size(); ++i) {
      char curW = v[curI].second;

      if ((v[i].second == '7' && v[i - 1].second == 'L') ||
          (v[i].second == 'J' && v[i - 1].second == 'F')) {
        if (rotated)
          inside = false;
        rotated = true;
      }

      if (curW == 'F' &&
          ((v[i].second == '7' && !rotated) || v[i].second == '|'))
        inside = false;
      else if (curW == 'L' &&
               ((v[i].second == 'J' && !rotated) || v[i].second == '|'))
        inside = false;
      else if (curW == '|' && (v[i].second == '|' || rotated))
        inside = false;

      if (!inside) {
        total += v[i].first - v[curI].first + 1;
        curI = i + 1;
        ++i;

        inside = true;
        rotated = false;
      }
    }
    prevR = r + 1;
  }

  return total;
};

int main() {
  std::vector<std::string> moves;

  std::string line;
  while (std::getline(std::cin, line))
    moves.emplace_back(line);

  std::cout << part1(moves) << '\n';
  std::cout << part2(moves) << '\n';

  return 0;
}
