class Directory {
    let name: String
    let parent: Directory?

    var fileSize: UInt64 = 0
    var subdirs: [Directory] = []

    init(name: String, parent: Directory?) {
        self.name = name
        self.parent = parent
    }

    func size() -> UInt64 { 
        subdirs.reduce(0, { $0 + $1.size() }) + fileSize 
    }
}

func parseFileSystem(_ commands: [String]) -> Directory {
    let root = Directory(name: "/", parent: nil)
    
    var curDir = root
    for command in commands {
        let split = command.split(separator: " ")

        switch split[0] {
        case "$":
            if split[1] == "cd" {
                if split[2] == ".." {
                    curDir = curDir.parent!
                } else {
                    curDir = curDir.subdirs.first { $0.name == split[2] } ?? curDir
                }
            }
        case "dir":
            curDir.subdirs.append(Directory(name: String(split[1]), parent: curDir))
        default:
            curDir.fileSize += UInt64(split[0])!
        }
    }

    return root
}

func part1(_ dir: Directory) -> UInt64 {
    var size: UInt64 = dir.size() < 100000 ? dir.size() : 0
    
    for subdir in dir.subdirs {
        size += part1(subdir)
    }

    return size
}

func part2(_ dir: Directory, _ limit: UInt64) -> UInt64 {
    var size: UInt64 = dir.size() > limit ? dir.size() : 70000000

    for subdir in dir.subdirs {
        size = min(size, part2(subdir, limit))
    }

    return size
}

var lines: [String] = [String]()

while let line = readLine() {
    lines.append(line)
}

let root = parseFileSystem(lines)

print(part1(root))
print(part2(root, 30000000 - (70000000 - root.size())))
