import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.stream.IntStream;

class day8 {
    private static void rotateRow(boolean[][] screen, int r, int n) {
        boolean[] tmp = new boolean[screen[r].length];

        for (int i = 0; i < tmp.length; i++)
            tmp[(i + n) % tmp.length] = screen[r][i];

        screen[r] = tmp;
    }

    private static void rotateCol(boolean[][] screen, int c, int n) {
        boolean[] tmp = new boolean[screen.length];

        for (int i = 0; i < tmp.length; i++)
            tmp[(i + n) % tmp.length] = screen[i][c];

        for (int i = 0; i < tmp.length; i++)
            screen[i][c] = tmp[i];
    }

    private static void rect(boolean[][] screen, int w, int h) {
        for (int i = 0; i < h; i++)
            for (int j = 0; j < w; j++)
                screen[i][j] = true;
    }

    private static long part1(boolean[][] screen, String[] lines) {
        for (String line : lines) {
            String[] split = line.split(" ");

            if (split[0].equals("rect")) {
                var vals = Arrays.stream(split[1].split("x"))
                        .map(Integer::parseInt)
                        .toArray(Integer[]::new);

                rect(screen, vals[0], vals[1]);
            } else if (split[0].equals("rotate")) {
                int target = Integer.parseInt(split[2].split("=")[1]);
                int n = Integer.parseInt(split[4]);

                if (split[1].equals("row")) rotateRow(screen, target, n);
                else rotateCol(screen, target, n);
            }
        }

        return Arrays.stream(screen)
                .map(l -> IntStream.range(0, l.length)
                        .filter(i -> l[i])
                        .count())
                .reduce(0L, Long::sum);
    }

    private static void part2(boolean[][] screen) {
        for (var r : screen) {
            for (var c : r) {
                if (c) System.out.print('O');
                else System.out.print(' ');
            }
            System.out.println();
        }
    }

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

        String[] lines = reader.lines().toArray(String[]::new);
        boolean[][] screen = new boolean[6][50];

        System.out.println(part1(screen, lines));
        part2(screen);
    }
}
