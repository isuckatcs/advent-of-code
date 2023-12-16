use std::{cmp::max, io};

#[derive(Clone, Copy)]
enum LightDir {
    Up = 1 << 0,
    Down = 1 << 1,
    Left = 1 << 2,
    Right = 1 << 3,
}

struct Light {
    r: i32,
    c: i32,
    d: LightDir,
}

impl Light {
    fn create(r: i32, c: i32, d: LightDir) -> Light {
        Light { r, c, d }
    }
}

fn part1(cave: &[String], start: Light) -> usize {
    let mut lights = vec![start];
    let mut energized = vec![vec![0; cave[0].len()]; cave.len()];

    while let Some(Light { mut r, mut c, d }) = lights.pop() {
        if r < 0 || r as usize >= cave.len() || c < 0 || c as usize >= cave[0].len() {
            continue;
        }

        if energized[r as usize][c as usize] & d as i32 != 0 {
            continue;
        }

        loop {
            if r < 0 || r as usize >= cave.len() || c < 0 || c as usize >= cave[0].len() {
                break;
            }

            energized[r as usize][c as usize] |= d as i32;

            let cur = cave[r as usize].chars().nth(c as usize).unwrap();
            match d {
                LightDir::Up => {
                    match cur {
                        '\\' => {
                            lights.push(Light::create(r, c - 1, LightDir::Left));
                            break;
                        }
                        '/' => {
                            lights.push(Light::create(r, c + 1, LightDir::Right));
                            break;
                        }
                        '-' => {
                            lights.push(Light::create(r, c - 1, LightDir::Left));
                            lights.push(Light::create(r, c + 1, LightDir::Right));
                            break;
                        }
                        _ => {}
                    }
                    r -= 1;
                }
                LightDir::Down => {
                    match cur {
                        '\\' => {
                            lights.push(Light::create(r, c + 1, LightDir::Right));
                            break;
                        }
                        '/' => {
                            lights.push(Light::create(r, c - 1, LightDir::Left));
                            break;
                        }
                        '-' => {
                            lights.push(Light::create(r, c + 1, LightDir::Right));
                            lights.push(Light::create(r, c - 1, LightDir::Left));
                            break;
                        }
                        _ => {}
                    }
                    r += 1;
                }
                LightDir::Left => {
                    match cur {
                        '\\' => {
                            lights.push(Light::create(r - 1, c, LightDir::Up));
                            break;
                        }
                        '/' => {
                            lights.push(Light::create(r + 1, c, LightDir::Down));
                            break;
                        }
                        '|' => {
                            lights.push(Light::create(r - 1, c, LightDir::Up));
                            lights.push(Light::create(r + 1, c, LightDir::Down));
                            break;
                        }
                        _ => {}
                    }
                    c -= 1;
                }
                LightDir::Right => {
                    match cur {
                        '\\' => {
                            lights.push(Light::create(r + 1, c, LightDir::Down));
                            break;
                        }
                        '/' => {
                            lights.push(Light::create(r - 1, c, LightDir::Up));
                            break;
                        }
                        '|' => {
                            lights.push(Light::create(r + 1, c, LightDir::Down));
                            lights.push(Light::create(r - 1, c, LightDir::Up));
                            break;
                        }
                        _ => {}
                    }
                    c += 1;
                }
            }
        }
    }

    energized
        .iter()
        .map(|r| r.iter().filter(|&c| *c != 0).count())
        .sum()
}

fn part2(cave: &[String]) -> usize {
    let mut m = 0;

    for i in 0..cave.len() {
        m = max(m, part1(cave, Light::create(i as i32, 0, LightDir::Right)));
        m = max(
            m,
            part1(
                cave,
                Light::create(i as i32, cave[0].len() as i32 - 1, LightDir::Left),
            ),
        );
    }

    for i in 0..cave[0].len() {
        m = max(m, part1(cave, Light::create(0, i as i32, LightDir::Down)));
        m = max(
            m,
            part1(
                cave,
                Light::create(cave.len() as i32 - 1, i as i32, LightDir::Up),
            ),
        );
    }

    m
}

fn main() {
    let stdin = io::stdin();

    let mut cave = Vec::<String>::new();
    for line in stdin.lines() {
        cave.push(line.unwrap());
    }

    println!("{}", part1(&cave, Light::create(0, 0, LightDir::Right)));
    println!("{}", part2(&cave));
}
