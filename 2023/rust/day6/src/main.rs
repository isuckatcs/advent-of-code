use std::io;

fn part1(lines: &[String]) -> u32 {
    let nums = lines
        .iter()
        .map(|line| {
            line.split(':')
                .nth(1)
                .unwrap()
                .split(' ')
                .filter(|s| !s.is_empty())
                .map(|s| s.parse::<u32>().unwrap())
                .collect::<Vec<u32>>()
        })
        .collect::<Vec<Vec<u32>>>();

    let mut out = 1;
    for i in 0..nums[0].len() {
        let t = nums[0][i];
        let d = nums[1][i];

        let mut cnt = 0;
        for j in 0..=t {
            if (t - j) * j > d {
                cnt += 1;
            }
        }
        out *= cnt;
    }

    out
}

fn part2(lines: &[String]) -> u32 {
    let nums = lines
        .iter()
        .map(|line| {
            line.split(':')
                .nth(1)
                .unwrap()
                .chars()
                .filter(|c| !c.is_whitespace())
                .collect::<String>()
                .parse::<usize>()
                .unwrap()
        })
        .collect::<Vec<usize>>();

    let mut out = 0;
    let t = nums[0];
    let d = nums[1];

    for j in 0..=t {
        if (t - j) * j > d {
            out += 1;
        }
    }

    out
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
