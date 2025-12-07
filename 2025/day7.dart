import 'dart:io';

int part1((int, int) pos, List<String> grid, Set<(int, int)> visited) {
  final (row, col) = pos;

  if (!visited.add(pos) || row == grid.length) return 0;

  if (grid[row][col] == "^") {
    return 1 +
        part1((row, col - 1), grid, visited) +
        part1((row, col + 1), grid, visited);
  }

  return part1((row + 1, col), grid, visited);
}

int part2((int, int) pos, List<String> grid, Map<(int, int), int> dp) {
  final cached = dp[pos];
  if (cached != null) return cached;

  final (row, col) = pos;
  if (row == grid.length) return 1;

  final val = grid[row][col] == "^"
      ? part2((row, col - 1), grid, dp) + part2((row, col + 1), grid, dp)
      : part2((row + 1, col), grid, dp);
  dp[pos] = val;
  return val;
}

void main() {
  final grid = <String>[];

  String? line;
  while ((line = stdin.readLineSync()) != null) grid.add(line!);

  final start = (0, grid[0].indexOf('S'));
  print(part1(start, grid, {}));
  print(part2(start, grid, {}));
}
