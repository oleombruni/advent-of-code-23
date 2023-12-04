const fs = require("fs")

function fromPullToDict(pull) {
    const splits = pull.split(",")
    let dict = {
        blue: 0,
        red: 0,
        green: 0
    }
    for (let split of splits) {
        const [_, nr, color] = split.match(/([0-9]*) (blue|red|green)/)
        dict[color] = Number.parseInt(nr.trim())
    }
    return dict
}

function updateLimits(dict, cubes) {
    for (const color in dict) {
        if (dict[color] > cubes[color])
            cubes[color] = dict[color];
    }
    return true;
}

function powerCubes(cubes) {
    return cubes.red * cubes.blue * cubes.green
}


const i = fs.readFileSync("input.txt", { encoding: 'utf-8' })
const lines = i.split("\n")

let sumGames = 0
for (const line of lines) {
    const [gameline, game] = line.split(":")
    const pulls = game.split(";")
    const gamenr = Number.parseInt(gameline.replace(/Game /, ""))
    let fewestCubes = {
        blue: 0,
        red: 0,
        green: 0
    }
    for (const pull of pulls) {
        updateLimits(fromPullToDict(pull), fewestCubes)
    }
    console.log("Game " + gamenr + " limits { red: " + fewestCubes.red + ", blue: " + fewestCubes.blue + ", green: " + fewestCubes.green + "} - power is " + powerCubes(fewestCubes))
    sumGames += powerCubes(fewestCubes)
}

console.log("The solution is " + sumGames)