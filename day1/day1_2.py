def forwards(s: str) -> str:
    for c in s:
        if c.isdigit():
            return c
    raise ValueError()

def backwards(s: str) -> int:
    for i in range(len(s)-1, -1, -1):
        if s[i].isdigit():
            return s[i]
    raise ValueError()


if __name__ == "__main__":
    import time
    start = time.time()
    count = 0
    with open("input.txt", "r") as f:
        lines = f.readlines()
        for s in lines:
            s = s.strip()                       \
                    .replace("one", "o1ne")     \
                    .replace("two", "t2wo")     \
                    .replace("three", "thr3ee") \
                    .replace("four", "fo4ur")   \
                    .replace("five", "fi5ve")   \
                    .replace("six", "s6ix")     \
                    .replace("seven", "sev7en") \
                    .replace("eight", "eig8ht") \
                    .replace("nine", "ni9ne")   

            first = forwards(s)
            second = backwards(s)

            count += int(first + second)
    end = time.time()
    print(count)
    print(f"elapsed: {end - start}")