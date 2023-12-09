
let filename = "input.txt";;
  
let read_lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all 
  in
  String.split_on_char '\n' contents;;

type state =
  | Start
  | Seeds
  | Map;;

let count = ref 0;;

let process_input i: int =
  let rec helper currState strlist input (maps: (int * int * int) list list) tmpmap =
    match currState, strlist with
    | Start, x::y::xs ->  if String.starts_with ~prefix:"seeds: " x 
                          then
                            let templist = List.map int_of_string (String.split_on_char ' ' (String.sub x 7 (String.length x - 7)))
                            in let rec buildSeedList l = begin match l with
                                | [] -> []
                                | x::[] -> failwith "invalid input"
                                | x::y::xs -> (x, y)::(buildSeedList xs)
                            end
                            in helper Seeds xs (buildSeedList templist) maps tmpmap
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
    | _, _ -> failwith "invalid input"
  and minval lis =  match lis with
  | [] -> failwith "empty input"
  | (x, y)::[] -> x
  | (x, y)::xs -> let res = minval xs in if res > x then x else res
  and convertFun maps (start, length) = match maps with
  | (dest, src, range)::xs when (src <= start) && (start < src + range) -> 
      if (src <= (start + length -1)) && ((start + length - 1) < src + range) 
      then ((dest + (start - src), length), None)
      else let last = src + range - start in ((dest + start - src, last), Some((src+range,  length-last)))
  | (dest, src, range)::xs -> convertFun xs (start, length)
  | [] -> ((start, length), None)
  and applyMap ilist mlist = match ilist with
  | [] -> []
  | x::xs -> let (res, other) = convertFun mlist x in begin match other with 
              | Some(a) -> res::(applyMap (a::xs) mlist)
              | None -> res::(applyMap xs mlist)
             end
  and runMaps ilist mlistlist = match mlistlist with
  | [] -> ilist
  | m::ms -> runMaps (applyMap ilist m) ms 
  in
  let i, m = helper Start i [] [] []
  in minval (runMaps i m)

let solution = process_input(read_lines filename);;
print_endline ("Solution is " ^ (string_of_int solution));;