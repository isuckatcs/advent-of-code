struct Position : Hashable {
    var x: Int
    var y: Int
}

func solve(movements: [String], ropeLength: Int) -> Int {
    var knots = Array(repeating: Position(x: 0, y: 0), count: ropeLength)
    var uniqueTailPositions = Set<Position>()

    let dirs = ["R": (1, 0), "L": (-1, 0), "D": (0, -1), "U": (0, 1)]
    
    for movement in movements {
        let split = movement.split(separator: " ")

        let (dx, dy) = dirs[String(split[0])]!
        let cnt = Int(split[1])!

        for _ in 0..<cnt {
            var newKnots = [Position(x: knots[0].x + dx, y: knots[0].y + dy)]

            for i in 1..<knots.count {
                let newParentPos = newKnots[i - 1]
                let currentPos = knots[i]
                var newPos = currentPos

                if abs(newParentPos.x - currentPos.x) >= 2 || abs(newParentPos.y - currentPos.y) >= 2 {
                    if newParentPos.x != currentPos.x {
                        newPos.x += newParentPos.x > knots[i].x ? 1 : -1
                    }

                    if newParentPos.y != currentPos.y {
                        newPos.y += newParentPos.y > knots[i].y ? 1 : -1
                    }
                }

                newKnots.append(newPos)
            }

            knots = newKnots
            uniqueTailPositions.insert(knots.last!)
        }
    }

    return uniqueTailPositions.count
}

func part1(lines: [String]) -> Int {
    solve(movements: lines, ropeLength: 2)
}

func part2(lines: [String]) -> Int {
    solve(movements: lines, ropeLength: 10)
}

var lines: [String] = [String]()

while let line = readLine() {
    lines.append(line)
}

print(part1(lines: lines))
print(part2(lines: lines))
