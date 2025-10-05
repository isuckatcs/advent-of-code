string simulate(List<List<char>> input, bool stopOnFirstCollision)
{
    List<Cart> carts = [];
    for (int r = 0; r < input.Count; r++)
    {
        for (int c = 0; c < input[0].Count; c++)
        {
            if (input[r][c] == '^')
                carts.Add(new Cart((r, c), (-1, 0), '|'));
            else if (input[r][c] == '>')
                carts.Add(new Cart((r, c), (0, 1), '-'));
            else if (input[r][c] == 'v')
                carts.Add(new Cart((r, c), (1, 0), '|'));
            else if (input[r][c] == '<')
                carts.Add(new Cart((r, c), (0, -1), '-'));
        }
    }

    while (true)
    {
        carts = [.. carts.Where(c => !c.Removed).OrderBy(c => c.Pos.Item1).ThenBy(c => c.Pos.Item2)];

        if (carts.Count == 1)
            return $"{carts.First().Pos.Item2},{carts.First().Pos.Item1}";

        foreach (var cart in carts)
        {
            var (r, c) = cart.Pos;
            input[r][c] = cart.UnderlyingTile;

            switch (cart.UnderlyingTile)
            {
                case '/':
                    if (cart.Dir.Item2 == 0)
                        cart.RotateRight();
                    else
                        cart.RotateLeft();
                    break;
                case '\\':
                    if (cart.Dir.Item1 == 0)
                        cart.RotateRight();
                    else
                        cart.RotateLeft();
                    break;
                case '+':
                    cart.Rotate();
                    break;
            }

            cart.Advance();
            cart.UnderlyingTile = input[cart.Pos.Item1][cart.Pos.Item2];

            var collisions = carts.Where(c => c != cart && c.Pos == cart.Pos);
            if (collisions.Any())
            {
                if (stopOnFirstCollision)
                    return $"{cart.Pos.Item2},{cart.Pos.Item1}";


                cart.Remove();
                foreach (var collision in collisions)
                    collision.Remove();
            }
        }
    }
}

string part1(List<List<char>> input)
{
    return simulate(input, true);
}

string part2(List<List<char>> input)
{
    return simulate(input, false);
}

List<List<char>> input = [];
List<List<char>> input2 = [];

string? line;
while ((line = Console.ReadLine()) != null)
{
    input.Add([.. line]);
    input2.Add([.. line]);
}

Console.WriteLine(part1(input));
Console.WriteLine(part2(input2));



class Cart((int, int) pos, (int, int) dir, char underlyingTile)
{
    enum Direction
    {
        LEFT, STRAIGHT, RIGHT
    }

    public (int, int) Pos { get; set; } = pos;
    public (int, int) Dir { get; set; } = dir;
    public char UnderlyingTile { get; set; } = underlyingTile;
    public bool Removed { get; set; } = false;
    private Direction IntersectionProgress { get; set; } = Direction.LEFT;

    public void Rotate()
    {
        switch (IntersectionProgress)
        {
            case Direction.LEFT:
                RotateLeft();
                IntersectionProgress = Direction.STRAIGHT;
                break;
            case Direction.STRAIGHT:
                IntersectionProgress = Direction.RIGHT;
                break;
            case Direction.RIGHT:
                RotateRight();
                IntersectionProgress = Direction.LEFT;
                break;
        }
    }

    public void RotateLeft()
    {
        Dir = (-Dir.Item2, Dir.Item1);
    }

    public void RotateRight()
    {
        Dir = (Dir.Item2, -Dir.Item1);
    }

    public void Advance()
    {
        Pos = (Pos.Item1 + Dir.Item1, Pos.Item2 + Dir.Item2);
    }

    public void Remove()
    {
        Removed = true;
    }
}
