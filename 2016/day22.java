import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.*;

class day22 {
    private record Node(int x, int y, int size, int used, int free) {
    }

    private static int part1(ArrayList<Node> nodes) {
        int cnt = 0;
        for (Node n1 : nodes) {
            for (Node n2 : nodes) {
                if (n1 == n2 || n1.used == 0 || n1.used > n2.free) continue;

                ++cnt;
            }
        }
        return cnt;
    }

    private record State(int fr, int fc, int gr, int gc, int steps) {
        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            State state = (State) o;
            return fr == state.fr && fc == state.fc && gr == state.gr && gc == state.gc;
        }

        @Override
        public int hashCode() {
            return Objects.hash(fr, fc, gr, gc);
        }
    }

    private static int part2(ArrayList<Node> nodes) {
        Node free = nodes.stream().filter(n -> n.used == 0).toList().getFirst();

        char[][] grid = new char[nodes.getLast().y + 1][nodes.getLast().x + 1];
        for (Node n : nodes)
            grid[n.y][n.x] = n.used > free.size ? '#' : '.';

        int[][] dirs = new int[][]{{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        HashSet<State> visited = new HashSet<>();

        PriorityQueue<State> q = new PriorityQueue<>(Comparator.comparingInt(
                o -> o.gr + o.gc + Math.abs(o.fr - o.gr) + Math.abs(o.fc - o.gc)
        ));
        q.add(new State(free.y, free.x, 0, grid[0].length - 1, 0));

        while (!q.isEmpty()) {
            var cur = q.remove();

            if (!visited.add(cur)) continue;
            if (cur.gr == 0 && cur.gc == 0) return cur.steps;

            for (int[] dir : dirs) {
                int nr = cur.fr + dir[0];
                int nc = cur.fc + dir[1];

                if (nr < 0 || nc < 0 || nr >= grid.length || nc >= grid[0].length || grid[nr][nc] == '#') continue;

                boolean swapWithGoal = nr == cur.gr && nc == cur.gc;
                int ngr = swapWithGoal ? cur.fr : cur.gr;
                int ngc = swapWithGoal ? cur.fc : cur.gc;

                q.add(new State(nr, nc, ngr, ngc, cur.steps + 1));
            }
        }

        return -1;
    }

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String[] lines = reader.lines().skip(2).toArray(String[]::new);

        ArrayList<Node> nodes = new ArrayList<>(lines.length);
        for (String line : lines) {
            String[] split = line.split("T? +");
            int s = Integer.parseInt(split[1]);
            int u = Integer.parseInt(split[2]);
            int f = Integer.parseInt(split[3]);

            String[] coords = split[0].split("-[xy]");
            int x = Integer.parseInt(coords[1]);
            int y = Integer.parseInt(coords[2]);

            nodes.add(new Node(x, y, s, u, f));
        }

        System.out.println(part1(nodes));
        System.out.println(part2(nodes));
    }
}
