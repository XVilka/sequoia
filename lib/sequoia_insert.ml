open Sequoia_query_common

module Driver = Sequoia_driver
module Field  = Sequoia_field
module Lit    = Sequoia_lit
module Table  = Sequoia_table
module Vector = Sequoia_vector
module Nat    = Vector.Nat

module type S = sig
  module Vector : Vector.S with type ('t, 'a) elem := ('t, 'a) Field.t

  type _ t

  val insert : into:'t Table.t
            -> fields:('t, 'a, 'n Nat.s) Vector.t
            -> values:('u, 'a, 'm Nat.s, 'n Nat.s) Lit.Vector.matrix
            -> 't t

  val seal : 't t -> string * Sequoia_param.t list
end

module Make (D : Driver.S) : S = struct
  include InsertReplace

  let insert = create
  let seal stmt = seal ~placeholder:D.placeholder ~query:"INSERT" stmt
end
