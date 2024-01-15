func calculateScore(c: Character) -> Int {
    switch c {
    case "a"..."z": 
        return Int(c.unicodeScalars.first!.value - UnicodeScalar("a").value + 1)
    case "A"..."Z":
        return Int(c.unicodeScalars.first!.value - UnicodeScalar("A").value + 27)
    default:
        assertionFailure()
        return 0
    }
}

func part1(lines: [String]) -> Int {
    lines.map { line in 
        let s1 = Set(line.prefix(line.count / 2))
        let s2 = Set(line.suffix(line.count / 2))

        let intersection = s1.intersection(s2)
        assert(intersection.count == 1)

        return calculateScore(c: intersection.first!)
    }.reduce(0, +)
}

func part2(lines: [String]) -> Int {
    stride(from: 0, to: lines.count, by: 3).map { i in
        let s1 = Set(lines[i])
        let s2 = Set(lines[i+1])
        let s3 = Set(lines[i+2])

        let intersection = s1.intersection(s2).intersection(s3)
        assert(intersection.count == 1)

        return calculateScore(c: intersection.first!)
    }.reduce(0,+)
}

var lines: [String] = [String]()

while let line = readLine() {
    lines.append(line)
}

print(part1(lines: lines))
print(part2(lines: lines))
