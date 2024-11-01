import Foundation

struct Blueprint {
    let id: Int
    let costs: [[Int:Int]] // [ore, clay, obsidian, geode]
}

struct State : Hashable {
    var minute: Int
    var bots: [Int]      // [ore, clay, obsidian, geode]
    var resources: [Int] // [ore, clay, obsidian, geode]
}

func calculateGeodes(blueprints: [Blueprint], minutes: Int) -> [Int] {
    blueprints.map({blueprint in 
        var maxGeodes = 0
        let spendRates = [ // [ore, clay, obsidian, geode]
            blueprint.costs.reduce(0, {res, cost in max(res, cost[0]!)}), 
            blueprint.costs[2][1]!, 
            blueprint.costs[3][2]!, 
            Int.max
        ]

        var states = [State]()
        var seen = Set<State>()
        
        states.append(State(minute: 0, bots: [1,0,0,0], resources: [0,0,0,0]))

        while !states.isEmpty {
            let state = states.removeLast()

            maxGeodes = max(maxGeodes, (minutes - state.minute) * state.bots[3] + state.resources[3])
            if(state.minute == minutes) {
                continue
            }

            for (botIdx, botCost) in blueprint.costs.enumerated() {
                // Figure out how much time it takes to construct a specific bot
                var waitTime = -1
                for (resource, count) in botCost {
                    if state.bots[resource] == 0 {
                        waitTime = -1
                        break
                    }

                    waitTime = max(waitTime, max(0, Int(ceil(Double(count - state.resources[resource]) / Double(state.bots[resource])))))
                }

                if waitTime == -1 || state.minute + waitTime + 1 > minutes {
                    continue
                }

                // Fast-forward
                var newState = state
                newState.minute += waitTime + 1
                for idx in newState.resources.indices {
                    newState.resources[idx] += (waitTime + 1) * newState.bots[idx]
                }

                // Purchase the bot
                newState.bots[botIdx] += 1
                for (resource, count) in botCost {
                    newState.resources[resource] -= count
                }

                if newState.bots[botIdx] > spendRates[botIdx] {
                    continue
                }

                // Visit the new state
                if seen.insert(newState).inserted {
                    states.append(newState)
                }
            }
        }

        return maxGeodes
    })
}

func part1(blueprints: [Blueprint]) -> Int {
    calculateGeodes(blueprints: blueprints, minutes: 24)
        .enumerated()
        .reduce(0, {(r, e) in r + (e.offset + 1) * e.element})
}

func part2(blueprints: [Blueprint]) -> Int {
    calculateGeodes(blueprints: Array(blueprints.prefix(3)), minutes: 32)
        .reduce(1, {r, g in r * g})
}

var blueprints = [Blueprint]()
while let line = readLine() {
    let match = line.matches(of: try Regex("\\d+"))
    blueprints.append(Blueprint(
        id: Int(line[match[0].range]) ?? 0,
        costs: [
            [
                0: Int(line[match[1].range]) ?? 0
            ],
            [
                0: Int(line[match[2].range]) ?? 0
            ],
            [
                0: Int(line[match[3].range]) ?? 0,
                1: Int(line[match[4].range]) ?? 0
            ],
            [
                0: Int(line[match[5].range]) ?? 0,
                2: Int(line[match[6].range]) ?? 0
            ]
        ]
    ))
}

print(part1(blueprints: blueprints))
print(part2(blueprints: blueprints))
