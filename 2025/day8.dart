import 'dart:io';
import 'dart:math';

typedef Coord3 = (int, int, int);

class UnionFind {
  final parents = <int, int>{};
  final size = <int, int>{};

  void add(int a) {
    parents[a] = a;
    size[a] = 1;
  }

  int find(int a) {
    return a == parents[a] ? a : find(parents[a]!);
  }

  void union(int a, int b) {
    final (s1, s2) = (find(a), find(b));
    if (s1 == s2) return;

    parents[s2] = s1;
    size[s1] = size[s1]! + size[s2]!;
    size.remove(s2);
  }
}

double dist(Coord3 p, Coord3 q) {
  final (d1, d2, d3) = (q.$1 - p.$1, q.$2 - p.$2, q.$3 - p.$3);
  return sqrt(d1 * d1 + d2 * d2 + d3 * d3);
}

int part1(List<Coord3> coords, List<(double, int, int)> sortedPairs) {
  final uf = UnionFind();
  for (var i = 0; i < coords.length; i++) uf.add(i);

  for (var i = 0; i < 1000; i++) {
    final (_, p, q) = sortedPairs[i];
    uf.union(p, q);
  }

  final sizes = uf.size.values.toList()..sort((a, b) => b.compareTo(a));
  return sizes.take(3).reduce((a, b) => a * b);
}

int part2(List<Coord3> coords, List<(double, int, int)> sortedPairs) {
  final uf = UnionFind();
  for (var i = 0; i < coords.length; i++) uf.add(i);

  var i = 0;
  while (true) {
    final (_, p, q) = sortedPairs[i++];
    uf.union(p, q);

    final sizes = uf.size.values.toList()..sort((a, b) => b.compareTo(a));
    if (sizes.first == coords.length) return coords[p].$1 * coords[q].$1;
  }
}

void main() {
  final coords = <Coord3>[];

  String? line;
  while ((line = stdin.readLineSync()) != null) {
    final [x, y, z, ...] = line!.split(',').map((e) => int.parse(e)).toList();
    coords.add((x, y, z));
  }

  final uniquePairs = <(double, int, int)>{};
  for (var i = 0; i < coords.length; i++) {
    for (var j = 0; j < coords.length; j++) {
      if (i == j) continue;

      uniquePairs.add((dist(coords[i], coords[j]), min(i, j), max(i, j)));
    }
  }

  final sortedPairs = uniquePairs.toList();
  sortedPairs.sort((a, b) => a.$1.compareTo(b.$1));

  print(part1(coords, sortedPairs));
  print(part2(coords, sortedPairs));
}
