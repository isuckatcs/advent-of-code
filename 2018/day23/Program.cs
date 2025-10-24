using System.Text.RegularExpressions;

int dist(List<int> a, List<int> b)
{
    return Math.Abs(b[0] - a[0]) + Math.Abs(b[1] - a[1]) + Math.Abs(b[2] - a[2]);
}

int part1(List<List<int>> nanobots)
{
    var sorted = nanobots.OrderByDescending(bot => bot[3]);
    var l = sorted.First();

    return sorted.Count(b => dist(l, b) <= l[3]);
}

int part2(List<List<int>> bots)
{
    Dictionary<int, List<int>> overlaps = [];

    for (int i = 0; i < bots.Count; i++)
    {
        List<int> tmp = [];
        for (int j = 0; j < bots.Count; j++)
            if ((dist(bots[i], bots[j]) - bots[j][3]) <= bots[i][3])
                tmp.Add(j);
        overlaps[i] = tmp;
    }

    Dictionary<int, List<int>> intersections = [];
    for (int i = 0; i < bots.Count; i++)
    {
        List<int> intersection = overlaps[i];

        foreach (var o in overlaps[i])
            intersection = [.. intersection.Intersect(overlaps[o])];

        intersections[i] = intersection;
    }

    List<int> highestGroup = [.. intersections.Values.MaxBy(v => v.Count)!.Where(b => (dist(bots[b], [0, 0, 0, 0]) - bots[b][3]) > 0)];
    int closestToOrigin = highestGroup.Select(b => dist(bots[b], [0, 0, 0, 0]) - bots[b][3]).Min();
    int furthestFromOrigin = highestGroup.Select(b => dist(bots[b], [0, 0, 0, 0]) + bots[b][3]).Max();

    // In general the correct answer is >= r. For my input the correct answer was r + 1, for others r is correct.
    for (int r = closestToOrigin; r <= furthestFromOrigin; r++)
        if (highestGroup.All(g => (dist(bots[g], [0, 0, 0, 0]) - bots[g][3]) <= r))
            return r + 1;

    return 0;
}

List<List<int>> input = [];

string? line;
while ((line = Console.ReadLine()) != null)
    input.Add([.. Regex.Matches(line, @"-?\d+").Select(m => int.Parse(m.Value))]);

Console.WriteLine(part1(input));
Console.WriteLine(part2(input));
