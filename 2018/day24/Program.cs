using System.Text.RegularExpressions;

List<Group> simulate(List<Group> groups)
{
    while (true)
    {
        var targetSelectionOrder = groups.OrderByDescending(g => g.Units * g.Attack).ThenByDescending(g => g.Initiative);

        Dictionary<Group, Group> selectedTargets = [];
        foreach (var group in targetSelectionOrder)
        {
            var targetOrder = groups
                .Where(g => !selectedTargets.ContainsValue(g))
                .Where(g => g.IsImmuneSystem != group.IsImmuneSystem)
                .OrderByDescending(g => g.DamageTakenFrom(group))
                .ThenByDescending(g => g.EffectivePower())
                .ThenByDescending(g => g.Initiative)
                .Where(g => g.DamageTakenFrom(group) != 0);

            if (!targetOrder.Any())
                continue;

            selectedTargets.Add(group, targetOrder.First());
        }

        if (selectedTargets.Keys.Count == 0)
            break;

        var attackOrder = selectedTargets.OrderByDescending(g => g.Key.Initiative);
        int lostUnits = 0;
        foreach (var (attacker, target) in attackOrder)
        {
            if (attacker.Units <= 0)
                continue;

            lostUnits += attacker.AttackGroup(target);
        }

        if (lostUnits == 0)
            return [];

        groups = [.. groups.Where(g => g.Units > 0)];
    }

    return groups;
}

int part1(List<Group> groups)
{
    return simulate(groups).Sum(g => g.Units);
}

int part2(List<Group> groups)
{
    int boost = 1;
    while (true)
    {
        List<Group> boostedGroups = [.. groups.Select(g => g with { Attack = g.Attack + (g.IsImmuneSystem ? boost : 0) })];
        var res = simulate(boostedGroups);
        if (res.Count != 0 && res[0].IsImmuneSystem)
            return res.Sum(g => g.Units);

        ++boost;
    }
}

List<Group> groups = [];
bool isImmuneSystem = false;

string? line;
while ((line = Console.ReadLine()) != null)
{
    if (line.Length == 0)
        continue;

    if (line.StartsWith("Immune"))
    {
        isImmuneSystem = true;
        continue;
    }

    if (line.StartsWith("Infection"))
    {
        isImmuneSystem = false;
        continue;
    }

    var matchGroups = Regex.Match(line, @"(\d+) units each with (\d+) hit points(?: \((?:(?:; )?(?:(?:weak to ([^;)]*))|(?:immune to ([^;)]*))))+\))? with an attack that does (\d+) (.*) damage at initiative (\d+)").Groups;

    var group = new Group(
        isImmuneSystem,
        int.Parse(matchGroups[1].Value),
        int.Parse(matchGroups[2].Value),
        [.. matchGroups[3].Value.Split(", ")],
        [.. matchGroups[4].Value.Split(", ")],
        int.Parse(matchGroups[5].Value),
        matchGroups[6].Value,
        int.Parse(matchGroups[7].Value)
    );

    groups.Add(group);
}

Console.WriteLine(part1([.. groups.Select(g => g with { })]));
Console.WriteLine(part2(groups));

record Group(bool IsImmuneSystem, int Units, int HP, HashSet<string> WeakTo, HashSet<string> ImmuneTo,
             int Attack, string AttackType, int Initiative)
{
    public int Units { get; set; } = Units;

    public int EffectivePower()
    {
        return Units * Attack;
    }

    public int DamageTakenFrom(Group other)
    {
        if (ImmuneTo.Contains(other.AttackType))
            return 0;

        return other.EffectivePower() * (WeakTo.Contains(other.AttackType) ? 2 : 1);
    }

    public int AttackGroup(Group other)
    {
        int damage = other.DamageTakenFrom(this);
        int lostUnits = damage / other.HP;

        other.Units -= lostUnits;
        return lostUnits;
    }
}
