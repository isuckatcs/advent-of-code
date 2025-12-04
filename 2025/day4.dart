import 'dart:io';

const dirs = [
  (-1, -1),
  (-1, 0),
  (-1, 1),
  (0, -1),
  (0, 1),
  (1, -1),
  (1, 0),
  (1, 1),
];

List<(int, int)> movableRolls(List<List<String>> grid) {
  final movable = <(int, int)>[];

  for (var r = 0; r < grid.length; r++) {
    for (var c = 0; c < grid[0].length; c++) {
      if (grid[r][c] != '@') continue;

      var adj = 0;
      for (var (dr, dc) in dirs) {
        final (nr, nc) = (r + dr, c + dc);

        if (nr < 0 || nc < 0 || nr == grid.length || nc == grid[0].length)
          continue;

        if (grid[nr][nc] == '@') adj++;
      }

      if (adj < 4) movable.add((r, c));
    }
  }

  return movable;
}

int day1(List<List<String>> grid) {
  return movableRolls(grid).length;
}

int day2(List<List<String>> grid) {
  var total = 0;

  while (true) {
    final movable = movableRolls(grid);
    if (movable.isEmpty) break;

    total += movable.length;
    for (var (r, c) in movable) grid[r][c] = '.';
  }

  return total;
}

void main() {
  final grid = <List<String>>[];

  String? line;
  while ((line = stdin.readLineSync()) != null)
    grid.add(line!.runes.map((r) => String.fromCharCode(r)).toList());

  print(day1(grid));
  print(day2(grid));
}
