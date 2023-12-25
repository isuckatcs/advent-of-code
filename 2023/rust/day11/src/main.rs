use std::{collections::BTreeSet, io, mem::swap};

fn part1(grid: &[String]) -> usize {
    let mut galaxies = Vec::new();
    let mut occupied_cols = BTreeSet::new();
    let mut occupied_rows = BTreeSet::new();

    grid.iter().enumerate().for_each(|(ri, r)| {
        r.chars().enumerate().for_each(|(ci, c)| {
            if c == '#' {
                galaxies.push((ri, ci));
                occupied_rows.insert(ri);
                occupied_cols.insert(ci);
            }
        });
    });

    let mut total_dist: usize = 0;
    galaxies.iter().enumerate().for_each(|(ri, g1)| {
        galaxies.iter().skip(ri).for_each(|g2| {
            let (mut a, mut b) = g1;
            let (mut c, mut d) = g2;

            if a > c {
                swap(&mut a, &mut c);
            }

            if b > d {
                swap(&mut b, &mut d);
            }

            let mut dist: usize = c - a + d - b;
            for k in a..c {
                if !occupied_rows.contains(&k) {
                    dist += 1
                }
            }
            for k in b..d {
                if !occupied_cols.contains(&k) {
                    dist += 1
                }
            }
            total_dist += dist;
        })
    });

    total_dist
}

fn part2(grid: &[String]) -> usize {
    let mut galaxies = Vec::new();
    let mut occupied_cols = BTreeSet::new();
    let mut occupied_rows = BTreeSet::new();

    grid.iter().enumerate().for_each(|(ri, r)| {
        r.chars().enumerate().for_each(|(ci, c)| {
            if c == '#' {
                galaxies.push((ri, ci));
                occupied_rows.insert(ri);
                occupied_cols.insert(ci);
            }
        });
    });

    let mut total_dist: usize = 0;
    galaxies.iter().enumerate().for_each(|(ri, g1)| {
        galaxies.iter().skip(ri).for_each(|g2| {
            let (mut a, mut b) = g1;
            let (mut c, mut d) = g2;

            if a > c {
                swap(&mut a, &mut c);
            }

            if b > d {
                swap(&mut b, &mut d);
            }

            let mut dist: usize = c - a + d - b;
            for k in a..c {
                if !occupied_rows.contains(&k) {
                    dist += 1000000 - 1
                }
            }
            for k in b..d {
                if !occupied_cols.contains(&k) {
                    dist += 1000000 - 1
                }
            }
            total_dist += dist;
        })
    });

    total_dist
}

fn main() {
    let stdin = io::stdin();
    let mut grid = Vec::new();

    for line in stdin.lines() {
        grid.push(line.unwrap());
    }

    println!("{}", part1(&grid));
    println!("{}", part2(&grid));
}
