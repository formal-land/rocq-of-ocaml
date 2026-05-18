let rules =
  [
    (* Built-in types *)
    ("char", "ascii");
    ("()", "tt");
    ("op_coloncolon", "cons");
    ("Ok", "inl");
    ("Error", "inr");
    ("exn", "extensible_type");
    (* Predefined exceptions *)
    ("Match_failure", "RocqOfOCaml.Match_failure");
    ("Assert_failure", "RocqOfOCaml.Assert_failure");
    ("Invalid_argument", "RocqOfOCaml.Invalid_argument");
    ("Failure", "RocqOfOCaml.Failure");
    ("Not_found", "RocqOfOCaml.Not_found");
    ("Out_of_memory", "RocqOfOCaml.Out_of_memory");
    ("Stack_overflow", "RocqOfOCaml.Stack_overflow");
    ("Sys_error", "RocqOfOCaml.Sys_error");
    ("End_of_file", "RocqOfOCaml.End_of_file");
    ("Division_by_zero", "RocqOfOCaml.Division_by_zero");
    ("Sys_blocked_io", "RocqOfOCaml.Sys_blocked_io");
    ("Undefined_recursive_module", "RocqOfOCaml.Undefined_recursive_module");
    (* Optional parameters *)
    ("*predef*.None", "None");
    ("*predef*.Some", "Some");
    (* Stdlib *)
    (* Exceptions *)
    ("Stdlib.invalid_arg", "RocqOfOCaml.Stdlib.invalid_arg");
    ("Stdlib.failwith", "RocqOfOCaml.Stdlib.failwith");
    ("Stdlib.Exit", "RocqOfOCaml.Stdlib.Exit");
    (* Comparisons *)
    ("Stdlib.op_eq", "equiv_decb");
    ("Stdlib.op_ltgt", "nequiv_decb");
    ("Stdlib.op_lt", "RocqOfOCaml.Stdlib.lt");
    ("Stdlib.op_gt", "RocqOfOCaml.Stdlib.gt");
    ("Stdlib.op_lteq", "RocqOfOCaml.Stdlib.le");
    ("Stdlib.op_gteq", "RocqOfOCaml.Stdlib.ge");
    ("Stdlib.compare", "RocqOfOCaml.Stdlib.compare");
    ("Stdlib.min", "RocqOfOCaml.Stdlib.min");
    ("Stdlib.max", "RocqOfOCaml.Stdlib.max");
    (* Boolean operations *)
    ("Stdlib.not", "negb");
    ("Stdlib.op_andand", "andb");
    ("Stdlib.op_and", "andb");
    ("Stdlib.op_pipepipe", "orb");
    ("Stdlib.or", "orb");
    (* Integer arithmetic *)
    ("Stdlib.op_tildeminus", "Z.opp");
    ("Stdlib.op_tildeplus", "");
    ("Stdlib.succ", "Z.succ");
    ("Stdlib.pred", "Z.pred");
    ("Stdlib.op_plus", "Z.add");
    ("Stdlib.op_minus", "Z.sub");
    ("Stdlib.op_star", "Z.mul");
    ("Stdlib.op_div", "Z.div");
    ("Stdlib._mod", "Z.modulo");
    ("Stdlib.abs", "Z.abs");
    (* Bitwise operations *)
    ("Stdlib.land", "Z.land");
    ("Stdlib.lor", "Z.lor");
    ("Stdlib.lxor", "Z.lxor");
    ("Stdlib.lsl", "Z.shiftl");
    ("Stdlib.lsr", "Z.shiftr");
    (* Floating-point arithmetic *)
    (* String operations *)
    ("Stdlib.op_caret", "String.append");
    (* Character operations *)
    ("Stdlib.int_of_char", "RocqOfOCaml.Stdlib.int_of_char");
    ("Stdlib.char_of_int", "RocqOfOCaml.Stdlib.char_of_int");
    (* Unit operations *)
    ("Stdlib.ignore", "RocqOfOCaml.Stdlib.ignore");
    (* String conversion functions *)
    ("Stdlib.string_of_bool", "RocqOfOCaml.Stdlib.string_of_bool");
    ("Stdlib.bool_of_string", "RocqOfOCaml.Stdlib.bool_of_string");
    ("Stdlib.string_of_int", "RocqOfOCaml.Stdlib.string_of_int");
    ("Stdlib.int_of_string", "RocqOfOCaml.Stdlib.int_of_string");
    (* Pair operations *)
    ("Stdlib.fst", "fst");
    ("Stdlib.snd", "snd");
    (* List operations *)
    ("Stdlib.op_at", "RocqOfOCaml.Stdlib.app");
    (* Input/output *)
    (* Output functions on standard output *)
    ("Stdlib.print_char", "RocqOfOCaml.Stdlib.print_char");
    ("Stdlib.print_string", "RocqOfOCaml.Stdlib.print_string");
    ("Stdlib.print_int", "RocqOfOCaml.Stdlib.print_int");
    ("Stdlib.print_endline", "RocqOfOCaml.Stdlib.print_endline");
    ("Stdlib.print_newline", "RocqOfOCaml.Stdlib.print_newline");
    (* Output functions on standard error *)
    ("Stdlib.prerr_char", "RocqOfOCaml.Stdlib.prerr_char");
    ("Stdlib.prerr_string", "RocqOfOCaml.Stdlib.prerr_string");
    ("Stdlib.prerr_int", "RocqOfOCaml.Stdlib.prerr_int");
    ("Stdlib.prerr_endline", "RocqOfOCaml.Stdlib.prerr_endline");
    ("Stdlib.prerr_newline", "RocqOfOCaml.Stdlib.prerr_newline");
    (* Input functions on standard input *)
    ("Stdlib.read_line", "RocqOfOCaml.Stdlib.read_line");
    ("Stdlib.read_int", "RocqOfOCaml.Stdlib.read_int");
    (* General output functions *)
    (* General input functions *)
    (* Operations on large files *)
    (* References *)
    (* Result type *)
    ("Stdlib.result", "sum");
    (* Operations on format strings *)
    (* Program termination *)

    (* Bytes *)
    ("Stdlib.Bytes.cat", "String.append");
    ("Stdlib.Bytes.concat", "String.concat");
    ("Stdlib.Bytes.length", "String.length");
    ("Stdlib.Bytes.sub", "String.sub");
    (* List *)
    ("Stdlib.List.exists", "RocqOfOCaml.List._exists");
    ("Stdlib.List.exists2", "RocqOfOCaml.List._exists2");
    ("Stdlib.List.length", "RocqOfOCaml.List.length");
    ("Stdlib.List.map", "List.map");
    ("Stdlib.List.rev", "List.rev");
    (* Seq *)
    ("Stdlib.Seq.t", "RocqOfOCaml.Seq.t");
    (* String *)
    ("Stdlib.String.length", "RocqOfOCaml.String.length");
  ]
