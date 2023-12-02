#include <iostream>
#include <sstream>
#include <string>
#include <vector>

struct CubeCount {
  int red{}, green{}, blue{};

  void setDefaults() {
    red = 12;
    green = 13;
    blue = 14;
  }

  bool isValid() { return red >= 0 && green >= 0 && blue >= 0; }
};

int part1(const std::string &line) {
  std::stringstream ss(line);

  // Game X:
  int id = 0;
  std::string str;
  ss >> str >> id;
  ss.get();

  CubeCount cc;
  cc.setDefaults();

  int n = 0;
  while (ss >> n >> str) {
    if (str.starts_with("red")) {
      cc.red -= n;
    } else if (str.starts_with("green")) {
      cc.green -= n;
    } else if (str.starts_with("blue")) {
      cc.blue -= n;
    }

    if (str.back() == ';' || str.back() != ',') {
      if (!cc.isValid()) {
        return 0;
      }

      cc.setDefaults();
    }
  }

  return id;
};

int part2(const std::string &line) {

  std::stringstream ss(line);

  CubeCount cc;
  int n = 0;
  std::string str;

  ss >> str >> n;
  ss.get();

  while (ss >> n >> str) {
    if (str.starts_with("red")) {
      cc.red = std::max(cc.red, n);
    } else if (str.starts_with("blue")) {
      cc.blue = std::max(cc.blue, n);
    } else if (str.starts_with("green")) {
      cc.green = std::max(cc.green, n);
    }
  }

  return cc.red * cc.green * cc.blue;
}

int main() {

  int part1Sum = 0;
  int part2Sum = 0;

  std::string line;
  while (std::getline(std::cin, line)) {
    part1Sum += part1(line);
    part2Sum += part2(line);
  }

  std::cout << part1Sum << '\n';
  std::cout << part2Sum << '\n';

  return 0;
}
