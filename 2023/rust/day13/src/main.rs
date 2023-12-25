use std::io;

fn part1(block: &[String]) -> usize {
    let get_mirror = |block: &[String], reflections: &[usize]| {
        reflections
            .iter()
            .find_map(|&r| {
                let mut mirror = true;

                for i in 0..r {
                    let opposite = r + (r - i) - 1;

                    if opposite >= block.len() {
                        continue;
                    }

                    mirror &= block[i] == block[opposite];
                }

                if mirror {
                    Some(r)
                } else {
                    None
                }
            })
            .unwrap_or(0)
    };

    let refl_rows = block
        .iter()
        .enumerate()
        .filter_map(|(idx, r)| {
            if idx + 1 >= block.len() {
                return None;
            }

            if *r == block[idx + 1] {
                Some(idx + 1)
            } else {
                None
            }
        })
        .collect::<Vec<usize>>();

    let x = get_mirror(block, &refl_rows);
    if x != 0 {
        return x * 100;
    }

    let mut rotated = Vec::new();
    for i in 0..block[0].len() {
        let mut col = String::new();

        for r in block {
            col.push(r.chars().nth(i).unwrap())
        }

        rotated.push(col)
    }

    let refl_cols = rotated
        .iter()
        .enumerate()
        .filter_map(|(idx, r)| {
            if idx + 1 >= rotated.len() {
                return None;
            }

            if *r == rotated[idx + 1] {
                Some(idx + 1)
            } else {
                None
            }
        })
        .collect::<Vec<usize>>();

    get_mirror(&rotated, &refl_cols)
}

fn part2(block: &[String]) -> usize {
    let count_diff = |a: &String, b: &String| -> usize {
        a.chars().zip(b.chars()).filter(|(c1, c2)| c1 != c2).count()
    };

    let get_mirror = |block: &[String], reflections: &[usize]| {
        reflections
            .iter()
            .find_map(|&r| {
                let mut mirror = true;
                let mut correction = false;

                for i in 0..r {
                    let opposite = r + (r - i) - 1;

                    if opposite >= block.len() {
                        continue;
                    }

                    let diff = count_diff(&block[i], &block[opposite]);

                    mirror &= diff == 0 || (diff == 1 && !correction);
                    correction |= diff != 0;
                }

                if mirror && correction {
                    Some(r)
                } else {
                    None
                }
            })
            .unwrap_or(0)
    };

    let refl_rows = block
        .iter()
        .enumerate()
        .filter_map(|(idx, r)| {
            if idx + 1 >= block.len() {
                return None;
            }

            if count_diff(r, &block[idx + 1]) <= 1 {
                Some(idx + 1)
            } else {
                None
            }
        })
        .collect::<Vec<usize>>();

    let x = get_mirror(block, &refl_rows);
    if x != 0 {
        return x * 100;
    }

    let mut rotated = Vec::new();
    for i in 0..block[0].len() {
        let mut col = String::new();

        for r in block {
            col.push(r.chars().nth(i).unwrap())
        }

        rotated.push(col)
    }

    let refl_cols = rotated
        .iter()
        .enumerate()
        .filter_map(|(idx, r)| {
            if idx + 1 >= rotated.len() {
                return None;
            }

            if count_diff(r, &rotated[idx + 1]) <= 1 {
                Some(idx + 1)
            } else {
                None
            }
        })
        .collect::<Vec<usize>>();

    get_mirror(&rotated, &refl_cols)
}
fn main() {
    let mut part1_sum = 0;
    let mut part2_sum = 0;

    let stdin = io::stdin();

    let mut block = Vec::<String>::new();
    for res_line in stdin.lines() {
        let res = res_line.unwrap();

        if !res.is_empty() {
            block.push(res);
            continue;
        }

        part1_sum += part1(&block);
        part2_sum += part2(&block);
        block.clear();
    }

    part1_sum += part1(&block);
    part2_sum += part2(&block);

    println!("{}", part1_sum);
    println!("{}", part2_sum);
}
