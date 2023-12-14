use std::collections::HashMap;
use std::io;

fn part1(block: &[String]) -> usize {
    let mut weight = 0;

    for c in 0..block[0].len() {
        let mut stop = 0;

        for r in 0..block.len() {
            let cur = block[r].as_bytes()[c];
            if cur == b'#' {
                stop = r + 1;
                continue;
            }

            if cur == b'O' {
                weight += block.len() - stop;
                stop += 1;
            }
        }
    }

    weight
}

fn part2(mut block: Vec<String>) -> usize {
    let mut val_to_n = HashMap::<usize, usize>::new();
    let mut iters = Vec::<usize>::new();

    let mut cycle_idx = 0;
    let mut cycle_base = 0;
    let mut prev_cycle_end = 0;
    let mut detect_cycle = false;

    let row_count = block.len();
    let col_count = block[0].len();

    let target = 1_000_000_000;
    for n in 0..target {
        let mut weight = 0;

        // Tilt north
        for c in 0..col_count {
            let mut stop = 0;

            for r in 0..row_count {
                let cur = block[r].as_bytes()[c];
                if cur == b'#' {
                    stop = r + 1;
                    continue;
                }

                if cur == b'O' {
                    unsafe {
                        block[r].as_bytes_mut()[c] = b'.';
                        block[stop].as_bytes_mut()[c] = b'O';
                    }
                    stop += 1;
                }
            }
        }

        // Tilt west
        for r in block.iter_mut() {
            let mut stop = 0;

            for c in 0..col_count {
                let cur = r.as_bytes()[c];
                if cur == b'#' {
                    stop = c + 1;
                    continue;
                }

                if cur == b'O' {
                    unsafe {
                        r.as_bytes_mut()[c] = b'.';
                        r.as_bytes_mut()[stop] = b'O';
                    }
                    stop += 1;
                }
            }
        }

        // Tilt south
        for c in 0..col_count {
            let mut stop = row_count - 1;

            for r in (0..row_count).rev() {
                let cur = block[r].as_bytes()[c];

                if cur == b'#' {
                    stop = r.saturating_sub(1);
                    continue;
                }

                if cur == b'O' {
                    unsafe {
                        block[r].as_bytes_mut()[c] = b'.';
                        block[stop].as_bytes_mut()[c] = b'O';
                    }
                    weight += row_count - stop;
                    stop = stop.saturating_sub(1);
                }
            }
        }

        // Tilt east
        for r in block.iter_mut() {
            let mut stop = col_count - 1;

            for c in (0..col_count).rev() {
                let cur = r.as_bytes()[c];
                if cur == b'#' {
                    stop = c.saturating_sub(1);
                    continue;
                }

                if cur == b'O' {
                    unsafe {
                        r.as_bytes_mut()[c] = b'.';
                        r.as_bytes_mut()[stop] = b'O';
                    }
                    stop = stop.saturating_sub(1);
                }
            }
        }

        if detect_cycle {
            detect_cycle = weight == iters[cycle_idx + 1];
            cycle_idx += 1;
        }

        if val_to_n.contains_key(&weight) {
            if detect_cycle {
                if iters[cycle_base] == weight {
                    if prev_cycle_end == *val_to_n.get(&weight).unwrap() {
                        break;
                    }

                    prev_cycle_end = n;
                }
            } else {
                cycle_base = *val_to_n.get(&weight).unwrap();
                cycle_idx = cycle_base;
                detect_cycle = true;
            }
        }

        val_to_n.insert(weight, n);
        iters.push(weight);
    }

    if detect_cycle {
        let diff = iters.len() - prev_cycle_end;
        let m = (target - prev_cycle_end - 1) % diff;

        return iters[prev_cycle_end + m];
    }

    iters[target - 1]
}

fn main() {
    let stdin = io::stdin();

    let mut block = Vec::<String>::new();
    for line in stdin.lines() {
        block.push(line.unwrap());
    }

    println!("{}", part1(&block));
    println!("{}", part2(block));
}
