import 'dart:io';

bool isInvalid(String id, [bool allowRepeatedPattern = false]) {
  final idLength = id.length;

  if (allowRepeatedPattern) {
    for (var i = 1; i <= idLength ~/ 2; i++) {
      if (idLength % i != 0) continue;

      final pattern = id.substring(0, i);
      final repeated = List.generate(idLength ~/ i, (_) => pattern).join();
      if (id == repeated) return true;
    }
  }

  if (idLength % 2 == 1) return false;

  final splitAt = idLength ~/ 2;
  return id.substring(0, splitAt) == id.substring(splitAt);
}

List<int> intRange(String rangeDescriptor) {
  final split = rangeDescriptor.split('-');
  final begin = int.parse(split[0]);
  final end = int.parse(split[1]);
  return List.generate(end - begin + 1, (i) => begin + i);
}

int day1(List<String> ranges) {
  return ranges
      .expand((range) => intRange(range))
      .where((id) => isInvalid(id.toString()))
      .fold(0, (sum, id) => sum + id);
}

int day2(List<String> ranges) {
  return ranges
      .expand((range) => intRange(range))
      .where((id) => isInvalid(id.toString(), true))
      .fold(0, (sum, id) => sum + id);
}

void main() {
  final line = stdin.readLineSync()!;
  final ranges = line.split(',');

  print(day1(ranges));
  print(day2(ranges));
}
