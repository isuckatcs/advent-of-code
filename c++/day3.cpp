#include <iostream>
#include <string>
#include <vector>

bool isDigit(char c) { return c >= '0' && c <= '9'; };

int part1(const std::vector<std::string> &lines) {
  int out = 0;

  for (int i = 0; i < lines.size(); ++i) {
    for (int j = 0; j < lines[i].size(); ++j) {

      if (lines[i][j] == '.' || isDigit(lines[i][j]))
        continue;

      static int di[] = {-1, -1, -1, 0, 0, 1, 1, 1};
      static int dj[] = {0, -1, 1, -1, 1, 0, -1, 1};

      for (int d = 0; d < sizeof(di) / sizeof(di[0]); ++d) {
        int ti = i + di[d];
        int tj = j + dj[d];

        if (ti < 0 || ti >= lines.size())
          continue;

        if (tj < 0 || tj >= lines[i].size())
          continue;

        if (!isDigit(lines[ti][tj]))
          continue;

        int b = tj;
        int e = tj;

        while (b >= 0 && isDigit(lines[ti][b]))
          --b;
        while (e < lines[ti].size() && isDigit(lines[ti][e]))
          ++e;

        int n = std::stoi(lines[ti].substr(b + 1, e - b - 1));

        // If the character directly above or below the symbol is
        // a number, there cannot be one more adjacent number in
        // the same row, so the checks for that can be skipped.
        if (d == 0 || d == 5)
          d += 2;

        out += n;
      }
    }
  }

  return out;
};

int part2(const std::vector<std::string> &lines) {
  int out = 0;

  for (int i = 0; i < lines.size(); ++i) {
    for (int j = 0; j < lines[i].size(); ++j) {

      if (lines[i][j] != '*')
        continue;

      static int di[] = {-1, -1, -1, 0, 0, 1, 1, 1};
      static int dj[] = {0, -1, 1, -1, 1, 0, -1, 1};

      int n1 = 0, n2 = 0;
      for (int d = 0; d < sizeof(di) / sizeof(di[0]); ++d) {
        int ti = i + di[d];
        int tj = j + dj[d];

        if (ti < 0 || ti >= lines.size())
          continue;

        if (tj < 0 || tj >= lines[i].size())
          continue;

        if (!isDigit(lines[ti][tj]))
          continue;

        int b = tj;
        int e = tj;

        while (b >= 0 && isDigit(lines[ti][b]))
          --b;
        while (e < lines[ti].size() && isDigit(lines[ti][e]))
          ++e;

        int n = std::stoi(lines[ti].substr(b + 1, e - b - 1));

        if (!n1) {
          n1 = n;
        } else if (!n2) {
          n2 = n;
        } else {
          n1 = n2 = 0;
          break;
        }

        // If the character directly above or below the symbol is
        // a number, there cannot be one more adjacent number in
        // the same row, so the checks for that can be skipped.
        if (d == 0 || d == 5)
          d += 2;
      }

      out += n1 * n2;
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
