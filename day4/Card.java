import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public record Card(int cardNo, Set<Integer> winningNumbers, Set<Integer> cardNumbers) {
    public static Card stringToCard(String in) {
        var p = Pattern.compile("Card( *)([0-9]*): (.*) \\| (.*)");
        var matcher = p.matcher(in);
        if (matcher.find()) {
            int cardNo = Integer.parseInt(matcher.group(2));
            var winning = Arrays.stream(matcher.group(3).split("\\s+"))
                    .filter((e) -> !e.isEmpty())
                    .mapToInt(Integer::parseInt)
                    .boxed()
                    .collect(Collectors.toCollection(HashSet::new));
            var cardNumbers =  Arrays.stream(matcher.group(4).split("\\s+"))
                    .filter((e) -> !e.isEmpty())
                    .mapToInt(Integer::parseInt)
                    .boxed()
                    .collect(Collectors.toCollection(HashSet::new));
            return new Card(cardNo, winning, cardNumbers);
        } else {
            return null;
        }
    }
}
