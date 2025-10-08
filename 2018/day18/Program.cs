int solve(List<List<char>> input, int minutes)
{
    List<List<List<char>>> layouts = [input];
    int cycleIdx = -1;

    while (true)
    {
        List<List<char>> newGrid = [];

        for (int r = 0; r < input.Count; r++)
        {
            List<char> newRow = [];
            for (int c = 0; c < input[0].Count; c++)
            {
                var (adjacentTrees, adjacentLumberyards) = (0, 0);
                foreach (var (dr, dc) in new (int, int)[] { (-1, -1), (-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1) })
                {
                    if (r + dr < 0 || r + dr >= input.Count || c + dc < 0 || c + dc >= input[0].Count)
                        continue;

                    adjacentTrees += input[r + dr][c + dc] == '|' ? 1 : 0;
                    adjacentLumberyards += input[r + dr][c + dc] == '#' ? 1 : 0;
                }

                char cur = input[r][c];
                if (cur == '.' && adjacentTrees >= 3)
                    newRow.Add('|');
                else if (cur == '|' && adjacentLumberyards >= 3)
                    newRow.Add('#');
                else if (cur == '#' && (adjacentTrees == 0 || adjacentLumberyards == 0))
                    newRow.Add('.');
                else
                    newRow.Add(cur);
            }
            newGrid.Add(newRow);
        }

        input = newGrid;
        cycleIdx = layouts.FindIndex(l => l.Index().All(p => p.Item.SequenceEqual(input[p.Index])));
        if (cycleIdx != -1)
            break;

        layouts.Add(input);
    }

    int shift = (minutes - cycleIdx) % (layouts.Count - cycleIdx);
    int idx = minutes <= cycleIdx ? minutes : cycleIdx + shift;

    int trees = layouts[idx].Select(r => r.Count(c => c == '|')).Sum();
    int lumberyards = layouts[idx].Select(r => r.Count(c => c == '#')).Sum();
    return trees * lumberyards;
}

int part1(List<List<char>> input)
{
    return solve(input, 10);
}

int part2(List<List<char>> input)
{
    return solve(input, 1000000000);
}

List<List<char>> input = [];

string? line;
while ((line = Console.ReadLine()) != null)
    input.Add([.. line]);

Console.WriteLine(part1(input));
Console.WriteLine(part2(input));
