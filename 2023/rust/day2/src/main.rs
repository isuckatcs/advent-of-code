use std::{
    cmp,
    io::{self},
};

struct CubeCount {
    red: i32,
    green: i32,
    blue: i32,
}

impl Default for CubeCount {
    fn default() -> Self {
        Self {
            red: 12,
            green: 13,
            blue: 14,
        }
    }
}

impl CubeCount {
    fn is_valid(&self) -> bool {
        self.red >= 0 && self.green >= 0 && self.blue >= 0
    }
}

fn part1(line: &str) -> i32 {
    let tokens: Vec<&str> = line.split(':').collect();

    let valid = tokens[1]
        .split(';')
        .map(|s| {
            let mut cc = CubeCount::default();

            s.split(',').for_each(|s| {
                let cubes: Vec<&str> = s.trim().split(' ').collect();
                let n: i32 = cubes[0].parse::<i32>().unwrap();

                match cubes[1] {
                    "red" => cc.red -= n,
                    "green" => cc.green -= n,
                    "blue" => cc.blue -= n,
                    _ => panic!("invalid color"),
                }
            });

            cc.is_valid()
        })
        .fold(true, |init, v| init & v);

    if !valid {
        return 0;
    }

    tokens[0]
        .trim()
        .split(' ')
        .nth(1)
        .unwrap()
        .parse::<i32>()
        .unwrap()
}

fn part2(line: &str) -> i32 {
    let tokens: Vec<&str> = line.split(':').collect();

    let mut cc = CubeCount {
        red: 0,
        green: 0,
        blue: 0,
    };

    tokens[1].split(';').for_each(|s| {
        s.split(',').for_each(|s| {
            let cubes: Vec<&str> = s.trim().split(' ').collect();
            let n: i32 = cubes[0].parse::<i32>().unwrap();

            match cubes[1] {
                "red" => cc.red = cmp::max(cc.red, n),
                "green" => cc.green = cmp::max(cc.green, n),
                "blue" => cc.blue = cmp::max(cc.blue, n),
                _ => panic!("invalid color"),
            }
        })
    });

    cc.red * cc.green * cc.blue
}

fn main() {
    let mut part1_sum = 0;
    let mut part2_sum = 0;

    let stdin = io::stdin();
    for line in stdin.lines() {
        part1_sum += part1(line.as_ref().unwrap());
        part2_sum += part2(line.as_ref().unwrap());
    }

    println!("{}", part1_sum);
    println!("{}", part2_sum);
}
