use std::collections::HashSet;
use std::collections::VecDeque;
use std::io;

fn get_reached_plot_count(garden: &[String], start: &(usize, usize), steps: usize) -> usize {
    let mut queue = VecDeque::new();
    let mut visited = HashSet::new();

    queue.push_back((start.0 as i32, start.1 as i32));
    queue.push_back((-1, -1));

    let mut step = 0;
    while !queue.is_empty() {
        let (r, c) = queue.pop_front().unwrap();

        if r == -1 && c == -1 {
            if step == steps {
                break;
            }

            step += 1;
            visited.clear();

            if !queue.is_empty() {
                queue.push_back((-1, -1));
            }

            continue;
        }

        if !visited.insert((r, c)) {
            continue;
        }

        static DIRS: [(i32, i32); 4] = [(0, 1), (0, -1), (1, 0), (-1, 0)];

        for (dr, dc) in DIRS.iter() {
            let (nr, nc) = (r + dr, c + dc);

            if nr < 0
                || nr as usize >= garden.len()
                || nc < 0
                || nc as usize >= garden[0].len()
                || garden[nr as usize].chars().nth(nc as usize).unwrap() == '#'
            {
                continue;
            }

            queue.push_back((nr, nc));
        }
    }

    visited.len()
}

fn part1(garden: &[String], start: &(usize, usize)) -> usize {
    get_reached_plot_count(garden, start, 64)
}

fn part2(garden: &[String], start: &(usize, usize)) -> usize {
    let n = 26501365;

    let odd_covered = get_reached_plot_count(garden, start, 131);
    let odd_diamond = get_reached_plot_count(garden, start, 65);

    let even_covered = get_reached_plot_count(garden, start, 130);
    let even_diamond = get_reached_plot_count(garden, start, 64);

    let repetition = (2 * n + 1) / garden[0].len();
    let dist = (repetition - 1) / 2;

    let total_odd = dist + 1 + (dist + 1) * dist;
    let total_even = dist + (dist - 1) * dist;

    total_odd * odd_covered + total_even * even_covered - (dist + 1) * (odd_covered - odd_diamond)
        + dist * (even_covered - even_diamond)
}

fn main() {
    let stdin = io::stdin();
    let mut garden = Vec::new();
    let mut start: (usize, usize) = (0, 0);

    for res_line in stdin.lines() {
        let line = res_line.unwrap();

        if let Some(n) = line.find('S') {
            start = (garden.len(), n);
        }

        garden.push(line);
    }

    println!("{}", part1(&garden, &start));
    println!("{}", part2(&garden, &start));
}
