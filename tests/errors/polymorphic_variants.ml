type t = [ `A | `B of int ]

let a : t =
  `A

let b : t =
  `B 1

let match_variant (x : t) =
  match x with
  | `A -> 0
  | `B n -> n
