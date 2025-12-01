import 'dart:io';

int day1(List<String> rotations) {
  int cnt = 0;

  int dial = 50;
  for (var rotation in rotations) {
    int amount = int.parse(rotation.substring(1));
    dial += rotation[0] == 'R' ? amount : -amount;
    dial %= 100;

    if (dial == 0) ++cnt;
  }

  return cnt;
}

int day2(List<String> rotations) {
  int cnt = 0;

  int dial = 50;
  for (var rotation in rotations) {
    for (var i = 0; i < int.parse(rotation.substring(1)); i++) {
      dial += rotation[0] == 'R' ? 1 : -1;
      dial %= 100;

      if (dial == 0) ++cnt;
    }
  }

  return cnt;
}

void main() {
  final rotations = <String>[];

  String? line;
  while ((line = stdin.readLineSync()) != null) rotations.add(line!);

  print(day1(rotations));
  print(day2(rotations));
}
