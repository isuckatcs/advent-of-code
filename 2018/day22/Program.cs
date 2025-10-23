using System.Text.RegularExpressions;

int dist((int, int) p1, (int, int) p2)
{
    return Math.Abs(p2.Item1 - p1.Item1) + Math.Abs(p2.Item2 - p1.Item2);
}

List<List<int>> createGrid(int depth, (int, int) target, (int, int) size)
{
    int rows = size.Item2 + 1;
    int cols = size.Item1 + 1;

    List<List<int>> indices = [];
    List<List<int>> levels = [];
    List<List<int>> grid = [];
    for (int y = 0; y < rows; y++)
    {
        indices.Add([.. Enumerable.Repeat(0, cols)]);
        levels.Add([.. Enumerable.Repeat(0, cols)]);
        grid.Add([.. Enumerable.Repeat(0, cols)]);
    }

    for (int x = 0; x < cols; x++)
    {
        indices[0][x] = x * 16807;
        levels[0][x] = (indices[0][x] + depth) % 20183;
    }

    for (int y = 0; y < rows; y++)
    {
        indices[y][0] = y * 48271;
        levels[y][0] = (indices[y][0] + depth) % 20183;
    }

    for (int x = 1; x < cols; x++)
    {
        for (int y = 1; y < rows; y++)
        {
            if (x == target.Item1 && y == target.Item2)
                continue;

            indices[y][x] = levels[y][x - 1] * levels[y - 1][x];
            levels[y][x] = (indices[y][x] + depth) % 20183;
        }
    }

    for (int x = 0; x < cols; x++)
        for (int y = 0; y < rows; y++)
            grid[y][x] = levels[y][x] % 3;

    return grid;
}

int part1(int depth, (int, int) target)
{
    return createGrid(depth, target, target).Select(r => r.Sum()).Sum();
}

int part2(int depth, (int, int) target)
{
    int expand = 1;
    List<List<int>> grid = createGrid(depth, target, target);
    HashSet<(int, int, int)> visited = [];

    PriorityQueue<(int, int, int, int), int> q = new();
    q.Enqueue((0, 0, 0, 0), 0);

    while (true)
    {
        var (x, y, t, m) = q.Dequeue();

        if (!visited.Add((x, y, t)))
            continue;

        if (x == target.Item1 && y == target.Item2)
        {
            if (t == 0)
                return m;
            continue;
        }

        foreach (var (dx, dy) in new (int, int)[] { (1, 0), (-1, 0), (0, 1), (0, -1) })
        {
            int nx = x + dx;
            int ny = y + dy;

            if (nx < 0 || ny < 0)
                continue;

            if (ny >= grid.Count || nx >= grid[0].Count)
            {
                expand *= 2;
                grid = createGrid(depth, target, (target.Item1 * expand, target.Item2 * expand));
            }

            var (next, nextMinutes) = (grid[ny][nx], m + 1 + dist((nx, ny), target));
            if (t == 0 && (next == 0 || next == 2))
                q.Enqueue((nx, ny, t, m + 1), nextMinutes);
            else if (t == 1 && (next == 0 || next == 1))
                q.Enqueue((nx, ny, t, m + 1), nextMinutes);
            else if (t == 2 && (next == 1 || next == 2))
                q.Enqueue((nx, ny, t, m + 1), nextMinutes);

            var (cur, curMinutes) = (grid[y][x], m + 7 + dist((x, y), target));
            if (cur == 0)
                q.Enqueue((x, y, t == 0 ? 1 : 0, m + 7), curMinutes);
            else if (cur == 1)
                q.Enqueue((x, y, t == 1 ? 2 : 1, m + 7), curMinutes);
            else if (cur == 2)
                q.Enqueue((x, y, t == 0 ? 2 : 0, m + 7), curMinutes);
        }
    }
}

int depth = int.Parse(Regex.Match(Console.ReadLine()!, @"\d+").Value);
List<int> coords = [.. Regex.Matches(Console.ReadLine()!, @"\d+").Select(m => int.Parse(m.Value))];

Console.WriteLine(part1(depth, (coords[0], coords[1])));
Console.WriteLine(part2(depth, (coords[0], coords[1])));
