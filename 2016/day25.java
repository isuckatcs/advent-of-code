import java.io.BufferedReader;
import java.io.InputStreamReader;

class day25 {
    private static int part1(String[] instructions) {
        // Running the instructions infinitely prints the binary
        // representation of 'a + MAGIC_NUMBER' after each other.
        //
        // 1: while(true) {
        // 2:    n = a + MAGIC_NUMBER;
        // 3:    while(n != 0) {
        // 4:        print(n % 2);
        // 5:        n /= 2;
        // 6:    }
        // 7: }
        int x = Integer.parseInt(instructions[1].split(" ")[1]);
        int y = Integer.parseInt(instructions[2].split(" ")[1]);

        String magicBinary = Integer.toBinaryString(x * y);
        String desiredBinary = "10".repeat(magicBinary.length() / 2);

        return Integer.parseUnsignedInt(desiredBinary, 2) - Integer.parseInt(magicBinary, 2);
    }

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String[] instruction = reader.lines().toArray(String[]::new);

        System.out.println(part1(instruction));
    }
}

