func part1(ranges: [(ClosedRange<Int>, ClosedRange<Int>)]) -> Int  {
    ranges.map { (r1, r2) in
        (r1.contains(r2) || r2.contains(r1)) ? 1 : 0
    }.reduce(0, +)
}

func part2(ranges: [(ClosedRange<Int>, ClosedRange<Int>)]) -> Int {
    ranges.map { (r1, r2) in
        r1.overlaps(r2) ? 1 : 0
    }.reduce(0, +)
}

var lines: [String] = [String]()

while let line = readLine() {
    lines.append(line)
}

let ranges = lines.map { line in
    let nums = line.ranges(of: try! Regex("[0-9]+")).map { Int(line[$0])! }

    return (nums[0]...nums[1], nums[2]...nums[3])
}

print(part1(ranges: ranges))
print(part2(ranges: ranges))
