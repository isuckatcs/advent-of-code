(string, int) growPlants(string state, Dictionary<string, char> rules)
{
    int extendFront = Math.Max(0, 5 - state.IndexOf('#'));
    int extendBack = Math.Max(0, 5 - (state.Length - 1 - state.LastIndexOf('#')));

    state = new string([
        .. Enumerable.Repeat('.', extendFront),
            .. state,
            .. Enumerable.Repeat('.', extendBack)
    ]);

    char[] nextState = state.ToCharArray();
    for (int i = 2; i < state.Length - 2; i++)
        nextState[i] = rules.TryGetValue(state.Substring(i - 2, 5), out char value) ? value : '.';

    return (new string(nextState), extendFront);
}

int part1(string state, Dictionary<string, char> rules)
{
    int startOffset = 0;
    for (int generation = 0; generation < 20; generation++)
    {
        var (newState, offset) = growPlants(state, rules);

        state = newState;
        startOffset += offset;
    }

    return state.Index().Where(p => p.Item == '#').Select(p => p.Index - startOffset).Sum();
}

long part2(string state, Dictionary<string, char> rules)
{
    int startOffset = 0;
    var cache = new HashSet<string>();
    while (true)
    {
        if (!cache.Add(state.Trim('.')))
            break;

        var (newState, offset) = growPlants(state, rules);

        state = newState;
        startOffset += offset;
    }

    return state.Index().Where(p => p.Item == '#').Select(p => p.Index - startOffset + 50_000_000_000 - cache.Count).Sum();
}

string? line = Console.ReadLine()!;
string initialState = line.Split(' ')[2];

Console.ReadLine();

var rules = new Dictionary<string, char>();
while ((line = Console.ReadLine()) != null)
{
    var split = line.Split(" => ");
    rules.Add(split[0], split[1][0]);
}

Console.WriteLine(part1(initialState, rules));
Console.WriteLine(part2(initialState, rules));
