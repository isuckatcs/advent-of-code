import java.io.BufferedReader;
import java.io.InputStreamReader;

class day21 {
    private static String part1(String[] instructions, String password) {
        for (String instr : instructions) {
            String[] split = instr.split(" ");
            if (split[0].equals("swap")) {
                char[] chars = password.toCharArray();

                if (split[1].equals("position")) {
                    int p1 = Integer.parseInt(split[2]);
                    int p2 = Integer.parseInt(split[5]);

                    char tmp = chars[p2];
                    chars[p2] = chars[p1];
                    chars[p1] = tmp;
                } else if (split[1].equals("letter")) {
                    char c1 = split[2].charAt(0);
                    char c2 = split[5].charAt(0);

                    for (int i = 0; i < chars.length; i++) {
                        if (chars[i] == c1) chars[i] = c2;
                        else if (chars[i] == c2) chars[i] = c1;
                    }
                }

                password = new String(chars);
            } else if (split[0].equals("rotate")) {
                char[] chars = password.toCharArray();
                boolean right;
                int by;

                if (split[1].equals("based")) {
                    right = true;
                    by = password.indexOf(split[6]) + 1;
                    if (by >= 5) ++by;
                } else {
                    right = split[1].equals("right");
                    by = Integer.parseInt(split[2]);
                }

                char[] rotated = chars.clone();
                for (int i = 0; i < rotated.length; i++) {
                    int newI = i + (right ? by : -by);
                    if (newI < 0) newI = rotated.length + newI;

                    rotated[newI % rotated.length] = chars[i];
                }

                password = new String(rotated);
            } else if (split[0].equals("reverse")) {
                int from = Integer.parseInt(split[2]);
                int to = Integer.parseInt(split[4]);

                StringBuilder builder = new StringBuilder(password.substring(from, to + 1));
                password = password.substring(0, from) + builder.reverse() + password.substring(to + 1);
            } else if (split[0].equals("move")) {
                int from = Integer.parseInt(split[2]);
                int to = Integer.parseInt(split[5]);
                char c = password.charAt(from);

                password = new StringBuilder(password).deleteCharAt(from).insert(to, c).toString();
            }
        }

        return password;
    }

    private static String bruteForce(String scrambled, String[] instructions, String current) {
        if (current.length() == scrambled.length())
            return part1(instructions, current).equals(scrambled) ? current : "";

        char[] l = "abcdefgh".toCharArray();

        for (char c : l) {
            if (current.indexOf(c) != -1) continue;

            String res = bruteForce(scrambled, instructions, current + c);
            if (!res.isEmpty())
                return res;
        }

        return "";
    }

    private static String part2(String[] instructions, String scrambled) {
        return bruteForce(scrambled, instructions, "");
    }

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String[] instructions = reader.lines().toArray(String[]::new);

        System.out.println(part1(instructions, "abcdefgh"));
        System.out.println(part2(instructions, "fbgdceah"));
    }
}
