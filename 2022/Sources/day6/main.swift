func eatUntilNDistinct(_ line: String, _ distinct: Int) -> Int {
    var window = line.prefix(distinct)

    var n = distinct;
    while true {

        if Set(window).count == distinct {
            return n;
        }

        let _ = window.popFirst()
        window.append(line[line.index(line.startIndex, offsetBy: n)])
        
        if(n >= line.count) {
            return -1
        }
        
        n += 1
    }
}

func part1(_ line: String) -> Int {
    eatUntilNDistinct(line, 4)
}

func part2(_ line: String) -> Int {
    eatUntilNDistinct(line, 14)
}

let line = readLine()!

print(part1(line))
print(part2(line))
