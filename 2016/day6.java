import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

class day6 {
    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String[] lines = reader.lines().toArray(String[]::new);

        ArrayList<ArrayList<Character>> columns = new ArrayList<>();
        for (int i = 0; i < lines[0].length(); i++)
            columns.add(new ArrayList<>());

        for (String line : lines)
            IntStream.range(0, line.length()).forEach(i -> columns.get(i).add(line.charAt(i)));

        String part1 = columns.stream()
                .map(c -> c.stream()
                        .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()))
                        .entrySet()
                        .stream()
                        .max(Map.Entry.comparingByValue())
                        .map(Map.Entry::getKey)
                        .orElse(' '))
                .map(Object::toString)
                .collect(Collectors.joining());

        String part2 = columns.stream()
                .map(c -> c.stream()
                        .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()))
                        .entrySet()
                        .stream()
                        .min(Map.Entry.comparingByValue())
                        .map(Map.Entry::getKey)
                        .orElse(' '))
                .map(Object::toString)
                .collect(Collectors.joining());

        System.out.println(part1);
        System.out.println(part2);
    }
}
