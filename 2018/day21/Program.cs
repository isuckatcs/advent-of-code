using System.Text.RegularExpressions;

var operations = new Dictionary<string, Func<List<int>, List<int>, int>>
{
    {"addr", (s, i) => s[i[1]] + s[i[2]]},
    {"addi", (s, i) => s[i[1]] + i[2]},
    {"mulr", (s, i) => s[i[1]] * s[i[2]]},
    {"muli", (s, i) => s[i[1]] * i[2]},
    {"banr", (s, i) => s[i[1]] & s[i[2]]},
    {"bani", (s, i) => s[i[1]] & i[2]},
    {"borr", (s, i) => s[i[1]] | s[i[2]]},
    {"bori", (s, i) => s[i[1]] | i[2]},
    {"setr", (s, i) => s[i[1]]},
    {"seti", (s, i) => i[1]},
    {"gtir", (s, i) => i[1] > s[i[2]] ? 1 : 0},
    {"gtri", (s, i) => s[i[1]] > i[2] ? 1 : 0},
    {"gtrr", (s, i) => s[i[1]] > s[i[2]] ? 1 : 0},
    {"eqir", (s, i) => i[1] == s[i[2]] ? 1 : 0},
    {"eqri", (s, i) => s[i[1]] == i[2] ? 1 : 0},
    {"eqrr", (s, i) => s[i[1]] == s[i[2]] ? 1 : 0},
};

int solve(int rip, List<(string, List<int>)> input, bool fewest)
{
    int pc = 0;
    var registers = Enumerable.Repeat(0, 6).ToList();

    HashSet<int> seen = [];
    int lastAdded = 0;

    while (pc < input.Count)
    {
        var (op, operands) = input[pc];

        registers[rip] = pc;
        registers[operands[3]] = operations[op](registers, operands);

        pc = registers[rip] + 1;

        if (pc == 28)
        {
            if (fewest)
                return registers[5];

            if (!seen.Add(registers[5]))
                return lastAdded;

            lastAdded = registers[5];
        }
    }

    return registers[0];
}

int part1(int rip, List<(string, List<int>)> input)
{
    return solve(rip, input, true);
}

int part2(int rip, List<(string, List<int>)> input)
{
    return solve(rip, input, false);
}

int rip = int.Parse(Regex.Match(Console.ReadLine()!, @"\d+").Value);
List<(string, List<int>)> input = [];

string? line;
while ((line = Console.ReadLine()) != null)
{
    var split = line.Split(' ');
    input.Add((split[0], [-1, .. split.Skip(1).Select(int.Parse)]));
}

Console.WriteLine(part1(rip, input));
Console.WriteLine(part2(rip, input));
