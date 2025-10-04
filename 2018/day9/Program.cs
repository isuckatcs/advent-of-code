using System.Text.RegularExpressions;

ulong part1(int players, int lastMarbleWorth)
{
    var scores = Enumerable.Repeat(0ul, players).ToList();
    var marbles = new LinkedList<int>();
    LinkedListNode<int> currentMarble = marbles.AddLast(0);

    int currentMarbleWorth = 1;
    int currentPlayer = 0;

    while (currentMarbleWorth <= lastMarbleWorth)
    {
        if (currentMarbleWorth % 23 == 0)
        {
            for (int i = 0; i < 6; i++)
                currentMarble = currentMarble.Previous ?? marbles.Last!;

            var marbleToRemove = currentMarble.Previous ?? marbles.Last!;
            scores[currentPlayer] += (ulong)(currentMarbleWorth + marbleToRemove.Value);

            marbles.Remove(marbleToRemove);
        }
        else
        {
            currentMarble = marbles.AddAfter(currentMarble.Next ?? marbles.First!, currentMarbleWorth);
        }

        currentPlayer = (currentPlayer + 1) % players;
        ++currentMarbleWorth;
    }

    return scores.Max();
}

ulong part2(int players, int lastMarbleWorth)
{
    return part1(players, lastMarbleWorth * 100);
}

string line = Console.ReadLine()!;
var matches = Regex.Matches(line, @"\d+");

int players = int.Parse(matches[0].Value);
int lastMarbleWorth = int.Parse(matches[1].Value);

Console.WriteLine(part1(players, lastMarbleWorth));
Console.WriteLine(part2(players, lastMarbleWorth));
