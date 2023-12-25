use std::io;

fn part1(line: &str) -> usize {
    line.split(',')
        .map(|s| {
            let mut hash: usize = 0;

            for b in s.as_bytes() {
                hash += *b as usize;
                hash *= 17;
                hash %= 256;
            }

            hash
        })
        .sum()
}

fn part2(line: &str) -> usize {
    let mut boxes = vec![Vec::<(String, i32)>::new(); 256];

    for s in line.split(',') {
        let last = *s.as_bytes().last().unwrap();
        let rm = last == b'-';
        let delim = if rm { '-' } else { '=' };
        let label = s.split(delim).next().unwrap();

        let mut hash: usize = 0;
        for b in label.as_bytes() {
            hash += *b as usize;
            hash *= 17;
            hash %= 256;
        }

        let b = &mut boxes[hash];
        if rm {
            *b = b.iter().filter(|&(l, _)| l != label).cloned().collect();
            continue;
        }

        let val = (last - b'0') as i32;
        if let Some(i) = b.iter().position(|(l, _)| l == label) {
            b[i].1 = val;
        } else {
            b.push((label.to_string(), val));
        }
    }

    boxes
        .iter()
        .enumerate()
        .filter(|(_, b)| !b.is_empty())
        .map(|(i, b)| {
            b.iter()
                .enumerate()
                .map(|(j, &(_, v))| (i + 1) * (j + 1) * (v as usize))
                .sum::<usize>()
        })
        .sum()
}

fn main() {
    let stdin = io::stdin();

    for res_line in stdin.lines() {
        let line = res_line.unwrap();

        println!("{}", part1(&line));
        println!("{}", part2(&line));
    }
}
