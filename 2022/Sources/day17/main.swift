let rocks = [
    ["####"], 

    [".#.", 
     "###", 
     ".#."],
    
    ["..#",
     "..#",
     "###"],

    ["#",
     "#",
     "#",
     "#"],

    ["##",
     "##"]
]

func fillPattern(chamber: inout [[Character]], pattern: [String], bottomLeftXY: (Int, Int), fill: Character) {
    for (row, r) in pattern.reversed().enumerated() {
        for (col, ch) in r.enumerated() {
            if ch != "#" {
                continue
            }

            let ri = bottomLeftXY.1 + row
            let ci = bottomLeftXY.0 + col

            chamber[ri][ci] = fill
        }
    }
}

func isPatternBlocked(chamber: [[Character]], pattern: [String], bottomLeftXY: (Int, Int)) -> Bool {
    for (row, r) in pattern.reversed().enumerated() {
        for (col, ch) in r.enumerated() {
            if ch != "#" {
                continue
            }

            let ri = bottomLeftXY.1 + row
            let ci = bottomLeftXY.0 + col

            if chamber[ri][ci] == "#" {
                return true
            }
        }
    }

    return false
}

struct State : Hashable {
    var topRow: [Character]
    var rock: Int
}

func solve(pattern: [Character], nrOfRocks: Int) -> Int {
    var cycles: [State:(Int, Int)] = [:]
    var chamber: [[Character]] = []

    var height = 0
    var highestPoint = 0
    var curRock = 0
    var curSteam = 0

    var n = 0
    while n < nrOfRocks {
        let rock = rocks[curRock]
        var rockBottomLeftCorner = (2, highestPoint + 3)

        // Add 3 lines and pretend that the rock is added too, no need to fill it now.
        chamber.append(contentsOf: Array(repeating: Array(repeating: ".", count: 7), count: 3 + rock.count))

        while true {
            let shiftX = pattern[curSteam] == ">" ? 1 : -1
            let shiftedPos = (rockBottomLeftCorner.0 + shiftX, rockBottomLeftCorner.1);
            if shiftedPos.0 >= 0 && shiftedPos.0 + rock[0].count <= chamber[0].count
                && !isPatternBlocked(chamber: chamber, pattern: rock, bottomLeftXY: shiftedPos) {
                rockBottomLeftCorner = shiftedPos
            }

            curSteam = (curSteam + 1) % pattern.count
            if curSteam == 0 {
                let state = State(topRow: chamber[highestPoint - 1], rock: curRock)
                if let (prevHighest, prevN) = cycles[state] {
                    let cycleHeight = highestPoint - prevHighest
                    let cycleLength = n - prevN

                    let remainingRocks = nrOfRocks - n
                    let remainingCycles = remainingRocks / cycleLength

                    height += cycleHeight * remainingCycles
                    n = prevN + cycleLength * (remainingCycles + 1)
                }

                cycles[state] = (highestPoint, n)
            }
            
            let fallenPos = (rockBottomLeftCorner.0, rockBottomLeftCorner.1 - 1)
            if fallenPos.1 < 0 || isPatternBlocked(chamber: chamber, pattern: rock, bottomLeftXY: fallenPos) {
                break
            }

            rockBottomLeftCorner = fallenPos
        }
        
        fillPattern(chamber: &chamber, pattern: rock, bottomLeftXY: rockBottomLeftCorner, fill: "#")

        let newHighestPoint = (max(highestPoint, rockBottomLeftCorner.1 + rock.count))
        height += newHighestPoint - highestPoint
        highestPoint = newHighestPoint
        
        curRock = (curRock + 1) % rocks.count
        chamber.removeLast(chamber.count - highestPoint)
        n += 1
    }

    return height
}

func part1(pattern: [Character]) -> Int {
    solve(pattern: pattern, nrOfRocks: 2022)
}

func part2(pattern: [Character]) -> Int {
    solve(pattern: pattern, nrOfRocks: 1000000000000)
}

let pattern = Array(readLine()!)

print(part1(pattern: pattern))
print(part2(pattern: pattern))
