use std::io;

fn part1(lines: &[String]) -> i32 {
    let symbols: Vec<(i32, i32, char)> = lines
        .iter()
        .enumerate()
        .flat_map(|(r, v)| {
            let s: Vec<(i32, i32, char)> = v
                .chars()
                .enumerate()
                .filter(|(_c, v)| *v != '.' && !v.is_ascii_digit())
                .map(move |(c, v)| (r as i32, c as i32, v))
                .collect();

            s
        })
        .collect();

    let mut nums: Vec<(i32, i32, i32, i32)> = Vec::new();
    for (idx, line) in lines.iter().enumerate() {
        let mut i = 0;
        while i < line.len() {
            if !line.chars().nth(i).unwrap().is_ascii_digit() {
                i += 1;
                continue;
            }

            let b = i;
            while i < line.len() && line.chars().nth(i).unwrap().is_ascii_digit() {
                i += 1
            }

            nums.push((
                idx.try_into().unwrap(),
                b.try_into().unwrap(),
                (i - 1).try_into().unwrap(),
                line[b..i].to_string().parse::<i32>().unwrap(),
            ));
        }
    }

    nums.iter()
        .filter(|(l, b, e, _n)| {
            symbols
                .iter()
                .filter(|(sr, sc, _s)| *sr >= l - 1 && *sr <= l + 1 && *sc >= b - 1 && *sc <= e + 1)
                .peekable()
                .peek()
                .is_some()
        })
        .map(|(_, _, _, n)| *n)
        .sum()
}

fn part2(lines: &[String]) -> i32 {
    let symbols: Vec<(i32, i32, char)> = lines
        .iter()
        .enumerate()
        .flat_map(|(r, v)| {
            let s: Vec<(i32, i32, char)> = v
                .chars()
                .enumerate()
                .filter(|(_c, v)| *v == '*')
                .map(move |(c, v)| (r as i32, c as i32, v))
                .collect();

            s
        })
        .collect();

    let mut nums: Vec<(i32, i32, i32, i32)> = Vec::new();
    for (idx, line) in lines.iter().enumerate() {
        let mut i = 0;
        while i < line.len() {
            if !line.chars().nth(i).unwrap().is_ascii_digit() {
                i += 1;
                continue;
            }

            let b = i;
            while i < line.len() && line.chars().nth(i).unwrap().is_ascii_digit() {
                i += 1
            }

            nums.push((
                idx.try_into().unwrap(),
                b.try_into().unwrap(),
                (i - 1).try_into().unwrap(),
                line[b..i].to_string().parse::<i32>().unwrap(),
            ));
        }
    }

    symbols
        .iter()
        .filter_map(|(sr, sc, _s)| {
            let ans: Vec<i32> = nums
                .iter()
                .filter(|(l, b, e, _n)| {
                    *sr >= l - 1 && *sr <= l + 1 && *sc >= b - 1 && *sc <= e + 1
                })
                .map(|(_, _, _, n)| *n)
                .collect();

            if ans.len() != 2 {
                None
            } else {
                Some(ans[0] * ans[1])
            }
        })
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
