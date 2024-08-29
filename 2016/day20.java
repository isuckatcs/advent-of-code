import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;

class day20 {
    private record Range(long begin, long end) {
    }

    private static ArrayList<Range> getAllowedIPRanges(String[] blacklist) {
        ArrayList<Range> allowedIPRanges = new ArrayList<>(1);
        allowedIPRanges.add(new Range(0L, 4294967295L));

        for (String line : blacklist) {
            String[] split = line.split("-");

            long begin = Long.parseLong(split[0]);
            long end = Long.parseLong(split[1]);

            ArrayList<Range> tmp = new ArrayList<>();
            for (Range r : allowedIPRanges) {
                long overlapBegin = Long.max(begin, r.begin);
                long overlapEnd = Long.min(end, r.end);

                if (overlapBegin > overlapEnd) {
                    tmp.add(r);
                    continue;
                }

                if (r.begin < overlapBegin)
                    tmp.add(new Range(r.begin, overlapBegin - 1));

                if (r.end > overlapEnd)
                    tmp.add(new Range(overlapEnd + 1, r.end));
            }
            allowedIPRanges = tmp;
        }

        return allowedIPRanges;
    }

    private static long part1(String[] blacklist) {
        return getAllowedIPRanges(blacklist).getFirst().begin;
    }

    private static long part2(String[] blacklist) {
        return getAllowedIPRanges(blacklist).stream().mapToLong(r -> r.end - r.begin + 1).sum();
    }

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String[] lines = reader.lines().toArray(String[]::new);

        System.out.println(part1(lines));
        System.out.println(part2(lines));
    }
}
