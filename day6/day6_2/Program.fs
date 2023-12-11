
open System.IO

let srcdir = __SOURCE_DIRECTORY__

let readlines filepath = Array.ofSeq (File.ReadLines (Path.Combine [|(Directory.GetParent srcdir).FullName; filepath |]))

let rec listToString lis = match lis with
                            | [] -> ""
                            | x::xs -> x + "\n" + (listToString xs)

let lines = readlines "input.txt"
                            
lines |> Array.map (printfn "%s") |> ignore

let times = lines[0].Split [| ' ' |]
            |> Array.filter (fun e -> e.Length <> 0)
            |> Array.tail
            |> Array.reduce (+)
            |> int64
let toBeat = lines[1].Split [| ' ' |]
             |> Array.filter (fun e -> e.Length <> 0)
             |> Array.tail
             |> Array.reduce (+)
             |> int64
let findInterval x y =
    let dx, dy = double x, double y
    in let delta = sqrt(dx**2.0 - 4.0*dy)
        in let right = 0.5 * (dx + delta)
            in let left = 0.5 * (dx - delta)
                in int64(ceil(right) - floor(left) - 1.0)

let result = findInterval times toBeat

printfn $"{result}"