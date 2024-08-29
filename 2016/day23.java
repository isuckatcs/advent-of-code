import java.io.BufferedReader;
import java.io.InputStreamReader;

class day23 {
    private static int getOpVal(int[] r, String[] instr, int n) {
        String op = instr[n];

        char fst = op.charAt(0);
        if ('a' <= fst && fst <= 'd') return r[fst - 'a'];

        return Integer.parseInt(op);
    }

    private static int getRIdx(String[] instr, int n) {
        return instr[n].charAt(0) - 'a';
    }

    private static void execute(int[] r, String[] instructions) {
        int rip = 0;
        while (rip < instructions.length) {
            String[] instr = instructions[rip].split(" ");
            String opcode = instr[0];

            switch (opcode) {
                case "inc":
                    ++r[getRIdx(instr, 1)];
                    break;
                case "dec":
                    --r[getRIdx(instr, 1)];
                    break;
                case "cpy":
                    if (Character.isAlphabetic(instr[2].charAt(0))) {
                        r[getRIdx(instr, 2)] = getOpVal(r, instr, 1);
                    }
                    break;
                case "jnz":
                    if (getOpVal(r, instr, 1) != 0) {
                        rip += getOpVal(r, instr, 2);
                        continue;
                    }
                    break;
                case "tgl": {
                    int targetInst = rip + getOpVal(r, instr, 1);
                    if (targetInst < instructions.length) {
                        String opc = instructions[targetInst].split(" ")[0];
                        instructions[targetInst] = instructions[targetInst].replace(opc, switch (opc) {
                            case "inc" -> "dec";
                            case "dec", "tgl" -> "inc";
                            case "cpy" -> "jnz";
                            default -> "cpy";
                        });
                    }
                }
            }

            ++rip;
        }
    }

    private static int part1(String[] instructions) {
        int[] r = new int[4];
        r[0] = 7;

        execute(r, instructions);
        return r[0];
    }

    private static int part2(String[] instructions) {
        int[] r = new int[4];
        r[0] = 12;

        execute(r, instructions);
        return r[0];
    }

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String[] lines = reader.lines().toArray(String[]::new);

        System.out.println(part1(lines.clone()));
        System.out.println(part2(lines));
    }
}
