
use "$data/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"


xi: reg lnlights_001 lnpdgpd1990 i.state_gadm `controls_gis' Land_250_1000_1100, r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1] 
	estimates store rob1
    outreg2 using  "$output/timeperiodrep_tab1.tex", replace ctitle("Conflict Exposure 1000-1100") keep(Land_250_1000_1100) 
	
xi: reg lnlights_001 lnpdgpd1990 i.state_gadm `controls_gis' Land_250_1100_1200, r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store rob2
	outreg2 using  "$output/timeperiodrep_tab1.tex", append ctitle("Conflict Exposure 1100-1200") keep(Land_250_1100_1200) 

	
xi: reg lnlights_001 lnpdgpd1990 i.state_gadm `controls_gis' Land_250_1200_1300, r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store rob3
	outreg2 using  "$output/timeperiodrep_tab1.tex", append ctitle("Conflict Exposure 1200-1300") keep(Land_250_1200_1300) 
	
xi: reg lnlights_001 lnpdgpd1990 i.state_gadm `controls_gis' Land_250_1300_1400, r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store rob4
	outreg2 using  "$output/timeperiodrep_tab1.tex", append ctitle("Conflict Exposure 1300-1400") keep(Land_250_1300_1400) 

xi: reg lnlights_001 lnpdgpd1990 i.state_gadm `controls_gis' Land_250_1400_1500, r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store rob5
	outreg2 using  "$output/timeperiodrep_tab1.tex", append ctitle("Conflict Exposure 1400-1500") keep(Land_250_1400_1500) 

xi: reg lnlights_001 lnpdgpd1990 i.state_gadm `controls_gis' Land_250_1500_1600, r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store rob6
	outreg2 using  "$output/timeperiodrep_tab1.tex", append ctitle("Conflict Exposure 1500-1600") keep(Land_250_1500_1600) 

xi: reg lnlights_001 lnpdgpd1990 i.state_gadm `controls_gis' Land_250_1600_1700, r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store rob7
	outreg2 using  "$output/timeperiodrep_tab1.tex", append ctitle("Conflict Exposure 1600-1700") keep(Land_250_1600_1700) 


/*Compute within R-squared values*/

use "$data/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

cap erase table1_withinr2.xml
cap erase table1_withinr2.txt

reghdfe lnlights_001 Land_250_1000_1100 lnpdgpd1990 `controls_gis', a(state) vce(robust)
	outreg2 using table1_withinr2, addstat(Within R2,e(r2_a_within)) keep(Land_250_1000_1100) excel nocon label replace
	
reghdfe lnlights_001 Land_250_1100_1200 lnpdgpd1990 `controls_gis', a(state) vce(robust)
	outreg2 using table1_withinr2, addstat(Within R2,e(r2_a_within)) keep(Land_250_1100_1200) excel nocon label append
	
reghdfe lnlights_001 Land_250_1200_1300 lnpdgpd1990 `controls_gis', a(state) vce(robust)
	outreg2 using table1_withinr2, addstat(Within R2,e(r2_a_within)) keep(Land_250_1200_1300) excel nocon label append

reghdfe lnlights_001 Land_250_1300_1400 lnpdgpd1990 `controls_gis', a(state) vce(robust)
	outreg2 using table1_withinr2, addstat(Within R2,e(r2_a_within)) keep(Land_250_1300_1400) excel nocon label append

reghdfe lnlights_001 Land_250_1400_1500 lnpdgpd1990 `controls_gis', a(state) vce(robust)
	outreg2 using table1_withinr2, addstat(Within R2,e(r2_a_within)) keep(Land_250_1400_1500) excel nocon label append

reghdfe lnlights_001 Land_250_1500_1600 lnpdgpd1990 `controls_gis', a(state) vce(robust)
	outreg2 using table1_withinr2, addstat(Within R2,e(r2_a_within)) keep(Land_250_1500_1600) excel nocon label append

reghdfe lnlights_001 Land_250_1600_1700 lnpdgpd1990 `controls_gis', a(state) vce(robust)
	outreg2 using table1_withinr2, addstat(Within R2,e(r2_a_within)) keep(Land_250_1600_1700) excel nocon label append

cap erase table1_withinr2.txt



/*Table 2: IV*/

use "$data/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"
		
/*First stage*/

xi: reg Land_250_1000_1100 instrument lnpdgpd1990 i.state_gadm `controls_gis', r beta
	outreg2 using  "$output/timeperiodrep_tab2.tex", replace ctitle("Conflict Exposure 1000-1100") keep(instrument) 

xi: reg Land_250_1100_1200 instrument lnpdgpd1990 i.state_gadm `controls_gis', r beta
	outreg2 using  "$output/timeperiodrep_tab2.tex", append ctitle("Conflict Exposure 1100-1200") keep(instrument) 
	
xi: reg Land_250_1200_1300 instrument lnpdgpd1990 i.state_gadm `controls_gis', r beta
	outreg2 using  "$output/timeperiodrep_tab2.tex", append ctitle("Conflict Exposure 1200-1300") keep(instrument) 
	
xi: reg Land_250_1300_1400 instrument lnpdgpd1990 i.state_gadm `controls_gis', r beta
	outreg2 using  "$output/timeperiodrep_tab2.tex", append ctitle("Conflict Exposure 1300-1400") keep(instrument) 
	
xi: reg Land_250_1400_1500 instrument lnpdgpd1990 i.state_gadm `controls_gis', r beta
	outreg2 using  "$output/timeperiodrep_tab2.tex", append ctitle("Conflict Exposure 1400-1500") keep(instrument) 
	
xi: reg Land_250_1500_1600 instrument lnpdgpd1990 i.state_gadm `controls_gis', r beta
	outreg2 using  "$output/timeperiodrep_tab2.tex", append ctitle("Conflict Exposure 1500-1600") keep(instrument) 
	
xi: reg Land_250_1600_1700 instrument lnpdgpd1990 i.state_gadm `controls_gis', r beta
	outreg2 using  "$output/timeperiodrep_tab2.tex", append ctitle("Conflict Exposure 1600-1700") keep(instrument) 


/*Second stage*/

xi: ivreg2 lnlights_001 (Land_250_1000_1100=instrument) lnpdgpd1990 i.state_gadm `controls_gis', r ffirst
	outreg2 using  "$output/timeperiodrep_tab2.tex", replace ctitle("Conflict Exposure 1000-1100")

xi: ivreg2 lnlights_001 (Land_250_1100_1200=instrument) lnpdgpd1990 i.state_gadm `controls_gis', r ffirst
	outreg2 using  "$output/timeperiodrep_tab2.tex", append ctitle("Conflict Exposure 1100-1200")
	
xi: ivreg2 lnlights_001 (Land_250_1200_1300=instrument) lnpdgpd1990 i.state_gadm `controls_gis', r ffirst
	outreg2 using  "$output/timeperiodrep_tab2.tex", append ctitle("Conflict Exposure 1200-1300")
	
xi: ivreg2 lnlights_001 (Land_250_1300_1400=instrument) lnpdgpd1990 i.state_gadm `controls_gis', r ffirst
	outreg2 using  "$output/timeperiodrep_tab2.tex", append ctitle("Conflict Exposure 1300-1400")
	
xi: ivreg2 lnlights_001 (Land_250_1500_1600=instrument) lnpdgpd1990 i.state_gadm `controls_gis', r ffirst
	outreg2 using  "$output/timeperiodrep_tab2.tex", append ctitle("Conflict Exposure 1500-1600")	

xi: ivreg2 lnlights_001 (Land_250_1600_1700=instrument) lnpdgpd1990 i.state_gadm `controls_gis', r ffirst
	outreg2 using  "$output/timeperiodrep_tab2.doc", append ctitle("Conflict Exposure 1600-1700")	
	
/*Table 3: Pre-Colonial-Era State-Making*/

use "$data/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

/*Make sample equivalent to benchmark sample*/

xi: reg lnlights_001 Land_250_1526 lnpdgpd1990, r beta
	keep if e(sample)

xi: reg plateVIA4_any Land_250_1500_1757 `controls_gis' i.state_gadm lnhyde1500, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store initialstate21

xi: reg babur Land_250_1500_1757 `controls_gis' i.state_gadm lnhyde1500, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store initialstate22

xi: reg akbar Land_250_1500_1757 `controls_gis' i.state_gadm lnhyde1500, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store initialstate23

xi: reg aurangzeb Land_250_1500_1757 `controls_gis' i.state_gadm lnhyde1500, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store initialstate24
	
esttab initialstate21 initialstate22 initialstate23 initialstate24 using  "$output/timeperiodrep_tab3.tex", ///
	replace fragment keep(Land_250_1500_1757 Land_250_1500_1757 Land_250_1500_1757 Land_250_1500_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-5}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Land_250_1757 "Pre-colonial conflict exposure (benchmark)" ///
	Land_250_1526 "Pre-colonial conflict exposure (1000-1526)" ///
	Land_250_1556 "Pre-colonial conflict exposure (1000-1556)" ///
	Land_250_1658 "Pre-colonial conflict exposure (1000-1658)") ///
	indicate("Population density = lnhyde1500" "State FE = *state*" "Geographic controls = `controls_gis'")	


/*Table 4: Colonial Fiscal Development*/

use "$data/conflictexposure_native.dta", clear

local controls_gis "latitude longitude altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

xi: reg lnlandrevpa Land_250_1500_1757 `controls_gis' i.state_gadm lnhyde1850, r beta
outreg2 using  "$output/timeperiodrep_tab4.tex", replace ctitle("ln(Tax/Area)")	keep(Land_250_1500_1757)


xi: reg lnlandrevpc Land_250_1500_1757 `controls_gis' i.state_gadm lnhyde1850, r beta
outreg2 using  "$output/timeperiodrep_tab4.tex", append ctitle("ln(Tax/Person)") keep(Land_250_1500_1757)
	
xi: reg lnlandrevpaBI Land_250_1500_1757 `controls_gis' i.state_gadm lnhyde1850, r beta
outreg2 using  "$output/timeperiodrep_tab4.tex", append ctitle("ln(Tax/Person), British India") keep(Land_250_1500_1757)

xi: reg lnlandrevpcBI Land_250_1500_1757 `controls_gis' i.state_gadm lnhyde1850, r beta
outreg2 using  "$output/timeperiodrep_tab4.tex", append ctitle("ln(Tax/Area), British India")	keep(Land_250_1500_1757)


xi: reg lnlandrevpaNSII Land_250_1500_1757 `controls_gis' i.state_gadm lnhyde1850, r beta
outreg2 using  "$output/timeperiodrep_tab4.tex", append ctitle("ln(Tax/Person), Princely States")	keep(Land_250_1500_1757)

xi: reg lnlandrevpcNSII Land_250_1500_1757 `controls_gis' i.state_gadm lnhyde1850, r beta
outreg2 using  "$output/timeperiodrep_tab4.tex", append ctitle("ln(Tax/Person), Princely States")	keep(Land_250_1500_1757)

use "$data/leetaxdata.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"

xi: reg lntaxpa Land_250_1500_1757 `controls_gis' i.state_gadm lnhydepd1930, r beta
outreg2 using  "$output/timeperiodrep_tab4.tex", append ctitle("ln(Tax/Area), British India")	keep(Land_250_1500_1757)

xi: reg lntaxpc Land_250_1500_1757 `controls_gis' i.state_gadm lnhydepd1930, r beta
outreg2 using  "$output/timeperiodrep_tab4.tex", append ctitle("ln(Tax/Person), British India") keep(Land_250_1500_1757)


/*Table 5: Colonial and Post-Colonial Conflict*/

use "$data/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

xi: reg Land_250_1758_1839 Land_250_1500_1757 lnhyde1750 i.state_gadm `controls_gis' if lnlights_001!=., r beta
outreg2 using  "$output/timeperiodrep_tab5.tex", replace ctitle("Land battles") keep(Land_250_1500_1757)

xi: reg Conflict_250_1758_1839 Land_250_1500_1757 lnhyde1750 i.state_gadm `controls_gis' if lnlights_001!=., r beta
outreg2 using  "$output/timeperiodrep_tab5.tex", append ctitle("All conflict") keep(Land_250_1500_1757)

xi: reg Land_250_1840_1946 Land_250_1500_1757 lnhyde1850 i.state_gadm `controls_gis' if lnlights_001!=., r beta
outreg2 using  "$output/timeperiodrep_tab5.tex", append ctitle("Land battles") keep(Land_250_1500_1757)

xi: reg Conflict_250_1840_1946 Land_250_1500_1757 lnhyde1850 i.state_gadm `controls_gis' if lnlights_001!=., r beta
outreg2 using  "$output/timeperiodrep_tab5.tex", append ctitle("All conflict") keep(Land_250_1500_1757)

xi: reg Land_250_1947 Land_250_1500_1757 lnhyde1950 i.state_gadm `controls_gis' if lnlights_001!=., r beta
outreg2 using  "$output/timeperiodrep_tab5.tex", append ctitle("Land battles") keep(Land_250_1500_1757)

xi: reg Conflict_250_1947 Land_250_1500_1757 lnhyde1950 i.state_gadm `controls_gis' if lnlights_001!=., r beta
outreg2 using  "$output/timeperiodrep_tab5.tex", append ctitle("All conflict") keep(Land_250_1500_1757)
	
/*Table 6: Conflict and Post-Colonial Political Violence*/

use "$data/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

/*Make sample equivalent to benchmark sample*/

xi: reg lnlights_001 Land_250_1757 lnpdgpd1990, r beta
	keep if e(sample)

xi: reg fatalities2 Land_250_1500_1757 `controls_gis' i.state_gadm lnpdgpd1990, r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
outreg2 using "$output/timeperiodrep_tab6.tex", replace ctitle("Political Violence") keep(Land_250_1500_1757)

//Mukherjee data for column 2 does not have any other time period, so merge
keep state_gadm district_gadm Land_250_1500_1757
rename state_gadm state_
rename district_gadm dist_91_
save "$data/conflictExposure_Land_1500.dta", replace

use "$data/mukherjeedata.dta", clear
merge m:1 state_ dist_91_ using "$data/conflictExposure_Land_1500.dta"

local controls_gis "latitude_gadm_collapsed longitude_gadm_collapsed altit_collapsed nprug_collapsed precip_collapsed ramank_collapsed dryrice_collapsed wrice_collapsed wheat_collapsed kmal_collapsed"

xi: reg maoist_BDI_2003 Land_250_1757 lnpdgpd1990, r beta
	keep if e(sample)

xi: reg maoist_BDI_2003 Land_250_1500_1757 lnpdgpd1990_collapsed i.state `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store polviolence2
outreg2 using  "$output/timeperiodrep_tab6.tex", append ctitle("Maoist Control") keep(Land_250_1500_1757)


	
use "$data/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

xi: reg ethfrac Land_250_1500_1757 lnpdgpd1990 i.state_gadm `controls_gis' if lnlights_001!=., r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
outreg2 using  "$output/timeperiodrep_tab6.tex", append ctitle("Ethnic Fractionalization") keep(Land_250_1500_1757)

xi: reg relfrac_census Land_250_1500_1757 lnpdgpd1990 i.state_gadm `controls_gis' if lnlights_001!=., r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
outreg2 using  "$output/timeperiodrep_tab6.tex", append ctitle("Religious Fractionalization") keep(Land_250_1500_1757)



/*Table 7: Irrigation Infrastructure*/

use "$data/vdsadataclean.dta", clear
local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"

xi: reg prop_canal_312 Land_250_1500_1757 lnhyde1900 i.statename `controls_gis' if lnlights_001!=. & year==1966, r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store aginvest1
outreg2 using  "$output/timeperiodrep_tab7.tex", replace ctitle("1931") keep(Land_250_1500_1757)

use "$data/conflictExposure_Land_1500.dta"
rename state_ state
rename dist_91_ dist_91
save "$data/conflictExposure_Land_1500.dta", replace
use "$data/exposure_bi.dta", clear

merge m:1 state dist_91 using "$data/conflictExposure_Land_1500.dta"

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"

/*Make sample equivalent to benchmark sample*/

xi: reg irr_g_avg2 Land_250_1757 lnpdgpd1990, r beta
	keep if e(sample)

xi: reg irr_g_avg2 Land_250_1500_1757 lnhyde1950 i.state `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store aginvest2
	
outreg2 using  "$output/timeperiodrep_tab7.tex", append ctitle("1956-87") keep(Land_250_1500_1757)

xi: reg lyld_avg Land_250_1500_1757 lnhyde1950 i.state `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store aginvest3
 outreg2 using  "$output/timeperiodrep_tab7.tex", append ctitle("ln(Yield)") keep(Land_250_1500_1757)

use "$data/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

/*Make sample equivalent to benchmark sample*/

xi: reg lnlights_001 Land_250_1500_1757 lnpdgpd1990, r beta
keep if e(sample)==1

xi: reg sh_nonag Land_250_1500_1757 lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store aginvest4
outreg2 using  "$output/timeperiodrep_tab7.tex", append ctitle("% Non-Agriculture") keep(Land_250_1500_1757)


/*Table 8: Literacy*/

use "$data/literacy1881.dta", clear
local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"

xi: reg literacy81 Land_250_1500_1757 lnhyde1850 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store literacy1
outreg2 using  "$output/timeperiodrep_tab8.tex", replace ctitle("1881") keep(Land_250_1500_1757)

use "$data/literacy1921.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if province21=="Andaman and Nicobars"

xi: reg literacy21 Land_250_1500_1757 lnhyde1900 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta, replace
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store literacy2
outreg2 using  "$output/timeperiodrep_tab8.tex", append ctitle("1921") keep(Land_250_1500_1757)


keep province21 district21 Land_250_1500_1757
drop if province21 =="" | district21 ==""
save "$data/landData_1500_1757.dta", replace

use "$data/exposure_bi_literacy.dta", clear
drop if province21 =="" | district21 ==""


merge m:1 province21 district21 using "$data/landData_1500_1757.dta"

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"

xi: reg lrate_avg2 Land_250_1500_1757 lnhyde1950 i.state `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store literacy3
outreg2 using  "$output/timeperiodrep_tab8.tex", append ctitle("1961-91") keep(Land_250_1500_1757)


use "$data/devcensuswgis.dta", clear
drop if province21 =="" | district21 ==""

merge m:1 province21 district21 using "$data/landData_1500_1757.dta"


local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if areaname=="Nicobars" | areaname=="South Andaman" | areaname=="North  & Middle Andaman" | areaname=="Lakshadweep"

xi: reg cinfo324_2011 Land_250_1500_1757 lnpopd2011 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store literacy4
outreg2 using  "$output/timeperiodrep_tab8.tex", append ctitle("2011") keep(Land_250_1500_1757)

/*Table 9: Education*/

//Data for another time period not available


/*Table 9: Education*/

use "$data/bi_educ_exposure.dta", clear

merge m:1 state dist_91 using "$data/conflictExposure_Land_1500.dta"

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"

xi: reg pprimary812 Land_250_1500_1757 lnhyde1950 i.state `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store education1

xi: reg phigh812 Land_250_1500_1757 lnhyde1950 i.state `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store education2
	
use "$data/bi_infmort_exposure.dta", clear

merge m:1 state dist_91 using "$data/conflictExposure_Land_1500.dta"


local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"

xi: reg infmort Land_250_1500_1757 lnhyde1950 i.state `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store education3
	
esttab education1 education2 education3 using  "$output/timeperiodrep_tab9.tex", ///
	replace fragment keep(Land_250_1500_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Land_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = _cons" "State FE = *state*" "Geographic controls = `controls_gis'")

