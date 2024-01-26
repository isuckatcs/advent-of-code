// This could benefit from memoization, but caching the values resultee in slower runtime.
func maxFlow(curValve: Int, time: Int, openValves: Int, valveSet: Int) -> Int {
    var newFlow = 0

    for (valve, dist) in adjacentValves[curValve]! {
        let valveBit = (1 << valve)
        let newTime = time - dist - 1

        if newTime < 0 || (openValves & valveBit) != 0 || (valveSet & valveBit) == 0 {
            continue
        }

        newFlow = max(newFlow, newTime * flowRate[valve] + maxFlow(
            curValve: valve, 
            time: newTime, 
            openValves: openValves | valveBit, 
            valveSet: valveSet
        ))
    }

    return newFlow
}

func part1(lines: [String]) -> Int {
    return maxFlow(curValve: nodeToIdx["AA"]!, time: 30, openValves: 0, valveSet: ~0)
}

func part2(lines: [String]) -> Int {
    var out = 0

    for i in 0..<(1 << adjacentValves.count) / 2 {
        let valveSubset = adjacentValves.enumerated()
            .filter { (1 << $0.offset) & i != 0}
            .map { 1 << $0.element.key}
            .reduce(0, |)

        let AAIdx = nodeToIdx["AA"]!
        out = max(out,
            maxFlow(curValve: AAIdx, time: 26, openValves: 0, valveSet: valveSubset | AAIdx) 
            + maxFlow(curValve: AAIdx, time: 26, openValves: 0, valveSet: ~valveSubset | AAIdx)
        )
    }

    return out
}

var lines: [String] = [String]()
while let line = readLine() {
    lines.append(line)
}

let regex = try! Regex("[A-Z][A-Z]|[0-9]+")
var nodeToIdx: [String: Int] = [:]
var flowRate: [Int] = []

for line in lines {
    let ranges = line.ranges(of: regex) 
    let node = String(line[ranges[0]])
    let idx = flowRate.count

    nodeToIdx[node] = idx
    flowRate.append(Int(line[ranges[1]])!)
}

var neighbours: [[(Int, Int)]] = Array(repeating: [], count: nodeToIdx.count)
for line in lines {
    let ranges = line.ranges(of: regex) 
    let idx = nodeToIdx[String(line[ranges[0]])]!

    ranges.dropFirst(2).forEach {
        let neighbourIdx = nodeToIdx[String(line[$0])]!
        neighbours[idx] += [(neighbourIdx, 1)]
    }
}

var adjacentValves: [Int: [(Int, Int)]] = [:]
for node in 0..<neighbours.count {
    var q: [(Int, Int)] = [(node, 0)]
    var visited = Set<Int>()
    
    if flowRate[node] == 0 && node != nodeToIdx["AA"] {
        continue
    }
    
    adjacentValves[node] = []
    while !q.isEmpty {
        let (firstNode, dist) = q.removeFirst()
        if !visited.insert(firstNode).inserted {
            continue
        }
        
        if (flowRate[firstNode] != 0 || firstNode == nodeToIdx["AA"]) && firstNode != node {
            adjacentValves[node]!.append((firstNode, dist))
        }

        for (n, d) in neighbours[firstNode] {
            q.append((n, d + dist))
        }
    }
}

print(part1(lines: lines))
print(part2(lines: lines))
