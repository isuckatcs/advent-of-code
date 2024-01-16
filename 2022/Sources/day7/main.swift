protocol Node {
    var name: String { get }
    var parent: Directory? { get }

    func size() -> UInt64
}

class File : Node {
    let name: String
    let fileSize: UInt64
    let parent: Directory?

    init(name: String, size: UInt64, parent: Directory) {
        self.name = name
        self.fileSize = size
        self.parent = parent
    }

    func size() -> UInt64 { fileSize }
}

class Directory : Node {
    let name: String
    let parent: Directory?
    var files: [File] = []
    var subdirs: [Directory] = []

    init(name: String, parent: Directory?) {
        self.name = name
        self.parent = parent
    }

    func size() -> UInt64 { 
        subdirs.reduce(0, { $0 + $1.size() })
        + files.reduce(0, { $0 + $1.size() }) 
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
            break
        case "dir":
            curDir.subdirs.append(Directory(name: String(split[1]), parent: curDir))
        default:
            curDir.files.append(File(name: String(split[1]), size: UInt64(split[0])!, parent: curDir))
        }
    }

    return root
}

func part1(_ node: Node) -> UInt64 {
    var size: UInt64 = 0
    
    if let dir = node as? Directory {
        let dsize = dir.size()
        if(dsize < 100000) {
            size += dsize
        }

        for subdir in dir.subdirs {
            size += part1(subdir)
        }

    }

    return size
}

func part2(_ node: Node, _ limit: UInt64) -> UInt64 {
    var m: UInt64 = 70000000

    if let dir = node as? Directory {
        let dsize = dir.size()
        if(dsize >= limit) {
            m = min(dsize, m)
        }

        for subdir in dir.subdirs {
            m = min(m, part2(subdir, limit))
        }
    }

    return m
}

var lines: [String] = [String]()

while let line = readLine() {
    lines.append(line)
}

let root = parseFileSystem(lines)

print(part1(root))
print(part2(root, 30000000 - (70000000 - root.size())))
