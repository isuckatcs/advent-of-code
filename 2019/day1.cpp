#include <iostream>
#include <vector>

int solve(int mass, bool part1 = true) {
  int fuel = mass / 3 - 2;

  if (part1)
    return fuel;

  if (fuel <= 0)
    return 0;

  return fuel + solve(fuel, part1);
}

int part1(const std::vector<int> &masses) {
  int sum = 0;

  for (auto &&mass : masses)
    sum += solve(mass);

  return sum;
}

int part2(const std::vector<int> &masses) {
  int sum = 0;

  for (auto &&mass : masses)
    sum += solve(mass, false);

  return sum;
}

int main() {
  std::vector<int> masses;

  int mass;
  while (std::cin >> mass)
    masses.emplace_back(mass);

  std::cout << part1(masses) << '\n';
  std::cout << part2(masses) << '\n';

  return 0;
}