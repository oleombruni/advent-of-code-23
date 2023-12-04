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

function checkLimits(dict) {
    const limits = {
        blue: 14,
        green: 13,
        red: 12
    }

    for (const color in limits) {
        if (dict[color] > limits[color]) return false;
    }
    return true;
}


const i = fs.readFileSync("input.txt", { encoding: 'utf-8' })
const lines = i.split("\n")

let sumGames = 0
for (const line of lines) {
    const [gameline, game] = line.split(":")
    const pulls = game.split(";")
    const gamenr = Number.parseInt(gameline.replace(/Game /, ""))
    let isGamePossible = true
    for (const pull of pulls) {
        const mDict = fromPullToDict(pull)
        if (!checkLimits(mDict)) {
            isGamePossible = false
            break
        }
    }
    if (isGamePossible) {
        console.log("Game " + gamenr + " is possible")
        sumGames += gamenr
    } else {
        console.log("Game " + gamenr + " is not possible")
    }
}

console.log("The solution is " + sumGames)