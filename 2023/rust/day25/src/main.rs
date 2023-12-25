use std::collections::{HashMap, HashSet};
use std::io;

use rand::Rng;

fn part1(components: &HashMap<String, HashSet<String>>) -> usize {
    let mut node2id = HashMap::new();

    for node in components.keys() {
        node2id.insert(node, node2id.len());
    }

    let mut original_subsets = Vec::new();
    let mut original_edges = Vec::new();

    for (n, es) in components {
        original_subsets.push(HashSet::new());
        original_subsets.last_mut().unwrap().insert(node2id[n]);

        for e in es {
            original_edges.push((node2id[n], node2id[e]));
        }
    }

    loop {
        let mut subsets = original_subsets.clone();
        let mut edges = original_edges.clone();

        while subsets.len() > 2 {
            let n = rand::thread_rng().gen_range(0..edges.len());

            let (b, e) = edges.remove(n);
            let (mut s1, mut s2) = (0, 0);

            for (i, s) in subsets.iter().enumerate() {
                if s.contains(&b) {
                    s1 = i;
                }
                if s.contains(&e) {
                    s2 = i;
                }
            }

            if s1 == s2 {
                continue;
            }

            let ns1: HashSet<_> = subsets[s1].union(&subsets[s2]).copied().collect();
            subsets = subsets
                .iter()
                .enumerate()
                .filter(|&(i, _)| i != s1 && i != s2)
                .map(|(_, v)| v.to_owned())
                .collect();
            subsets.push(ns1);
        }

        let cnt = edges
            .iter()
            .filter(|(b, e)| subsets[0].contains(b) && subsets[1].contains(e))
            .count();

        if cnt == 3 {
            return subsets[0].len() * subsets[1].len();
        }
    }
}

fn part2() -> i64 {
    0
}

fn main() {
    let stdin = io::stdin();
    let mut components: HashMap<String, HashSet<String>> = HashMap::new();

    for res_line in stdin.lines() {
        let line = res_line.unwrap();

        let split = line
            .split(':')
            .map(|s| s.trim().to_owned())
            .collect::<Vec<String>>();

        let head = split[0].clone();

        let edges = split[1]
            .split(' ')
            .map(|s| s.trim().to_owned())
            .collect::<Vec<String>>();

        for edge in edges {
            components
                .entry(head.clone())
                .or_default()
                .insert(edge.clone());

            components
                .entry(edge.clone())
                .or_default()
                .insert(head.clone());
        }
    }

    println!("{}", part1(&components));
    println!("{}", part2());
}
