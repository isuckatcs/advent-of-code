let dirs = [(1, 0, 0), (-1, 0, 0), (0, 1, 0), (0, -1, 0), (0, 0, 1), (0, 0, -1)]

func inBounds(grid: [[[Int]]], coord: (Int, Int, Int)) -> Bool {
    coord.0 >= 0 && coord.0 < grid.count && 
    coord.1 >= 0 && coord.1 < grid[0].count && 
    coord.2 >= 0 && coord.2 < grid[0][0].count
}

func calculateSurfaceArea(_ grid: [[[Int]]]) -> Int {
    let (mx, my, mz) = (grid.count, grid[0].count, grid[0][0].count)
    var area = 0

    for x in 0..<mx {
        for y in 0..<my {
            for z in 0..<mz {
                if grid[x][y][z] == 0 {
                    continue
                }
                
                for (dx, dy, dz) in dirs {
                    let (nx, ny, nz) = (x + dx, y + dy, z + dz)

                    if inBounds(grid: grid, coord: (nx, ny, nz)) && grid[nx][ny][nz] == 1 {
                        continue
                    }

                    area += 1
                }
            }
        }
    }

    return area
}

func part1(grid: [[[Int]]]) -> Int {
    calculateSurfaceArea(grid)
}

func part2(grid: [[[Int]]]) -> Int {
    var excavatedDroplet = grid.map { $0.map { $0.map { _ in 1 } } }
    var q = [(0, 0, 0)]

    while !q.isEmpty {
        let (x, y, z) = q.removeFirst()

        if excavatedDroplet[x][y][z] != 1 {
            continue
        }

        excavatedDroplet[x][y][z] = 0

        for (dx, dy, dz) in dirs {
            let (nx, ny, nz) = (x + dx, y + dy, z + dz)

            if inBounds(grid: grid, coord: (nx, ny, nz)) && grid[nx][ny][nz] == 0 {
                q.append((nx, ny, nz))
            }
        }
    }

    return calculateSurfaceArea(excavatedDroplet)
}

var lines: [String] = [String]()
while let line = readLine() {
    lines.append(line)
}

let intCoords = lines.map { str in str.split(separator: ",").map { Int($0)! } }

let maxX = intCoords.map { $0[0] }.max()! + 1
let maxY = intCoords.map { $0[1] }.max()! + 1
let maxZ = intCoords.map { $0[2] }.max()! + 1

var grid = Array(repeating: Array(repeating: Array(repeating: 0, count: maxZ), count: maxY), count: maxX)

intCoords.forEach { 
    grid[$0[0]][$0[1]][$0[2]] = 1
}

print(part1(grid: grid))
print(part2(grid: grid))
