import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class day14 {
    private interface HashFunction {
        String hash(MessageDigest md, String input);
    }

    private static String hash(MessageDigest md, String input) {
        return String.format("%032x", new BigInteger(1, md.digest(input.getBytes())));
    }

    private static String stretchedHash(MessageDigest md, String input) {
        String hash = hash(md, input);
        for (int i = 0; i < 2016; i++)
            hash = hash(md, hash);
        return hash;
    }

    private static int solve(String salt, HashFunction fn) {
        try {
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            Pattern triple = Pattern.compile("(.)\\1{2}");

            ArrayList<String> hashes = new ArrayList<>(2000);
            int idx = 0;
            int keys = 0;

            while (keys < 64) {
                int oldIdx = idx;
                ++idx;

                if (oldIdx >= hashes.size()) hashes.add(fn.hash(md5, salt + oldIdx));

                Matcher matcher = triple.matcher(hashes.get(oldIdx));
                if (!matcher.find()) continue;
                String fivePattern = matcher.group().substring(0, 1).repeat(5);

                for (int i = oldIdx + 1; i < oldIdx + 1000; i++) {
                    if (i >= hashes.size()) hashes.add(fn.hash(md5, salt + i));
                    if (!hashes.get(i).contains(fivePattern)) continue;

                    ++keys;
                    System.err.println("idx: " + oldIdx + ", keys: " + keys);
                    break;
                }
            }

            return idx - 1;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    private static int part1(String salt) {
        return solve(salt, day14::hash);
    }

    private static int part2(String salt) {
        return solve(salt, day14::stretchedHash);
    }

    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String salt = reader.readLine();

        System.out.println(part1(salt));
        System.out.println(part2(salt));
    }
}
