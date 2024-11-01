func solve(numbers: [Int], decryptionKey: Int, mixTimes: Int) -> Int {
    let numbers = numbers.map({n in n * decryptionKey})
    var workingNumbers = numbers.enumerated().reduce([], {(arr, e) in arr + [[e.offset, e.element]]})

    for _ in 0 ..< mixTimes {
        for (i, n) in numbers.enumerated() {
            var ptr = workingNumbers.firstIndex(of: [i, n])!

            for _ in 0 ..< abs(n % (numbers.count - 1)) {
                let tmp = ptr + (n < 0 ? -1 : 1)
                let other = tmp < 0 ? workingNumbers.count - 1 : tmp % workingNumbers.count

                workingNumbers.swapAt(ptr, other)
                ptr = other
            }
        }
    }

    let idx = workingNumbers.firstIndex(of: [numbers.firstIndex(of: 0)!, 0])!
    return [1000, 2000, 3000].reduce(0, {(r, n) in r + workingNumbers[(idx + n) % workingNumbers.count][1]})
}

func part1(_ numbers: [Int]) -> Int {
    solve(numbers: numbers, decryptionKey: 1, mixTimes: 1)
}

func part2(_ numbers: [Int]) -> Int {
    solve(numbers: numbers, decryptionKey: 811589153, mixTimes: 10)
}

var numbers = [Int]()
while let line = readLine() {
    numbers.append(Int(line)!)
}

print(part1(numbers))
print(part2(numbers))
