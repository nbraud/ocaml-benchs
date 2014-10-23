open Lwt

let make_th mvars n id =
  let p, s =
    match id with
    | 0 -> 502, 1
    | 502 -> 501, 0
    | n -> pred n, succ n in
  let rec do_n_times = function
    | 0 -> Lwt.return_unit
    | n ->
      Lwt_stream.next @@ fst mvars.(p) >>= fun () ->
      snd mvars.(s) @@ Some ();
      do_n_times (pred n)
  in
  do_n_times n

let main n =
  let mvars = Array.init 503 (fun _ -> Lwt_stream.create ()) in
  let ths = Array.init 503 @@ make_th mvars n in
  snd mvars.(0) @@ Some ();
  ths.(502)

let () =
  let n = if Array.length Sys.argv > 1 then int_of_string Sys.argv.(1) else 50000
  in Lwt_main.run @@ main n