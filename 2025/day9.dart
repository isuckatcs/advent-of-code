import 'dart:io';
import 'dart:math';

typedef Coord2 = (int, int);

int part1(List<Coord2> coords) {
  var largestArea = 0;

  for (var (x1, y1) in coords)
    for (var (x2, y2) in coords)
      largestArea = max(
        largestArea,
        ((x2 - x1).abs() + 1) * ((y2 - y1).abs() + 1),
      );

  return largestArea;
}

int part2(List<Coord2> coords) {
  final xAxes = <int>{};
  final yAxes = <int>{};
  for (var (x, y) in coords) {
    xAxes.add(x);
    yAxes.add(y);
  }

  final xAxesSorted = xAxes.toList()..sort();
  final yAxesSorted = yAxes.toList()..sort();
  final sqashedGrid = List.generate(
    yAxesSorted.length * 2 + 1,
    (_) => List.filled(xAxesSorted.length * 2 + 1, false),
  );

  final coordToGridPos = <Coord2, Coord2>{};
  for (var i = 0; i < coords.length; i++) {
    final (x1, y1) = coords[i];
    final (x2, y2) = coords[(i + 1) % coords.length];

    final (gridX1, gridY1) = (
      xAxesSorted.indexOf(x1) * 2 + 1,
      yAxesSorted.indexOf(y1) * 2 + 1,
    );
    final (gridX2, gridY2) = (
      xAxesSorted.indexOf(x2) * 2 + 1,
      yAxesSorted.indexOf(y2) * 2 + 1,
    );

    coordToGridPos[(x1, y1)] = (gridX1, gridY1);
    for (var x = min(gridX1, gridX2); x <= max(gridX1, gridX2); x++)
      for (var y = min(gridY1, gridY2); y <= max(gridY1, gridY2); y++)
        sqashedGrid[y][x] = true;
  }

  final externalPoints = <Coord2>{};
  final stack = [(0, 0)];
  while (stack.isNotEmpty) {
    final (x, y) = stack.removeLast();

    if (!externalPoints.add((x, y))) continue;

    for (var (dx, dy) in [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
      final (nx, ny) = (x + dx, y + dy);

      if (ny < 0 ||
          ny == sqashedGrid.length ||
          nx < 0 ||
          nx == sqashedGrid[0].length ||
          sqashedGrid[ny][nx])
        continue;

      stack.add((nx, ny));
    }
  }

  final externalRangesPerRow = <List<(int, int)>>[];
  for (var y = 0; y < sqashedGrid.length; y++) {
    externalRangesPerRow.add([]);
    var x = 0;

    final rowLength = sqashedGrid[0].length;
    while (x < rowLength) {
      if (!externalPoints.contains((x, y))) {
        x++;
        continue;
      }

      final begin = x;
      while (x < rowLength && externalPoints.contains((x, y))) x++;
      externalRangesPerRow[y].add((begin, x - 1));
    }
  }

  final externalRangesPerCol = <List<(int, int)>>[];
  for (var x = 0; x < sqashedGrid[0].length; x++) {
    externalRangesPerCol.add([]);
    var y = 0;

    final colLength = sqashedGrid.length;
    while (y < colLength) {
      if (!externalPoints.contains((x, y))) {
        y++;
        continue;
      }

      final begin = y;
      while (y < colLength && externalPoints.contains((x, y))) y++;
      externalRangesPerCol[x].add((begin, y - 1));
    }
  }

  var largestArea = 0;

  for (var c1 in coords) {
    for (var c2 in coords) {
      final (x1, y1) = coordToGridPos[c1]!;
      final (x2, y2) = coordToGridPos[c2]!;

      final (minX, maxX) = (min(x1, x2), max(x1, x2));
      final (minY, maxY) = (min(y1, y2), max(y1, y2));

      var touchesExternalPoint = false;
      touchesExternalPoint |= externalRangesPerRow[minY].any(
        (r) => minX <= r.$2 && r.$1 <= maxX,
      );
      touchesExternalPoint |= externalRangesPerRow[maxY].any(
        (r) => minX <= r.$2 && r.$1 <= maxX,
      );
      touchesExternalPoint |= externalRangesPerCol[minX].any(
        (r) => minY <= r.$1 && r.$2 <= maxY,
      );
      touchesExternalPoint |= externalRangesPerCol[maxX].any(
        (r) => minY <= r.$1 && r.$2 <= maxY,
      );

      if (touchesExternalPoint) continue;

      largestArea = max(
        largestArea,
        ((c2.$1 - c1.$1).abs() + 1) * ((c2.$2 - c1.$2).abs() + 1),
      );
    }
  }

  return largestArea;
}

void main() {
  final coords = <Coord2>[];
  String? line;
  while ((line = stdin.readLineSync()) != null) {
    final [x, y, ...] = line!.split(',').map((e) => int.parse(e)).toList();
    coords.add((x, y));
  }

  print(part1(coords));
  print(part2(coords));
}
