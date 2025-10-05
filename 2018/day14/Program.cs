List<int> generateScores(Func<List<int>, bool> stopCondition)
{
    List<int> scores = [3, 7];

    int elf1 = 0;
    int elf2 = 1;

    while (true)
    {
        int newRecipe = scores[elf1] + scores[elf2];
        if (newRecipe >= 10)
        {
            scores.Add(newRecipe / 10 % 10);
            if (stopCondition(scores))
                break;
        }

        scores.Add(newRecipe % 10);
        if (stopCondition(scores))
            break;

        elf1 = (elf1 + 1 + scores[elf1]) % scores.Count;
        elf2 = (elf2 + 1 + scores[elf2]) % scores.Count;
    }

    return scores;
}

string part1(int input)
{
    return string.Concat(generateScores(s => s.Count == input + 10).Skip(input).Take(10));
}

int part2(int input)
{
    var suffix = input.ToString();

    return generateScores(s =>
    {
        if (s.Count < suffix.Length)
            return false;

        for (int i = 0; i < suffix.Length; i++)
            if (s[s.Count - suffix.Length + i] != suffix[i] - '0')
                return false;

        return true;
    }).Count - suffix.Length;
}

int input = int.Parse(Console.ReadLine()!);

Console.WriteLine(part1(input));
Console.WriteLine(part2(input));
