use std::collections::{HashMap, VecDeque};
use std::io;

type WorkflowT = HashMap<String, Vec<(char, char, i32, String)>>;
type PartT = Vec<(i32, i32, i32, i32)>;

fn part1(workflows: &WorkflowT, parts: &[(i32, i32, i32, i32)]) -> usize {
    let mut sum = 0;

    for (x, m, a, s) in parts {
        let mut current = "in";

        while current != "A" && current != "R" {
            for (cat, op, size, dst) in workflows.get(current).unwrap() {
                let less = *op == '<';

                #[allow(unused_assignments)]
                let mut hit = false;

                match cat {
                    'x' => hit = if less { x < size } else { x > size },
                    'm' => hit = if less { m < size } else { m > size },
                    'a' => hit = if less { a < size } else { a > size },
                    's' => hit = if less { s < size } else { s > size },
                    _ => hit = true,
                }

                if hit {
                    current = &dst;
                    break;
                }
            }
        }

        if current == "A" {
            sum += (x + m + a + s) as usize;
        }
    }

    sum
}

#[derive(Clone, Debug)]
struct State {
    cur: String,
    x: (i32, i32),
    m: (i32, i32),
    a: (i32, i32),
    s: (i32, i32),
}

fn part2(workflows: &WorkflowT) -> usize {
    let mut combinations = 0;

    let mut q: VecDeque<State> = VecDeque::new();
    q.push_back(State {
        cur: "in".to_owned(),
        x: (1, 4000),
        m: (1, 4000),
        a: (1, 4000),
        s: (1, 4000),
    });

    while !q.is_empty() {
        let mut st = q.pop_front().unwrap();

        if st.cur == "R" {
            continue;
        }

        if st.cur == "A" {
            combinations += (st.x.1 - st.x.0 + 1) as usize
                * (st.m.1 - st.m.0 + 1) as usize
                * (st.a.1 - st.a.0 + 1) as usize
                * (st.s.1 - st.s.0 + 1) as usize;

            continue;
        }

        for (cat, op, size, dst) in workflows.get(&st.cur).unwrap() {
            st.cur = dst.to_string();
            let mut nst = st.clone();
            let less = *op == '<';

            match cat {
                'x' => {
                    if less {
                        nst.x.1 = size - 1;
                        st.x.0 = *size;
                    } else {
                        nst.x.0 = size + 1;
                        st.x.1 = *size;
                    }
                }
                'm' => {
                    if less {
                        nst.m.1 = size - 1;
                        st.m.0 = *size;
                    } else {
                        nst.m.0 = size + 1;
                        st.m.1 = *size;
                    }
                }
                'a' => {
                    if less {
                        nst.a.1 = size - 1;
                        st.a.0 = *size;
                    } else {
                        nst.a.0 = size + 1;
                        st.a.1 = *size;
                    }
                }
                's' => {
                    if less {
                        nst.s.1 = size - 1;
                        st.s.0 = *size;
                    } else {
                        nst.s.0 = size + 1;
                        st.s.1 = *size;
                    }
                }
                _ => {}
            }

            q.push_back(nst);
        }
    }

    combinations
}

fn main() {
    let mut workflows: WorkflowT = WorkflowT::new();
    let mut parts: PartT = PartT::new();

    for res_line in io::stdin().lines() {
        let line = res_line.unwrap();

        if line.is_empty() {
            break;
        }

        let mut split = line.split('{');

        let wf = split.next().unwrap().to_string();
        let items: Vec<(char, char, i32, String)> = split
            .next()
            .unwrap()
            .split(',')
            .map(|s| {
                if s.ends_with('}') {
                    return ('.', '.', 0, s[0..s.len() - 1].to_string());
                }

                let mut split = s[2..].split(':');
                let n = split.next().unwrap().parse::<i32>().unwrap();
                let d = split.next().unwrap().to_string();

                (s.chars().next().unwrap(), s.chars().nth(1).unwrap(), n, d)
            })
            .collect();

        workflows.insert(wf, items);
    }

    for res_line in io::stdin().lines() {
        let line = res_line.unwrap();

        let x: &[_] = &['{', '}'];
        let part: Vec<i32> = line
            .trim_matches(x)
            .split(',')
            .map(|s| s.split('=').next_back().unwrap().parse::<i32>().unwrap())
            .collect();

        parts.push((part[0], part[1], part[2], part[3]));
    }

    println!("{}", part1(&workflows, &parts));
    println!("{}", part2(&workflows));
}
