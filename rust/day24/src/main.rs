use std::io;
use std::ops;

const EPSILON: f64 = 1e-3;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Vec3 {
    x: i64,
    y: i64,
    z: i64,
}

impl ops::Add<Vec3> for Vec3 {
    type Output = Vec3;

    fn add(self, rhs: Vec3) -> Self::Output {
        Vec3 {
            x: self.x + rhs.x,
            y: self.y + rhs.y,
            z: self.z + rhs.z,
        }
    }
}

impl ops::Sub<Vec3> for Vec3 {
    type Output = Vec3;

    fn sub(self, rhs: Vec3) -> Self::Output {
        Vec3 {
            x: self.x - rhs.x,
            y: self.y - rhs.y,
            z: self.z - rhs.z,
        }
    }
}

impl ops::Mul<i64> for Vec3 {
    type Output = Vec3;

    fn mul(self, rhs: i64) -> Self::Output {
        Vec3 {
            x: self.x * rhs,
            y: self.y * rhs,
            z: self.z * rhs,
        }
    }
}

#[derive(Clone, Debug)]
struct Hailstone {
    pos: Vec3,
    dir: Vec3,
}

fn intersect(h1: &Hailstone, h2: &Hailstone) -> Option<(f64, f64)> {
    let Hailstone { pos: p1, dir: d1 } = h1;
    let Hailstone { pos: p2, dir: d2 } = h2;

    let fp1 = (p1.x as f64, p1.y as f64);
    let fd1 = (d1.x as f64, d1.y as f64);

    let fp2 = (p2.x as f64, p2.y as f64);
    let fd2 = (d2.x as f64, d2.y as f64);

    let a = fd1.1 / fd1.0;
    let c = fp1.1 - a * fp1.0;

    let b = fd2.1 / fd2.0;
    let d = fp2.1 - b * fp2.0;

    if (a - b).abs() < EPSILON {
        return None;
    }

    let x = (d - c) / (a - b);
    let t1 = (x - fp1.0) / fd1.0;
    let t2 = (x - fp2.0) / fd2.0;

    if t1 < 0.0 || t2 < 0.0 {
        return None;
    }

    Some((t1, t2))
}

fn part1(hailstones: &[Hailstone]) -> usize {
    const BEGIN: f64 = 200000000000000.0;
    const END: f64 = 400000000000000.0;

    let mut cnt = 0_usize;
    for (idx, h1) in hailstones.iter().enumerate() {
        for h2 in hailstones.iter().skip(idx + 1) {
            if let Some((t1, _)) = intersect(h1, h2) {
                let Hailstone { pos, dir } = h1;

                let x = pos.x as f64 + t1 * dir.x as f64;
                let y = pos.y as f64 + t1 * dir.y as f64;

                if (BEGIN..=END).contains(&x) && (BEGIN..=END).contains(&y) {
                    cnt += 1;
                }
            }
        }
    }

    cnt
}

fn part2(hailstones: &[Hailstone]) -> i64 {
    const N: i64 = 250;

    for x in -N..=N {
        for y in -N..=N {
            for z in -N..=N {
                let cv = Vec3 { x, y, z };

                let Hailstone { pos: p0, dir: td0 } = hailstones[0];
                let Hailstone { pos: p1, dir: td1 } = hailstones[1];

                let d0 = td0 - cv;
                let d1 = td1 - cv;

                if d0.x == 0 || d1.x == 0 {
                    continue;
                }

                if let Some((ft1, ft2)) = intersect(
                    &Hailstone { pos: p0, dir: d0 },
                    &Hailstone { pos: p1, dir: d1 },
                ) {
                    if (ft1.round() - ft1).abs() >= EPSILON || (ft2.round() - ft2).abs() >= EPSILON
                    {
                        continue;
                    }

                    let (t1, t2) = (ft1 as i64, ft2 as i64);

                    let intersection = p0 + d0 * t1;
                    let Vec3 {
                        x: ix,
                        y: iy,
                        z: iz,
                    } = intersection;

                    if iz != p1.z + t2 * d1.z {
                        continue;
                    }

                    if hailstones
                        .iter()
                        .skip(2)
                        .all(|&Hailstone { pos: cp, dir: cd }| {
                            let nd = cd - cv;
                            let tt = (ix - cp.x) / nd.x;

                            intersection == cp + nd * tt
                        })
                    {
                        return ix + iy + iz;
                    }
                }
            }
        }
    }

    0
}

fn main() {
    let stdin = io::stdin();
    let mut hailstones = Vec::new();

    for res_line in stdin.lines() {
        let line = res_line.unwrap();

        let vecs = line
            .split('@')
            .map(|s| {
                let split: Vec<&str> = s.split(',').map(|s| s.trim()).collect();

                Vec3 {
                    x: split[0].parse::<i64>().unwrap(),
                    y: split[1].parse::<i64>().unwrap(),
                    z: split[2].parse::<i64>().unwrap(),
                }
            })
            .collect::<Vec<Vec3>>();

        hailstones.push(Hailstone {
            pos: vecs[0].to_owned(),
            dir: vecs[1].to_owned(),
        });
    }

    println!("{}", part1(&hailstones));
    println!("{}", part2(&hailstones));
}
