(* FILE HANDLING *)

val OBJECT_TYPES = ["Pickup Plan", "Truck", "Cargo", "Silo"]
(* val EVENT_TYPES = ["Create Pickup Plan", "Assign Trucks", "Evaluate the Truck Entry","Weigh the Empty Truck","Load Truck", "Weigh the Loaded Truck", "Evaluate the Truck Exit", "Reject the Truck Entry","Input the Tally Sheet", "Print the Weighing Ticket"]; *)
val SEP = ";";


fun list2string([]) = ""|
list2string(x::l) = x ^ (if l=[] then "" else SEP) ^ list2string(l);

(* attributes *)
(* fun eas_by_type(a: EventType) = []; *)
	
fun oas_by_type(ot: ObjectType) = 
	if ot="Pickup Plan" then ["Cargo ID","Num of trucks","Total pickup weight"] else 
	if ot="Truck" then ["Pickup Plan ID", "Cargo ID", "LPT", "Axles", "Scheduled Pickup Weight", "Truck Status", "Truck Weight"] else 
	if ot="Cargo" then ["Cargo Type", "Cargo stock weight(scheduled)","Silo ID"] else 
	if ot="Silo" then ["Silo Status"] else 
	[];
	
(* table management *)
(* fun event_map_type(a: EventType) = 
	if a="Create Pickup Plan" then "CreatePickupPlan" else 
	if a="Assign Trucks" then "AssignTrucks" else
	if a="Evaluate the Truck Entry" then "EvaluateTruckEntry" else
	if a="Weigh the Empty Truck" then "WeighEmptyTruck" else
	if a="Load Truck" then "LoadTruck" else
	if a="Weigh the Loaded Truck" then "WeighLoadedTruck" else
	if a="Input the Tally Sheet" then "InputTallySheet" else
	if a="Print the Weighing Ticket" then "PrintWeighingTicket" else
	if a="Evaluate the Truck Exit" then "EvaluateTruckExit" else
	if a="Reject the Truck Entry" then "RejectTruckEntry" else
	""; *)
	
fun object_map_type(ot: ObjectType) = 
	if ot="Pickup Plan" then "Pickupplan" else
	if ot="Truck" then "Truck" else
	if ot="Cargo" then "Cargo" else
	if ot="Silo" then "Silo" else
	"";

(* table initializations *)
(* fun create_event_table() = 
let
   val file_id = TextIO.openOut("./event.csv")
   val _ = TextIO.output(file_id, list2string(["ocel_event_id", "ocel_type"])) 
   val _ = TextIO.output(file_id, "\n")
in
   TextIO.closeOut(file_id)
end; *)

fun create_object_table() = 
let
   val file_id = TextIO.openOut("./object.csv")
   val _ = TextIO.output(file_id, list2string(["ocel_id", "ocel_type"])) 
   val _ = TextIO.output(file_id, "\n")
in
   TextIO.closeOut(file_id)
end;

(* fun create_event_object_table() = 
let
   val file_id = TextIO.openOut("./event_object.csv")
   val _ = TextIO.output(file_id, list2string(["ocel_event_id", "ocel_object_id", "ocel_qualifier"])) 
   val _ = TextIO.output(file_id, "\n")
in
   TextIO.closeOut(file_id)
end; *)

(* fun create_object_object_table() = 
let
   val file_id = TextIO.openOut("./object_object.csv")
   val _ = TextIO.output(file_id, list2string(["ocel_source_id", "ocel_target_id", "ocel_qualifier"])) 
   val _ = TextIO.output(file_id, "\n")
in
   TextIO.closeOut(file_id)
end; *)

(* fun write_event_map_types(file_id, []) = () | write_event_map_types(file_id, et::ets) = (TextIO.output(file_id, list2string([et, event_map_type(et)])); TextIO.output(file_id, "\n"); write_event_map_types(file_id, ets))  *)

fun write_object_map_types(file_id, []) = () | write_object_map_types(file_id, ot::ots) = (TextIO.output(file_id, list2string([ot, object_map_type(ot)])); TextIO.output(file_id, "\n"); write_object_map_types(file_id, ots))

(* fun create_event_map_type_table() = 
let
   val file_id = TextIO.openOut("./event_map_type.csv")
   val _ = TextIO.output(file_id, list2string(["ocel_event_type", "ocel_event_type_map"])) 
   val _ = TextIO.output(file_id, "\n")
   val _ = write_event_map_types(file_id, EVENT_TYPES)
in
   TextIO.closeOut(file_id)
end; *)

fun create_object_map_type_table() = 
let
   val file_id = TextIO.openOut("./object_map_type.csv")
   val _ = TextIO.output(file_id, list2string(["ocel_type", "ocel_type_map"])) 
   val _ = TextIO.output(file_id, "\n")
   val _ = write_object_map_types(file_id, OBJECT_TYPES)
in
   TextIO.closeOut(file_id)
end;

(* fun create_event_type_table(a: EventType) = 
let
   val emt = event_map_type(a)
   val eas = eas_by_type(a)
   val file_id = TextIO.openOut("./event_" ^ emt ^ ".csv")
   val _ = TextIO.output(file_id, list2string(["ocel_event_id", "ocel_time"]^^eas)) 
   val _ = TextIO.output(file_id, "\n")
in
   TextIO.closeOut(file_id)
end; *)

(* fun create_event_type_tables([]) = () | create_event_type_tables(a::a_s) = (create_event_type_table(a); create_event_type_tables(a_s)); *)

fun create_object_type_table(ot: ObjectType) = 
let
   val omt = object_map_type(ot)
   val oas = oas_by_type(ot)
   val file_id = TextIO.openOut("./object_" ^ omt ^ ".csv")
   val _ = TextIO.output(file_id, list2string(["ocel_id", "ocel_time", "ocel_changed_field"]^^oas))
   val _ = TextIO.output(file_id, "\n")
in
   TextIO.closeOut(file_id)
end;

fun create_object_type_tables([]) = () | create_object_type_tables(ot::ots) = (create_object_type_table(ot); create_object_type_tables(ots));


(* fun initialize_cargoDB() =
    let
        val outStream = TextIO.openOut("./cargodb.csv")
        val header = ["CargoID", "Cargo Name", "Cargo Weight", "Cargo Location"]
        val _ = TextIO.output(outStream, list2string(header))
        val _ = TextIO.output(outStream, "\n")
    in
        TextIO.closeOut(outStream)
    end;


fun initialize_RFIDReader() =
    let
        val outStream = TextIO.openOut("./rfidrDB.csv")
        val header = ["RFID Reader ID", "Status", "Time", "Tag No"]
        val _ = TextIO.output(outStream, list2string(header))
        val _ = TextIO.output(outStream, "\n")
    in
        TextIO.closeOut(outStream)
    end;    *)

fun initialise_objects() = (
   create_object_table(); 
   create_object_map_type_table(); 
   create_object_type_tables(OBJECT_TYPES)
);