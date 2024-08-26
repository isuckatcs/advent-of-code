import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

class day9 {
    private static long length(String line, boolean recursive) {
        long length = 0;

        for (int i = 0; i < line.length(); ++i) {
            if (line.charAt(i) == '(') {
                int end = line.indexOf(')', i);
                String expandPattern = line.substring(i + 1, end);

                String[] vals = expandPattern.split("x");
                int amount = Integer.parseInt(vals[0]);
                int repeat = Integer.parseInt(vals[1]);

                String pattern = line.substring(end + 1, end + amount + 1);
                long patternLength = (recursive ? length(pattern, true) : pattern.length());
                length += patternLength * repeat;

                i = end + amount;
                continue;
            }

            ++length;
        }

        return length;
    }

    private static long part1(String line) {
        return length(line, false);
    }


    private static long part2(String line) {
        return length(line, true);
    }

    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String line = reader.readLine();

        System.out.println(part1(line));
        System.out.println(part2(line));
    }
}
