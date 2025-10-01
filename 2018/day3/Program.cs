using System.Text.RegularExpressions;

int part1(List<Rectangle> input)
{
    var coveredSquares = new HashSet<(int, int)>();

    foreach (Rectangle rect in input)
    {
        foreach (Rectangle other in input)
        {
            if (rect.Id == other.Id)
                continue;

            var overlap = rect.Intersect(other);
            if (overlap != null)
                coveredSquares.UnionWith(overlap.Squares);
        }
    }

    return coveredSquares.Count;
}

int part2(List<Rectangle> input)
{
    return input.Find(r => input.All(o => r.Id == o.Id || o.Intersect(r) == null))!.Id;
}

var input = new List<Rectangle>();

string? line;
while ((line = Console.ReadLine()) != null)
{
    var matches = Regex.Matches(line, @"\d+");
    input.Add(new Rectangle(
        int.Parse(matches[0].Value),
        int.Parse(matches[1].Value),
        int.Parse(matches[2].Value),
        int.Parse(matches[3].Value),
        int.Parse(matches[4].Value)
    ));
}

Console.WriteLine(part1(input));
Console.WriteLine(part2(input));

record Rectangle(int Id, int Left, int Top, int Width, int Height)
{
    public Rectangle? Intersect(Rectangle other)
    {
        int hLeft = Math.Max(Left, other.Left);
        int hRight = Math.Min(Left + Width, other.Left + other.Width) - 1;

        int vLeft = Math.Max(Top, other.Top);
        int vRight = Math.Min(Top + Height, other.Top + other.Height) - 1;

        if (hLeft > hRight || vLeft > vRight)
            return null;

        return new Rectangle(-1, hLeft, vLeft, hRight - hLeft + 1, vRight - vLeft + 1);
    }

    public List<(int, int)> Squares
    {
        get
        {
            var result = new List<(int, int)>();

            for (int Row = 0; Row < Height; ++Row)
                for (int Col = 0; Col < Width; Col++)
                    result.Add((Left + Col, Top + Row));

            return result;
        }
    }
}
