*** This dataset is UCDP's most disaggregated dataset, covering individual events of organized violence (phenomena of lethal violence occurring at a given time and place). These events are sufficiently fine-grained to be geo-coded down to the level of individual villages, with temporal durations disaggregated to single, individual days.

clear all
set more off


use "$data/01_GEDEvent_v22_1.dta"

tab dyad_name

keep if country == "India" // focus only on India
drop if year <= 2000

drop id relid active_year code_status type_of_violence conflict_dset_id conflict_new_id date_end region event_clarity date_prec gwnob gwnoa low high best deaths_unknown deaths_civilians deaths_b deaths_a date_start side_a_dset_id side_a_new_id side_b_dset_id side_b_new_id source_date source_headline source_office source_article source_headline source_original where_prec where_coordinates where_description country_id geom_wkt longitude latitude priogrid_gid number_of_sources

replace adm_2 = subinstr(adm_2," district","",.)

rename adm_2 district_gadm  // rename the var that the var has the same name as Dineccio et al used
drop dyad_dset_id dyad_new_id side_a side_b country conflict_name dyad_name 



drop if district_gadm == ""
save "$data/02_Indien_conflict.dta", replace

************************************************************************************

clear all
use "$data/02_Indien_conflict.dta"
sort district_gadm
by district_gadm: egen no_incidents = count(district_gadm) 
bysort district_gadm: keep if _n==1

replace no_incidents = 0 if no_incidents ==.

gen no_incidents_100 = no_incidents/ 100
replace no_incidents_100 = 0 if no_incidents_100 ==.

save "$data/03_Indien_conflict_2001_2021", replace

**************
clear all
use "$data/02_Indien_conflict.dta"
drop if year < 2015 
drop if year > 2018
sort district_gadm
by district_gadm: egen no_incidents = count(district_gadm) 
bysort district_gadm: keep if _n==1

replace no_incidents = 0 if no_incidents ==.
gen no_incidents_100 = no_incidents/ 100 // Dineccio et al used the number of incidents divded by 100. Therefore, we also transform the data like this
replace no_incidents_100 = 0 if no_incidents ==.

save "$data/04_Indien_conflict_2015_2018.dta", replace
