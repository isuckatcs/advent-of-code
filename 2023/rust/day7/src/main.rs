use std::io;

fn part1(lines: &[String]) -> i32 {
    let cards = "23456789TJQKA";

    let mut nums = lines
        .iter()
        .map(|line| {
            let split = line.split(' ').collect::<Vec<&str>>();

            let mut cnt = [0; 13];

            split[0].chars().for_each(|x| {
                cnt[cards.find(x).unwrap()] += 1;
            });

            cnt.sort();
            cnt.reverse();

            let filtered = cnt.into_iter().filter(|&x| x != 0).collect::<Vec<i32>>();
            let kind = match &filtered[..] {
                [5] => 6,
                [4, ..] => 5,
                [3, 2] => 4,
                [3, ..] => 3,
                [2, 2, ..] => 2,
                [2, ..] => 1,
                _ => 0,
            };

            (kind, split[1].parse::<i32>().unwrap(), split[0])
        })
        .collect::<Vec<(i32, i32, &str)>>();

    nums.sort_by(|a, b| {
        if a.0 == b.0 {
            let (ac, bc) = a.2.chars().zip(b.2.chars()).find(|(f, s)| f != s).unwrap();
            return cards.find(ac).unwrap().cmp(&cards.find(bc).unwrap());
        }

        a.0.cmp(&b.0)
    });

    nums.iter()
        .enumerate()
        .map(|(i, v)| (i + 1) as i32 * v.1)
        .sum()
}

fn part2(lines: &[String]) -> i32 {
    let cards = "J23456789TQKA";

    let mut nums = lines
        .iter()
        .map(|line| {
            let split = line.split(' ').collect::<Vec<&str>>();

            let mut cnt = [0; 13];

            split[0].chars().filter(|&x| x != 'J').for_each(|x| {
                cnt[cards.find(x).unwrap()] += 1;
            });

            cnt.sort();
            cnt.reverse();

            let jokers = split[0].chars().map(|x| if x == 'J' { 1 } else { 0 }).sum();
            let filtered = cnt.into_iter().filter(|&x| x != 0).collect::<Vec<i32>>();

            let kind = match (jokers, &filtered[..]) {
                (0, [5]) | (5, []) | (1, [4]) | (4, [..]) | (3, [2]) | (2, [3]) => 6,
                (0, [4, ..]) | (1, [3, ..]) | (3, [1, ..]) | (2, [2, ..]) => 5,
                (0, [3, 2]) | (1, [2, 2]) => 4,
                (0, [3, ..]) | (1, [2, ..]) | (2, [1, ..]) => 3,
                (0, [2, 2, ..]) => 2,
                (0, [2, ..]) | (1, [1, ..]) => 1,
                _ => 0,
            };

            (kind, split[1].parse::<i32>().unwrap(), split[0])
        })
        .collect::<Vec<(i32, i32, &str)>>();

    nums.sort_by(|a, b| {
        if a.0 == b.0 {
            let (ac, bc) = a.2.chars().zip(b.2.chars()).find(|(f, s)| f != s).unwrap();
            return cards.find(ac).unwrap().cmp(&cards.find(bc).unwrap());
        }

        a.0.cmp(&b.0)
    });

    nums.iter()
        .enumerate()
        .map(|(i, v)| (i + 1) as i32 * v.1)
        .sum()
}

fn main() {
    let mut lines = Vec::<String>::new();

    let stdin = io::stdin();
    for line in stdin.lines() {
        lines.push(line.unwrap());
    }

    println!("{}", part1(&lines));
    println!("{}", part2(&lines));
}
