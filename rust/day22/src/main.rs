use std::cmp::max;
use std::cmp::min;
use std::collections::HashMap;
use std::collections::HashSet;
use std::collections::VecDeque;
use std::io;

#[derive(Clone, Debug)]
struct Point {
    x: i32,
    y: i32,
    z: i32,
}

#[derive(Clone, Debug)]
struct Brick {
    id: usize,
    begin: Point,
    end: Point,
}

#[derive(Default, Debug)]
struct CollisionData {
    supports: Vec<usize>,
    supported_by: Vec<usize>,
}

type CollisionDataMap = HashMap<usize, CollisionData>;

fn simulate_gravity(mut bricks: Vec<Brick>) -> CollisionDataMap {
    bricks.sort_by(|rhs, lhs| rhs.begin.z.cmp(&lhs.begin.z));

    let mut collision_datas = CollisionDataMap::new();
    let mut fallen_bricks = bricks.clone();

    for Brick {
        id: i,
        begin: mut b,
        end: mut e,
    } in bricks
    {
        collision_datas.insert(i, CollisionData::default());

        let mut falling_bricks = Vec::new();
        let mut maybe_collides = Vec::new();
        let mut z_collision = 1;

        for Brick {
            id: ci,
            begin: cb,
            end: ce,
        } in &fallen_bricks
        {
            if i == *ci {
                continue;
            }

            falling_bricks.push(Brick {
                id: *ci,
                begin: cb.clone(),
                end: ce.clone(),
            });

            let (xb, xe) = (max(cb.x, b.x), min(ce.x, e.x));
            let (yb, ye) = (max(cb.y, b.y), min(ce.y, e.y));

            if xb > xe || yb > ye {
                continue;
            }

            if ce.z < b.z {
                z_collision = max(z_collision, ce.z + 1);
                maybe_collides.push((*ci, ce.z + 1));
            }
        }

        let fall = b.z - z_collision;

        b.z -= fall;
        e.z -= fall;
        falling_bricks.push(Brick {
            id: i,
            begin: b,
            end: e,
        });

        for (id, z) in maybe_collides {
            if z == z_collision {
                let mut d1 = collision_datas
                    .insert(id, CollisionData::default())
                    .unwrap_or_default();

                d1.supports.push(i);
                collision_datas.insert(id, d1);

                let mut d2 = collision_datas
                    .insert(i, CollisionData::default())
                    .unwrap_or_default();

                d2.supported_by.push(id);
                collision_datas.insert(i, d2);
            }
        }

        fallen_bricks = falling_bricks;
    }

    collision_datas
}

fn part1(collision_datas: &CollisionDataMap) -> usize {
    collision_datas
        .iter()
        .filter(|(_, data)| {
            data.supports
                .iter()
                .all(|supported| collision_datas.get(supported).unwrap().supported_by.len() > 1)
        })
        .count()
}

fn part2(collision_datas: &CollisionDataMap) -> usize {
    let mut total = 0;

    for &block in collision_datas.keys() {
        let mut queue = VecDeque::new();
        let mut visited = HashSet::new();

        queue.push_back(block);
        visited.insert(block);

        let mut falling = 0;
        while !queue.is_empty() {
            let b = queue.pop_front().unwrap();

            for &supported in collision_datas.get(&b).unwrap().supports.iter() {
                if visited.contains(&supported) {
                    continue;
                }

                let supporters_falling = collision_datas
                    .get(&supported)
                    .unwrap()
                    .supported_by
                    .iter()
                    .all(|supporter| visited.contains(supporter));

                if supporters_falling {
                    queue.push_back(supported);
                    visited.insert(supported);
                    falling += 1;
                }
            }
        }

        total += falling;
    }

    total
}

fn main() {
    let stdin = io::stdin();
    let mut bricks = Vec::new();

    for res_line in stdin.lines() {
        let line = res_line.unwrap();

        let points = line
            .split('~')
            .map(|s| {
                let split: Vec<&str> = s.split(',').collect();

                Point {
                    x: split[0].parse::<i32>().unwrap(),
                    y: split[1].parse::<i32>().unwrap(),
                    z: split[2].parse::<i32>().unwrap(),
                }
            })
            .collect::<Vec<Point>>();

        bricks.push(Brick {
            id: bricks.len(),
            begin: points[0].to_owned(),
            end: points[1].to_owned(),
        });
    }

    let collision_datas = simulate_gravity(bricks);

    println!("{}", part1(&collision_datas));
    println!("{}", part2(&collision_datas));
}
