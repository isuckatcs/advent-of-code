#include <algorithm>
#include <iostream>
#include <map>
#include <queue>
#include <ranges>
#include <set>
#include <sstream>
#include <string>

struct Point {
  union {
    int arr[3];

    struct {
      int x;
      int y;
      int z;
    };
  };
};

struct Brick {
  size_t id;
  Point begin;
  Point end;
};

struct CollisionData {
  std::vector<int> supports;
  std::vector<int> supportedBy;
};

using CollisionDataMap = std::map<size_t, CollisionData>;

CollisionDataMap simulateGravity(std::vector<Brick> bricks) {
  std::sort(bricks.begin(), bricks.end(),
            [](Brick lhs, Brick rhs) { return rhs.begin.z > lhs.begin.z; });

  CollisionDataMap collisionDatas;

  for (auto &[i, b, e] : bricks) {
    collisionDatas[i].supports = {};

    std::vector<std::pair<int, int>> maybeCollides;
    int zCollision = 1;

    for (auto &&[ci, cb, ce] : bricks) {
      if (i == ci)
        continue;

      int xb = std::max(cb.x, b.x);
      int xe = std::min(ce.x, e.x);

      int yb = std::max(cb.y, b.y);
      int ye = std::min(ce.y, e.y);

      if (xb > xe || yb > ye)
        continue;

      if (ce.z + 1 <= b.z) {
        zCollision = std::max(zCollision, ce.z + 1);
        maybeCollides.emplace_back(ci, ce.z + 1);
      }
    }

    int fall = b.z - zCollision;
    b.z -= fall;
    e.z -= fall;

    for (auto &&[id, z] : maybeCollides) {
      if (z == zCollision) {
        collisionDatas[id].supports.emplace_back(i);
        collisionDatas[i].supportedBy.emplace_back(id);
      }
    }
  }

  return collisionDatas;
}

size_t part1(const CollisionDataMap &collisionDatas) {

  size_t removed = 0;
  for (auto &&[block, data] : collisionDatas) {
    bool canRemove = true;
    for (auto &&supported : data.supports)
      canRemove &= collisionDatas.at(supported).supportedBy.size() > 1;

    removed += canRemove;
  }

  return removed;
}

size_t part2(const CollisionDataMap &collisionDatas) {

  size_t total = 0;
  for (auto &&[block, _] : collisionDatas) {
    std::queue<int> q;
    q.emplace(block);

    std::set<int> visited;
    visited.emplace(block);

    size_t falling = 0;
    while (!q.empty()) {
      int b = q.front();
      q.pop();

      for (auto &&supported : collisionDatas.at(b).supports) {
        if (visited.contains(supported))
          continue;

        bool supportersFalling = true;
        for (auto &&supporter : collisionDatas.at(supported).supportedBy)
          supportersFalling &= visited.contains(supporter);

        if (supportersFalling) {
          q.emplace(supported);
          visited.emplace(supported);
          falling += 1;
        }
      }
    }

    total += falling;
  }

  return total;
}

int main() {
  auto parsePoint = [](std::istream &s) -> Point {
    Point p{};

    for (int &coord : p.arr) {
      s >> coord;
      s.get();
    }

    return p;
  };

  std::vector<Brick> bricks;

  std::string buffer;
  while (std::getline(std::cin, buffer)) {
    std::stringstream ss(buffer);
    bricks.push_back({bricks.size(), parsePoint(ss), parsePoint(ss)});
  }

  auto collisionDatas = simulateGravity(std::move(bricks));

  std::cerr << part1(collisionDatas) << '\n';
  std::cerr << part2(collisionDatas) << '\n';

  return 0;
}
