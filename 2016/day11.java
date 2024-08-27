import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

class day11 {
    private record Element(String code, boolean m) implements Comparable<Element> {
        @Override
        public String toString() {
            return code + (m ? "M" : "G");
        }

        @Override
        public int compareTo(Element e) {
            return toString().compareTo(e.toString());
        }
    }

    private static class Floors extends ArrayList<TreeSet<Element>> {
        private Floors deepClone() {
            Floors tmp = new Floors();
            for (var arr : this)
                tmp.add((TreeSet<Element>) arr.clone());
            return tmp;
        }

        private Floors moveElement(int from, int to, Element el) {
            var tmp = deepClone();
            tmp.get(from).remove(el);
            tmp.get(to).add(el);
            return tmp;
        }
    }

    private record State(int elevator, int steps, Floors floors) {
        private boolean isValid() {
            for (var floor : floors) {
                var partition = floor.stream().collect(Collectors.partitioningBy(Element::m));

                for (var m : partition.get(true)) {
                    var generators = partition.get(false);
                    if (!generators.isEmpty() && generators.stream().noneMatch(g -> g.code.equals(m.code)))
                        return false;
                }
            }

            return true;
        }
    }

    private static int simulate(State initialState) {
        ArrayDeque<State> q = new ArrayDeque<>();
        q.add(initialState);

        HashSet<String> visited = new HashSet<>();

        int steps = 0;
        while (!q.isEmpty()) {
            State cur = q.removeFirst();
            if (!cur.isValid()) continue;

            int elevator = cur.elevator;

            if (!visited.add("e:" + cur.elevator + cur.floors)) continue;

            if (steps != cur.steps) {
                steps = cur.steps;
                System.err.println("steps: " + steps + ", states in queue: " + q.size());
            }

            if (IntStream.range(0, 3).allMatch(i -> cur.floors.get(i).isEmpty())) return cur.steps;

            List<Element> curFloor = cur.floors.get(elevator).stream().toList();
            int curFloorSize = curFloor.size();

            for (int i = 0; i < curFloorSize; i++) {
                for (int to : new int[]{elevator + 1, elevator - 1}) {
                    if (to < 0 || to >= cur.floors.size()) continue;

                    Element el = curFloor.get(i);

                    // move 1 item
                    var up1 = cur.floors.moveElement(elevator, to, el);
                    q.add(new State(to, cur.steps + 1, up1));

                    // move 2 items
                    for (int j = i + 1; j < curFloorSize; j++) {
                        var up2 = up1.moveElement(elevator, to, curFloor.get(j));
                        q.add(new State(to, cur.steps + 1, up2));
                    }
                }
            }
        }

        return -1;
    }

    public static void main(String[] args) {
        Floors floors = new Floors();
        for (int i = 0; i < 4; i++)
            floors.add(new TreeSet<>());

        floors.get(0).add(new Element("PR", false));
        floors.get(0).add(new Element("PR", true));

        floors.get(1).add(new Element("CO", false));
        floors.get(1).add(new Element("CU", false));
        floors.get(1).add(new Element("RU", false));
        floors.get(1).add(new Element("PL", false));

        floors.get(2).add(new Element("CO", true));
        floors.get(2).add(new Element("CU", true));
        floors.get(2).add(new Element("RU", true));
        floors.get(2).add(new Element("PL", true));

        System.out.println(simulate(new State(0, 0, floors)));

        floors.get(0).add(new Element("EL", false));
        floors.get(0).add(new Element("EL", true));

        floors.get(0).add(new Element("DI", false));
        floors.get(0).add(new Element("DI", true));

        System.out.println(simulate(new State(0, 0, floors)));
    }
}
