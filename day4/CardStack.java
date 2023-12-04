public class CardStack {
    private final int cardNo;
    private int count;
    private int winnings;

    public CardStack(int cardNo, int count, int winnings) {
        this.cardNo = cardNo;
        this.count = count;
        this.winnings = winnings;
    }

    public int getCardNo() {
        return cardNo;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public int getWinnings() {
        return winnings;
    }
}
