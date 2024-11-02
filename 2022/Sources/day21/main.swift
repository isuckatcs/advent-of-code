struct Op {
    let lhs:  String
    let op:   String?
    let rhs:  String?
}

func solve(name: String, monkeys: [String : Op], cache: inout [String : Int]) -> Int {
    if let value = cache[name] {
        return value
    }
    
    let op = monkeys[name]!
    var value = 0

    if op.op == nil {
        value = Int(op.lhs)!
    } else {
        let lhs = solve(name: op.lhs, monkeys: monkeys, cache: &cache)
        let rhs = solve(name: op.rhs!, monkeys: monkeys, cache: &cache)

        value = switch op.op! {
        case "+":
            lhs + rhs
        case "*":
            lhs * rhs
        case "/":
            lhs / rhs
        case "-":
            lhs - rhs
        default:
            fatalError("unexpected operation")
        }
    }

    cache[name] = value
    return value
}

func part1(_ monkeys: [String : Op]) -> Int {
    var cache = [String : Int]()
    return solve(name: "root", monkeys: monkeys, cache: &cache)
}

func solveBackwards(result: Int, name: String, monkeys: [String : Op]) -> Int {
    if name == "humn" {
        return result
    }
    
    let op = monkeys[name]!

    var lhsCache = [String : Int]()
    let lhsVal = solve(name: op.lhs, monkeys: monkeys, cache: &lhsCache)

    var rhsCache = [String : Int]()
    let rhsVal = solve(name: op.rhs!, monkeys: monkeys, cache: &rhsCache)

    let solveForLhs = lhsCache["humn"] != nil
    let X = switch op.op! {
        case "+":
            solveForLhs ? result - rhsVal : result - lhsVal
        case "*":
            solveForLhs ? result / rhsVal : result / lhsVal
        case "/":
            solveForLhs ? result * rhsVal : lhsVal / result
        case "-":
            solveForLhs ? result + rhsVal : lhsVal - result
        default:
            fatalError("unexpected operation")
        }

    return solveBackwards(result: X, name: solveForLhs ? op.lhs : op.rhs!, monkeys: monkeys)
}

func part2(_ monkeys: [String : Op]) -> Int {
    let root = monkeys["root"]!

    var cache = [String : Int]()
    let lhsVal = solve(name: root.lhs, monkeys: monkeys, cache: &cache)

    return solveBackwards(
        result: cache["humn"] == nil ? lhsVal : solve(name: root.rhs!, monkeys: monkeys, cache: &cache), 
        name: cache["humn"] == nil ? root.rhs! : root.lhs, 
        monkeys: monkeys
    )
}

var monkeys = [String : Op]()
while let line = readLine() {
    var split: [String?] = line.split(separator: try Regex(":? ")).map({ss in String(ss)});
    if split.count == 2 {
        split.append(contentsOf: [nil, nil])
    }
    monkeys[split[0]!] = Op(lhs: split[1]!, op: split[2], rhs: split[3])
}

print(part1(monkeys))
print(part2(monkeys))
