func part1(cycles: [Int]) -> Int {
    stride(from: 20, through: 220, by: 40).map { $0 * cycles[$0 - 1] }.reduce(0, +)
}

func part2(cycles: [Int]) {
    for r in 0...5 {
        for c in 0...39 {
            let m = cycles[r * 40 + c]
            
            print(m - 1 <= c && c <= m + 1 ? "#" : ".", terminator: "")
        }
        print()
    }
}

var lines: [String] = [String]()

while let line = readLine() {
    lines.append(line)
}

var sim: [Int] = [1]

for line in lines {
    let split = line.split(separator: " ")
    
    sim.append(sim.last!)

    if split[0] == "addx" {
        sim.append(sim.last! + Int(split[1])!)
    }
}

print(part1(cycles: sim))
part2(cycles: sim)
