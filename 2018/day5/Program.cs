int part1(string input)
{
    while (true)
    {
        string reducedPolymer = input;

        for (int i = 0; i < input.Length; i++)
        {
            if (i + 1 >= input.Length)
                continue;

            char cur = input[i];
            char next = input[i + 1];

            if (char.IsLower(cur) && char.ToUpper(cur) != next)
                continue;

            if (char.IsUpper(cur) && char.ToLower(cur) != next)
                continue;

            reducedPolymer = reducedPolymer.Remove(i, 2);
            break;
        }

        if (input == reducedPolymer)
            return input.Length;

        input = reducedPolymer;
    }
}

int part2(string input)
{
    var min = int.MaxValue;
    for (char c = 'a'; c <= 'z'; c++)
        min = Math.Min(min, part1(new([.. input.ToCharArray().Where(ch => char.ToLower(ch) != c)])));

    return min;
}

string input = Console.ReadLine()!;

Console.WriteLine(part1(input));
Console.WriteLine(part2(input));
