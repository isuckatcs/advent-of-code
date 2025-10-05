List<Unit> createUnits(List<List<char>> input, int elfAttackPower)
{
    List<Unit> units = [];

    for (int r = 0; r < input.Count; r++)
    {
        for (int c = 0; c < input[0].Count; c++)
        {
            if (input[r][c] == 'E')
                units.Add(new Unit((r, c), true, elfAttackPower));
            if (input[r][c] == 'G')
                units.Add(new Unit((r, c), false, 3));
        }
    }

    return units;
}

(int, List<Unit>) simulate(List<List<char>> input, List<Unit> units)
{
    int rounds = 0;
    while (true)
    {
        units = [.. units.OrderBy(u => u.Pos.Item1).ThenBy(u => u.Pos.Item2)];

        int unitIdx = 0;
        while (unitIdx < units.Count)
        {
            var unit = units[unitIdx];

            List<Unit> targets = unit.IdentifyTargets(units);
            if (targets.Count == 0)
                return (rounds, units);

            if (unit.Attack(units))
            {
                units = [.. units.Where(u => u.HP > 0)];
                if (units.IndexOf(unit) == unitIdx)
                    ++unitIdx;
                continue;
            }

            var openSquares = new HashSet<(int, int)>(targets.SelectMany(t => t.OpenSquaresInRange(input, units)));
            if (!openSquares.Any())
            {
                ++unitIdx;
                continue;
            }

            unit.Pos = unit.SquareToStepTo(input, units, openSquares);
            if (unit.Attack(units))
            {
                units = [.. units.Where(u => u.HP > 0)];
                if (units.IndexOf(unit) == unitIdx)
                    ++unitIdx;
                continue;
            }

            ++unitIdx;
        }

        ++rounds;
    }
}

int part1(List<List<char>> input)
{
    List<Unit> inputUnits = createUnits(input, 3);
    var (rounds, units) = simulate(input, inputUnits);
    return rounds * units.Select(u => u.HP).Sum();
}

int part2(List<List<char>> input)
{
    int elfAttackPower = 4;
    while (true)
    {
        List<Unit> inputUnits = createUnits(input, elfAttackPower);
        var (rounds, units) = simulate(input, inputUnits);
        if (inputUnits.Count(u => u.IsElf) == units.Count(u => u.IsElf))
            return rounds * units.Select(u => u.HP).Sum();
        ++elfAttackPower;
    }
}

List<List<char>> map = [];

string? line;
while ((line = Console.ReadLine()) != null)
{
    map.Add([.. line]);
}

Console.WriteLine(part1(map));
Console.WriteLine(part2(map));

record Unit((int, int) Pos, bool IsElf, int Atk)
{
    public (int, int) Pos { get; set; } = Pos;
    public int HP { get; set; } = 200;

    public List<Unit> IdentifyTargets(List<Unit> units)
    {
        return [.. units.Where(u => u.IsElf != IsElf)];
    }

    public bool Attack(List<Unit> units)
    {
        List<Unit> targets = [];
        foreach (var (dr, dc) in new (int, int)[] { (-1, 0), (0, -1), (0, 1), (1, 0) })
        {
            var (nr, nc) = (Pos.Item1 + dr, Pos.Item2 + dc);

            var potentialTarget = units.Where(u => u.IsElf != IsElf && u.Pos == (nr, nc)).FirstOrDefault();
            if (potentialTarget != null)
                targets.Add(potentialTarget);

        }

        if (targets.Count == 0)
            return false;

        var target = targets
            .OrderBy(t => t.HP)
            .ThenBy(t => t.Pos.Item1)
            .ThenBy(t => t.Pos.Item2)
            .First();

        target.HP -= Atk;
        return true;
    }

    public HashSet<(int, int)> OpenSquaresInRange(List<List<char>> map, List<Unit> units)
    {
        HashSet<(int, int)> openSquares = [];
        foreach (var (dr, dc) in new (int, int)[] { (-1, 0), (0, -1), (0, 1), (1, 0) })
        {
            var (nr, nc) = (Pos.Item1 + dr, Pos.Item2 + dc);

            if (map[nr][nc] != '#' && !units.Any(u => u.Pos == (nr, nc)))
                openSquares.Add((nr, nc));
        }

        return openSquares;
    }

    public (int, int) SquareToStepTo(List<List<char>> map, List<Unit> units, HashSet<(int, int)> targets)
    {
        var paths = new Dictionary<(int, int), List<List<(int, int)>>>();

        var q = new Queue<((int, int), int, List<(int, int)>, HashSet<(int, int)>)>();
        q.Enqueue((Pos, 0, [], []));
        int shortestDist = int.MaxValue;

        while (q.Count != 0)
        {
            var (curPos, curDist, curPath, curVisited) = q.Dequeue();
            if (curDist > shortestDist)
                continue;

            if (!curVisited.Add(curPos))
                continue;

            curPath.Add(curPos);
            if (targets.Contains(curPos))
            {
                shortestDist = curDist;
                if (!paths.ContainsKey(curPos))
                    paths.Add(curPos, []);
                paths[curPos].Add(curPath);
                continue;
            }

            foreach (var (dr, dc) in new (int, int)[] { (-1, 0), (0, -1), (0, 1), (1, 0) })
            {
                var (nr, nc) = (curPos.Item1 + dr, curPos.Item2 + dc);

                if (map[nr][nc] == '#' || units.Any(u => u.Pos == (nr, nc)))
                    continue;

                q.Enqueue(((nr, nc), curDist + 1, [.. curPath], curVisited));
            }
        }

        if (paths.Count == 0)
            return Pos;

        var chosenTarget = paths.OrderBy(p => p.Key.Item1).ThenBy(p => p.Key.Item2).First();

        return chosenTarget.Value.Select(p => p[1]).OrderBy(p => p.Item1).ThenBy(p => p.Item2).First();
    }
}
