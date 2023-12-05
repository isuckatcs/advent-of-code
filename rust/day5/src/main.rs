use std::io;

fn part1(lines: &[String]) -> u32 {
    let mut nums: Vec<u32> = lines
        .get(0)
        .unwrap()
        .split(':')
        .next_back()
        .unwrap()
        .trim()
        .split(' ')
        .map(|s| s.parse::<u32>().unwrap())
        .collect();

    let mut tmp = nums.clone();
    for line in lines.iter().skip(1) {
        if line.is_empty() || line.split(' ').count() < 3 {
            nums = tmp.clone();
            continue;
        }

        let mapping = line
            .trim()
            .split(' ')
            .map(|s| s.parse::<u32>().unwrap())
            .collect::<Vec<u32>>();

        for (idx, &n) in nums.iter().enumerate() {
            let end: usize = mapping[1] as usize + mapping[2] as usize;
            if n >= mapping[1] && (n as usize) < end {
                tmp[idx] = mapping[0] + (n - mapping[1]);
            }
        }
    }

    tmp.into_iter().min().unwrap()
}

fn part2(lines: &[String]) -> u32 {
    let ranges: Vec<u32> = lines
        .get(0)
        .unwrap()
        .split(':')
        .next_back()
        .unwrap()
        .trim()
        .split(' ')
        .map(|s| s.parse::<u32>().unwrap())
        .collect();

    let mut nums = Vec::<u32>::new();
    for i in (0..ranges.len()).step_by(2) {
        for n in 0..ranges[i + 1] {
            nums.push(ranges[i] + n);
        }
    }
    drop(ranges);

    let mut tmp = nums.clone();

    for line in lines.iter().skip(1) {
        if line.is_empty() || line.split(' ').count() < 3 {
            nums.clear();
            nums.shrink_to_fit();
            nums = tmp.clone();
            continue;
        }

        let mapping = line
            .trim()
            .split(' ')
            .map(|s| s.parse::<u32>().unwrap())
            .collect::<Vec<u32>>();

        for (idx, &n) in nums.iter().enumerate() {
            let end: usize = mapping[1] as usize + mapping[2] as usize;
            if n >= mapping[1] && (n as usize) < end {
                tmp[idx] = mapping[0] + (n - mapping[1]);
            }
        }
    }

    tmp.into_iter().min().unwrap()
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
