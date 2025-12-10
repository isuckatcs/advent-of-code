import 'dart:collection';
import 'dart:io';
import 'package:z3/z3.dart';

typedef Blueprint = (int, List<List<int>>, List<int>);

int part1(List<Blueprint> blueprints) {
  var sum = 0;

  for (var (target, buttons, _) in blueprints) {
    final q = Queue<(int, int)>();
    q.add((0, 0));

    while (q.isNotEmpty) {
      final (state, buttonPresses) = q.removeFirst();

      if (state == target) {
        sum += buttonPresses;
        break;
      }

      for (var button in buttons) {
        var newState = state;
        for (var idx in button) newState ^= 1 << idx;
        q.add((newState, buttonPresses + 1));
      }
    }
  }

  return sum;
}

int part2(List<Blueprint> blueprints) {
  var sum = 0;

  for (final (_, buttons, joltages) in blueprints) {
    final opt = optimize();
    final xs = List.generate(buttons.length, (i) => constVar('x$i', intSort));
    xs.forEach((x) => opt.add(x >= 0));

    for (final (jIdx, joltage) in joltages.indexed) {
      Expr equation = intFrom(0);
      for (final (xIdx, x) in xs.indexed)
        equation += x * (buttons[xIdx].contains(jIdx) ? 1 : 0);

      opt.add(equation.eq(joltage));
    }

    opt.minimize(xs.map((x) => x as Expr).reduce((a, b) => a + b));
    opt.check();

    final model = opt.getModel();
    sum += xs.map((x) => model[x].toInt()).reduce((a, b) => a + b);
  }

  return sum;
}

void main() {
  final regex = RegExp(r'\[(.*)\] (\(.*\))+ \{(.*)\}');
  final blueprints = <Blueprint>[];

  String? line;
  while ((line = stdin.readLineSync()) != null) {
    final match = regex.firstMatch(line!)!;

    var targetState = 0;
    final target = match.group(1)!;
    for (var i = 0; i < target.length; i++)
      if (target[i] == '#') targetState |= (1 << i);

    final buttons = match
        .group(2)!
        .split(' ')
        .map(
          (s) => s
              .substring(1, s.length - 1)
              .split(',')
              .map((s) => int.parse(s))
              .toList(),
        )
        .toList();

    final joltages = match
        .group(3)!
        .split(',')
        .map((e) => int.parse(e))
        .toList();

    blueprints.add((targetState, buttons, joltages));
  }

  print(part1(blueprints));
  print(part2(blueprints));
}
