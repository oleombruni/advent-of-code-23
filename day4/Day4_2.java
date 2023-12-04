import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Day4_2 {

    public static int processCard(Map<Integer, CardStack> m, int index) {
        var cs = m.get(index);
        for(int i = index + 1; i < index + cs.getWinnings() + 1 && i < m.size() + 1; ++i) {
            var tmp = m.get(i);
            tmp.setCount(tmp.getCount() + cs.getCount());
        }
        return cs.getCount();
    }

    public static void main(String[] args) {

        try (Stream<String> lines_stream = Files.lines(Path.of("input.txt"), Charset.defaultCharset())) {
            var map = lines_stream
                    .map(Card::stringToCard)
                    .filter(Objects::nonNull)
                    .map((e) -> {
                        e.winningNumbers().retainAll(e.cardNumbers());
                        return new CardStack(e.cardNo(), 1, e.winningNumbers().size());
                    })
                    .collect(Collectors.toMap(CardStack::getCardNo, (e) -> e));

            int count = 0;
            for (int i = 1; i < map.size() + 1; ++i) {
                count += processCard(map, i);
            }

            System.out.println("Solution: " + count);

        } catch (IOException e) {
            System.out.println("Error in reading file");
            System.exit(1);
        }

    }
}
