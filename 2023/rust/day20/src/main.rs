use std::collections::{HashMap, VecDeque};
use std::io;

#[derive(Default, Clone, PartialEq, Eq, Debug)]
enum Type {
    #[default]
    None,
    FlipFlop,
    Conjunction,
}

#[derive(Default, Clone, Debug)]
struct Module {
    t: Type,
    id: String,
    connections: Vec<String>,
    inputs: HashMap<String, bool>,
    flipped: bool,
}

type ModuleInfosT = HashMap<String, Module>;

fn gcd(mut a: usize, mut b: usize) -> usize {
    while a != b {
        if a > b {
            a -= b
        } else {
            b -= a
        }
    }

    a
}

fn part1(mut module_infos: ModuleInfosT) -> usize {
    let mut low = 0;
    let mut high = 0;

    for _ in 0..1000 {
        let mut q = VecDeque::<(String, bool)>::new();
        q.push_back((String::from("broadcaster"), false));

        while !q.is_empty() {
            let mut new_infos = module_infos.clone();
            let (cur, mut pulse) = q.pop_front().unwrap();

            if pulse {
                high += 1
            } else {
                low += 1
            }

            let info = module_infos.get_mut(&cur).unwrap();

            if info.t == Type::FlipFlop {
                if pulse {
                    continue;
                }

                pulse = !info.flipped;
                info.flipped = !info.flipped;
            } else if info.t == Type::Conjunction {
                let all_high = info.inputs.iter().fold(true, |acc, e| acc & e.1);

                pulse = !all_high
            }

            if !new_infos.contains_key(&cur) {
                continue;
            }

            for c in info.connections.iter() {
                let cur_info = new_infos.get_mut(c).unwrap();
                if cur_info.t == Type::Conjunction {
                    cur_info.inputs.insert(cur.clone(), pulse);
                }

                q.push_back((c.to_string(), pulse));
            }

            new_infos.insert(cur, info.clone());
            module_infos = new_infos;
        }
    }

    low * high
}

fn part2(mut module_infos: ModuleInfosT) -> usize {
    let sub_endings = module_infos
        .get(
            module_infos
                .get("rx")
                .unwrap()
                .inputs
                .keys()
                .next()
                .unwrap(),
        )
        .unwrap()
        .inputs
        .clone();
    let mut cycles: Vec<usize> = Vec::new();

    let mut push = 1;
    while cycles.len() != 4 {
        let mut q = VecDeque::<(String, bool)>::new();
        q.push_back((String::from("broadcaster"), false));

        while !q.is_empty() {
            let mut new_infos = module_infos.clone();
            let (cur, mut pulse) = q.pop_front().unwrap();

            if sub_endings.contains_key(&cur) && !pulse {
                cycles.push(push);
            }

            let info = module_infos.get_mut(&cur).unwrap();

            if info.t == Type::FlipFlop {
                if pulse {
                    continue;
                }

                pulse = !info.flipped;
                info.flipped = !info.flipped;
            } else if info.t == Type::Conjunction {
                let all_high = info.inputs.iter().fold(true, |acc, e| acc & e.1);

                pulse = !all_high
            }

            if !new_infos.contains_key(&cur) {
                continue;
            }

            for c in info.connections.iter() {
                let cur_info = new_infos.get_mut(c).unwrap();
                if cur_info.t == Type::Conjunction {
                    cur_info.inputs.insert(cur.clone(), pulse);
                }

                q.push_back((c.to_string(), pulse));
            }

            new_infos.insert(cur, info.clone());
            module_infos = new_infos;
        }

        push += 1;
    }

    cycles.iter().fold(1, |acc, n| acc * n / gcd(acc, *n))
}

fn main() {
    let mut module_infos: ModuleInfosT = ModuleInfosT::new();

    for res_line in io::stdin().lines() {
        let line = res_line.unwrap();

        let mut split = line.split("->");
        let m = split.next().unwrap().trim();
        let conenctions: Vec<String> = split
            .next()
            .unwrap()
            .trim()
            .split(',')
            .map(|s| s.trim().to_string())
            .collect();

        let mut module = Module {
            id: m[1..].to_owned(),
            connections: conenctions,
            ..Module::default()
        };

        match m.chars().next().unwrap() {
            '%' => module.t = Type::FlipFlop,
            '&' => module.t = Type::Conjunction,
            _ => module.id = m.to_string(),
        }

        module_infos.insert(module.id.clone(), module);
    }

    module_infos.insert(
        "rx".to_owned(),
        Module {
            id: "rx".to_owned(),
            ..Default::default()
        },
    );

    let mut connected_infos = module_infos.clone();
    for (m, i) in module_infos {
        for c in i.connections {
            let ci = connected_infos.get_mut(&c).unwrap();
            if ci.t == Type::Conjunction || c == "rx" {
                ci.inputs.insert(m.clone(), false);
            }
        }
    }

    println!("{}", part1(connected_infos.clone()));
    println!("{}", part2(connected_infos));
}
