import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

class day5 {
    private static String crackPassword(String id, boolean part2) throws NoSuchAlgorithmException {
        MessageDigest md5 = MessageDigest.getInstance("MD5");

        char[] password = new char[8];
        boolean[] cracked = new boolean[8];

        int knownCharacters = 0;
        int idx = 0;

        while (knownCharacters < 8) {
            md5.update(StandardCharsets.UTF_8.encode(id + idx));

            var hash = String.format("%032x", new BigInteger(1, md5.digest()));
            if (hash.startsWith("00000")) {
                char currentChar = part2 ? hash.charAt(6) : hash.charAt(5);
                int currentCharIdx = part2 ? hash.charAt(5) - '0' : knownCharacters;

                if (currentCharIdx >= 0 && currentCharIdx <= 7 && !cracked[currentCharIdx]) {
                    System.err.printf("Found %d. character: '%c'\n", currentCharIdx + 1, currentChar);

                    password[currentCharIdx] = currentChar;
                    cracked[currentCharIdx] = true;
                    ++knownCharacters;
                }
            }

            ++idx;
        }

        return new String(password);
    }

    public static void main(String[] args) throws NoSuchAlgorithmException, IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String id = reader.readLine();

        System.out.println(crackPassword(id, false));
        System.out.println(crackPassword(id, true));
    }
}
