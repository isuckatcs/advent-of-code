import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashSet;

class day1 {
    private record Pair<K, V>(K first, V second) {
    }

    private static int rotate(boolean left, int facing) {
        if (left) return facing == 0 ? 3 : facing - 1;
        else return (facing + 1) % 4;
    }

    private static ArrayList<Pair<Integer, Integer>> move(Pair<Integer, Integer> pos, int facing, int steps) {
        ArrayList<Pair<Integer, Integer>> moves = new ArrayList<>();

        for (int i = 0; i < steps; i++) {
            moves.add(switch (facing) {
                case 0 -> new Pair<>(pos.first + 1, pos.second);
                case 1 -> new Pair<>(pos.first, pos.second + 1);
                case 2 -> new Pair<>(pos.first - 1, pos.second);
                case 3 -> new Pair<>(pos.first, pos.second - 1);
                default -> throw new UnknownError();
            });

            pos = moves.getLast();
        }

        return moves;
    }

    private static int part1(String input) {
        // 0 - N; 1 - E; 2 - S; 3 - W
        int facing = 0;
        Pair<Integer, Integer> pos = new Pair<>(0, 0);

        for (String dir : input.split(", ")) {
            boolean left = dir.charAt(0) == 'L';
            int steps = Integer.parseInt(dir.substring(1));

            facing = rotate(left, facing);
            pos = move(pos, facing, steps).getLast();
        }

        return Math.abs(pos.first) + Math.abs(pos.second);
    }

    private static int part2(String input) {
        int facing = 0;
        Pair<Integer, Integer> pos = new Pair<>(0, 0);

        HashSet<Pair<Integer, Integer>> visited = new HashSet<>();
        visited.add(pos);

        for (String dir : input.split(", ")) {
            boolean left = dir.charAt(0) == 'L';
            int steps = Integer.parseInt(dir.substring(1));

            facing = rotate(left, facing);
            var visitedPositions = move(pos, facing, steps);

            for (var visitedPos : visitedPositions) {
                if (!visited.add(visitedPos)) return Math.abs(visitedPos.first) + Math.abs(visitedPos.second);
            }

            pos = visitedPositions.getLast();
        }

        throw new UnknownError();
    }

    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

        String line = reader.readLine();
        System.out.println(part1(line));
        System.out.println(part2(line));
    }
}
