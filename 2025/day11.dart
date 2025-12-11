import 'dart:io';

int solve(
  String node,
  Set<String> targets,
  Map<String, List<String>> nodeGraph,
  Map<(String, String), int> cache,
) {
  if (targets.isEmpty) return 1;

  final cached = cache[(node, targets.join(','))];
  if (cached != null) return cached;

  final children = nodeGraph[node];
  if (children == null) return 0;

  final paths = children.fold(
    0,
    (v, c) => v + solve(c, {...targets.where((t) => t != c)}, nodeGraph, cache),
  );

  cache[(node, targets.join(','))] = paths;
  return paths;
}

int part1(Map<String, List<String>> nodeGraph) {
  return solve('you', {'out'}, nodeGraph, {});
}

int part2(Map<String, List<String>> nodeGraph) {
  return solve('svr', {'dac', 'fft', 'out'}, nodeGraph, {});
}

void main() {
  final nodeGraph = <String, List<String>>{};

  String? line;
  while ((line = stdin.readLineSync()) != null) {
    final [node, children, ...] = line!.split(': ');

    nodeGraph[node] = children.split(' ');
  }

  print(part1(nodeGraph));
  print(part2(nodeGraph));
}
