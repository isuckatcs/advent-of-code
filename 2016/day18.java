import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;

class day18 {
    private static long calculateSafeTiles(String startingRow, int rowCnt) {
        ArrayList<String> rows = new ArrayList<>(40);
        rows.add(startingRow);

        for (int i = 1; i < rowCnt; i++) {
            String extendedRow = "." + rows.get(i - 1) + ".";

            StringBuilder builder = new StringBuilder(startingRow.length());
            for (int j = 1; j <= startingRow.length(); j++) {
                String pattern = extendedRow.substring(j - 1, j + 2);

                boolean trap = pattern.equals("^^.") ||
                        pattern.equals(".^^") ||
                        pattern.equals("^..") ||
                        pattern.equals("..^");

                builder.append(trap ? '^' : '.');
            }
            rows.add(builder.toString());
        }

        return rows.stream()
                .mapToLong(r -> r.chars().filter(c -> c == '.').count())
                .sum();
    }

    private static long part1(String startingRow) {
        return calculateSafeTiles(startingRow, 40);
    }

    private static long part2(String startingRow) {
        return calculateSafeTiles(startingRow, 400000);
    }

    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String row = reader.readLine();

        System.out.println(part1(row));
        System.out.println(part2(row));
    }
}
