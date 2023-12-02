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

    count = 0
    with open("input.txt", "r") as f:
        lines = f.readlines()
        for s in lines:
            s = s.strip()
            print("line: " + s)

            first = forwards(s)
            second = backwards(s)

            print("number: " + first + second + "\n")

            count += int(first + second)

    print(count)    