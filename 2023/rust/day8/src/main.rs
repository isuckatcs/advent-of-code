use std::collections::HashMap;
use std::io;

fn gcd(mut a: usize, mut b: usize) -> usize {
    while a != b {
        if a > b {
            a -= b
        } else {
            b -= a
        }
    }

    a
}

fn part1(lines: &[String]) -> i32 {
    let mut m: HashMap<String, (String, String)> = HashMap::new();

    lines.iter().skip(2).for_each(|l| {
        let split = l.split('=').collect::<Vec<&str>>();
        let dests = split[1].split(',').collect::<Vec<&str>>();

        m.insert(
            split[0].trim().to_owned(),
            (
                dests[0].trim()[1..].to_string(),
                dests[1].trim()[..3].to_string(),
            ),
        );
    });

    let dirs = &lines[0];
    let mut node = "AAA";
    let mut i = 0;
    let mut size = 0;

    while node != "ZZZ" {
        node = if dirs.as_bytes()[i] == b'L' {
            &m[node].0
        } else {
            &m[node].1
        };

        i = (i + 1) % dirs.len();
        size += 1;
    }

    size
}

fn part2(lines: &[String]) -> usize {
    let mut m: HashMap<String, (String, String)> = HashMap::new();

    lines.iter().skip(2).for_each(|l| {
        let split = l.split('=').collect::<Vec<&str>>();
        let dests = split[1].split(',').collect::<Vec<&str>>();

        m.insert(
            split[0].trim().to_owned(),
            (
                dests[0].trim()[1..].to_string(),
                dests[1].trim()[..3].to_string(),
            ),
        );
    });

    let dirs = &lines[0];
    m.iter()
        .filter(|(k, _)| k.as_bytes()[2] == b'A')
        .map(|(k, _)| {
            let mut i = 0;
            let mut size = 0;
            let mut node = k;

            while node.as_bytes()[2] != b'Z' {
                node = if dirs.as_bytes()[i] == b'L' {
                    &m[node].0
                } else {
                    &m[node].1
                };

                i = (i + 1) % dirs.len();
                size += 1;
            }

            size
        })
        .fold(1_usize, |init, a| init * a / gcd(init, a))
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
