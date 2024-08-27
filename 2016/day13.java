import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayDeque;
import java.util.HashSet;

class day13 {
    private static boolean isWall(int x, int y, int n) {
        return Integer.bitCount(x * x + 3 * x + 2 * x * y + y + y * y + n) % 2 == 1;
    }

    private record Visited(int x, int y) {
    }

    private record State(int x, int y, int steps) {
    }

    private static int simulate(int targetX, int targetY, int designerN, boolean part2) {
        ArrayDeque<State> q = new ArrayDeque<>();
        HashSet<Visited> visited = new HashSet<>();

        q.add(new State(1, 1, 0));
        while (!q.isEmpty()) {
            State cur = q.removeFirst();

            if (part2 && cur.steps > 50) continue;
            if (!visited.add(new Visited(cur.x, cur.y))) continue;
            if (!part2 && cur.x == targetX && cur.y == targetY) return cur.steps;

            for (int[] dir : new int[][]{{0, 1}, {0, -1}, {1, 0}, {-1, 0}}) {
                int dx = cur.x + dir[0];
                int dy = cur.y + dir[1];

                if (dx < 0 || dy < 0 || isWall(dx, dy, designerN)) continue;

                q.add(new State(dx, dy, cur.steps + 1));
            }
        }

        return visited.size();
    }

    private static int part1(int designerN) {
        return simulate(31, 39, designerN, false);
    }

    private static int part2(int designerN) {
        return simulate(0, 0, designerN, true);
    }

    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        int n = Integer.parseInt(reader.readLine());

        System.out.println(part1(n));
        System.out.println(part2(n));
    }
}
