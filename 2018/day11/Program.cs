int[,] createGrid(int gridSerialNumber)
{
    var grid = new int[300, 300];
    for (int x = 0; x < 300; x++)
    {
        for (int y = 0; y < 300; y++)
        {
            int rackID = x + 1 + 10;
            int powerLevel = (rackID * (y + 1) + gridSerialNumber) * rackID;
            int hundredsDigit = powerLevel / 100 % 10;

            grid[x, y] = hundredsDigit - 5;
        }
    }

    return grid;
}

int squareSum(int[,] grid, int x, int y, int size)
{
    if (x + size - 1 >= grid.GetLength(0) || y + size - 1 >= grid.GetLength(1))
        return 0;

    int sum = 0;
    for (int i = 0; i < size; i++)
        for (int j = 0; j < size; j++)
            sum += grid[x + i, y + j];
    return sum;
}

string solve(int gridSerialNumber, (int, int) sizes)
{
    var grid = createGrid(gridSerialNumber);

    var size = 0;
    var max = 0;
    var coords = (0, 0);

    for (int x = 0; x < 300; x++)
    {
        for (int y = 0; y < 300; y++)
        {
            for (int s = sizes.Item1; s <= sizes.Item2; s++)
            {
                int sum = squareSum(grid, x, y, s);
                if (sum > max)
                {
                    size = s;
                    max = sum;
                    coords = (x + 1, y + 1);
                }
            }
        }
    }

    return $"{coords.Item1},{coords.Item2},{size}";
}

string part1(int gridSerialNumber)
{
    var str = solve(gridSerialNumber, (3, 3));
    return str.Substring(0, str.Length - 2);
}

string part2(int gridSerialNumber)
{
    return solve(gridSerialNumber, (1, 300));
}

string line = Console.ReadLine()!;
int gridSerialNumber = int.Parse(line);

Console.WriteLine(part1(gridSerialNumber));
Console.WriteLine(part2(gridSerialNumber));
