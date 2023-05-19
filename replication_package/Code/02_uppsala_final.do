
/*Table 6: Conflict and Post-Colonial Political Violence*/

use "$data/conflictexposure.dta", clear

merge m:1 district_gadm using "$data/03_Indien_conflict_2001_2021" // merge the new conflict data and the UCDP data covering teh time 2001 to 2021

replace no_incidents_100 = 0 if no_incidents ==.

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

/*Make sample equivalent to benchmark sample*/

xi: reg lnlights_001 Land_250_1757 lnpdgpd1990, r beta
	keep if e(sample)

	xi: reg fatalities2  Land_250_1757 `controls_gis' i.state_gadm lnpdgpd1990, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store polviolence_original

xi: reg no_incidents_100 Land_250_1757 `controls_gis' i.state_gadm lnpdgpd1990, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store polviolence1
	
*************************************************	

use "$data/conflictexposure.dta", clear
merge m:1 district_gadm using "$data/04_Indien_conflict_2015_2018"
replace no_incidents_100 =0 if no_incidents_100 ==.

local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

/*Make sample equivalent to benchmark sample*/

xi: reg lnlights_001 Land_250_1757 lnpdgpd1990, r beta
	keep if e(sample)
	
xi: reg no_incidents_100 Land_250_1757 `controls_gis' i.state_gadm lnpdgpd1990, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store polviolence2
	
esttab polviolence_original  polviolence1 polviolence2   using "$output/table6_ADM1_2.tex", 	replace fragment keep(Land_250_1757) ///
	b(3) se(3) posthead(\cmidrule(lr){2-5}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Land_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	/// 
addnote("Estimation method is OLS. Unit of analysis is region (ADM1) for estimation 1, 2, and 3 and distirct (ADM2) for estimation 4. Dependent variable in column 1 is Political violence, defined as fatalities per district between 2015 and 2018 (in hundreds). Column 2 show the exposure from 2000 to 2010, and column 3 show the exposure from 2000 to2022. Variable of interest is pre-colonial conflict exposure to land battles between 1000 and 1757. Geographic controls include latitude, longitude, altitude, ruggedness, precipitation, land quality, dry rice suitability, wet rice suitability, wheat suitability and malaria risk. Population density is ln(PopulationDensity) in 1990. Robust SEs in parentheses, followed by p-values in brackets. ***, ** and * indicate statistical significance at 1%, 5% and 10% level.")	

