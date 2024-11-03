struct Coord : Hashable {
    let r: Int
    let c: Int
}

func solve(_ map: [[Character]], _ part2: Bool) -> Int {
    var elves = Set<Coord>()
    for (r, row) in map.enumerated() {
        for (c, col) in row.enumerated() {
            if col == "#" {
                elves.insert(Coord(r: r, c: c))
            }
        }
    }

    // [NE, N, NW, W, SW, S, SE, E]
    let dirs = [(-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1), (1, 0), (1, 1), (0, 1)]
    let dirIndices = [1, 5, 3, 7]
    var firstMoveIdx = 0

    var round = 1
    while round <= 10 || part2 {
        var proposedMoves = [Coord : [Coord]]()
        for elf in elves {
            let isFieldEmpty = {(vR, vC) in !elves.contains(Coord(r: elf.r + vR, c: elf.c + vC))}
            
            let hasNoAdjacentElf = dirs.allSatisfy(isFieldEmpty)
            if hasNoAdjacentElf {
                proposedMoves[elf] = [elf]
                continue
            }

            for n in (0..<4) {
                let dirIdx = dirIndices[(firstMoveIdx + n) % 4]
                if [dirIdx - 1, dirIdx, (dirIdx + 1) % dirs.count].map({i in dirs[i]}).allSatisfy(isFieldEmpty) {
                    let (vR, vC) = dirs[dirIdx]
                    let move = Coord(r: elf.r + vR, c: elf.c + vC)

                    let elvesProposedTheSameMove = proposedMoves[move]
                    proposedMoves[move] = (elvesProposedTheSameMove == nil ? [] : elvesProposedTheSameMove!) + [elf]
                    break
                }
                
                if(n == 3) {
                    proposedMoves[elf] = [elf]
                }
            }
        }

        let newElves = Set(proposedMoves.flatMap({(dest, elves) in elves.count == 1 ? [dest] : elves}))
        if(newElves == elves) {
            return round
        }
        
        firstMoveIdx = (firstMoveIdx + 1) % dirIndices.count
        elves = newElves
        round += 1
    }

    let rowCoords = elves.map({c in c.r})
    let colCoords = elves.map({c in c.c})

    return (rowCoords.max()! - rowCoords.min()! + 1) * (colCoords.max()! - colCoords.min()! + 1) - elves.count
}

func part1(_ map: [[Character]]) -> Int {
    solve(map, false)
}

func part2(_ map: [[Character]]) -> Int {
    solve(map, true)
}

var map = [[Character]]()
while let line = readLine() {
    map.append(Array(line))
}

print(part1(map))
print(part2(map))
