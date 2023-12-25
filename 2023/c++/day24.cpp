#include <cmath>
#include <iostream>
#include <optional>
#include <ranges>
#include <sstream>
#include <string>
#include <vector>

const float epsilon = 1e-3;

struct Vec3 {
  long long x;
  long long y;
  long long z;

  Vec3 operator+(const Vec3 &rhs) const {
    return {x + rhs.x, y + rhs.y, z + rhs.z};
  }

  Vec3 operator-(const Vec3 &rhs) const {
    return {x - rhs.x, y - rhs.y, z - rhs.z};
  }

  Vec3 operator*(long long n) const { return {x * n, y * n, z * n}; }

  bool operator==(const Vec3 &rhs) const {
    return x == rhs.x && y == rhs.y && z == rhs.z;
  }
};

struct Hailstone {
  Vec3 pos;
  Vec3 dir;
};

std::optional<std::pair<double, double>> intersect(const Hailstone &h1,
                                                   const Hailstone &h2) {
  const auto &[p1, d1] = h1;
  const auto &[p2, d2] = h2;

  double a = d1.y / (d1.x * 1.);
  double c = p1.y - a * p1.x;

  double b = d2.y / (d2.x * 1.);
  double d = p2.y - b * p2.x;

  if (std::abs(a - b) < epsilon)
    return std::nullopt;

  double x = (d - c) / (a - b);
  double t1 = (x - p1.x) / (d1.x * 1.);
  double t2 = (x - p2.x) / (d2.x * 1.);

  if (t1 < 0 || t2 < 0)
    return std::nullopt;

  return std::make_pair(t1, t2);
}

size_t part1(const std::vector<Hailstone> &hailstones) {
  const size_t begin = 200000000000000;
  const size_t end = 400000000000000;

  size_t cnt = 0;
  for (auto i : std::views::iota(0U, hailstones.size())) {
    for (auto j : std::views::iota(i + 1, hailstones.size())) {
      if (auto is = intersect(hailstones[i], hailstones[j])) {
        const auto &[p, d] = hailstones[i];
        double x = p.x + is->first * d.x;
        double y = p.y + is->first * d.y;

        if (begin <= x && x <= end && begin <= y && y <= end)
          ++cnt;
      }
    }
  }

  return cnt;
}

size_t part2(const std::vector<Hailstone> &hailstones) {
  const int n = 250;

  for (int x : std::ranges::views::iota(-n, n + 1)) {
    for (int y : std::ranges::views::iota(-n, n + 1)) {
      for (int z : std::ranges::views::iota(-n, n + 1)) {
        Vec3 cv{x, y, z};

        auto [p0, d0] = hailstones[0];
        auto [p1, d1] = hailstones[1];

        d0 = d0 - cv;
        d1 = d1 - cv;

        if (d0.x == 0 || d1.x == 0)
          continue;

        if (auto ts = intersect({p0, d0}, {p1, d1})) {
          auto [t1, t2] = *ts;

          if (std::abs(std::round(t1) - t1) >= epsilon ||
              std::abs(std::round(t2) - t2) >= epsilon)
            continue;

          Vec3 intersection = p0 + d0 * t1;
          const auto &[ix, iy, iz] = intersection;

          if (iz != p1.z + t2 * d1.z)
            continue;

          bool hit = true;
          for (size_t i = 2; hit && i < hailstones.size(); ++i) {
            auto [cp, cd] = hailstones[i];
            auto nd = cd - cv;

            long long tt = (ix - cp.x) / nd.x;
            hit &= intersection == cp + nd * tt;
          }

          if (hit)
            return ix + iy + iz;
        }
      }
    }
  }

  return 0;
}

int main() {
  auto parseVec3 = [](std::istream &s) -> Vec3 {
    Vec3 v{};

    decltype(v.x) *coords[] = {&v.x, &v.y, &v.z};

    for (auto *c : coords) {
      s >> *c;
      s.get();
      s.get();
    }

    return v;
  };

  std::vector<Hailstone> hailstones;

  std::string buffer;
  while (std::getline(std::cin, buffer)) {
    std::stringstream ss(buffer);
    hailstones.push_back({parseVec3(ss), parseVec3(ss)});
  }

  std::cerr << part1(hailstones) << '\n';
  std::cerr << part2(hailstones) << '\n';

  return 0;
}
