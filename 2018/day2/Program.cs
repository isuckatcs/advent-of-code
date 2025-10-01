int part1(List<string> input)
{
    int exactlyTwo = 0;
    int exactlyThree = 0;

    foreach (string line in input)
    {
        var chars = new int[26];
        foreach (char c in line)
            ++chars[c - 'a'];

        exactlyTwo += chars.Any(x => x == 2) ? 1 : 0;
        exactlyThree += chars.Any(x => x == 3) ? 1 : 0;
    }

    return exactlyTwo * exactlyThree;
}

string part2(List<string> input)
{
    foreach (string line in input)
    {
        var res = input
            .Select(s => new string(s.Zip(line).Where(p => p.First == p.Second).Select(p => p.First).ToArray()!))
            .Where(s => s.Length == line.Length - 1)
            .ToList();

        if (res.Count != 0)
            return res.First();
    }

    return "";
}

var input = new List<string>();

string? line;
while ((line = Console.ReadLine()) != null)
    input.Add(line);

Console.WriteLine(part1(input));
Console.WriteLine(part2(input));
