module type Included = sig
  type item
  val item_value : item
end

include Included

include sig
  type inline_type
  val inline_value : inline_type
end

class type point = object
  method x : int
  method move : int -> int
end

module M : sig
  type t
  val v : t
end

exception SignatureError of int

module Alias = M

module type NestedSig = sig
  val nested_sig_value : int
end

module FromTypeof : module type of M

module type Arg = sig
  type t
  val v : t
end

module type Result = sig
  type result
  val result : int -> result
end

module Functor (X : Arg) : Result
