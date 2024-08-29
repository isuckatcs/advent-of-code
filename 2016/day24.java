import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.*;

class day24 {
    private record DistancesState(int r, int c, int dist) {
        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            DistancesState distancesState = (DistancesState) o;
            return r == distancesState.r && c == distancesState.c;
        }

        @Override
        public int hashCode() {
            return Objects.hash(r, c);
        }
    }

    private static int[][] getDistanceBetweenLocations(String[] grid) {
        HashMap<Integer, int[]> numLocations = new HashMap<>();
        for (int r = 0; r < grid.length; r++) {
            for (int c = 0; c < grid[0].length(); c++) {
                char ch = grid[r].charAt(c);
                if (Character.isDigit(ch)) numLocations.put(ch - '0', new int[]{r, c});
            }
        }

        int[][] dists = new int[numLocations.size()][numLocations.size()];
        int[][] dirs = new int[][]{{1, 0}, {-1, 0}, {0, 1}, {0, -1}};

        for (int i = 0; i < numLocations.size(); i++) {
            ArrayDeque<DistancesState> q = new ArrayDeque<>();
            HashSet<DistancesState> visited = new HashSet<>();

            int[] startPos = numLocations.get(i);
            q.add(new DistancesState(startPos[0], startPos[1], 0));

            while (!q.isEmpty()) {
                var cur = q.remove();
                if (!visited.add(cur)) continue;

                char ch = grid[cur.r].charAt(cur.c);
                if (Character.isDigit(ch)) dists[i][ch - '0'] = cur.dist;

                for (int[] dir : dirs) {
                    int nr = cur.r + dir[0];
                    int nc = cur.c + dir[1];

                    if (nr < 0 || nc < 0 || nr >= grid.length || nc >= grid[0].length() || grid[nr].charAt(nc) == '#')
                        continue;

                    q.add(new DistancesState(nr, nc, cur.dist + 1));
                }
            }
        }

        return dists;
    }

    private record ShortestPathState(int node, int dist, HashSet<Integer> visited, boolean returning) {
    }

    private static int getShortestDist(int[][] dists, boolean shouldReturn) {
        PriorityQueue<ShortestPathState> q2 = new PriorityQueue<>(Comparator.comparingInt(o -> o.dist));
        q2.add(new ShortestPathState(0, 0, new HashSet<>(), false));

        while (!q2.isEmpty()) {
            ShortestPathState cur = q2.remove();
            if (!cur.visited.add(cur.node)) continue;

            boolean returning = cur.returning;
            if (cur.visited.size() == dists.length) {
                if (!shouldReturn || returning) return cur.dist;

                returning = true;
                cur.visited.remove(0);
            }

            for (int i = 0; i < dists.length; i++) {
                var tmp = (HashSet<Integer>) cur.visited.clone();
                q2.add(new ShortestPathState(i, cur.dist + dists[cur.node][i], tmp, returning));
            }
        }

        return -1;
    }

    private static int part1(String[] grid) {
        return getShortestDist(getDistanceBetweenLocations(grid), false);
    }

    private static int part2(String[] grid) {
        return getShortestDist(getDistanceBetweenLocations(grid), true);
    }

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String[] grid = reader.lines().toArray(String[]::new);

        System.out.println(part1(grid));
        System.out.println(part2(grid));
    }
}
