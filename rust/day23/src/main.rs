use std::cmp::max;
use std::collections::HashSet;
use std::collections::VecDeque;
use std::io;

const DIRS: [(i32, i32); 4] = [(1, 0), (-1, 0), (0, -1), (0, 1)];

fn step_in_dir(map: &[String], r: usize, c: usize, d: (i32, i32)) -> Option<(usize, usize)> {
    let nr_i = r as i32 + d.0;
    let nc_i = c as i32 + d.1;

    let nr = nr_i as usize;
    let nc = nc_i as usize;

    if nr_i < 0
        || nr >= map.len()
        || nc_i < 0
        || nc >= map[0].len()
        || map[nr].chars().nth(nc).unwrap() == '#'
    {
        None
    } else {
        Some((nr, nc))
    }
}

fn part1(map: &[String]) -> Option<usize> {
    fn traverse(
        map: &[String],
        pos: (usize, usize),
        steps: usize,
        visited: &mut HashSet<(usize, usize)>,
    ) -> usize {
        if !visited.insert(pos) {
            return 0;
        }

        let (r, c) = pos;
        let cur = map[r].chars().nth(c).unwrap();
        let mut res = 0;

        if r == map.len() - 1 {
            res = steps;
        } else if cur == '>' {
            res = traverse(map, (r, c + 1), steps + 1, visited);
        } else if cur == '^' {
            res = traverse(map, (r - 1, c), steps + 1, visited);
        } else if cur == '<' {
            res = traverse(map, (r, c - 1), steps + 1, visited);
        } else if cur == 'v' {
            res = traverse(map, (r + 1, c), steps + 1, visited);
        } else {
            for (nr, nc) in DIRS.iter().filter_map(|&d| step_in_dir(map, r, c, d)) {
                res = max(res, traverse(map, (nr, nc), steps + 1, visited))
            }
        }

        res
    }

    let mut visited = HashSet::new();
    Some(traverse(map, (0, map[0].find('.')?), 0, &mut visited))
}

fn part2(map: &[String]) -> Option<usize> {
    fn traverse(
        map: &[HashSet<(usize, usize)>],
        pos: usize,
        steps: usize,
        visited: &mut HashSet<usize>,
    ) -> usize {
        if !visited.insert(pos) {
            return 0;
        }

        if pos == map.len() - 1 {
            visited.remove(&pos);
            return steps;
        }

        let res = map[pos].iter().fold(0, |acc, &(dst, w)| {
            max(acc, traverse(map, dst, steps + w, visited))
        });

        visited.remove(&pos);
        res
    }

    let mut pois = Vec::new();

    pois.push((pois.len(), 0, map[0].find('.')?));
    for (ri, r) in map.iter().enumerate() {
        for (ci, c) in r.chars().enumerate() {
            if c != '.' {
                continue;
            }

            let roads = DIRS
                .iter()
                .filter(|&&d| step_in_dir(map, ri, ci, d).is_some())
                .count();

            if roads > 2 {
                pois.push((pois.len(), ri, ci));
            }
        }
    }
    pois.push((pois.len(), map.len() - 1, map.last()?.find('.')?));

    let mut edges = vec![HashSet::<(usize, usize)>::new(); pois.len()];
    for &(pid, pr, pc) in pois.iter() {
        let mut visited = HashSet::new();

        let mut q = VecDeque::new();
        q.push_back((0, pr, pc));

        while !q.is_empty() {
            let (s, r, c) = q.pop_front()?;

            if let Some(pid2) = pois
                .iter()
                .filter(|&&(ni, nr, nc)| ni != pid && nr == r && nc == c)
                .map(|(i, _, _)| *i)
                .next()
            {
                edges[pid].insert((pid2, s));
                edges[pid2].insert((pid, s));
                continue;
            }

            if !visited.insert((r, c)) {
                continue;
            }

            for (nr, nc) in DIRS.iter().filter_map(|&d| step_in_dir(map, r, c, d)) {
                q.push_back((s + 1, nr, nc));
            }
        }
    }

    let mut visited = HashSet::new();
    Some(traverse(&edges, 0, 0, &mut visited))
}

fn main() {
    let stdin = io::stdin();
    let mut map = Vec::new();

    for line in stdin.lines() {
        map.push(line.unwrap());
    }

    println!("{}", part1(&map).unwrap_or_default());
    println!("{}", part2(&map).unwrap_or_default());
}
