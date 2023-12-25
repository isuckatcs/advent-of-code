#include <iostream>
#include <map>
#include <random>
#include <ranges>
#include <set>
#include <sstream>
#include <string>
#include <vector>

size_t part1(const std::map<std::string, std::set<std::string>> &components) {

  std::map<std::string, int> node2id;
  for (auto &&[node, _] : components)
    node2id[node] = node2id.size();

  std::vector<std::set<int>> originalSubsets;
  std::vector<std::pair<int, int>> originalEdges;

  for (auto &&[n, es] : components) {
    originalSubsets.push_back({node2id[n]});

    for (auto &&e : es)
      originalEdges.emplace_back(node2id[n], node2id[e]);
  }

  std::mt19937 mt(std::random_device{}());
  while (true) {
    std::vector<std::set<int>> subsets = originalSubsets;
    std::vector<std::pair<int, int>> edges = originalEdges;

    while (subsets.size() > 2) {
      int n = std::uniform_int_distribution<int>(0, edges.size() - 1)(mt);

      auto [b, e] = edges[n];
      edges.erase(edges.begin() + n);

      int s1 = -1;
      int s2 = -1;

      for (auto i : std::views::iota(0U, subsets.size())) {
        if (subsets[i].contains(b))
          s1 = i;
        if (subsets[i].contains(e))
          s2 = i;
      }

      if (s1 == s2)
        continue;

      subsets[s1].insert(subsets[s2].begin(), subsets[s2].end());
      subsets.erase(subsets.begin() + s2);
    }

    size_t cuts = 0;
    for (auto &&[b, e] : originalEdges)
      if (subsets[0].contains(b) && subsets[1].contains(e))
        ++cuts;

    if (cuts == 3)
      return subsets[0].size() * subsets[1].size();
  }
}

size_t part2() { return 0; }

int main() {
  std::map<std::string, std::set<std::string>> components;

  std::string buffer;
  while (std::getline(std::cin, buffer)) {
    std::stringstream ss(buffer);
    ss >> buffer;

    buffer.pop_back();
    std::string head = buffer;

    while (ss >> buffer) {
      components[head].emplace(buffer);
      components[buffer].emplace(head);
    }
  }

  std::cerr << part1(components) << '\n';
  std::cerr << part2() << '\n';

  return 0;
}
