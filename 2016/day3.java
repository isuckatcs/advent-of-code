import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Arrays;

class day3 {
    private static boolean isValidTriangle(Integer[] sides) {
        return sides[0] + sides[1] > sides[2] && sides[0] + sides[2] > sides[1] && sides[1] + sides[2] > sides[0];
    }

    private static long part1(Integer[][] lines) {
        return Arrays.stream(lines).filter(day3::isValidTriangle).count();
    }

    private static long part2(Integer[][] lines) {
        int cnt = 0;

        for (int i = 0; i < lines.length; i += 3)
            for (int j = 0; j < 3; ++j)
                if (isValidTriangle(new Integer[]{lines[i][j], lines[i + 1][j], lines[i + 2][j]}))
                    cnt += 1;

        return cnt;
    }

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        var lines = reader.lines()
                .map(str -> str.trim().split("\\s+"))
                .map(arr -> Arrays.stream(arr).map(Integer::parseInt).toArray(Integer[]::new))
                .toArray(Integer[][]::new);

        System.out.println(part1(lines));
        System.out.println(part2(lines));
    }
}
