use std::io;

fn solve(coords: &[(i32, i32)], steps: i32) -> isize {
    // https://en.wikipedia.org/wiki/Shoelace_formula#Example
    let xs: Vec<i32> = coords.iter().map(|&(x, _)| x).collect();
    let ys: Vec<i32> = coords.iter().map(|&(_, y)| y).collect();

    let a: isize = xs
        .iter()
        .zip(ys.iter().skip(1))
        .map(|(&x, &y)| x as isize * y as isize)
        .sum();
    let s: isize = ys
        .iter()
        .zip(xs.iter().skip(1))
        .map(|(&x, &y)| x as isize * y as isize)
        .sum();

    // https://en.wikipedia.org/wiki/Pick%27s_theorem#Formula
    let a = (a - s).abs() / 2;
    let b = steps as isize;
    let i = a - (b / 2) + 1;

    i + b
}

fn part1(moves: &[String]) -> isize {
    let ms: Vec<(char, i32)> = moves
        .iter()
        .map(|l| {
            let split: Vec<&str> = l.split(' ').collect();

            (
                split[0].chars().next().unwrap(),
                split[1].parse::<i32>().unwrap(),
            )
        })
        .collect();

    let mut steps = 0;
    let mut coords = Vec::<(i32, i32)>::new();
    coords.push((0, 0));

    for (dir, step) in ms.iter() {
        let (mut x, mut y) = coords.last().unwrap();

        steps += step;

        match dir {
            'U' => y += step,
            'D' => y -= step,
            'R' => x += step,
            'L' => x -= step,
            _ => unreachable!(),
        }

        coords.push((x, y));
    }

    solve(&coords, steps)
}

fn part2(moves: &[String]) -> isize {
    let ms: Vec<(char, i32)> = moves
        .iter()
        .map(|l| {
            let split: Vec<&str> = l.split(' ').collect();
            let hex = split[2];

            (
                hex.chars().nth(7).unwrap(),
                i32::from_str_radix(&hex[2..=6], 16).unwrap(),
            )
        })
        .collect();

    let mut steps = 0;
    let mut coords = Vec::<(i32, i32)>::new();
    coords.push((0, 0));

    for (dir, step) in ms.iter() {
        let (mut x, mut y) = coords.last().unwrap();

        steps += step;

        match dir {
            '3' => y += step,
            '1' => y -= step,
            '0' => x += step,
            '2' => x -= step,
            _ => unreachable!(),
        }

        coords.push((x, y));
    }

    solve(&coords, steps)
}

fn main() {
    let stdin = io::stdin();

    let mut moves = Vec::<String>::new();
    for line in stdin.lines() {
        moves.push(line.unwrap());
    }

    println!("{}", part1(&moves));
    println!("{}", part2(&moves));
}
