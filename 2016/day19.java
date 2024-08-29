import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.stream.IntStream;

class day19 {
    private static int part1(int elvesCnt) {
        int[] elves = IntStream.rangeClosed(1, elvesCnt).toArray();

        while (elves.length > 2) {
            int[] tmp = elves;
            elves = IntStream.range(tmp.length % 2, tmp.length)
                    .filter(i -> i % 2 == 0)
                    .map(i -> tmp[i])
                    .toArray();
        }

        return elves[0];
    }

    private static int part2(int elvesCnt) {
        ArrayList<Integer> elves = new ArrayList<>(IntStream.rangeClosed(1, elvesCnt).boxed().toList());

        int cur = 0;
        while (elves.size() > 1) {
            if (elves.size() % 10000 == 0)
                System.err.println("Remaining elves: " + elves.size());

            int tgt = cur + elves.size() / 2;
            boolean shouldInc = tgt < elves.size();

            elves.remove(tgt % elves.size());
            cur = (cur + (shouldInc ? 1 : 0)) % elves.size();
        }

        return elves.getFirst();
    }

    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        int elvesCnt = Integer.parseInt(reader.readLine());

        System.out.println(part1(elvesCnt));
        System.out.println(part2(elvesCnt));
    }
}
