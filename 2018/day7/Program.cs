using System.Text.RegularExpressions;

string part1(Dictionary<char, List<char>> input, Dictionary<char, HashSet<char>> prerequisites)
{
    var keys = input.Keys.ToHashSet();
    var vals = input.Values.SelectMany(x => x).ToHashSet();
    keys.ExceptWith(vals);

    string result = "";
    var q = new PriorityQueue<char, int>();

    foreach (var begin in keys)
        q.Enqueue(begin, begin);

    while (q.Count != 0)
    {
        char cur = q.Dequeue();
        result += cur;

        if (!input.ContainsKey(cur))
            continue;

        foreach (var dst in input[cur])
        {
            prerequisites[dst].Remove(cur);
            if (prerequisites[dst].Count == 0)
                q.Enqueue(dst, dst);
        }
    }

    return result;
}

int part2(Dictionary<char, List<char>> input, Dictionary<char, HashSet<char>> prerequisites)
{
    var keys = input.Keys.ToHashSet();
    var vals = input.Values.SelectMany(x => x).ToHashSet();
    keys.ExceptWith(vals);


    int seconds = 0;
    var workers = Enumerable.Repeat(('.', 1), 5).ToList();

    var q = new PriorityQueue<char, int>();

    foreach (var begin in keys)
        q.Enqueue(begin, begin);

    while (true)
    {
        if (q.Count == 0 && workers.All(w => w.Item1 == '.'))
            return seconds - 1;

        for (int i = 0; i < workers.Count; i++)
        {
            var (job, eta) = workers[i];
            if (job != '.')
                workers[i] = (job, eta - 1);

            if (eta == 1)
            {
                workers[i] = ('.', 1);

                if (job != '.')
                {
                    if (!input.ContainsKey(job))
                        continue;

                    foreach (var dst in input[job])
                    {
                        prerequisites[dst].Remove(job);
                        if (prerequisites[dst].Count == 0)
                            q.Enqueue(dst, dst);
                    }
                }

                if (q.Count == 0)
                    continue;

                char cur = q.Dequeue();
                workers[i] = (cur, cur - 'A' + 61);
                continue;
            }
        }

        ++seconds;
    }
}

var input = new Dictionary<char, List<char>>();
var prerequisites = new Dictionary<char, HashSet<char>>();

string? line;
while ((line = Console.ReadLine()) != null)
{
    var groups = Regex.Match(line, @".*([A-Z]).*([A-Z]).*").Groups;
    char from = groups[1].Value[0];
    char to = groups[2].Value[0];

    if (!input.ContainsKey(from))
        input[from] = [];
    input[from].Add(to);

    if (!prerequisites.ContainsKey(to))
        prerequisites[to] = [];
    prerequisites[to].Add(from);
}

Console.WriteLine(part1(input, prerequisites.ToDictionary(entry => entry.Key, entry => new HashSet<char>(entry.Value))));
Console.WriteLine(part2(input, prerequisites));
