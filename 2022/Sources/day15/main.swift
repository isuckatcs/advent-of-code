func coveredXRanges(beacons: [(Int, Int, Int)], y: Int) -> [(Int, Int)] {
    var coveredXRanges: [(Int, Int)] = []

    for beacon in beacons {
        let yDist = abs(beacon.1 - y)
        let xDiff = beacon.2 - yDist

        if xDiff >= 0 {
            var beaconCovered = (beacon.0 - xDiff, beacon.0 + xDiff)

            var tmpRanges: [(Int, Int)] = []
            for range in coveredXRanges {
                let b = max(range.0, beaconCovered.0)
                let e = min(range.1, beaconCovered.1)

                if b <= e {
                    beaconCovered.0 = min(range.0, beaconCovered.0)
                    beaconCovered.1 = max(range.1, beaconCovered.1)
                } else {
                    tmpRanges.append(range)
                }
            }

            tmpRanges.append(beaconCovered)
            coveredXRanges = tmpRanges
        }
    }

    return coveredXRanges
}

func part1(beacons: [(Int, Int, Int)]) -> Int {
    return coveredXRanges(beacons: beacons, y: 2000000).map { $0.1 - $0.0 }.reduce(0, +)
}

func part2(beacons: [(Int, Int, Int)]) -> Int {
    for y in 0...4000000 {
        let ranges = coveredXRanges(beacons: beacons, y: y)

        if ranges.count > 1 {
            let x = ranges.sorted { $0.0 < $1.0 }[0].1 + 1
            return x * 4000000 + y
        }
    }

    return 0
}

var lines: [String] = [String]()

while let line = readLine() {
    lines.append(line)
}

var beacons: [(Int, Int, Int)] = lines.map { 
    str in str.ranges(of: try! Regex("(-?[0-9]+)")).map { Int(str[$0])! } 
}.map {
    ($0[0], $0[1], abs($0[0] - $0[2]) + abs($0[1] - $0[3]))
}

print(part1(beacons: beacons))
print(part2(beacons: beacons))
