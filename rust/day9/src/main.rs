use std::io;

fn part1(sequences: &[Vec<i32>]) -> i32 {
    sequences.iter().map(|v| v.last().unwrap()).sum::<i32>()
}

fn part2(sequences: &[Vec<i32>]) -> i32 {
    sequences
        .iter()
        .rev()
        .map(|v| v.first().unwrap())
        .fold(0, |init, n| n - init)
}

fn main() {
    let mut part1_sum = 0;
    let mut part2_sum = 0;

    let stdin = io::stdin();
    for line in stdin.lines() {
        let initial_seq: Vec<i32> = line
            .unwrap()
            .split(' ')
            .map(|s| s.parse::<i32>().unwrap())
            .collect();

        let mut sequences: Vec<Vec<i32>> = Vec::new();
        sequences.push(initial_seq);

        loop {
            let s = &sequences.last().unwrap();
            let mut prev = s[0];
            let tmp: Vec<i32> = s
                .iter()
                .skip(1)
                .map(|&n| {
                    let tmp = n - prev;
                    prev = n;
                    tmp
                })
                .collect();

            if tmp.iter().sum::<i32>() == 0 {
                break;
            }

            sequences.push(tmp);
        }

        part1_sum += part1(&sequences);
        part2_sum += part2(&sequences);
    }

    println!("{}", part1_sum);
    println!("{}", part2_sum);
}
