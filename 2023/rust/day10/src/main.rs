use std::{collections::VecDeque, io, str::from_utf8};

fn part1(grid: &[String], start: &(usize, usize)) -> i32 {
    let mut queue = VecDeque::new();
    let mut visited = Vec::new();

    queue.push_back((start.0 as i32, start.1 as i32));
    visited.push((start.0 as i32, start.1 as i32));
    queue.push_back((-1, -1));

    let mut steps = 0;
    while !queue.is_empty() {
        let (r, c) = queue.pop_front().unwrap();

        if r == -1 && c == -1 {
            steps += 1;

            if !queue.is_empty() {
                queue.push_back((-1, -1));
            }
        }

        static VR: [i32; 4] = [0, 0, 1, -1];
        static VC: [i32; 4] = [1, -1, 0, 0];
        static DST: [&str; 4] = ["-J7", "-FL", "|LJ", "|F7"];
        static ORG: [&str; 4] = ["S-FL", "S-J7", "S|F7", "S|JL"];

        for i in 0..VR.len() {
            let (tr, tc) = (r + VR[i], c + VC[i]);

            if tr < 0
                || tr as usize >= grid.len()
                || tc < 0
                || tc as usize >= grid[0].len()
                || ORG[i]
                    .find(grid[r as usize].chars().nth(c as usize).unwrap())
                    .is_none()
            {
                continue;
            }

            if DST[i]
                .find(grid[tr as usize].chars().nth(tc as usize).unwrap())
                .is_some()
                && !visited.contains(&(tr, tc))
            {
                queue.push_back((tr, tc));
                visited.push((tr, tc));
            }
        }
    }

    steps - 1
}

fn part2(grid: &[String], start: &(usize, usize)) -> i32 {
    let vr = [0, 0, 1, -1];
    let vc = [1, -1, 0, 0];

    let mut queue = VecDeque::new();
    let mut visited = Vec::new();

    queue.push_back((start.0 as i32, start.1 as i32));
    visited.push((start.0 as i32, start.1 as i32));

    let mut start_dirs: u8 = 0;
    while !queue.is_empty() {
        let (r, c) = queue.pop_front().unwrap();

        static DST: [&str; 4] = ["-J7", "-FL", "|LJ", "|F7"];
        static ORG: [&str; 4] = ["S-FL", "S-J7", "S|F7", "S|JL"];

        for i in 0..vr.len() {
            let (tr, tc) = (r + vr[i], c + vc[i]);
            let c = grid[r as usize].chars().nth(c as usize).unwrap();

            if tr < 0
                || tr as usize >= grid.len()
                || tc < 0
                || tc as usize >= grid[0].len()
                || ORG[i].find(c).is_none()
            {
                continue;
            }

            if DST[i]
                .find(grid[tr as usize].chars().nth(tc as usize).unwrap())
                .is_some()
                && !visited.contains(&(tr, tc))
            {
                if c == 'S' {
                    start_dirs |= 1 << i;
                }

                queue.push_back((tr, tc));
                visited.push((tr, tc));
            }
        }
    }

    let mut scaled_grid: Vec<String> = vec![from_utf8(&vec![b'.'; grid[0].len() * 2 + 1])
        .unwrap()
        .to_string()];

    for i in 0..grid.len() {
        let mut tmp = String::from(".");
        for j in 0..grid[0].len() {
            if !visited.contains(&(i as i32, j as i32)) {
                tmp += "..";
                continue;
            }

            let mut c = grid[i].chars().nth(j).unwrap();

            if c == 'S' {
                c = match start_dirs {
                    0b0101 => 'F',
                    0b1001 => 'L',
                    0b0110 => '7',
                    0b1010 => 'J',
                    0b0011 => '-',
                    0b1100 => '|',
                    _ => unreachable!(),
                }
            }

            tmp.push(c);
            tmp.push(if String::from("FL-").contains(c) {
                '-'
            } else {
                '.'
            });
        }

        scaled_grid.push(tmp.clone());
        scaled_grid.push(tmp);

        for c in unsafe { scaled_grid.last_mut().unwrap().as_bytes_mut() } {
            *c = if String::from("F7|").contains(*c as char) {
                b'|'
            } else {
                b'.'
            }
        }
    }

    queue.clear();
    visited.clear();

    queue.push_back((0, 0));
    visited.push((0, 0));

    while !queue.is_empty() {
        let (r, c) = queue.pop_front().unwrap();

        for i in 0..vr.len() {
            let (tr, tc) = (r + vr[i], c + vc[i]);
            let c = scaled_grid[r as usize].chars().nth(c as usize).unwrap();

            if tr < 0
                || tr as usize >= scaled_grid.len()
                || tc < 0
                || tc as usize >= scaled_grid[0].len()
            {
                continue;
            }

            if c == '.' && !visited.contains(&(tr, tc)) {
                queue.push_back((tr, tc));
                visited.push((tr, tc));
            }
        }
    }

    let mut cnt = 0;
    for i in (1..scaled_grid.len()).step_by(2) {
        for j in (1..scaled_grid[i].len()).step_by(2) {
            if !visited.contains(&(i as i32, j as i32)) && scaled_grid[i].as_bytes()[j] == b'.' {
                cnt += 1;
            };
        }
    }

    cnt
}

fn main() {
    let stdin = io::stdin();
    let mut grid = Vec::new();
    let mut start: (usize, usize) = (0, 0);

    for res_line in stdin.lines() {
        let line = res_line.unwrap();

        if let Some(n) = line.find('S') {
            start = (grid.len(), n);
        }

        grid.push(line);
    }

    println!("{}", part1(&grid, &start));
    println!("{}", part2(&grid, &start));
}
