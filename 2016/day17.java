import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayDeque;

class day17 {
    private static String hash(String input) {
        try {
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            return String.format("%032x", new BigInteger(1, md5.digest(input.getBytes())));
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    private static boolean isOpen(char c) {
        return 'b' <= c && c <= 'f';
    }

    private record State(int r, int c, String path) {
    }

    private record DirInfo(int vr, int vc, int hIdx, char p) {
    }

    private static String getPath(String passcode, boolean stopAfterFirst) {
        String[] maze = new String[]{
                "#########",
                "#S| | | #",
                "#-#-#-#-#",
                "# | | | #",
                "#-#-#-#-#",
                "# | | | #",
                "#-#-#-#-#",
                "# | | |  ",
                "####### V",
        };

        DirInfo[] dis = new DirInfo[]{
                new DirInfo(-1, 0, 0, 'U'),
                new DirInfo(1, 0, 1, 'D'),
                new DirInfo(0, -1, 2, 'L'),
                new DirInfo(0, 1, 3, 'R')
        };

        String path = "";
        ArrayDeque<State> queue = new ArrayDeque<>();
        queue.add(new State(1, 1, ""));

        while (!queue.isEmpty()) {
            State cur = queue.removeFirst();

            if (cur.r == 7 && cur.c == 7) {
                path = cur.path;

                if (stopAfterFirst)
                    break;

                continue;
            }

            String doorInfo = hash(passcode + cur.path).substring(0, 4);

            for (DirInfo di : dis) {
                if (maze[cur.r + di.vr].charAt(cur.c + di.vc) != '#' && isOpen(doorInfo.charAt(di.hIdx)))
                    queue.add(new State(cur.r + 2 * di.vr, cur.c + 2 * di.vc, cur.path + di.p));
            }
        }

        return path;
    }

    private static String part1(String passcode) {
        return getPath(passcode, true);
    }

    private static int part2(String passcode) {
        return getPath(passcode, false).length();
    }

    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String passcode = reader.readLine();

        System.out.println(part1(passcode));
        System.out.println(part2(passcode));
    }
}
