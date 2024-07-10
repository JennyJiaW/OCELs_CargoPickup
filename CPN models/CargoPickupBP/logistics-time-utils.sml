(* TIME unit is seconds*)
val minute = 60.0;
val hour = 60.0*minute;
val day = 24.0*hour;
val week = 7.0*day;

fun Mtime() = ModelTime.time():time; 
fun now() = toReal(Mtime());
(* fun Mtime() = valOf (Real.fromString (ModelTime.toString ModelTime.time():time))*)

(* 19842 is the number of days since 1970 *)
(* AEST (Australian Eastern Standard Time) is 10 hours ahead of UTC (Coordinated Universal Time) *)
fun monday_april_29_2024() = 19842.0*day - 10.0*hour;
(* 19844 is the number of days since 1970 *)
fun Wed_may_01_2024() = 19844.0*day - 10.0*hour;
fun tuesday_may_30_2023() = 19507.0*day + 9.0*hour;

fun preprocess_start_time() = monday_april_29_2024();
(* Actual process *)
fun process_start_time() = Wed_may_01_2024();


fun start_time() = preprocess_start_time();

(* fun print_start_time() = Date.fmt "%Y-%m-%d %H:%M:%S" (Date.fromTimeLocal(Time.fromReal(start_time()))); *)

(* TIME OUTPUT mySQL*)
fun t2s(t) = Date.fmt "%Y-%m-%d %H:%M:%S" (Date.fromTimeLocal(Time.fromReal(t+start_time())));

(* fun tinit2s() = Date.fmt "%Y-%m-%d %H:%M:%S" (Date.fromTimeLocal(Time.fromReal(0.0))); *)

(* TIME OUTPUT KEYVALUE*)
fun t2s_alt(t) = Date.fmt "%Y-%m-%d %H:%M:%S" (Date.fromTimeLocal(Time.fromReal(t+process_start_time())));


(* BETA DISTRIBUTION *)
fun ran_beta(low:real,high:real,a:real,b:real) = low + ((high-low)*beta(a,b)):real; 
fun mean_beta(low:real,high:real,a:real,b:real) = low + ((high-low)* (a/(a+b)));
fun mode_beta(low:real,high:real,a:real,b:real) = low + ((high-low)*((a-1.0)/(a+b-2.0)));
fun var_beta(low:real,high:real,a:real,b:real) = ((high-low)*(high-low)* ((a*b)/((a+b)*(a+b)*(a+b+1.0))));
fun stdev_beta(low:real,high:real,a:real,b:real) = Math.sqrt(var_beta(low,high,a,b));


(* TIME FUNCTIONS *)

fun t2date(t) = Date.fromTimeLocal(Time.fromReal(t+start_time()));


fun t2year(t) = Date.year(t2date(t)):int;
fun t2month(t) = Date.month(t2date(t)):Date.month;
fun t2day(t) = Date.day(t2date(t)):int;
fun t2hour(t) = Date.hour(t2date(t)):int;
fun t2minute(t) = Date.minute(t2date(t)):int;
fun t2second(t) = Date.second(t2date(t)):int;
fun t2weekday(t) = Date.weekDay(t2date(t)):Date.weekday;

fun t2monthstr(t) = Date.fmt "%b" (Date.fromTimeLocal(Time.fromReal(t+start_time())));
fun t2weekdaystr(t) = Date.fmt "%a" (Date.fromTimeLocal(Time.fromReal(t+start_time())));

fun remaining_time_hour(t) = hour - ((Real.fromInt(t2minute(t))*minute) + Real.fromInt(t2second(t)));


(* ARRIVAL TIME DISTRIBUTIONS *)

(* arrival time intensities vary from 0.0 to 1.0 and are the product of three factors: yearly influences, weekly influences, and daily influences *)

fun at_month_intensity(m:string) =
case m of 
 "Jan" => 1.0
|"Feb" => 1.0
|"Mar" => 1.0
|"Apr" => 1.0
|"May" => 1.0
|"Jun" => 1.0
|"Jul" => 1.0
|"Aug" => 1.0
|"Sep" => 1.0
|"Oct" => 1.0 
|"Nov" => 1.0
|"Dec" => 1.0
| _ => 1.0;

fun at_weekday_intensity(d:string) =
case d of 
 "Mon" => 1.0
|"Tue" => 1.0
|"Wed" => 1.0
|"Thu" => 1.0
|"Fri" => 0.7
|"Sat" => 0.0
|"Sun" => 0.0
| _ => 1.0;

fun at_hour_intensity(h:int) =
case h of 
 0 => 0.0
|1 => 0.0
|2 => 0.0
|3 => 0.0
|4 => 0.0
|5 => 0.0
|6 => 0.0
|7 => 0.0
|8 => 0.5
|9 => 1.0
|10 => 1.0
|11 => 1.0
|12 => 1.0
|13 => 1.0
|14 => 1.0
|15 => 1.0
|16 => 1.0
|17 => 1.0
|18 => 1.0
|19 => 0.5
|20 => 0.5
|21 => 0.0
|22 => 0.0
|23 => 0.0
| _ => 1.0;
 
(* overall intensity *)
fun at_intensity(t) = at_month_intensity(t2monthstr(t))*at_weekday_intensity(t2weekdaystr(t))*
at_hour_intensity(t2hour(t));

(* Use this function to sample interarrival times: t is the current time and d is the net delay: It moves forward based on intensities: the lower the intensity, the longer the delay in absolute time.*) 
fun rel_at_delay(t,d) = 
if d < 0.0001
   then 0.0
   else if d < remaining_time_hour(t)*at_intensity(t)
        then d/at_intensity(t)
        else rel_at_delay(t+remaining_time_hour(t),
            d-(remaining_time_hour(t)*at_intensity(t)))+hour; 

(* same but now without indicating current time explicitly *)
fun r_at_delay(d) = rel_at_delay(now(),d);

(* the average ratio between effective/net time (parameter d) and delay in actual time*)
val eff_at_factor = r_at_delay(52.0*week)/(52.0*week);

(* normalized interarrival time delay using the ratio above *)
fun norm_rel_at_delay(t,d) = rel_at_delay(t,d/eff_at_factor) ;


(* normalized  interarrival time delay using the ratio above *)
fun norm_r_at_delay(d) = r_at_delay(d/eff_at_factor) ;

(* SERVICE TIME DISTRIBUTIONS *)

(* service time intensities vary from 0.0 to 1.0 and are the product of three factors: yearly influences, weekly influences, and daily influences *)

fun st_month_intensity(m:string) =
case m of 
 "Jan" => 1.0
|"Feb" => 1.0
|"Mar" => 1.0
|"Apr" => 1.0
|"May" => 1.0
|"Jun" => 1.0
|"Jul" => 0.7
|"Aug" => 0.5
|"Sep" => 1.0
|"Oct" => 1.0 
|"Nov" => 1.0
|"Dec" => 0.8
| _ => 1.0;

fun st_weekday_intensity(d:string) =
case d of 
 "Mon" => 0.9
|"Tue" => 1.0
|"Wed" => 1.0
|"Thu" => 1.0
|"Fri" => 0.8
|"Sat" => 0.0
|"Sun" => 0.0
| _ => 1.0;

fun st_hour_intensity(h:int) =
case h of 
 0 => 0.0
|1 => 0.0
|2 => 0.0
|3 => 0.0
|4 => 0.0
|5 => 0.0
|6 => 0.0
|7 => 0.5
|8 => 0.5
|9 => 1.0
|10 => 1.0
|11 => 1.0
|12 => 0.0
|13 => 0.8
|14 => 1.0
|15 => 1.0
|16 => 0.8
|17 => 0.3
|18 => 0.1
|19 => 0.0
|20 => 0.0
|21 => 0.0
|22 => 0.0
|23 => 0.0
| _ => 1.0;
 

fun st_intensity(t) = st_month_intensity(t2monthstr(t))*
st_weekday_intensity(t2weekdaystr(t))*
st_hour_intensity(t2hour(t));


(* Use this function to sample service times: t is the current time and d is the net delay: It moves forward based on intensities: the lower the intensity, the longer the delay in absolute time.*)
fun rel_st_delay(t,d) = 
if d < 0.0001
   then 0.0
   else if d < remaining_time_hour(t)*st_intensity(t)
        then d/st_intensity(t)
        else rel_st_delay(t+remaining_time_hour(t),
            d-(remaining_time_hour(t)*st_intensity(t)))+hour;

(* same but now without indicating current time explicitly *)
fun r_st_delay(d) = rel_st_delay(now(),d);

(* the average ratio between effective/net time (parameter d) and delay in actual time*)
val eff_st_factor = r_st_delay(52.0*week)/(52.0*week);

(* normalized service time delay using the ratio above *)
fun norm_rel_st_delay(t,d) = rel_st_delay(t,d/eff_st_factor) ;

(* normalized service time delay using the ratio above *)
fun norm_r_st_delay(d) = r_st_delay(d/eff_st_factor);

fun expb_h(av:real, mn:real, high:real) = 
let 
	val x = exponential(1.0/av) 
in 
	if (x > high orelse x < mn)
	then expb_h(av,mn,high) 
	else x 
end
(*fun expb_st(av:real, high:real) = norm_r_st_delay(expb_h(av,high));
fun norm_st(av:real, stdv:real) = norm_r_st_delay(normal(av,stdv));*)
fun norm_st(av:real, stdv:real) = r_st_delay(normal(av,stdv));
fun expb_st(av:real, mn:real, high:real) = r_st_delay(expb_h(av,mn,high));