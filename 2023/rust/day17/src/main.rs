use std::{collections::BinaryHeap, io};

#[derive(Debug, Eq)]
struct Data {
    w: usize,
    r: i32,
    c: i32,
    s: i32,
    d: Dir,
}

impl Data {
    fn create(w: usize, r: i32, c: i32, s: i32, d: Dir) -> Data {
        Data { w, r, c, s, d }
    }
}

impl PartialEq for Data {
    fn eq(&self, other: &Self) -> bool {
        self.w == other.w
            && self.r == other.r
            && self.c == other.c
            && self.s == other.s
            && self.d == other.d
    }
}

impl Ord for Data {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        other.w.cmp(&self.w)
    }
}

impl PartialOrd for Data {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

#[derive(Debug, PartialEq, Eq, Clone, Copy)]
enum Dir {
    Up,
    Down,
    Left,
    Right,
}

const VD: [(i32, i32); 4] = [(-1, 0), (1, 0), (0, -1), (0, 1)];
const NDS: [[Dir; 2]; 4] = [
    [Dir::Left, Dir::Right],
    [Dir::Left, Dir::Right],
    [Dir::Up, Dir::Down],
    [Dir::Up, Dir::Down],
];

fn part1(blocks: &[String]) -> usize {
    let mut visited = [[[[false; 4]; 4]; 150]; 150];

    let mut q = BinaryHeap::<Data>::new();
    q.push(Data::create(
        (blocks[0].as_bytes()[1] - b'0') as usize,
        0,
        1,
        1,
        Dir::Right,
    ));
    q.push(Data::create(
        (blocks[1].as_bytes()[0] - b'0') as usize,
        1,
        0,
        1,
        Dir::Down,
    ));

    while !q.is_empty() {
        let Data { w, r, c, s, d } = q.pop().unwrap();

        if r as usize == blocks.len() - 1 && c as usize == blocks[0].len() - 1 {
            return w;
        }

        if visited[r as usize][c as usize][d as usize][s as usize] {
            continue;
        }

        visited[r as usize][c as usize][d as usize][s as usize] = true;

        if s < 3 {
            let (vr, vc) = VD[d as usize];
            let nr = r + vr;
            let nc = c + vc;

            if nr >= 0
                && nr < blocks.len().try_into().unwrap()
                && nc >= 0
                && nc < blocks[0].len().try_into().unwrap()
            {
                q.push(Data::create(
                    w + (blocks[nr as usize].as_bytes()[nc as usize] - b'0') as usize,
                    nr,
                    nc,
                    s + 1,
                    d,
                ));
            }
        }

        for nd in NDS[d as usize] {
            let (vr, vc) = VD[nd as usize];
            let nr = r + vr;
            let nc = c + vc;

            if nr < 0
                || nr >= blocks.len().try_into().unwrap()
                || nc < 0
                || nc >= blocks[0].len().try_into().unwrap()
            {
                continue;
            }

            q.push(Data::create(
                w + (blocks[nr as usize].as_bytes()[nc as usize] - b'0') as usize,
                nr,
                nc,
                1,
                nd,
            ));
        }
    }

    0
}

fn part2(blocks: &[String]) -> usize {
    let mut visited = [[[[false; 11]; 4]; 150]; 150];

    let mut q = BinaryHeap::<Data>::new();
    q.push(Data::create(
        (blocks[0].as_bytes()[1] - b'0') as usize,
        0,
        1,
        1,
        Dir::Right,
    ));
    q.push(Data::create(
        (blocks[1].as_bytes()[0] - b'0') as usize,
        1,
        0,
        1,
        Dir::Down,
    ));

    while !q.is_empty() {
        let Data { w, r, c, s, d } = q.pop().unwrap();

        if r as usize == blocks.len() - 1 && c as usize == blocks[0].len() - 1 && s >= 4 {
            return w;
        }

        if visited[r as usize][c as usize][d as usize][s as usize] {
            continue;
        }

        visited[r as usize][c as usize][d as usize][s as usize] = true;

        if s < 10 {
            let (vr, vc) = VD[d as usize];
            let nr = r + vr;
            let nc = c + vc;

            if nr >= 0
                && nr < blocks.len().try_into().unwrap()
                && nc >= 0
                && nc < blocks[0].len().try_into().unwrap()
            {
                q.push(Data::create(
                    w + (blocks[nr as usize].as_bytes()[nc as usize] - b'0') as usize,
                    nr,
                    nc,
                    s + 1,
                    d,
                ));
            }

            if s < 4 {
                continue;
            }
        }

        for nd in NDS[d as usize] {
            let (vr, vc) = VD[nd as usize];
            let nr = r + vr;
            let nc = c + vc;

            if nr < 0
                || nr >= blocks.len().try_into().unwrap()
                || nc < 0
                || nc >= blocks[0].len().try_into().unwrap()
            {
                continue;
            }

            q.push(Data::create(
                w + (blocks[nr as usize].as_bytes()[nc as usize] - b'0') as usize,
                nr,
                nc,
                1,
                nd,
            ));
        }
    }
    0
}

fn main() {
    let stdin = io::stdin();

    let mut blocks = Vec::<String>::new();
    for line in stdin.lines() {
        blocks.push(line.unwrap());
    }

    println!("{}", part1(&blocks));
    println!("{}", part2(&blocks));
}
