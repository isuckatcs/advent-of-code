struct State : Hashable {
    let time: Int
    let pR: Int
    let pC: Int
    let forward: Bool
    let lastTrip: Bool
}

struct Blizzard {
    let pR: Int
    let pC: Int
    let dR: Int
    let dC: Int
}

func solve(_ map: [[Character]], roundTrip: Bool) -> Int {
    var blizzards = [Blizzard]()
    
    for (r, row) in map.enumerated() {
        for (c, col) in row.enumerated() {
            if col == "." || col == "#" {
                continue
            }

            let dir = switch col {
            case "v":
                (1, 0)
            case ">":
                (0, 1)
            case "<":
                (0, -1)
            case "^":
                (-1, 0)
            default:
                fatalError()
            }

            blizzards.append(Blizzard(pR: r, pC: c, dR: dir.0, dC: dir.1))
        }
    }
    
    let getBlizzardPosition: (Int, Blizzard) -> (Int, Int) = { (time, blizzard) in
        var nr = ((blizzard.pR - 1) + time * blizzard.dR) % (map.count - 2)
        var nc = ((blizzard.pC - 1) + time * blizzard.dC) % (map[0].count - 2)

        if nr < 0 {
            nr = (map.count - 2) + nr
        }

        if nc < 0 {
            nc = (map[0].count - 2) + nc
        }

        return (nr + 1, nc + 1)
    }

    var visited = Set<State>()
    var states = [State]()
    states.append(State(time: 0, pR: 0, pC: 1, forward: true, lastTrip: false))

    while !states.isEmpty {
        var cur = states.removeFirst()

        if visited.contains(cur) {
            continue
        }
        visited.insert(cur)

        if cur.pR == 0 && cur.forward == false {
            cur = State(time: cur.time, pR: cur.pR, pC: cur.pC, forward: true, lastTrip: true)
        }

        if cur.pR == map.count - 1 {
            cur = State(time: cur.time, pR: cur.pR, pC: cur.pC, forward: false, lastTrip: cur.lastTrip)

            if cur.lastTrip || !roundTrip {
                return cur.time
            }
        }

        for (vR, vC) in [(0,0), (1, 0), (0, 1), (-1, 0), (0, -1)] {
            let newPos = (cur.pR + vR, cur.pC + vC)

            if newPos.0 < 0 || 
              newPos.0 >= map.count || 
              map[newPos.0][newPos.1] == "#" ||
              blizzards.contains(where: {b in getBlizzardPosition(cur.time + 1, b) == newPos}) {
                continue
            }

            states.append(State(time: cur.time + 1, pR: newPos.0, pC: newPos.1, forward: cur.forward, lastTrip: cur.lastTrip))
        }
    }

    return 0
}

func part1(_ map: [[Character]]) -> Int {
    solve(map, roundTrip: false)
}

func part2(_ map: [[Character]]) -> Int {
    solve(map, roundTrip: true)
}

var map = [[Character]]()
while let line = readLine() {
    map.append(Array(line))
}

print(part1(map))
print(part2(map))
