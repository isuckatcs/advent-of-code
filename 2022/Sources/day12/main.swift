func part1(grid: [[Int]], start: (Int, Int), end: (Int, Int)) -> Int {
    var q = [(start, 0)]
    var visited = Set<[Int]>()

    while !q.isEmpty {
        let ((r, c), s) = q.removeFirst()

        if (r, c) == end {
            return s
        }

        if !visited.insert([r, c]).inserted {
            continue
        }

        for (vr, vc) in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
            let nr = r + vr
            let nc = c + vc

            if nr < 0 || nr >= grid.count || nc < 0 || nc >= grid[r].count {
                continue
            }

            if grid[nr][nc] - grid[r][c] <= 1 {
                q.append(((nr, nc), s + 1))
            }
        }
    }
    
    return Int.max
}

func part2(grid: [[Int]], start: (Int, Int), end: (Int, Int)) -> Int {
    var minimum = Int.max

    for (ri, r) in grid.enumerated() {
        for (ci, _) in r.enumerated() {
            if grid[ri][ci] == 0 {
                minimum = min(minimum, part1(grid: grid, start: (ri, ci), end: end))
            }
        }
    }

    return minimum
}

var grid: [[Int]] = []
var start: (Int, Int) = (-1, -1)
var end: (Int, Int) = (-1, -1)

var l = 0
while let line = readLine() {
    grid.append(line.enumerated().map { (idx, c) in 
        var cur = c

        if cur == "S" {
            start = (l, idx)
            cur = "a"
        } else if cur == "E" {
            end = (l, idx)
            cur = "z"
        }

        return Int(cur.unicodeScalars.first!.value - UnicodeScalar("a").value)
    })

    l += 1
}

print(part1(grid: grid, start: start, end: end))
print(part2(grid: grid, start: start, end: end))
