clear
set more off

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************


global maps $desktop/Data
global dofiles $desktop/Data
global cleandata $desktop/Data
global rawdata $desktop/Data
global output $desktop/Output

********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************

/*TABLES IN TEXT*/

********************************************************************************
********************************************************************************
********************************************************************************

/*Table 1: Main Results*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

xi: reg lnlights_001 Land_250_1757 lnpdgpd1990, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main1
	
xi: reg lnlights_001 Land_250_1757 lnpdgpd1990 i.state_gadm, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main2

xi: reg lnlights_001 Land_250_1757 lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main3
	
esttab main1 main2 main3 using table1.tex, ///
	replace fragment keep(Land_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Land_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

/*Compute within R-squared values*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

cap erase table1_withinr2.xml
cap erase table1_withinr2.txt
reghdfe lnlights_001 Land_250_1757 lnpdgpd1990, noabsorb vce(robust) 
	outreg2 using table1_withinr2, addstat(Within R2,e(r2_a_within)) keep(Land_250_1757) excel nocon label append
reghdfe lnlights_001 Land_250_1757 lnpdgpd1990, a(state) vce(robust) 
	outreg2 using table1_withinr2, addstat(Within R2,e(r2_a_within)) keep(Land_250_1757) excel nocon label append
reghdfe lnlights_001 Land_250_1757 lnpdgpd1990 `controls_gis', a(state) vce(robust)
	outreg2 using table1_withinr2, addstat(Within R2,e(r2_a_within)) keep(Land_250_1757) excel nocon label append
cap erase table1_withinr2.txt

/*
We have manually added the following after the "R2" line in Tex file:

Within \(R^{2}\) & 0.597 & 0.574 & 0.617 \\
*/

********************************************************************************
********************************************************************************
********************************************************************************

/*Table 2: IV*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"
		
/*First stage*/

xi: reg Land_250_1757 instrument lnpdgpd1990, r beta
	estadd ysumm
	estimates store iv_firststage1

xi: reg Land_250_1757 instrument lnpdgpd1990 i.state_gadm, r beta
	estadd ysumm
	estimates store iv_firststage2

xi: reg Land_250_1757 instrument lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estimates store iv_firststage3
	
esttab iv_firststage1 iv_firststage2 iv_firststage3 using table2a.tex, ///
	replace fragment keep(instrument) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(instrument "Proximity to Khyber Pass") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

/*Second stage*/

xi: ivreg2 lnlights_001 (Land_250_1757=instrument) lnpdgpd1990, r ffirst
	estadd ysumm
	estimates store iv_secondstage1
	
xi: ivreg2 lnlights_001 (Land_250_1757=instrument) lnpdgpd1990 i.state_gadm, r ffirst
	estadd ysumm
	estimates store iv_secondstage2

xi: ivreg2 lnlights_001 (Land_250_1757=instrument) lnpdgpd1990 i.state_gadm `controls_gis', r ffirst
	estadd ysumm
	estimates store iv_secondstage3

esttab iv_secondstage1 iv_secondstage2 iv_secondstage3 using table2b.tex, ///
	replace fragment keep(Land_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("archi2p Anderson-Rubin p-value" "widstat Kleibergen-Paap Wald rk F-statistic") sfmt(3) ///
	coeflabel(Land_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	


*Table  6

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

su Land_250_1000_1100
su Land_250_1100_1200 
su Land_250_1200_1300 
su Land_250_1300_1400 
su Land_250_1400_1500 
su Land_250_1500_1600
su Land_250_1600_1700 
su Land_250_1700_1800 
su Land_250_1757
 
