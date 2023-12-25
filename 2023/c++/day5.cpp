#include <iostream>
#include <sstream>
#include <string>
#include <vector>

unsigned part1(const std::vector<std::string> &lines) {
  std::stringstream ss(lines[0]);

  std::string dummy;
  ss >> dummy;

  std::vector<unsigned> nums;
  unsigned n = 0;
  while (ss >> n) {
    nums.emplace_back(n);
  }

  std::vector<unsigned> tmp = nums;
  for (unsigned i = 1; i < lines.size(); ++i) {
    ss.clear();
    ss.str(lines[i]);

    unsigned dst = 0, src = 0, len = 0;
    if (!(ss >> dst >> src >> len)) {
      nums = tmp;
      ++i;
      continue;
    }

    for (unsigned i = 0; i < nums.size(); ++i) {
      auto prev = nums[i];
      if (prev >= src && prev < src + len) {
        tmp[i] = dst + prev - src;
      }
    }
  }

  return *std::min_element(tmp.begin(), tmp.end());
};

// Brute-force
unsigned part2(const std::vector<std::string> &lines) {
  std::stringstream ss(lines[0]);

  std::string dummy;
  ss >> dummy;

  std::vector<unsigned> nums;
  unsigned b = 0, l = 0;
  while (ss >> b >> l) {

    std::cerr << '(' << b << ", " << l << ")\n";

    for (unsigned i = 0; i < l; ++i) {
      nums.emplace_back(b + i);
    }
  }

  std::vector<unsigned> tmp = nums;
  for (unsigned i = 1; i < lines.size(); ++i) {

    std::cerr << lines[i] << '\n';

    ss.clear();
    ss.str(lines[i]);

    unsigned dst = 0, src = 0, len = 0;
    if (!(ss >> dst >> src >> len)) {
      nums = tmp;

      ++i;
      continue;
    }

    for (unsigned i = 0; i < nums.size(); ++i) {
      auto prev = nums[i];
      if (prev >= src && prev < src + len) {
        tmp[i] = dst + prev - src;
      }
    }
  }

  return *std::min_element(tmp.begin(), tmp.end());
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
