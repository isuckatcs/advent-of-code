int part1(List<int> input)
{
    return input.Sum();
}

int part2(List<int> input)
{
    int freq = 0;
    int idx = 0;
    var seen = new HashSet<int>();

    while (true)
    {
        freq += input[idx];
        if (!seen.Add(freq))
            return freq;

        idx = (idx + 1) % input.Count;
    }
}

var input = new List<int>();

string? line;
while ((line = Console.ReadLine()) != null)
    input.Add(int.Parse(line));

Console.WriteLine(part1(input));
Console.WriteLine(part2(input));
