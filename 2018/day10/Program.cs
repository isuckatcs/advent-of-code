using System.Text.RegularExpressions;

((int, int), (int, int)) getBoundaries(List<Point> points)
{
    var XCoords = points.Select(p => p.PosX);
    var YCoords = points.Select(p => p.PosY);

    return ((XCoords.Min(), XCoords.Max()), (YCoords.Min(), YCoords.Max()));
}

void render(List<Point> points)
{
    var boundaries = getBoundaries(points);
    var X = boundaries.Item1;
    var Y = boundaries.Item2;

    for (int r = Y.Item1; r <= Y.Item2; r++)
    {
        for (int c = X.Item1; c <= X.Item2; c++)
            Console.Write(points.Any(p => p.PosX == c && p.PosY == r) ? "#" : " ");
        System.Console.WriteLine();
    }
}

void solve(List<Point> input)
{
    ulong area = ulong.MaxValue;
    int time = 0;
    while (true)
    {
        var boundaries = getBoundaries([.. input.Select(p => p.FastForward(time))]);
        var X = boundaries.Item1;
        var Y = boundaries.Item2;

        ulong currentArea = (ulong)(X.Item2 - X.Item1 + 1) * (ulong)(Y.Item2 - Y.Item1 + 1);
        if (currentArea > area)
            break;

        area = currentArea;
        ++time;
    }

    render([.. input.Select(p => p.FastForward(time - 1))]);
    System.Console.WriteLine(time - 1);
}

var input = new List<Point>();

string? line;
while ((line = Console.ReadLine()) != null)
{
    var matches = Regex.Matches(line, @"-?\d+");
    input.Add(new Point(
        int.Parse(matches[0].Value),
        int.Parse(matches[1].Value),
        int.Parse(matches[2].Value),
        int.Parse(matches[3].Value)
    ));
}

solve(input);

record Point(int PosX, int PosY, int VelX, int VelY)
{
    public Point FastForward(int time)
    {
        return new Point(PosX + time * VelX, PosY + time * VelY, VelX, VelY);
    }
};
