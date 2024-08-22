import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.stream.IntStream;

class day7 {
    private static boolean hasAbba(String str) {
        if (str.length() < 4) return false;

        int start = 0;
        int end = start + 3;

        char[] chars = str.toCharArray();
        while (end < str.length()) {
            if (chars[start] == chars[end] && chars[start + 1] == chars[end - 1] && chars[start] != chars[start + 1])
                return true;

            ++start;
            ++end;
        }

        return false;
    }

    private static ArrayList<String> getAbas(String str) {
        ArrayList<String> abas = new ArrayList<>();

        if (str.length() < 3) return abas;

        int start = 0;
        int end = start + 2;

        char[] chars = str.toCharArray();
        while (end < str.length()) {
            if (chars[start] == chars[end] && chars[start] != chars[start + 1])
                abas.add(str.substring(start, end + 1));

            ++start;
            ++end;
        }

        return abas;
    }

    private static String toBab(String aba) {
        char[] chars = aba.toCharArray();

        chars[0] = chars[1];
        chars[1] = chars[2];
        chars[2] = chars[0];

        return new String(chars);
    }

    private static long part1(String[] lines) {
        return Arrays.stream(lines)
                .map(l -> l.split("[\\[\\]]"))
                .filter(a -> IntStream.range(0, a.length)
                        .filter(i -> i % 2 == 0).mapToObj(i -> a[i])
                        .anyMatch(day7::hasAbba))
                .filter(a -> IntStream.range(0, a.length)
                        .filter(i -> i % 2 == 1)
                        .mapToObj(i -> a[i])
                        .noneMatch(day7::hasAbba))
                .count();
    }

    private static long part2(String[] lines) {
        int cnt = 0;

        for(String line : lines) {
            String[] split = line.split("[\\[\\]]");

            ArrayList<String> abas = new ArrayList<>();
            ArrayList<String> babs = new ArrayList<>();

            for (int i = 0; i < split.length; i++) {
                ArrayList<String> extractedAbas = getAbas(split[i]);

                if(i % 2 == 0)
                    abas.addAll(extractedAbas);
                else
                    babs.addAll(extractedAbas);

            }

            if(abas.stream().anyMatch(aba -> babs.stream().anyMatch(bab -> bab.equals(toBab(aba)))))
                ++cnt;
        }

        return cnt;
    }

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String[] lines = reader.lines().toArray(String[]::new);

        System.out.println(part1(lines));
        System.out.println(part2(lines));
    }
}
