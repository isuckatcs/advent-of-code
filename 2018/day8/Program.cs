int part1(List<int> input)
{
    return Node.Parse(new Queue<int>(input)).MetadataSum();
}

int part2(List<int> input)
{
    return Node.Parse(new Queue<int>(input)).Value();
}

var input = new List<int>();

string line = Console.ReadLine()!;

foreach (var n in line.Split(' '))
    input.Add(int.Parse(n));

Console.WriteLine(part1(input));
Console.WriteLine(part2(input));

record Node(List<Node> Children, List<int> Metadata)
{
    public static Node Parse(Queue<int> tokens)
    {
        int childCount = tokens.Dequeue();
        int metadataCount = tokens.Dequeue();

        var children = new List<Node>();
        for (int i = 0; i < childCount; i++)
            children.Add(Parse(tokens));

        var metadata = new List<int>();
        for (int i = 0; i < metadataCount; i++)
            metadata.Add(tokens.Dequeue());

        return new Node(children, metadata);
    }

    public int MetadataSum()
    {
        return Metadata.Sum() + Children.Select(c => c.MetadataSum()).Sum();
    }

    public int Value()
    {
        if (Children.Count == 0)
            return MetadataSum();


        return Metadata.Select(x => x - 1)
                        .Where(x => 0 <= x && x < Children.Count)
                        .Select(x => Children[x].Value())
                        .Sum();
    }
};