#include <iostream>
#include <map>
#include <numeric>
#include <queue>
#include <sstream>
#include <string>
#include <vector>

enum Type { NONE, FLIP_FLOP, CONJUNCTION };

struct Module {
  Type type;
  std::string id;
  std::map<std::string, int> inputs;
  bool flipped = false;
};

using ModuleConnectionsT = std::map<std::string, std::vector<std::string>>;
using ModuleInfosT = std::map<std::string, Module>;

size_t part1(const ModuleConnectionsT &moduleConnections,
             ModuleInfosT moduleInfos) {

  size_t low = 0;
  size_t high = 0;
  for (size_t i = 0; i < 1000; ++i) {
    std::queue<std::pair<std::string, int>> q;
    q.emplace("broadcaster", 0);

    while (!q.empty()) {
      auto [cur, pulse] = q.front();
      q.pop();

      if (pulse)
        ++high;
      else
        ++low;

      auto &curInfo = moduleInfos.at(cur);

      if (curInfo.type == FLIP_FLOP) {
        if (pulse == 1)
          continue;

        pulse = curInfo.flipped ? 0 : 1;
        curInfo.flipped = !curInfo.flipped;
      }

      else if (curInfo.type == CONJUNCTION) {
        bool allHigh = true;
        for (auto &&[in, p] : curInfo.inputs)
          allHigh &= p;

        pulse = allHigh ? 0 : 1;
      }

      if (!moduleConnections.contains(cur))
        continue;

      for (auto &&c : moduleConnections.at(cur)) {
        auto &cInfo = moduleInfos[c];
        if (cInfo.type == CONJUNCTION)
          cInfo.inputs[cur] = pulse;

        q.emplace(c, pulse);
      }
    }
  }

  return low * high;
}

size_t part2(const ModuleConnectionsT &moduleConnections,
             ModuleInfosT moduleInfos) {
  auto subEndings = moduleInfos[moduleInfos["rx"].inputs.begin()->first].inputs;
  std::vector<int> cycles;

  size_t push = 1;
  while (cycles.size() != 4) {
    std::queue<std::pair<std::string, int>> q;
    q.emplace("broadcaster", 0);

    while (!q.empty()) {
      auto [cur, pulse] = q.front();
      q.pop();

      if (subEndings.contains(cur) && pulse == 0)
        cycles.emplace_back(push);

      auto &curInfo = moduleInfos[cur];
      if (curInfo.type == FLIP_FLOP) {
        if (pulse == 1)
          continue;

        pulse = curInfo.flipped ? 0 : 1;
        curInfo.flipped = !curInfo.flipped;
      }

      else if (curInfo.type == CONJUNCTION) {
        bool allHigh = true;
        for (auto &&[in, p] : curInfo.inputs)
          allHigh &= p;

        pulse = allHigh ? 0 : 1;
      }

      if (!moduleConnections.contains(cur))
        continue;

      for (auto &&c : moduleConnections.at(cur)) {
        auto &cInfo = moduleInfos[c];
        if (cInfo.type == CONJUNCTION)
          cInfo.inputs[cur] = pulse;

        q.emplace(c, pulse);
      }
    }

    ++push;
  }

  size_t res = 1;
  for (auto &&c : cycles)
    res = std::lcm(res, c);

  return res;
}

int main() {
  std::map<std::string, std::vector<std::string>> moduleConnections;
  std::map<std::string, Module> moduleInfos;

  std::string buffer;
  while (std::getline(std::cin, buffer)) {
    std::stringstream ss(buffer);
    ss >> buffer;

    Module module;
    module.id = buffer.substr(1);

    switch (buffer[0]) {
    case '%':
      module.type = FLIP_FLOP;
      break;
    case '&':
      module.type = CONJUNCTION;
      break;
    default:
      module.type = NONE;
      module.id = buffer;
      break;
    }

    moduleInfos[module.id] = module;

    ss >> buffer;
    ss.get();

    while (std::getline(ss, buffer, ',')) {
      ss.get();
      moduleConnections[module.id].emplace_back(buffer);
    }
  }

  for (auto &&[m, cs] : moduleConnections) {
    for (auto &&c : cs) {
      auto &details = moduleInfos[c];
      if (details.type == CONJUNCTION || c == "rx")
        details.inputs.emplace(m, 0);
    }
  }

  std::cout << part1(moduleConnections, moduleInfos) << '\n';
  std::cout << part2(moduleConnections, moduleInfos) << '\n';

  return 0;
}
