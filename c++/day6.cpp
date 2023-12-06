#include <iostream>
#include <sstream>
#include <string>
#include <vector>

size_t part1(const std::vector<std::string> &lines) {
  std::vector<int> times;
  std::vector<int> distances;

  std::string category;
  int n = 0;

  std::stringstream ss(lines[0]);
  ss >> category;
  while (ss >> n) {
    times.emplace_back(n);
  }

  ss = std::stringstream(lines[1]);
  ss >> category;
  while (ss >> n) {
    distances.emplace_back(n);
  }

  size_t out = 1;
  for (size_t i = 0; i < times.size(); ++i) {
    size_t cnt = 0;

    for (int j = 0; j <= times[i]; ++j) {
      if ((times[i] - j) * j > distances[i]) {
        ++cnt;
      }
    }

    out *= cnt;
  }

  return out;
};

size_t part2(const std::vector<std::string> &lines) {
  std::vector<int> times;
  std::vector<int> distances;

  std::stringstream ss(lines[0]);
  std::string category;
  ss >> category;

  std::string time;
  std::string partial;
  while (ss >> partial) {
    time += partial;
  }

  ss = std::stringstream(lines[1]);
  ss >> category;

  std::string distance;
  while (ss >> partial) {
    distance += partial;
  }

  size_t out = 0;

  size_t t = std::stol(time);
  size_t d = std::stol(distance);
  for (int j = 0; j <= t; ++j) {
    if ((t - j) * j > d) {
      ++out;
    }
  }

  return out;
}

int main() {
  std::vector<std::string> lines;

  std::string line;
  while (std::getline(std::cin, line)) {
    lines.emplace_back(line);
  }

  std::cout << part1(lines) << '\n';
  std::cout << part2(lines) << '\n';

  return 0;
}
