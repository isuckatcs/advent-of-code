import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;

class day15 {
    private record Disc(int startPos, int positions) {
    }

    private static int simulate(ArrayList<Disc> discs) {
        int t = 0;
        while (true) {
            boolean fallthrough = true;

            for (int i = 0; i < discs.size(); i++)
                fallthrough &= (discs.get(i).startPos + t + i + 1) % discs.get(i).positions == 0;

            if (fallthrough) return t;
            ++t;
        }
    }

    private static int part1(ArrayList<Disc> discs) {
        return simulate(discs);
    }

    private static int part2(ArrayList<Disc> discs) {
        discs.add(new Disc(0, 11));
        return simulate(discs);
    }

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        ArrayList<Disc> discs = new ArrayList<>(
                reader.lines().map(l -> {
                    String[] split = l.split("[ .]");
                    return new Disc(Integer.parseInt(split[11]), Integer.parseInt(split[3]));
                }).toList()
        );

        System.out.println(part1(discs));
        System.out.println(part2(discs));
    }
}
