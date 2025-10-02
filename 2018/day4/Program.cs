using System.Runtime.CompilerServices;
using System.Text.RegularExpressions;

List<(int, List<int>)> getSleepMatrix(List<Entry> input)
{
    var sleepMatrix = new Dictionary<int, List<int>>();

    int i = 0;
    while (i < input.Count)
    {
        int guard = int.Parse(Regex.Match(input[i].Action, @"\d+").Value);
        sleepMatrix.TryAdd(guard, [.. Enumerable.Repeat(0, 60)]);
        ++i;

        while (i < input.Count && !input[i].Action.StartsWith("Guard"))
        {
            for (int minute = input[i].Date.Minute; minute < input[i + 1].Date.Minute; ++minute)
                ++sleepMatrix[guard][minute];
            i += 2;
        }
    }

    return [.. sleepMatrix.Select(e => (e.Key, e.Value))];
}

int part1(List<Entry> input)
{
    var sleepMatrix = getSleepMatrix(input)!;
    var max = sleepMatrix.MaxBy(e => e.Item2.Sum());
    return max.Item1 * max.Item2.IndexOf(max.Item2.Max());
}

int part2(List<Entry> input)
{
    var sleepMatrix = getSleepMatrix(input)!;
    var maxEntry = sleepMatrix.Select(e => (e.Item1, e.Item2.IndexOf(e.Item2.Max()), e.Item2.Max())).MaxBy(e => e.Item3);
    return maxEntry.Item1 * maxEntry.Item2;
}

var input = new List<Entry>();

string? line;
while ((line = Console.ReadLine()) != null)
{
    var groups = Regex.Match(line, @"\[(.*)\] (.*)").Groups;
    input.Add(new Entry(DateTime.Parse(groups[1].Value), groups[2].Value));
}

input.Sort((cur, other) => cur.Date.CompareTo(other.Date));

Console.WriteLine(part1(input));
Console.WriteLine(part2(input));

record Entry(DateTime Date, string Action);