clear all
cap log close
set more off

*ssc install ftools
*ssc install reghdfe
*ssc install ivreg2
*ssc install ranktest

/*PREAMBLE*/

*** set working directory here ****

***********************************
global data $desktop/Data
global output $desktop/Output
global code $desktop/Code

do "$code/wii_replication.do"
do "$code/moreConflictTypes.do"
do "$code/HCED.do"
do "$code/timeperiodreplication.do"
do "01_GEDEvent_final.do"
do "$code/02_uppsala_final.do"

