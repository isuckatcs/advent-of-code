import 'dart:io';
import 'dart:math';

bool includes((int, int) range, int n) => range.$1 <= n && n <= range.$2;

(int, int) join((int, int) range, (int, int) other) {
  return (max(range.$1, other.$1) > min(range.$2, other.$2))
      ? range
      : (min(range.$1, other.$1), max(range.$2, other.$2));
}

int day1(List<(int, int)> ranges, List<int> ingredients) {
  return ingredients.where((i) => ranges.any((r) => includes(r, i))).length;
}

int day2(List<(int, int)> ranges) {
  while (true) {
    final newRanges = ranges.map((r) => ranges.fold(r, join)).toSet().toList();

    if (ranges.every((e) => newRanges.contains(e))) break;

    ranges = newRanges;
  }

  return ranges.fold(0, (sum, range) => sum + range.$2 - range.$1 + 1);
}

void main() {
  final ranges = <(int, int)>[];
  final ingredients = <int>[];

  String? line;
  while ((line = stdin.readLineSync()) != null && line!.isNotEmpty) {
    final [begin, end, ...] = line.split('-');
    ranges.add((int.parse(begin), int.parse(end)));
  }

  while ((line = stdin.readLineSync()) != null)
    ingredients.add(int.parse(line!));

  print(day1(ranges, ingredients));
  print(day2(ranges));
}
