class Monkey {
    var items: [Int]
    let op: (Int) -> Int
    let test: (Int, Int, Int)

    init(items: [Int], op: @escaping (Int) -> Int, test: (Int, Int, Int)) {
        self.items = items
        self.op = op
        self.test = test
    }
}

func extractNumbersFromStr(_ str: String) -> [Int] {
    let regex = try! Regex("[0-9]+")
    return str.ranges(of: regex).map { Int(str[$0])! }
}

func parseMonkey(data: [String]) -> Monkey {
    let items = extractNumbersFromStr(data[1])

    let operation = data[2].split(separator: "=")[1].trimmingPrefix { $0.isWhitespace }
    let opParts = operation.split(separator: " ")
    let op: (Int) -> Int = switch opParts[1] {
    case "+":
        { $0 + Int(opParts[2])! }
    case "*":
        opParts[2] == "old" ? { $0 * $0 } : { $0 * Int(opParts[2])! }
    default:
        { $0 }
    }

    let test = extractNumbersFromStr(data[3])[0]
    let pass = extractNumbersFromStr(data[4])[0]
    let fail = extractNumbersFromStr(data[5])[0]

    return Monkey(items: items, op: op, test: (test, pass, fail))
}

func simulateMonkeyBusines(monkeys: [Monkey], rounds: Int, worryLevelTransform: (Int) -> Int) -> [Int] {
    var monkeyBusiness = Array(repeating: 0, count: monkeys.count)

    for _ in 1...rounds {
        for (id, monkey) in monkeys.enumerated() {
            while !monkey.items.isEmpty {
                let worryLevel = monkey.items.removeFirst()
                let newWorryLevel = worryLevelTransform(monkey.op(worryLevel))
                let (c, t, f) = monkey.test

                monkeyBusiness[id] += 1

                monkeys[newWorryLevel % c == 0 ? t : f].items.append(newWorryLevel)
            }
        }
    }

    return monkeyBusiness
}

func part1(monkeys: [Monkey]) -> Int {
    return simulateMonkeyBusines(monkeys: monkeys, rounds: 20) { 
        $0 / 3 
    }.sorted().suffix(2).reduce(1, *)
}

func part2(monkeys: [Monkey]) -> Int {
    return simulateMonkeyBusines(monkeys: monkeys, rounds: 10000) { 
        $0 % monkeys.map { $0.test.0 }.reduce(1, *) 
    }.sorted().suffix(2).reduce(1, *)
}

var lines: [String] = [String]()

while let line = readLine() {
    lines.append(line)
}

let monkeyDatas = lines.split { $0.isEmpty }.map { Array($0) }

print(part1(monkeys: monkeyDatas.map { parseMonkey(data: $0) }))
print(part2(monkeys: monkeyDatas.map { parseMonkey(data: $0) }))
