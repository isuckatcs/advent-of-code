import 'dart:io';

int solve(List<List<int>> nrs, List<String> ops) {
  return Iterable.generate(nrs.length)
      .map((i) => nrs[i].reduce((a, b) => ops[i] == '*' ? (a * b) : (a + b)))
      .reduce((a, b) => a + b);
}

int day1(List<String> lines) {
  final elements = lines.map((l) => l.trim().split(RegExp(r'\s+')));
  final rows = Iterable.generate(elements.length - 1);
  final cols = Iterable.generate(elements.first.length);

  final operands = cols
      .map((c) => rows.map((r) => int.parse(elements.elementAt(r)[c])).toList())
      .toList();

  return solve(operands, elements.last);
}

int day2(List<String> lines) {
  final numberLines = lines.take(lines.length - 1);
  final chunks = RegExp(r'[+*]\s+').allMatches(lines.last + ' ');

  final operands = chunks.map((chunk) {
    final tmp = <int>[];

    for (var digit = chunk.end - 2; digit >= chunk.start; digit--)
      tmp.add(int.parse(numberLines.map((l) => l[digit]).join()));

    return tmp;
  }).toList();

  final ops = chunks.map((c) => c.group(0)![0]).toList();
  return solve(operands, ops);
}

void main() {
  final lines = <String>[];

  String? line;
  while ((line = stdin.readLineSync()) != null) lines.add(line!);

  print(day1(lines));
  print(day2(lines));
}
