using System.Text.RegularExpressions;

(int, int) simulate(List<Clay> input)
{
    int minX = input.Min(c => c.XRange.Item1);
    int maxX = input.Max(c => c.XRange.Item2);

    int minY = input.Min(c => c.YRange.Item1);
    int maxY = input.Max(c => c.YRange.Item2);

    List<List<char>> grid = [];
    HashSet<(int, int)> visited = [];

    for (int r = 0; r <= maxY; r++)
    {
        List<char> row = [];
        for (int c = minX - 1; c <= maxX + 1; c++)
            row.Add(input.Any(clay => clay.Contains((c, r))) ? '#' : '.');
        grid.Add(row);
    }

    while (true)
    {

        Stack<((int, int), (int, int))> stack = [];
        stack.Push(((500 - minX + 1, 0), (0, 1)));

        bool added = false;
        while (stack.Count != 0)
        {
            var (currentWater, flowDir) = stack.Pop();
            var (x, y) = currentWater;

            visited.Add(currentWater);

            if (y + 1 > maxY)
                continue;

            // Force the water to flow down if it can...
            if (grid[y + 1][x] == '.')
            {
                stack.Push(((x, y + 1), (0, 1)));
                continue;
            }

            // Let the water flow in the current direction if it can...
            if (grid[y + flowDir.Item2][x + flowDir.Item1] == '.')
            {
                stack.Push(((x + flowDir.Item1, y + flowDir.Item2), flowDir));
                continue;
            }

            // The water can no longer keep flowing...

            // If the blocker is below, split the water to the left and right if possible...
            if (flowDir == (0, 1) && (grid[y][x + 1] == '.' || grid[y][x - 1] == '.'))
            {
                if (grid[y][x - 1] == '.')
                    stack.Push(((x, y), (-1, 0)));

                if (grid[y][x + 1] == '.')
                    stack.Push(((x, y), (1, 0)));
                continue;
            }

            // If the blocker is on the side, check if the water could flow to the other direction...
            if (flowDir.Item1 != 0)
            {
                var (ghostX, ghostY) = (x, y);
                bool canFlowToOtherDir = false;

                while (!canFlowToOtherDir && grid[ghostY][ghostX += -flowDir.Item1] == '.')
                    canFlowToOtherDir |= grid[ghostY + 1][ghostX] == '.';

                if (canFlowToOtherDir)
                    continue;
            }

            grid[y][x] = '~';
            added = true;
        }

        if (!added)
            break;
    }

    return (visited.Count - minY, grid.Select(r => r.Count(c => c == '~')).Sum());
}

int part1((int, int) simResult)
{
    return simResult.Item1;
}

int part2((int, int) simResult)
{
    return simResult.Item2;
}

List<Clay> input = [];

string? line;
while ((line = Console.ReadLine()) != null)
{
    var xCoords = Regex.Match(line, @"x=(\d+)(..(\d+))?").Groups;
    var xBegin = int.Parse(xCoords[1].Value);
    var xEnd = xCoords[3].Value.Length == 0 ? xBegin : int.Parse(xCoords[3].Value);

    var yCoords = Regex.Match(line, @"y=(\d+)(..(\d+))?").Groups;
    var yBegin = int.Parse(yCoords[1].Value);
    var yEnd = yCoords[3].Value.Length == 0 ? yBegin : int.Parse(yCoords[3].Value);

    input.Add(new Clay((xBegin, xEnd), (yBegin, yEnd)));
}

var simResult = simulate(input);

Console.WriteLine(part1(simResult));
Console.WriteLine(part2(simResult));

record Clay((int, int) XRange, (int, int) YRange)
{
    public bool Contains((int, int) point)
    {
        return XRange.Item1 <= point.Item1 && point.Item1 <= XRange.Item2 &&
               YRange.Item1 <= point.Item2 && point.Item2 <= YRange.Item2;
    }
}
