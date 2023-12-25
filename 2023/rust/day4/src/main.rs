use std::io;

fn part1(line: &str) -> i32 {
    let nums: Vec<Vec<i32>> = line
        .split(':')
        .next_back()
        .unwrap()
        .split('|')
        .map(|str| {
            str.split(' ')
                .filter(|s| !s.is_empty())
                .map(|s| s.parse::<i32>().unwrap())
                .collect::<Vec<i32>>()
        })
        .collect();

    nums[1].iter().filter(|n| nums[0].contains(n)).fold(
        0,
        |acc, _| {
            if acc == 0 {
                1
            } else {
                acc << 1
            }
        },
    )
}

fn part2(line: &str, cache: &mut Vec<i32>) -> i32 {
    let mut split_header = line.split(':');

    let id = split_header
        .next()
        .unwrap()
        .split(' ')
        .next_back()
        .unwrap()
        .parse::<usize>()
        .unwrap();

    let nums: Vec<Vec<i32>> = line
        .split(':')
        .next_back()
        .unwrap()
        .split('|')
        .map(|str| {
            str.split(' ')
                .filter(|s| !s.is_empty())
                .map(|s| s.parse::<i32>().unwrap())
                .collect::<Vec<i32>>()
        })
        .collect();

    cache[id] += 1;

    nums[1]
        .iter()
        .filter(|n| nums[0].contains(n))
        .enumerate()
        .for_each(|(i, _)| {
            if id + i + 1 < cache.len() {
                cache[id + i + 1] += cache[id]
            }
        });

    cache[id]
}

fn main() {
    let mut lines = Vec::<String>::new();

    let stdin = io::stdin();
    for line in stdin.lines() {
        lines.push(line.unwrap());
    }

    let mut part1_sum = 0;
    let mut part2_sum = 0;
    let mut cache: Vec<i32> = vec![0; lines.len() + 1];

    for line in lines.iter() {
        part1_sum += part1(line);
        part2_sum += part2(line, &mut cache);
    }

    println!("{}", part1_sum);
    println!("{}", part2_sum);
}
