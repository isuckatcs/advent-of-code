using System.Text.RegularExpressions;

int dist(List<int> p1, List<int> p2)
{
    return Math.Abs(p2[0] - p1[0]) + Math.Abs(p2[1] - p1[1]) + Math.Abs(p2[2] - p1[2]) + Math.Abs(p2[3] - p1[3]);
}

int part1(List<List<int>> points)
{
    int cnt = 0;
    var visited = new HashSet<List<int>>();

    foreach (var point in points)
    {

        if (!visited.Contains(point))
            ++cnt;

        var q = new Queue<List<int>>();
        q.Enqueue(point);

        while (q.Count != 0)
        {
            var p = q.Dequeue();

            if (!visited.Add(p))
                continue;

            foreach (var p2 in points)
                if (p != p2 && dist(p, p2) <= 3)
                    q.Enqueue(p2);
        }
    }

    return cnt;
}

int part2()
{
    return 0;
}

List<List<int>> input = [];

string? line;
while ((line = Console.ReadLine()) != null)
    input.Add([.. Regex.Matches(line, @"-?\d+").Select(m => int.Parse(m.Value))]);

Console.WriteLine(part1(input));
Console.WriteLine(part2());
