import 'dart:io';

int part1(List<List<String>> shapes, List<((int, int), List<int>)> queries) {
  return queries.where((q) {
    final ((w, h), counts) = q;
    return w * h >= counts.fold(0, (v, c) => v + 9 * c);
  }).length;
}

int part2() {
  return 0;
}

void main() {
  final lines = <String>[];
  String? line;
  while ((line = stdin.readLineSync()) != null) lines.add(line!);

  final shapes = <List<String>>[];
  final queries = <((int, int), List<int>)>[];

  for (var i = 0; i < 30; i += 5) shapes.add(lines.sublist(i + 1, i + 4));
  for (var i = 30; i < lines.length; i++) {
    final [d, q, ...] = lines[i].split(': ');
    final [w, h, ...] = d.split('x').map((e) => int.parse(e)).toList();
    queries.add(((w, h), q.split(' ').map((q) => int.parse(q)).toList()));
  }

  print(part1(shapes, queries));
  print(part2());
}
