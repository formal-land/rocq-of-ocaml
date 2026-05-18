type mutable_record = { mutable field : int }

let set_field (record : mutable_record) =
  record.field <- 1

let array_value =
  [| 1; 2; 3 |]

let while_loop () =
  let counter = ref 0 in
  while !counter < 2 do
    counter := !counter + 1
  done

let for_loop () =
  for index = 0 to 2 do
    ignore index
  done

class simple_object =
  object
    val mutable field = 0
    method get = field
    method set value = field <- value
  end

let object_value =
  object
    method get = 1
  end

let send_value =
  object_value#get

let new_object =
  new simple_object

let lazy_value =
  lazy 1

let assertion =
  assert true

let try_with value =
  try value with
  | Failure _ -> 0

let try_with_name value =
  try value with
  | exn -> 0

let try_with_any value =
  try value with
  | _ -> 0

let local_exception () =
  let exception Local in
  raise Local

type empty = |

let impossible (value : empty) =
  match value with
  | _ -> .

type extension = ..
type extension += Extension

let extension_value =
  Extension
