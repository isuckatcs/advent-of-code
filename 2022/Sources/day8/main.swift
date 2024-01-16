let dirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]

func walk(grid: [[Int]], elem: (Int, Int), dir: (Int, Int)) -> (Bool, Int) {
    var (r, c) = elem
    let (vr, vc) = dir

    var steps = 0
    while true {
        r = r + vr
        c = c + vc

        if r < 0 || r >= grid.count || c < 0 || c >= grid.count {
            return (true, steps)
        }

        steps += 1

        if grid[r][c] >= grid[elem.0][elem.1] {
            return (false, steps)
        }
    }
}

func part1(_ grid: [[Int]]) -> Int {
    var visible = 0

    for (r, row) in grid.enumerated() {
        for (c, _) in row.enumerated() {
            visible += dirs.contains { walk(grid: grid, elem: (r, c), dir: $0).0 } ? 1 : 0
        }
    }

    return visible
}

func part2(_ grid: [[Int]]) -> Int {
    var highest = 0
    
    for (r, row) in grid.enumerated() {
        for (c, _) in row.enumerated() {
            highest = max(highest, dirs.map { walk(grid: grid, elem: (r, c), dir: $0).1 }.reduce(1, *))
        }
    }

    return highest
}

var grid: [[Int]] = []

while let line = readLine() {
    grid.append(line.map { $0.wholeNumberValue! })
}

print(part1(grid))
print(part2(grid))
