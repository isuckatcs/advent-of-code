#include <functional>
#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

size_t part1(const std::string &line, const std::vector<unsigned> &groups,
             size_t li = 0, size_t gi = 0) {
  if (li >= line.length())
    return gi == groups.size();

  for (size_t i = li; i < line.size(); ++i) {
    if (line[i] == '.')
      continue;

    if (gi == groups.size()) {
      if (line[i] == '#')
        return 0;

      continue;
    }

    size_t base = i;
    while (i < line.size() && (line[i] == '?' || line[i] == '#'))
      ++i;

    size_t next = groups[gi];
    bool canReplace = i - base >= next &&
                      (base + next == line.size() || line[base + next] != '#');

    // If the beginning of the current block can be replaced with the current
    // group, do it.
    size_t replaced =
        canReplace ? part1(line, groups, base + 1 + next, gi + 1) : 0;

    // If the block begins with a '?', pretend it couldn't be replaced.
    size_t skipped = line[base] == '?' ? part1(line, groups, base + 1, gi) : 0;

    return replaced + skipped;
  }

  return gi == groups.size();
};

size_t part2(const std::string &line, const std::vector<unsigned> &groups,
             size_t li = 0, size_t gi = 0) {

  std::map<std::pair<size_t, size_t>, size_t> cache;

  std::function<decltype(part2)> partialMemo =
      [&cache, &partialMemo](const std::string &line,
                             const std::vector<unsigned> &groups, size_t li = 0,
                             size_t gi = 0) -> size_t {
    if (li >= line.length())
      return gi == groups.size();

    if (cache.contains({li, gi}))
      return cache[{li, gi}];

    for (size_t i = li; i < line.size(); ++i) {
      if (line[i] == '.')
        continue;

      if (gi == groups.size()) {
        if (line[i] == '#')
          return 0;

        continue;
      }

      size_t base = i;
      while (i < line.size() && (line[i] == '?' || line[i] == '#'))
        ++i;

      size_t next = groups[gi];
      bool canReplace = i - base >= next && (base + next == line.size() ||
                                             line[base + next] != '#');

      // If the beginning of the current block can be replaced with the current
      // group, do it.
      size_t replaced =
          canReplace ? partialMemo(line, groups, base + 1 + next, gi + 1) : 0;

      // If the block begins with a '?', pretend it couldn't be replaced.
      size_t skipped =
          line[base] == '?' ? partialMemo(line, groups, base + 1, gi) : 0;

      cache[{li, gi}] = replaced + skipped;
      return replaced + skipped;
    }

    return gi == groups.size();
  };

  auto expandedLine = line;
  auto expandedGroups = groups;
  for (int i = 0; i < 4; ++i) {
    expandedLine += '?' + line;

    for (auto &&g : groups) {
      expandedGroups.emplace_back(g);
    }
  }

  return partialMemo(expandedLine, expandedGroups, li, gi);
};

int main() {

  size_t part1Sum = 0;
  size_t part2Sum = 0;

  std::string line;
  while (std::getline(std::cin, line)) {
    std::stringstream ss(line);

    std::string springs;
    ss >> springs;

    std::vector<unsigned> groups;
    unsigned x = 0;
    while (ss >> x) {
      ss.get();
      groups.emplace_back(x);
    }

    part1Sum += part1(springs, groups);
    part2Sum += part2(springs, groups);
  }

  std::cout << part1Sum << '\n';
  std::cout << part2Sum << '\n';

  return 0;
}
