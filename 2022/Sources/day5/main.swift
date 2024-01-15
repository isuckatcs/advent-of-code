func part1(_ crates: [[Character]], _ instructions: [[Int]]) -> String {
    var newCrates = crates

    // inst: [repeat, from, to], indexed from 1
    for inst in instructions {
        for _ in 0..<inst[0] {
            newCrates[inst[2] - 1].append(newCrates[inst[1] - 1].popLast()!)
        }
    }

    return String(newCrates.compactMap { $0.last })
}

func part2(_ crates: [[Character]], _ instructions: [[Int]]) -> String {
    var newCrates = crates

    // inst: [repeat, from, to], indexed from 1
    for inst in instructions {
        var tmp = [Character]()

        for _ in 0..<inst[0] {
            tmp.append(newCrates[inst[1] - 1].popLast()!)
        }

        for _ in 0..<inst[0] {
            newCrates[inst[2] - 1].append(tmp.popLast()!)
        }
    }

    return String(newCrates.compactMap { $0.last })
}

var lines: [String] = [String]()

while let line = readLine() {
    lines.append(line)
}

let split = lines.split(separator: "")
let regex = try! Regex("[0-9]+")

let drawing = split[0].dropLast()
let instructions = split[1].map { l in 
    l.ranges(of: regex).map { Int(l[$0])! }
}

let numberLine = split[0].last!;
let columns = Int(numberLine[numberLine.ranges(of: regex).last!])!

var crates = [[Character]](repeating: [], count: columns)
for line in drawing.reversed() {
    for i in 0..<columns {
        let cur = line[line.index(line.startIndex, offsetBy: i * 4 + 1)]
        if !cur.isWhitespace {
            crates[i].append(cur)
        }
    }
}

print(part1(crates, instructions))
print(part2(crates, instructions))
