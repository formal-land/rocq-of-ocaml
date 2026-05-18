[@@@ocaml.warning "-32"]

class unsupported_class : object
  method value : int
end

module type Abstract

module rec Recursive : sig end

include sig
  type open_type = ..
  module IncludedModule : sig end
  module type IncludedModuleType
end

module type BadFunctor = functor (X : sig end) -> sig end
