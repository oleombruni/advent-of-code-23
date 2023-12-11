
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
            |> Array.map int
            |> List.ofArray
let toBeat = lines[1].Split [| ' ' |]
             |> Array.filter (fun e -> e.Length <> 0)
             |> Array.tail
             |> Array.map int
             |> List.ofArray

let rec ziparr a b = match a, b with
                        | x::xs, y::ys -> (x, y)::(ziparr xs ys)
                        | [], [] -> []
                        | _, [] -> failwith "invalid input"
                        | [], _ -> failwith "invalid input"
                        
let zips = ziparr times toBeat

zips |> List.map (fun (a,b) ->printfn $"%d{a} %d{b}") |> ignore

let rec processData lis =
    let findInterval x y =
        let dx, dy = double x, double y
        in let delta = sqrt(dx**2.0 - 4.0*dy)
            in let right = 0.5 * (dx + delta)
                in let left = 0.5 * (dx - delta)
                    in int(ceil(right) - floor(left) - 1.0)
    in begin match lis with
        | [] -> []
        | (a, b)::xs -> (findInterval a b)::(processData xs)
    end
    
let intermediate = processData zips

intermediate |> List.map (printfn "%d") |> ignore

let result = intermediate |> List.reduce (*)

printfn $"{result}"