#include <iostream>
#include <map>
#include <string>
#include <utility>
#include <vector>

enum LightDir : uint8_t {
  UP = 1 << 0,
  DOWN = 1 << 1,
  LEFT = 1 << 2,
  RIGHT = 1 << 3
};

struct Light {
  int r;
  int c;
  LightDir dir;
};

struct LightProperties {
  int vx;
  int vy;
  std::vector<std::pair<char, uint8_t>> colliders;
};

static const std::map<LightDir, LightProperties> vd = {
    {UP, {-1, 0, {{'\\', LEFT}, {'/', RIGHT}, {'-', LEFT | RIGHT}}}},
    {DOWN, {1, 0, {{'\\', RIGHT}, {'/', LEFT}, {'-', LEFT | RIGHT}}}},
    {LEFT, {0, -1, {{'\\', UP}, {'/', DOWN}, {'|', UP | DOWN}}}},
    {RIGHT, {0, 1, {{'\\', DOWN}, {'/', UP}, {'|', UP | DOWN}}}},
};

size_t part1(const std::vector<std::string> &cave,
             Light start = {0, 0, RIGHT}) {

  std::vector<Light> lights = {start};
  std::vector<std::vector<uint8_t>> energized(
      cave.size(), std::vector<uint8_t>(cave[0].size(), 0));

  while (!lights.empty()) {
    auto [r, c, dir] = lights.back();
    lights.pop_back();

    if (energized[r][c] & dir)
      continue;

    const auto &[vr, vy, cs] = vd.at(dir);

    while (true) {
      if (r < 0 || r >= cave.size() || c < 0 || c >= cave[0].size())
        break;

      energized[r][c] |= dir;

      bool collide = false;
      for (auto &&collider : cs) {
        const auto &[ch, d] = collider;

        if (ch != cave[r][c])
          continue;

        for (uint8_t i = 0; i < 4; ++i) {
          auto ld = static_cast<LightDir>(1U << i);

          if (d & ld) {
            auto [vr, vc, _] = vd.at(ld);
            int nr = r + vr;
            int nc = c + vc;

            if (nr < 0 || nr >= cave.size() || nc < 0 || nc >= cave[0].size())
              continue;

            lights.emplace_back(nr, nc, ld);
          }
        }
        collide = true;
      }

      if (collide)
        break;

      r += vr;
      c += vy;
    }
  }

  size_t e = 0;
  for (auto &&r : energized)
    for (auto &&c : r)
      e += c > 0;

  return e;
};

size_t part2(const std::vector<std::string> &cave) {

  std::vector<Light> startingLights;

  for (size_t i = 0; i < cave.size(); ++i) {
    startingLights.emplace_back(i, 0, RIGHT);
    startingLights.emplace_back(i, cave[0].size() - 1, LEFT);
  }

  for (size_t i = 0; i < cave[0].size(); ++i) {
    startingLights.emplace_back(0, i, DOWN);
    startingLights.emplace_back(cave.size() - 1, i, UP);
  }

  std::size_t m = 0;
  for (auto &&start : startingLights)
    m = std::max(m, part1(cave, start));

  return m;
};

int main() {
  std::vector<std::string> cave;

  std::string line;
  while (std::getline(std::cin, line))
    cave.emplace_back(line);

  std::cout << part1(cave) << '\n';
  std::cout << part2(cave) << '\n';

  return 0;
}
