func solve(_ map: [[Character]], _ instructions: String, _ transition: ((Int, Int), (Int, Int)) -> ((Int, Int), (Int, Int))) -> Int {
    let steps = instructions.split(separator: try! Regex("[A-Z]"))
    let rotations = instructions.split(separator: try! Regex("\\d+"))

    var pos = (0, map[0].firstIndex(of: ".")!)
    var dir = (0, 1) // (row, col)

    var idx = 0
    while idx < steps.count {
        let s = Int(steps[idx])!
        let r = idx < rotations.count ? rotations[idx] : nil

        for _ in 0..<s {
            (pos, dir) = transition(pos, dir)
        }

        if r == "R" {
            dir = (dir.1, -dir.0)
        } else if r != nil {
            dir = (-dir.1, dir.0)
        }

        idx += 1
    }

    let dirs = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    let rotVal = dirs.firstIndex(where: {e in e == dir})!
    return 1000 * (pos.0 + 1) + 4 * (pos.1 + 1) + rotVal
}

func part1(_ map: [[Character]], _ instructions: String) -> Int {
    solve(map, instructions, {(pos, dir) in 
        var (nr, nc) = (pos.0 + dir.0, pos.1 + dir.1)

        if nr >= map.count || nr < 0 || (dir.0 != 0 && map[nr][nc] == " ") {
            let closure: ([Character]) -> Bool = {arr in arr[nc] != " "}
            nr = dir.0 < 0 ? map.lastIndex(where: closure)! : map.firstIndex(where: closure)!
        }       

        if nc >= map[nr].count || nc < 0 || (dir.1 != 0 && map[nr][nc] == " ") {
            let closure: (Character) -> Bool = {c in c != " "}
            nc = dir.1 < 0 ? map[nr].lastIndex(where: closure)! : map[nr].firstIndex(where: closure)!
        }    

        return (map[nr][nc] == "#" ? pos : (nr, nc), dir)
    })
}

func part2(_ map: [[Character]], _ instructions: String) -> Int {
    // Hand-tailored for given input...
    //          +------+.     +------+.
    //  01      |`.   0  `.   |      | `.
    //  2       |  `+------+  |  5   |   +
    // 34  -->  | 3 |      |  |      | 1 |
    // 5        +   |   2  |  +------+.  |
    //           `. |      |   `.  4   `.|
    //             `+------+     `+------+
    let faces = [(0, 50), (0, 100), (50, 50), (100, 0), (100, 50), (150, 0)]

    // (vRow, vCol)
    let dirVectors = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    let dirStrings = ["R", "D", "L", "U"]

    // [tile : [leavingDir : (arriveAtTile, facingDir)]]
    let transitions: [Int : [String : (Int, String)]] = [
        0 : ["R" : (1, "R"), "D" : (2, "D"), "L" : (3, "R"), "U" : (5, "R")],
        1 : ["R" : (4, "L"), "D" : (2, "L"), "L" : (0, "L"), "U" : (5, "U")],
        2 : ["R" : (1, "U"), "D" : (4, "D"), "L" : (3, "D"), "U" : (0, "U")],
        3 : ["R" : (4, "R"), "D" : (5, "D"), "L" : (0, "R"), "U" : (2, "R")],
        4 : ["R" : (1, "L"), "D" : (5, "L"), "L" : (3, "L"), "U" : (2, "U")],
        5 : ["R" : (4, "U"), "D" : (1, "D"), "L" : (0, "D"), "U" : (3, "U")]
    ]

    return solve(map, instructions, {(pos, dir) in 
        let currentFace = Int(faces.firstIndex(where: {topLeft in 
            topLeft.0 <= pos.0 && pos.0 < topLeft.0 + 50 && 
            topLeft.1 <= pos.1 && pos.1 < topLeft.1 + 50}
        )!)

        let dirStr = if dir.0 != 0 {
            dir.0 < 0 ? "U" : "D"
        } else {
            dir.1 < 0 ? "L" : "R"
        }

        let (targetFace, targetDirStr) = transitions[currentFace]![dirStr]!
        let (targetFaceTop, targetFaceLeft) = faces[targetFace]

        var (nr, nc) = (pos.0 + dir.0, pos.1 + dir.1)
        let rowOff = nr >= map.count || nr < 0 || (dir.0 != 0 && map[nr][nc] == " ")
        let colOff = !rowOff && nc >= map[nr].count || nc < 0 || (dir.1 != 0 && map[nr][nc] == " ")

        if(!rowOff && !colOff) {
            return (map[nr][nc] == "#" ? pos : (nr, nc), dir)
        }

        switch targetDirStr {
        case "U": if rowOff {
            nr = targetFaceTop + 49
            nc = targetFaceLeft + pos.1 - faces[currentFace].1
        } else {
            nr = targetFaceTop + 49
            nc = targetFaceLeft + pos.0 - faces[currentFace].0
        }
        case "D": if rowOff {
            nr = targetFaceTop
            nc = targetFaceLeft + pos.1 - faces[currentFace].1
        } else {
            nr = targetFaceTop
            nc = targetFaceLeft + pos.0 - faces[currentFace].0
        }
        case "L": if rowOff {
            nr = targetFaceTop + pos.1 - faces[currentFace].1
            nc = targetFaceLeft + 49
        } else {
            nr = targetFaceTop + (dirStr == "L" ? pos.0 - faces[currentFace].0 : 49 - (pos.0 - faces[currentFace].0))
            nc = targetFaceLeft + 49
        }
        case "R": if rowOff {
            nr = targetFaceTop + pos.1 - faces[currentFace].1
            nc = targetFaceLeft
        } else {
            nr = targetFaceTop + (dirStr == "R" ? pos.0 - faces[currentFace].0 : 49 - (pos.0 - faces[currentFace].0))
            nc = targetFaceLeft
        }
        default:
            fatalError()
        }

        return map[nr][nc] == "#" ? (pos, dir) : ((nr, nc), dirVectors[dirStrings.firstIndex(of: targetDirStr)!])
    })
}

var map = [[Character]]()
while let line = readLine() {
    if line.isEmpty {
        break
    }

    map.append(Array(line))
}
let instructions = readLine()!

let width = map.max(by: {(lhs, rhs) in rhs.count > lhs.count})!.count
let paddedMap = map.map({str in str.count < width ? str + String(repeating: " ", count: width - str.count) : str})

print(part1(paddedMap, instructions))
print(part2(paddedMap, instructions))
