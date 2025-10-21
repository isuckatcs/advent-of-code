int part1(string regex)
{
    return new GridContext(regex).GetRoomDistances().Max();
}

int part2(string regex)
{
    return new GridContext(regex).GetRoomDistances().Count(d => d >= 1000);
}

string input = Console.ReadLine()!;

Console.WriteLine(part1(input));
Console.WriteLine(part2(input));

class GridContext(string regex)
{
    private int idx = 0;
    private readonly Dictionary<(int, int), int> grid = [];

    private List<(int, int, int)> ParseStatement(List<(int, int, int)> positions)
    {
        List<(int, int, int)> outPositions = positions;
        while (true)
        {
            if (regex[idx] == '(')
            {
                outPositions = ParseParen(outPositions);
                continue;
            }

            if (char.IsAsciiLetterUpper(regex[idx]))
            {
                outPositions = ParsePrimary(outPositions);
                continue;
            }

            break;
        }
        return outPositions;
    }

    private List<(int, int, int)> ParsePrimary(List<(int, int, int)> positions)
    {
        while (char.IsAsciiLetterUpper(regex[idx]))
        {
            char cur = regex[idx];

            List<(int, int, int)> newPositions = [];
            foreach (var (x, y, l) in positions)
            {
                var (nx, ny) = cur switch
                {
                    'W' => (x - 1, y),
                    'E' => (x + 1, y),
                    'N' => (x, y + 1),
                    _ => (x, y - 1),
                };

                if (!grid.ContainsKey((nx, ny)))
                {
                    grid[(nx, ny)] = l + 1;
                    newPositions.Add((nx, ny, l + 1));
                }

            }
            positions = newPositions;

            ++idx;
        }

        return positions;
    }

    private List<(int, int, int)> ParseParen(List<(int, int, int)> positions)
    {
        ++idx; // eat (

        List<(int, int, int)> outPositions = [];
        while (true)
        {
            outPositions.AddRange(ParseStatement(positions));

            if (regex[idx] == '|')
                ++idx;

            if (regex[idx] == ')')
            {
                outPositions.AddRange(positions);
                break;
            }
        }

        ++idx; // eat )
        return outPositions;
    }

    private void Parse()
    {
        ++idx; // eat ^
        ParseStatement([(0, 0, 0)]);
        ++idx; // eat $
    }


    public List<int> GetRoomDistances()
    {
        Parse();
        return [.. grid.Values];
    }
}
