import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.stream.Collectors;

class day16 {
    private static String dragon(String a, int length) {
        if (a.length() > length)
            return a.substring(0, length);

        String b = new StringBuilder(a).reverse().toString();
        b = b.chars()
                .map(c -> (c - '0') ^ 1)
                .mapToObj(Integer::toString)
                .collect(Collectors.joining());

        return dragon(a + "0" + b, length);
    }

    private static String checksum(String s) {
        if (s.length() % 2 == 1)
            return s;

        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < s.length(); i += 2)
            builder.append(s.charAt(i) == s.charAt(i + 1) ? 1 : 0);

        return checksum(builder.toString());
    }

    private static String part1(String input) {
        return checksum(dragon(input, 272));
    }

    private static String part2(String input) {
        return checksum(dragon(input, 35651584));
    }

    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String input = reader.readLine();

        System.out.println(part1(input));
        System.out.println(part2(input));
    }
}
