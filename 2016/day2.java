import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.stream.Collectors;

class day2 {
    private record Position(int row, int col) {
    }

    private static String getCode(char[][] keypad, ArrayList<String> instructions, Position start) {
        StringBuilder codeStream = new StringBuilder();
        Position pos = start;

        for (String line : instructions) {
            for (char c : line.toCharArray()) {
                Position newPos = switch (c) {
                    case 'U' -> new Position(pos.row - 1, pos.col);
                    case 'D' -> new Position(pos.row + 1, pos.col);
                    case 'L' -> new Position(pos.row, pos.col - 1);
                    case 'R' -> new Position(pos.row, pos.col + 1);
                    default -> throw new IllegalStateException("Unexpected value: " + c);
                };

                if (newPos.row < 0 || newPos.row >= keypad.length) continue;
                if (newPos.col < 0 || newPos.col >= keypad[0].length) continue;
                if (keypad[newPos.row][newPos.col] == ' ') continue;

                pos = newPos;
            }

            codeStream.append(keypad[pos.row][pos.col]);
        }

        return codeStream.toString();
    }

    private static String part1(ArrayList<String> lines) {
        char[][] keypad = {
                {'1', '2', '3'},
                {'4', '5', '6'},
                {'7', '8', '9'}
        };

        return getCode(keypad, lines, new Position(1, 1));
    }

    private static String part2(ArrayList<String> lines) {
        char[][] keypad = {
                {' ', ' ', '1', ' ', ' '},
                {' ', '2', '3', '4', ' '},
                {'5', '6', '7', '8', '9'},
                {' ', 'A', 'B', 'C', ' '},
                {' ', ' ', 'D', ' ', ' '},
        };

        return getCode(keypad, lines, new Position(2, 0));
    }

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        ArrayList<String> lines = reader.lines().collect(Collectors.toCollection(ArrayList::new));

        System.out.println(part1(lines));
        System.out.println(part2(lines));
    }
}
