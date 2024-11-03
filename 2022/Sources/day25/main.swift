func addSNAFU(lhs: [Character], rhs: [Character]) -> [Character] {
    let digits: [Character] = ["=", "-", "0", "1", "2"]
    let values = [-2, -1, 0, 1, 2]

    var rLhs = Array(lhs.reversed())
    var rRhs = Array(rhs.reversed())

    if rLhs.count < rRhs.count {
        swap(&rLhs, &rRhs)
    }

    var idx = 0
    var carry = 0
    var sum = ""

    while idx < rLhs.count {
        let lIdx = digits.firstIndex(of: rLhs[idx])!
        let rVal = idx >= rRhs.count ? 0 : values[digits.firstIndex(of: rRhs[idx])!]
        
        let nIdx = lIdx + rVal + carry
        carry = nIdx < 0 ? -1 : (nIdx >= digits.count ? 1 : 0)

        let mod = nIdx % digits.count
        let sIdx = mod < 0 ? digits.count + mod : mod
        sum.append(digits[sIdx])

        idx += 1
    }

    if carry == 1 {
        sum.append("1")
    }

    return sum.reversed()
}

func part1(_ numbers: [[Character]]) -> String {
    String(numbers.reduce(["0"], addSNAFU))
}

func part2() -> Int {
    0
}

var numbers = [[Character]]()
while let line = readLine() {
    numbers.append(Array(line))
}

print(part1(numbers))
print(part2())