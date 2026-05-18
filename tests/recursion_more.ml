let rec f_map f l =
  match l with
  | [] -> []
  | x :: l -> f x :: f_map f l

let n =
  let rec sum l =
    match l with
    | [] -> 0
    | x :: l -> x + sum l in
  sum [1; 2; 3]

let rec double_list l =
  match l with
  | [] -> l
  | n :: l -> double n :: double_list l

and[@rocq_mutual_as_notation] double n = 2 * n

type 'a tree =
  | Leaf of 'a
  | Node of 'a tree list

let rec sum (t : int tree) =
  match t with
  | Leaf n -> n
  | Node ts -> sums ts

and[@rocq_mutual_as_notation] zero () = 0

and[@rocq_mutual_as_notation][@rocq_struct "ts"] sums (ts : int tree list) =
  match ts with
  | [] -> zero ()
  | t :: ts -> sum t + sums ts

(* Notation with polymorphism *)
let rec count t =
  match t with
  | Leaf l -> length l
  | Node ts -> counts ts

and[@rocq_mutual_as_notation][@rocq_struct "ts"] counts ts =
  match ts with
  | [] -> 0
  | t :: ts -> count t + counts ts

and[@rocq_mutual_as_notation] length l =
  List.length l

let[@rocq_struct "n_value"] rec factorial n =
  if n = 0 then
    1
  else
    n * factorial (n - 1)
