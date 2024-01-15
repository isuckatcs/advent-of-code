func part1(calories: [Int]) -> Int {
    calories.max()!
}

func part2(calories: [Int]) -> Int {
    calories.sorted().suffix(3).reduce(0, +)
}

var lines: [String] = [String]()

while let line = readLine() {
    lines.append(line)
}

let calories = lines.split(separator: "").map { 
    group in group.map { line in Int(line)! }.reduce(0, +) 
}

print(part1(calories: calories))
print(part2(calories: calories))
