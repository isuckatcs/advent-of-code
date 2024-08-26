import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.TreeSet;

class day10 {
    private static boolean process(HashMap<Integer, TreeSet<Integer>> bots, int val, String dst, String dstId) {
        int to = Integer.parseInt(dstId);

        if (!dst.equals("output")) {
            bots.putIfAbsent(to, new TreeSet<>());
            bots.get(to).add(val);
            return true;
        }

        return to > 2;
    }

    private static int[] simulate(List<String> lines) {
        ArrayList<String> linesToProcess = new ArrayList<>(lines);

        HashMap<Integer, TreeSet<Integer>> bots = new HashMap<>();
        int[] out = {-1, 1};

        while (!linesToProcess.isEmpty()) {
            String line = linesToProcess.removeFirst();
            String[] split = line.split(" ");

            if (split[0].equals("value")) {
                int val = Integer.parseInt(split[1]);
                int bot = Integer.parseInt(split[split.length - 1]);

                bots.putIfAbsent(bot, new TreeSet<>());
                bots.get(bot).add(val);
                continue;
            }

            int from = Integer.parseInt(split[1]);
            if (!bots.containsKey(from) || bots.get(from).size() != 2) {
                linesToProcess.add(line);
                continue;
            }

            int low = bots.get(from).removeFirst();
            int high = bots.get(from).removeFirst();

            if (low == 17 && high == 61) out[0] = from;
            if (!process(bots, low, split[5], split[6])) out[1] *= low;
            if (!process(bots, high, split[10], split[11])) out[1] *= high;
        }

        return out;
    }

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        var res = simulate(reader.lines().toList());

        System.out.println(res[0]);
        System.out.println(res[1]);
    }
}
