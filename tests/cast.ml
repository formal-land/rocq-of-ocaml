let f x =
  x[@rocq_cast] + 1

type _ t =
  | Int : int t

let g (type a) (kind : a t) (x : a) : int =
  match kind with
  | Int -> (x[@rocq_cast] : int) + 1
