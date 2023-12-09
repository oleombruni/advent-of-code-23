import re


with open("input.txt", "r") as file:
    lines = file.readlines()

seeds = None
current_map = list()

def process1(lis: list, cmap):
    ranges = []
    for (start, length) in lis:
        for (dest, src, rg) in cmap:
            if src <= start and start < src + rg:
                f = dest + start - src
                if src <= (start + length - 1) and (start + length - 1) < src + rg:
                    ranges.append((f, length))
                else:
                    last = src + rg - start
                    print("Split! old=" + str((start, length)) + " new=[" + str((start, last)) + "," + str((src+rg, length - last))+"] fun=" + str((dest, src, rg)))
                    ranges.append((f, last))
                    lis.append((src + rg, length - last))
                break
        else:
            ranges.append((start, length))
    return ranges


def process2(lis: list, cmap):
    mins = []
    for (start, length) in lis:
        for (dest, src, rg) in cmap:
            if src <= start and start < src + rg:
                f = dest + start - src
                if src <= (start + length - 1) and (start + length - 1) < src + rg:
                   mins.append(f)
                else:
                    last = src + rg - start
                    print("Split! old=" + str((start, length)) + " new=[" + str((start, last)) + "," + str((src+rg, length - last))+"] fun=" + str((dest, src, rg)))
                    mins.append(f)
                    lis.append((src + rg, length - last))
                break
        else:
            mins.append(start)
    return mins

for line in lines:
    line = line.strip()
    if line.startswith("seeds: "):
        tmp = line.split()[1:]
        seeds = list()
        for i in range(0, len(tmp), 2):
            seeds.append((int(tmp[i]), int(tmp[i+1])))
        print(seeds)
    elif re.match("(.*)-to-(.*) map:", line) is not None:
        seeds = process1(seeds, current_map)
        print(seeds)
        print(line)
        current_map = list()
    else:
        row = re.match("([0-9]+) ([0-9]+) ([0-9]+)", line)
        if row is None:
            continue
        dest, src, rg = map(int, row.groups())
        current_map.append((dest, src, rg))

res = process2(seeds, current_map)
print(res)

print(min(res))