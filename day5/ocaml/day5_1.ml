let filename = "input.txt";;

let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all 
  in
  String.split_on_char '\n' contents;;

type state =
  | Start
  | Seeds
  | Map;;

let process_input i: int =
  let rec helper currState strlist input (maps: (int * int * int) list list) tmpmap =
    match currState, strlist with
    | Start, x::y::xs ->  if String.starts_with ~prefix:"seeds: " x 
                          then
                            let seedlist = List.map int_of_string (String.split_on_char ' ' (String.sub x 7 (String.length x - 7)))
                            in helper Seeds xs seedlist maps tmpmap
                          else
                            failwith ("invalid input " ^ x)
    | Seeds, x::xs ->     if x = "seed-to-soil map:"
                          then helper Map xs input maps tmpmap
                          else failwith ("invalid input " ^ x)
    | Map, x::xs -> (match x with
                          | "" -> helper Map xs input (maps@[tmpmap]) []
                          | el when String.ends_with ~suffix:"map:" el -> helper Map xs input maps tmpmap
                          | el -> let maplist = List.map int_of_string (String.split_on_char ' ' el)
                                  in (match maplist with
                                    | x::y::z::[] -> helper Map xs input maps ((x, y, z)::tmpmap) 
                                    | _ -> failwith ("invalid input " ^ el))
                    )
    | Map, [] -> input, maps
    | _, _ -> failwith ("invalid input")
  and minval lis = match lis with
  | [] -> failwith "empty input"
  | x::[] -> x
  | x::xs -> let res = minval xs in if res > x then x else res
  and convertFun maplist_list el =
    let rec convertInner maplist n = 
      match maplist with
      | (dest, src, range)::xs when (src <= n) && (n < src + range) -> dest + (n - src)
      | (dest, src, range)::xs -> convertInner xs n
      | [] -> n
    in
      match maplist_list with
      | [] -> el
      | x::xs -> convertFun xs (convertInner x el) 
  in
  let i, m = helper Start i [] [] []
  in minval (List.map (convertFun m) i)

let solution = process_input(read_lines filename);;
print_endline ("Solution is " ^ (string_of_int solution));;