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

int part1(int rip, List<(string, List<int>)> input)
{
    int pc = 0;
    var registers = Enumerable.Repeat(0, 6).ToList();

    while (pc < input.Count)
    {
        var (op, operands) = input[pc];

        registers[rip] = pc;
        registers[operands[3]] = operations[op](registers, operands);

        pc = registers[rip] + 1;
    }

    return registers[0];
}

int part2()
{
    int s = 0;
    int n = 10551430;

    for (int i = 1; i < Math.Sqrt(n); i++)
    {
        if (n % i != 0)
            continue;

        s += i + n / i;
    }

    return s;
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
Console.WriteLine(part2());
