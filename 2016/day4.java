import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

class day4 {
    private static boolean isRealRoom(String encryptedName) {
        var split = encryptedName.split("[\\[\\]]");
        String data = split[0];
        String checksum = split[1];

        HashMap<Character, Integer> charCount = new HashMap<>();

        for (char c : data.toCharArray()) {
            if (Character.isAlphabetic(c)) {
                int cnt = charCount.getOrDefault(c, 0);
                charCount.put(c, cnt + 1);
            }
        }

        String expectedChecksum = charCount.entrySet().stream()
                .sorted((lhs, rhs) -> Objects.equals(lhs.getValue(), rhs.getValue())
                        ? lhs.getKey().compareTo(rhs.getKey())
                        : rhs.getValue() - lhs.getValue())
                .limit(5)
                .map(e -> e.getKey().toString())
                .collect(Collectors.joining());

        return expectedChecksum.equals(checksum);
    }

    private static int extractSectorID(String encryptedName) {
        Pattern pattern = Pattern.compile("([0-9]+)");
        Matcher matcher = pattern.matcher(encryptedName);

        if (matcher.find()) return Integer.parseInt(matcher.group(1));

        throw new IllegalStateException();
    }

    private static String decryptRoomName(String encryptedName) {
        int id = extractSectorID(encryptedName);

        var chars = encryptedName.toCharArray();
        for (int i = 0; i < chars.length; i++) {
            char c = chars[i];

            if (Character.isDigit(c)) break;

            if (c == '-') {
                chars[i] = ' ';
                continue;
            }

            for (int j = 0; j < id; j++) {
                c += 1;
                if (c > 'z') c = 'a';
            }

            chars[i] = c;
        }

        return new String(chars);
    }

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        var lines = reader.lines().toList();

        var part1 = lines.stream()
                .filter(day4::isRealRoom)
                .mapToInt(day4::extractSectorID)
                .sum();

        var part2 = lines.stream()
                .filter(day4::isRealRoom)
                .map(day4::decryptRoomName)
                .filter(s -> s.startsWith("northpole object storage"))
                .mapToInt(day4::extractSectorID)
                .sum();

        System.out.println(part1);
        System.out.println(part2);
    }
}
