func simulate(grid: inout [[String]], start: [Int]) -> Bool {
    var coords = (start[0], start[1])
    
    if(grid[coords.1][coords.0] != ".") {
        return false
    }

    while true {
        var placed = false
        for vc in [(0, 1), (-1, 1), (1, 1)] {
            let nx = coords.0 + vc.0
            let ny = coords.1 + vc.1

            if ny >= grid.count || nx < 0 || nx >= grid[ny].count {
                return false
            }

            if grid[ny][nx] == "." {
                placed = true
                coords = (nx, ny)
                break
            }
        }

        if !placed {
            grid[coords.1][coords.0] = "o"
            return true
        }
    }
}

func solve(lines: [String], floor: Bool) -> Int {
    let rocks = lines.map { 
        $0.split(separator: " -> ").map { 
            $0.split(separator: ",").map { Int($0)! } 
        } 
    }
    
    let xVals = rocks.flatMap { $0.map { $0[0] } }
    let xBoundary = (xVals.min()!, xVals.max()!)

    let yMax = rocks.flatMap { $0.map { $0[1] } }.max()!

    let xExtent = yMax + 2
    let row = Array(repeating: ".", count: xBoundary.1 - xBoundary.0 + 1 + 2 * xExtent)
    var map = Array(repeating: row, count: yMax + 1)

    if floor {
        map.append(contentsOf: [row, row.map { _ in "#" }])
    }

    for points in rocks {
        for i in 0..<points.count - 1 {
            var p1 = points[i]
            var p2 = points[i + 1]
            let ci = p1[1] != p2[1] ? 1 : 0

            if p1[ci] > p2[ci] {
                swap(&p1, &p2)
            }

            for n in p1[ci]...p2[ci] {
                let x = ci == 1 ? p1[0] : n
                let y = ci == 1 ? n : p1[1]
                map[y][x - xBoundary.0 + xExtent] = "#"
            }
        }
    }

    return (0...).first(where: ) { _ in 
        !simulate(grid: &map, start: [500 - xBoundary.0 + xExtent, 0]) 
    }!
}

func part1(lines: [String]) -> Int {
    solve(lines: lines, floor: false)
}

func part2(lines: [String]) -> Int {
    solve(lines: lines, floor: true)
}

var lines: [String] = [String]()

while let line = readLine() {
    lines.append(line)
}

print(part1(lines: lines))
print(part2(lines: lines))
