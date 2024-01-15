func calculateScore(s1: UInt32, s2: UInt32) -> UInt32 {
    var score =  s2 + 1

    if s1 == s2 {
        score += 3
    } else if (s2 > s1 && (s1 != 0 || s2 != 2)) || (s2 == 0 && s1 == 2) {
        score += 6
    }

    return score
}

func part1(lines: [String]) -> UInt32 {
    lines.map { line in 
        let signs = line.split(separator: " ")

        let s1 = signs[0].unicodeScalars.first!.value - UnicodeScalar("A").value
        let s2 = signs[1].unicodeScalars.first!.value - UnicodeScalar("X").value

        return calculateScore(s1: s1, s2: s2)
    }.reduce(0, +)
}

func part2(lines: [String]) -> UInt32 {
    lines.map { line in 
        let signs = line.split(separator: " ")

        let s1 = signs[0].unicodeScalars.first!.value - UnicodeScalar("A").value
        var s2: UInt32 = 0

        switch signs[1] {
        case "X":
            s2 = s1 == 0 ? 2 : s1 - 1
        case "Y":
            s2 = s1
        case "Z":
            s2 = (s1 + 1) % 3
            
        default:    
            assert(false, "unreachable")
        }

        return calculateScore(s1: s1, s2: s2)
    }.reduce(0, +)
}

var lines: [String] = [String]()

while let line = readLine() {
    lines.append(line)
}

print(part1(lines: lines))
print(part2(lines: lines))
