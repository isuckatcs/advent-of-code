using System.Text.RegularExpressions;

List<Func<List<int>, List<int>, int>> operations = [
    (s, i) => s[i[1]] + s[i[2]],
    (s, i) => s[i[1]] + i[2],
    (s, i) => s[i[1]] * s[i[2]],
    (s, i) => s[i[1]] * i[2],
    (s, i) => s[i[1]] & s[i[2]],
    (s, i) => s[i[1]] & i[2],
    (s, i) => s[i[1]] | s[i[2]],
    (s, i) => s[i[1]] | i[2],
    (s, i) => s[i[1]],
    (s, i) => i[1],
    (s, i) => i[1] > s[i[2]] ? 1 : 0,
    (s, i) => s[i[1]] > i[2] ? 1 : 0,
    (s, i) => s[i[1]] > s[i[2]] ? 1 : 0,
    (s, i) => i[1] == s[i[2]] ? 1 : 0,
    (s, i) => s[i[1]] == i[2] ? 1 : 0,
    (s, i) => s[i[1]] == s[i[2]] ? 1 : 0,
];

int part1(List<(List<int>, List<int>, List<int>)> input)
{
    return input.Count(i => operations.Count(o => i.Item3[i.Item2[3]] == o(i.Item1, i.Item2)) >= 3);
}

int part2(List<(List<int>, List<int>, List<int>)> input, List<List<int>> program)
{
    var opcodes = new Dictionary<int, Func<List<int>, List<int>, int>>();

    while (opcodes.Keys.Count != 16)
    {
        foreach (var (b, i, a) in input)
        {
            var matches = operations.FindAll(o => a[i[3]] == o(b, i)).Where(op => !opcodes.ContainsValue(op)).ToList();

            if (matches.Count == 1)
                opcodes[i[0]] = matches.First();
        }
    }

    var state = Enumerable.Repeat(0, 4).ToList();
    foreach (var instruction in program)
        state[instruction[3]] = opcodes[instruction[0]](state, instruction);

    return state[0];
}

List<(List<int>, List<int>, List<int>)> input = [];
List<List<int>> program = [];

List<string> lines = [];
string? line;
while ((line = Console.ReadLine()) != null)
    lines.Add(line);

int idx = 0;
while (lines[idx].Length != 0)
{
    var tmp = lines.Skip(idx)
                   .Take(3)
                   .Select(l => Regex.Matches(l, @"\d+").Select(m => int.Parse(m.Value)).ToList())
                   .ToList();

    input.Add((tmp[0], tmp[1], tmp[2]));
    idx += 4;
}

idx += 2;

while (idx < lines.Count)
{
    program.Add([.. Regex.Matches(lines[idx], @"\d+").Select(m => int.Parse(m.Value))]);
    ++idx;
}

Console.WriteLine(part1(input));
Console.WriteLine(part2(input, program));
