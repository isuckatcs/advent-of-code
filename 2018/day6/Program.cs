using System.Text.RegularExpressions;

var directions = new (int dx, int dy)[] { (1, 0), (-1, 0), (0, 1), (0, -1) };

int part1(List<Coordinate> input)
{
    int max = 0;

    foreach (var coord in input)
    {
        var visited = new HashSet<Coordinate>();
        var q = new Queue<Coordinate>();
        q.Enqueue(coord);

        while (q.Count != 0)
        {
            Coordinate cur = q.Dequeue();

            if (cur.SingleClosest(input) != coord)
                continue;

            if (!visited.Add(cur))
                continue;

            if (!cur.IsFinite(input))
            {
                visited.Clear();
                break;
            }

            foreach (var (dx, dy) in directions)
                q.Enqueue(new Coordinate(cur.X + dx, cur.Y + dy));
        }

        max = Math.Max(max, visited.Count);
    }

    return max;
}

int part2(List<Coordinate> input)
{
    var visited = new HashSet<Coordinate>();
    foreach (var coord in input)
    {
        var q = new Queue<Coordinate>();
        q.Enqueue(coord);

        while (q.Count != 0)
        {
            Coordinate cur = q.Dequeue();

            if (input.Select(c => c.ManhattanDistance(cur)).Sum() >= 10000)
                continue;

            if (!visited.Add(cur))
                continue;

            foreach (var (dx, dy) in directions)
                q.Enqueue(new Coordinate(cur.X + dx, cur.Y + dy));
        }
    }

    return visited.Count;
}

var input = new List<Coordinate>();

string? line;
while ((line = Console.ReadLine()) != null)
{
    var groups = Regex.Match(line, @"(\d+),\s*(\d+)").Groups;
    input.Add(new Coordinate(int.Parse(groups[1].Value), int.Parse(groups[2].Value)));
}

Console.WriteLine(part1(input));
Console.WriteLine(part2(input));

record Coordinate(int X, int Y);

static class CoordinateExtensions
{
    public static bool IsFinite(this Coordinate coord, List<Coordinate> coordinates)
    {
        if (!coordinates.Any(c => c.X < coord.X))
            return false;

        if (!coordinates.Any(c => c.X > coord.X))
            return false;

        if (!coordinates.Any(c => c.Y < coord.Y))
            return false;

        if (!coordinates.Any(c => c.Y > coord.Y))
            return false;

        return true;
    }

    public static int ManhattanDistance(this Coordinate coord, Coordinate other)
    {
        return Math.Abs(other.X - coord.X) + Math.Abs(other.Y - coord.Y);
    }

    public static Coordinate? SingleClosest(this Coordinate coord, List<Coordinate> coordinates)
    {
        var distances = coordinates
            .Select(c => (c, c.ManhattanDistance(coord)))
            .OrderBy(c => c.Item2);

        var shortest = distances.Where(c => c.Item2 == distances.First().Item2);
        if (shortest.Count() == 1)
            return shortest.First().c;

        return null;
    }
}
