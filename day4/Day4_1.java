import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashSet;
import java.util.Objects;
import java.util.stream.Stream;

public class Day4_1 {

    public static int pointsPerCard(Card c) {
        HashSet<Integer> s1 = new HashSet<>(c.cardNumbers());
        s1.retainAll(c.winningNumbers());
        System.out.println("Card " + c.cardNo() + ": intersection " + s1);
        int points = (int) Math.pow(2, (s1.size() - 1));
        System.out.println("Card " + c.cardNo() + ": " + points + " points");
        return points;
    }

    public static void printStringArray(String[] arr) {
        for (String s: arr) {
            System.out.println(s);
        }
    }

    public static void main(String[] args) {

        try (Stream<String> lines_stream = Files.lines(Path.of("input.txt"), Charset.defaultCharset())) {
             var result = lines_stream
                     .map(Card::stringToCard)
                     .filter(Objects::nonNull)
                     .mapToInt(Day4_1::pointsPerCard)
                     .sum();
             System.out.println("Result: " + result);
        } catch (IOException e) {
            System.out.println("Error in reading file");
            System.exit(1);
        }

    }
}
