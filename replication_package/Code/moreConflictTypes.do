clear
set more off

*MAIN RESULTS WITH DIFFERENT CONFLICT TYPES
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

/*PREAMBLE*/

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

* table 1 but with capital stock
xi: reg lnlights_001 Siege_250_1757 lnpdgpd1990 , r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)	
	estadd scalar stb = beta[1,1]
	estimates store main1
	
xi: reg lnlights_001 Siege_250_1757  lnpdgpd1990 i.state_gadm, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main2

xi: reg lnlights_001 Siege_250_1757   lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main3
	
esttab main1 main2 main3 using table1_moreConflicts_Siege.tex, ///
	replace fragment keep(Siege_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Siege_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	



/*Table 2: IV but with K_1600*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"
		
/*First stage*/

xi: reg Siege_250_1757 instrument lnpdgpd1990 , r beta
	estadd ysumm
	estimates store iv_firststage1

xi: reg Siege_250_1757 instrument lnpdgpd1990  i.state_gadm, r beta
	estadd ysumm
	estimates store iv_firststage2

xi: reg Siege_250_1757 instrument lnpdgpd1990  i.state_gadm `controls_gis', r beta
	estadd ysumm
	estimates store iv_firststage3
	
esttab iv_firststage1 iv_firststage2 iv_firststage3 using table2a_moreConflicts_Siege.tex, ///
	replace fragment keep(instrument) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(instrument "Proximity to Khyber Pass") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

/*Second stage*/

xi: ivreg2 lnlights_001 (Siege_250_1757=instrument) lnpdgpd1990 , r ffirst
	estadd ysumm
	estimates store iv_secondstage1
	
	
xi: ivreg2 lnlights_001 (Siege_250_1757=instrument) lnpdgpd1990  i.state_gadm, r ffirst
	estadd ysumm
	estimates store iv_secondstage2

xi: ivreg2 lnlights_001 (Siege_250_1757=instrument) lnpdgpd1990  i.state_gadm `controls_gis', r ffirst
	estadd ysumm
	estimates store iv_secondstage3

esttab iv_secondstage1 iv_secondstage2 iv_secondstage3 using table2b_moreConflicts_Siege.tex, ///
	replace fragment keep(Siege_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("archi2p Anderson-Rubin p-value" "widstat Kleibergen-Paap Wald rk F-statistic") sfmt(3) ///
	coeflabel(Siege_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")
	
	
	
********************************************************************************************************
*Naval

/*Table 1: Main Results*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear


local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

* table 1 but with capital stock
xi: reg lnlights_001 Naval_250_1757 lnpdgpd1990 , r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)	
	estadd scalar stb = beta[1,1]
	estimates store main1
	
xi: reg lnlights_001 Naval_250_1757  lnpdgpd1990 i.state_gadm, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main2

xi: reg lnlights_001 Naval_250_1757   lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main3
	
esttab main1 main2 main3 using table1_moreConflicts_Naval.tex, ///
	replace fragment keep(Naval_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Naval_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	



/*Table 2: IV but with K_1600*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"
		
/*First stage*/

xi: reg Naval_250_1757 instrument lnpdgpd1990 , r beta
	estadd ysumm
	estimates store iv_firststage1

xi: reg Naval_250_1757 instrument lnpdgpd1990  i.state_gadm, r beta
	estadd ysumm
	estimates store iv_firststage2

xi: reg Naval_250_1757 instrument lnpdgpd1990  i.state_gadm `controls_gis', r beta
	estadd ysumm
	estimates store iv_firststage3
	
esttab iv_firststage1 iv_firststage2 iv_firststage3 using table2a_moreConflicts_Naval.tex, ///
	replace fragment keep(instrument) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(instrument "Proximity to Khyber Pass") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

/*Second stage*/

xi: ivreg2 lnlights_001 (Naval_250_1757=instrument) lnpdgpd1990 , r ffirst
	estadd ysumm
	estimates store iv_secondstage1
	
	
xi: ivreg2 lnlights_001 (Naval_250_1757=instrument) lnpdgpd1990  i.state_gadm, r ffirst
	estadd ysumm
	estimates store iv_secondstage2

xi: ivreg2 lnlights_001 (Naval_250_1757=instrument) lnpdgpd1990  i.state_gadm `controls_gis', r ffirst
	estadd ysumm
	estimates store iv_secondstage3

esttab iv_secondstage1 iv_secondstage2 iv_secondstage3 using table2b_moreConflicts_Naval.tex, ///
	replace fragment keep(Naval_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("archi2p Anderson-Rubin p-value" "widstat Kleibergen-Paap Wald rk F-statistic") sfmt(3) ///
	coeflabel(Naval_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")		
	

********************************************************************************************************
*Storming

/*Table 1: Main Results*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear


local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

* table 1 but with capital stock
xi: reg lnlights_001 Storming_250_1757 lnpdgpd1990 , r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)	
	estadd scalar stb = beta[1,1]
	estimates store main1
	
xi: reg lnlights_001 Storming_250_1757  lnpdgpd1990 i.state_gadm, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main2

xi: reg lnlights_001 Storming_250_1757   lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main3
	
esttab main1 main2 main3 using table1_moreConflicts_Storming.tex, ///
	replace fragment keep(Storming_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Storming_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	



/*Table 2:*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"
		
/*First stage*/

xi: reg Storming_250_1757 instrument lnpdgpd1990 , r beta
	estadd ysumm
	estimates store iv_firststage1

xi: reg Storming_250_1757 instrument lnpdgpd1990  i.state_gadm, r beta
	estadd ysumm
	estimates store iv_firststage2

xi: reg Storming_250_1757 instrument lnpdgpd1990  i.state_gadm `controls_gis', r beta
	estadd ysumm
	estimates store iv_firststage3
	
esttab iv_firststage1 iv_firststage2 iv_firststage3 using table2a_moreConflicts_Storming.tex, ///
	replace fragment keep(instrument) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(instrument "Proximity to Khyber Pass") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

/*Second stage*/

xi: ivreg2 lnlights_001 (Storming_250_1757=instrument) lnpdgpd1990 , r ffirst
	estadd ysumm
	estimates store iv_secondstage1
	
	
xi: ivreg2 lnlights_001 (Storming_250_1757=instrument) lnpdgpd1990  i.state_gadm, r ffirst
	estadd ysumm
	estimates store iv_secondstage2

xi: ivreg2 lnlights_001 (Storming_250_1757=instrument) lnpdgpd1990  i.state_gadm `controls_gis', r ffirst
	estadd ysumm
	estimates store iv_secondstage3

esttab iv_secondstage1 iv_secondstage2 iv_secondstage3 using table2b_moreConflicts_Storming.tex, ///
	replace fragment keep(Storming_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("archi2p Anderson-Rubin p-value" "widstat Kleibergen-Paap Wald rk F-statistic") sfmt(3) ///
	coeflabel(Storming_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")
	
	
	
********************************************************************************************************
*SackingRazing

/*Table 1: Main Results*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear


local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

* table 1 but with capital stock
xi: reg lnlights_001 SackingRazing_250_1757 lnpdgpd1990 , r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)	
	estadd scalar stb = beta[1,1]
	estimates store main1
	
xi: reg lnlights_001 SackingRazing_250_1757  lnpdgpd1990 i.state_gadm, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main2

xi: reg lnlights_001 SackingRazing_250_1757   lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main3
	
esttab main1 main2 main3 using table1_moreConflicts_SackingRazing.tex, ///
	replace fragment keep(SackingRazing_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(SackingRazing_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	



/*Table 2:*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"
		
/*First stage*/

xi: reg SackingRazing_250_1757 instrument lnpdgpd1990 , r beta
	estadd ysumm
	estimates store iv_firststage1

xi: reg SackingRazing_250_1757 instrument lnpdgpd1990  i.state_gadm, r beta
	estadd ysumm
	estimates store iv_firststage2

xi: reg SackingRazing_250_1757 instrument lnpdgpd1990  i.state_gadm `controls_gis', r beta
	estadd ysumm
	estimates store iv_firststage3
	
esttab iv_firststage1 iv_firststage2 iv_firststage3 using table2a_moreConflicts_SackingRazing.tex, ///
	replace fragment keep(instrument) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(instrument "Proximity to Khyber Pass") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

/*Second stage*/

xi: ivreg2 lnlights_001 (SackingRazing_250_1757=instrument) lnpdgpd1990 , r ffirst
	estadd ysumm
	estimates store iv_secondstage1
	
	
xi: ivreg2 lnlights_001 (SackingRazing_250_1757=instrument) lnpdgpd1990  i.state_gadm, r ffirst
	estadd ysumm
	estimates store iv_secondstage2

xi: ivreg2 lnlights_001 (SackingRazing_250_1757=instrument) lnpdgpd1990  i.state_gadm `controls_gis', r ffirst
	estadd ysumm
	estimates store iv_secondstage3

esttab iv_secondstage1 iv_secondstage2 iv_secondstage3 using table2b_moreConflicts_SackingRazing.tex, ///
	replace fragment keep(SackingRazing_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("archi2p Anderson-Rubin p-value" "widstat Kleibergen-Paap Wald rk F-statistic") sfmt(3) ///
	coeflabel(SackingRazing_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	
	

********************************************************************************************************
*Other

/*Table 1: Main Results*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear


local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

* table 1 but with capital stock
xi: reg lnlights_001 Other_250_1757 lnpdgpd1990 , r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)	
	estadd scalar stb = beta[1,1]
	estimates store main1
	
xi: reg lnlights_001 Other_250_1757  lnpdgpd1990 i.state_gadm, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main2

xi: reg lnlights_001 Other_250_1757   lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main3
	
esttab main1 main2 main3 using table1_moreConflicts_Other.tex, ///
	replace fragment keep(Other_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Other_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	



/*Table 2:*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"
		
/*First stage*/

xi: reg Other_250_1757 instrument lnpdgpd1990 , r beta
	estadd ysumm
	estimates store iv_firststage1

xi: reg Other_250_1757 instrument lnpdgpd1990  i.state_gadm, r beta
	estadd ysumm
	estimates store iv_firststage2

xi: reg Other_250_1757 instrument lnpdgpd1990  i.state_gadm `controls_gis', r beta
	estadd ysumm
	estimates store iv_firststage3
	
esttab iv_firststage1 iv_firststage2 iv_firststage3 using table2a_moreConflicts_Other.tex, ///
	replace fragment keep(instrument) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(instrument "Proximity to Khyber Pass") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

/*Second stage*/

xi: ivreg2 lnlights_001 (Other_250_1757=instrument) lnpdgpd1990 , r ffirst
	estadd ysumm
	estimates store iv_secondstage1
	
	
xi: ivreg2 lnlights_001 (Other_250_1757=instrument) lnpdgpd1990  i.state_gadm, r ffirst
	estadd ysumm
	estimates store iv_secondstage2

xi: ivreg2 lnlights_001 (Other_250_1757=instrument) lnpdgpd1990  i.state_gadm `controls_gis', r ffirst
	estadd ysumm
	estimates store iv_secondstage3

esttab iv_secondstage1 iv_secondstage2 iv_secondstage3 using table2b_moreConflicts_Other.tex, ///
	replace fragment keep(Other_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("archi2p Anderson-Rubin p-value" "widstat Kleibergen-Paap Wald rk F-statistic") sfmt(3) ///
	coeflabel(Other_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	
	

********************************************************************************************************
*Oneday

/*Table 1: Main Results*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear


local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

* table 1 but with capital stock
xi: reg lnlights_001 Oneday_250_1757 lnpdgpd1990 , r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)	
	estadd scalar stb = beta[1,1]
	estimates store main1
	
xi: reg lnlights_001 Oneday_250_1757  lnpdgpd1990 i.state_gadm, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main2

xi: reg lnlights_001 Oneday_250_1757   lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main3
	
esttab main1 main2 main3 using table1_moreConflicts_Oneday.tex, ///
	replace fragment keep(Oneday_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Oneday_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	



/*Table 2:*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"
		
/*First stage*/

xi: reg Oneday_250_1757 instrument lnpdgpd1990 , r beta
	estadd ysumm
	estimates store iv_firststage1

xi: reg Oneday_250_1757 instrument lnpdgpd1990  i.state_gadm, r beta
	estadd ysumm
	estimates store iv_firststage2

xi: reg Oneday_250_1757 instrument lnpdgpd1990  i.state_gadm `controls_gis', r beta
	estadd ysumm
	estimates store iv_firststage3
	
esttab iv_firststage1 iv_firststage2 iv_firststage3 using table2a_moreConflicts_Oneday.tex, ///
	replace fragment keep(instrument) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(instrument "Proximity to Khyber Pass") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

/*Second stage*/

xi: ivreg2 lnlights_001 (Oneday_250_1757=instrument) lnpdgpd1990 , r ffirst
	estadd ysumm
	estimates store iv_secondstage1
	
	
xi: ivreg2 lnlights_001 (Oneday_250_1757=instrument) lnpdgpd1990  i.state_gadm, r ffirst
	estadd ysumm
	estimates store iv_secondstage2

xi: ivreg2 lnlights_001 (Oneday_250_1757=instrument) lnpdgpd1990  i.state_gadm `controls_gis', r ffirst
	estadd ysumm
	estimates store iv_secondstage3

esttab iv_secondstage1 iv_secondstage2 iv_secondstage3 using table2b_moreConflicts_Oneday.tex, ///
	replace fragment keep(Oneday_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("archi2p Anderson-Rubin p-value" "widstat Kleibergen-Paap Wald rk F-statistic") sfmt(3) ///
	coeflabel(Oneday_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	
	
********************************************************************************************************
*Multiday

/*Table 1: Main Results*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear


local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

* table 1 but with capital stock
xi: reg lnlights_001 Multiday_250_1757 lnpdgpd1990 , r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)	
	estadd scalar stb = beta[1,1]
	estimates store main1
	
xi: reg lnlights_001 Multiday_250_1757  lnpdgpd1990 i.state_gadm, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main2

xi: reg lnlights_001 Multiday_250_1757   lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main3
	
esttab main1 main2 main3 using table1_moreConflicts_Multiday.tex, ///
	replace fragment keep(Multiday_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Multiday_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	



/*Table 2:*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"
		
/*First stage*/

xi: reg Multiday_250_1757 instrument lnpdgpd1990 , r beta
	estadd ysumm
	estimates store iv_firststage1

xi: reg Multiday_250_1757 instrument lnpdgpd1990  i.state_gadm, r beta
	estadd ysumm
	estimates store iv_firststage2

xi: reg Multiday_250_1757 instrument lnpdgpd1990  i.state_gadm `controls_gis', r beta
	estadd ysumm
	estimates store iv_firststage3
	
esttab iv_firststage1 iv_firststage2 iv_firststage3 using table2a_moreConflicts_Multiday.tex, ///
	replace fragment keep(instrument) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(instrument "Proximity to Khyber Pass") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

/*Second stage*/

xi: ivreg2 lnlights_001 (Multiday_250_1757=instrument) lnpdgpd1990 , r ffirst
	estadd ysumm
	estimates store iv_secondstage1
	
	
xi: ivreg2 lnlights_001 (Multiday_250_1757=instrument) lnpdgpd1990  i.state_gadm, r ffirst
	estadd ysumm
	estimates store iv_secondstage2

xi: ivreg2 lnlights_001 (Multiday_250_1757=instrument) lnpdgpd1990  i.state_gadm `controls_gis', r ffirst
	estadd ysumm
	estimates store iv_secondstage3

esttab iv_secondstage1 iv_secondstage2 iv_secondstage3 using table2b_moreConflicts_Multiday.tex, ///
	replace fragment keep(Multiday_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("archi2p Anderson-Rubin p-value" "widstat Kleibergen-Paap Wald rk F-statistic") sfmt(3) ///
	coeflabel(Multiday_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

********************************************************************************************************
*Multiyear

/*Table 1: Main Results*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear


local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

* table 1 but with capital stock
xi: reg lnlights_001 Multiyear_250_1757 lnpdgpd1990 , r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)	
	estadd scalar stb = beta[1,1]
	estimates store main1
	
xi: reg lnlights_001 Multiyear_250_1757  lnpdgpd1990 i.state_gadm, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main2

xi: reg lnlights_001 Multiyear_250_1757   lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main3
	
esttab main1 main2 main3 using table1_moreConflicts_Multiyear.tex, ///
	replace fragment keep(Multiyear_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Multiyear_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	



/*Table 2:*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"
		
/*First stage*/

xi: reg Multiyear_250_1757 instrument lnpdgpd1990 , r beta
	estadd ysumm
	estimates store iv_firststage1

xi: reg Multiyear_250_1757 instrument lnpdgpd1990  i.state_gadm, r beta
	estadd ysumm
	estimates store iv_firststage2

xi: reg Multiyear_250_1757 instrument lnpdgpd1990  i.state_gadm `controls_gis', r beta
	estadd ysumm
	estimates store iv_firststage3
	
esttab iv_firststage1 iv_firststage2 iv_firststage3 using table2a_moreConflicts_Multiyear.tex, ///
	replace fragment keep(instrument) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(instrument "Proximity to Khyber Pass") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

/*Second stage*/

xi: ivreg2 lnlights_001 (Multiyear_250_1757=instrument) lnpdgpd1990 , r ffirst
	estadd ysumm
	estimates store iv_secondstage1
	
	
xi: ivreg2 lnlights_001 (Multiyear_250_1757=instrument) lnpdgpd1990  i.state_gadm, r ffirst
	estadd ysumm
	estimates store iv_secondstage2

xi: ivreg2 lnlights_001 (Multiyear_250_1757=instrument) lnpdgpd1990  i.state_gadm `controls_gis', r ffirst
	estadd ysumm
	estimates store iv_secondstage3

esttab iv_secondstage1 iv_secondstage2 iv_secondstage3 using table2b_moreConflicts_Multiyear.tex, ///
	replace fragment keep(Multiyear_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("archi2p Anderson-Rubin p-value" "widstat Kleibergen-Paap Wald rk F-statistic") sfmt(3) ///
	coeflabel(Multiyear_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	
	
********************************************************************************************************
*Conflict

/*Table 1: Main Results*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear


local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

* table 1 but with capital stock
xi: reg lnlights_001 Conflict_250_1757 lnpdgpd1990 , r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)	
	estadd scalar stb = beta[1,1]
	estimates store main1
	
xi: reg lnlights_001 Conflict_250_1757  lnpdgpd1990 i.state_gadm, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main2

xi: reg lnlights_001 Conflict_250_1757   lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main3
	
esttab main1 main2 main3 using table1_moreConflicts_Conflict.tex, ///
	replace fragment keep(Conflict_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Conflict_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	



/*Table 2:*/

cd "$output"
use "$cleandata/conflictexposure.dta", clear

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"
		
/*First stage*/

xi: reg Conflict_250_1757 instrument lnpdgpd1990 , r beta
	estadd ysumm
	estimates store iv_firststage1

xi: reg Conflict_250_1757 instrument lnpdgpd1990  i.state_gadm, r beta
	estadd ysumm
	estimates store iv_firststage2

xi: reg Conflict_250_1757 instrument lnpdgpd1990  i.state_gadm `controls_gis', r beta
	estadd ysumm
	estimates store iv_firststage3
	
esttab iv_firststage1 iv_firststage2 iv_firststage3 using table2a_moreConflicts_Conflict.tex, ///
	replace fragment keep(instrument) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(instrument "Proximity to Khyber Pass") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

/*Second stage*/

xi: ivreg2 lnlights_001 (Conflict_250_1757=instrument) lnpdgpd1990 , r ffirst
	estadd ysumm
	estimates store iv_secondstage1
	
	
xi: ivreg2 lnlights_001 (Conflict_250_1757=instrument) lnpdgpd1990  i.state_gadm, r ffirst
	estadd ysumm
	estimates store iv_secondstage2

xi: ivreg2 lnlights_001 (Conflict_250_1757=instrument) lnpdgpd1990  i.state_gadm `controls_gis', r ffirst
	estadd ysumm
	estimates store iv_secondstage3

esttab iv_secondstage1 iv_secondstage2 iv_secondstage3 using table2b_moreConflicts_Conflict.tex, ///
	replace fragment keep(Conflict_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("archi2p Anderson-Rubin p-value" "widstat Kleibergen-Paap Wald rk F-statistic") sfmt(3) ///
	coeflabel(Conflict_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	
	

