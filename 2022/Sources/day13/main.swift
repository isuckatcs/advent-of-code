protocol Node {
    func isBefore(other: Node) -> Bool?
}

class List: Node {
    var children: [Node] = []

    init(children: [Node]) {
        self.children = children
    }

    func isBefore(other: Node) -> Bool? {
        if let otherList = other as? List {
            for (idx, child) in children.enumerated() {
                if idx >= otherList.children.count {
                    return false
                }
                
                if let res = child.isBefore(other: otherList.children[idx]) {
                    return res
                }
            }

            return children.count == otherList.children.count ? nil : true
        }

        return isBefore(other: List(children: [other as! Value]))
    }
}

class Value: Node {
    var value: Int = 0

    init(value: Int) {
        self.value = value
    }

    func isBefore(other: Node) -> Bool? {
        if let otherVal = other as? Value {
            return value == otherVal.value ? nil : value < otherVal.value
        }

        return List(children: [self]).isBefore(other: other)
    }
}

func parse(str: [Character]) -> Node? {
    var idx = 0
    return parsePrimary(str: str, idx: &idx)
}

// list|value
func parsePrimary(str: [Character], idx: inout Int) -> Node? {
    if str[idx] == "[" {
        return parseList(str: str, idx: &idx)
    }

    return parseValue(str: str, idx: &idx)
}   

// [0-9]+
func parseValue(str: [Character], idx: inout Int) -> Node? {
    let val = String(str.dropFirst(idx).prefix { $0.isWholeNumber })
    idx += val.count

    return val.isEmpty ? nil : Value(value: Int(val)!)
}

// '['(primary(,primary)*)?']'
func parseList(str: [Character], idx: inout Int) -> Node? {
    idx += 1 // eat '['

    var children: [Node] = []
    if let p = parsePrimary(str: str, idx: &idx) {
        children.append(p)

        while str[idx] == "," {
            idx += 1 // eat ','

            if let np = parsePrimary(str: str, idx: &idx) {
                children.append(np)
            } else {
                return nil
            }
        }
    }

    idx += 1 // eat ']'

    return List(children: children)
}

func part1(lines: [String]) -> Int {
    lines.split { $0.isEmpty }.enumerated().filter { (_, pair) in
        let p1 = parse(str: pair.first!.dropLast(0))!
        let p2 = parse(str: pair.last!.dropLast(0))!
        return p1.isBefore(other: p2)!
    }.reduce(0) { (acc, p) in acc + p.0 + 1}
}

func part2(lines: [String]) -> Int {
    let placeholders = ["[[2]]", "[[6]]"]
    let tmp = lines + placeholders

    let sorted = tmp.filter { !$0.isEmpty }
        .map { ($0, parse(str: $0.dropLast(0))!) }
        .sorted { $0.1.isBefore(other: $1.1)! }

    return sorted.enumerated().filter { placeholders.contains($0.1.0) }
        .reduce(1) { $0 * ($1.0 + 1) }
}

var lines: [String] = [String]()

while let line = readLine() {
    lines.append(line)
}

print(part1(lines: lines))
print(part2(lines: lines))
