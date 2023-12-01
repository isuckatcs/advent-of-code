use std::{collections::HashMap, io};

fn part1(lines: &[String]) -> u32 {
    let line_to_sum = |line: &String| {
        let mut it = line
            .chars()
            .filter(|c| c.is_ascii_digit())
            .map(|d| d.to_digit(10).unwrap());

        let first = it.next().unwrap();
        let last = it.last().unwrap_or(first);

        10 * first + last
    };

    lines.iter().map(line_to_sum).sum()
}

fn part2(lines: &[String]) -> u32 {
    let keywords = [
        ("one", 1),
        ("two", 2),
        ("three", 3),
        ("four", 4),
        ("five", 5),
        ("six", 6),
        ("seven", 7),
        ("eight", 8),
        ("nine", 9),
    ];

    let keyword_map: HashMap<String, _> = keywords
        .into_iter()
        .map(|(s, i)| (String::from(s), i))
        .collect();

    let mut sum = 0;
    for line in lines {
        let digits: Vec<u32> = line
            .chars()
            .enumerate()
            .filter_map(|(idx, c)| -> Option<u32> {
                if c.is_ascii_digit() {
                    return c.to_digit(10);
                }

                for n in 3..=5 {
                    let substr: String = line.chars().skip(idx).take(n).collect();
                    if keyword_map.contains_key(&substr) {
                        return Some(*keyword_map.get(&substr).unwrap());
                    }
                }

                None
            })
            .collect();
        sum += 10 * digits.first().unwrap() + digits.last().unwrap();
    }

    sum
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
