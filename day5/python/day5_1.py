import re


with open("input.txt", "r") as file:
    lines = file.readlines()

seeds = None
current_map = list()

def process(el, cmap):
    for (dest, src, rg) in cmap:
        if src <= el and el < src + rg:
            el = dest + el - src
            break
    return el

for line in lines:
    line = line.strip()
    if line.startswith("seeds: "):
        seeds = list(map(int, line.split()[1:]))
    elif re.match("(.*)-to-(.*) map:", line) is not None:
        seeds = list(map(lambda el: process(el, current_map), seeds))
        current_map = list()
    else:
        row = re.match("([0-9]+) ([0-9]+) ([0-9]+)", line)
        if row is None:
            continue
        dest, src, rg = map(int, row.groups())
        current_map.append((dest, src, rg))

seeds = list(map(lambda el: process(el, current_map), seeds))

print(min(seeds))