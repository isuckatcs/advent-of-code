use memoize::memoize;
use std::io;

#[memoize]
fn part1(line: String, groups: Vec<usize>, mut li: usize, gi: usize) -> usize {
    if li >= line.len() {
        return (gi == groups.len()) as usize;
    }

    while li < line.len() {
        let base_char = line.chars().nth(li).unwrap();

        if base_char == '.' {
            li += 1;
            continue;
        }

        if gi == groups.len() {
            if base_char == '#' {
                return 0;
            }

            li += 1;
            continue;
        }

        let base_idx = li;
        while li < line.len() && (line.as_bytes()[li] == b'?' || line.as_bytes()[li] == b'#') {
            li += 1;
        }

        let next_group = groups[gi];
        let can_replace = li - base_idx >= next_group
            && (base_idx + next_group == line.len()
                || line.chars().nth(base_idx + next_group).unwrap() != '#');

        let replaced = if can_replace {
            part1(
                line.clone(),
                groups.clone(),
                base_idx + 1 + next_group,
                gi + 1,
            )
        } else {
            0
        };

        let skipped = if base_char == '?' {
            part1(line, groups, base_idx + 1, gi)
        } else {
            0
        };

        return replaced + skipped;
    }

    (gi == groups.len()) as usize
}

fn main() {
    let mut part1_sum = 0;
    let mut part2_sum = 0;

    let stdin = io::stdin();
    for line in stdin.lines() {
        let split = line
            .unwrap()
            .split(' ')
            .map(|s| s.to_string())
            .collect::<Vec<String>>();

        let springs = split[0].to_string();
        let groups = split[1]
            .split(',')
            .map(|s| s.parse::<usize>().unwrap())
            .collect::<Vec<usize>>();

        let expanded_springs = vec![&springs; 4]
            .into_iter()
            .fold(String::from(&springs), |acc, s| acc + "?" + &s);

        let mut expanded_groups = groups.clone();
        for _ in 0..4 {
            expanded_groups.append(&mut groups.clone());
        }

        part1_sum += part1(springs, groups, 0, 0);
        part2_sum += part1(expanded_springs, expanded_groups, 0, 0);
    }

    println!("{}", part1_sum);
    println!("{}", part2_sum);
}
