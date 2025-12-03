import 'dart:io';

int largestJoltage(String bank, int nrOfBatteries) {
  final batteryIndices = <int>[];

  while (batteryIndices.length != nrOfBatteries) {
    var begin = batteryIndices.isEmpty ? 0 : batteryIndices.last + 1;
    var end = bank.length;

    if (begin == end) {
      var i = batteryIndices.length - 1;
      while (i >= 0 && batteryIndices[i] == end - 1) {
        end = batteryIndices[i];
        i--;
      }

      begin = i >= 0 ? batteryIndices[i] + 1 : 0;
    }

    final batteryIdx = bank.runes.indexed
        .skip(begin)
        .take(end - begin)
        .reduce((max, cur) => max.$2.compareTo(cur.$2) >= 0 ? max : cur)
        .$1;

    batteryIndices.add(batteryIdx);
    batteryIndices.sort((a, b) => a.compareTo(b));
  }

  final n = int.parse(batteryIndices.map((n) => bank[n]).join());
  return n;
}

int day1(List<String> banks) {
  return banks
      .map((bank) => largestJoltage(bank, 2))
      .reduce((acc, e) => acc + e);
}

int day2(List<String> banks) {
  return banks
      .map((bank) => largestJoltage(bank, 12))
      .reduce((acc, e) => acc + e);
}

void main() {
  final banks = <String>[];

  String? line;
  while ((line = stdin.readLineSync()) != null) banks.add(line!);

  print(day1(banks));
  print(day2(banks));
}
