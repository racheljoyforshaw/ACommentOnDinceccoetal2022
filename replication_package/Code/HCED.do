
cap shp2dta using "$data/IND_adm2" , database("$data/IND_adm2_data") coordinates ("$data/IND_adm2_coord") genid(id)  

tempfile conflict
import delimited using "$data/HCEDdata_IndiaSurrounding.csv" , clear
keep if year <= 1757 & year>=1000
keep if theatre=="Land"
gen century = 1000
replace century = 1100 if year>=1100
replace century = 1200 if year>=1200
replace century = 1300 if year>=1300
replace century = 1400 if year>=1400
replace century = 1500 if year>=1500
replace century = 1600 if year>=1600
replace century = 1700 if year>=1700
tab century
drop century

g i = 1
g j = _n
g N = _N
rename ïlatitude latitude
drop theatre
reshape wide longitude latitude year, i(i) j(j)
save `conflict'

tempfile alternative
u "$data/IND_adm2_data" , clear
// this drops repetition of Palghar, Maharastra (365 has incorrect centroid lat/long)
drop if id==365
g i = 1
merge n:1 i using `conflict' , nogen

* original conflict exposure definition
sum N 
forv i = 1/`r(max)' {
	geodist latitude longitude latitude`i' longitude`i' , gen(distance`i') 
}

sum N 
forv i = 1/`r(max)'  {
	replace distance`i' = . if distance`i' > 250 
	g invdistance`i' = 1/(1+distance`i')
}


egen conflictexposure_0 = rowtotal(invdistance*)




* alternative definition -- u=10
drop inv* distance*
sum N 
forv i = 1/`r(max)' {
	geodist latitude longitude latitude`i' longitude`i' , gen(distance`i') 
}

sum N 
forv i = 1/`r(max)'  {
	replace distance`i' = . if distance`i' > 250 
	g invdistance`i' = 1/(1+(distance`i')/10)
}


egen conflictexposure_1 = rowtotal(invdistance*)

* alternative definition -- u=100
drop inv* distance*
sum N 
forv i = 1/`r(max)' {
	geodist latitude longitude latitude`i' longitude`i' , gen(distance`i') 
}

sum N 
forv i = 1/`r(max)'  {
	replace distance`i' = . if distance`i' > 250 
	g invdistance`i' = 1/(1+(distance`i')/100)
}


egen conflictexposure_2 = rowtotal(invdistance*)



* count
drop inv* distance*
sum N 
forv i = 1/`r(max)' {
	geodist latitude longitude latitude`i' longitude`i' , gen(distance`i') 
}
sum N 
forv i = 1/`r(max)'  {
	g counter`i' = 1
	replace counter`i' = . if distance`i' > 250
}
egen conflictexposure_3 = rowtotal(counter*)

* gaussian
drop  distance*
sum N 
forv i = 1/`r(max)' {
	geodist latitude longitude latitude`i' longitude`i' , gen(distance`i') 
}
sum N 
forv i = 1/`r(max)'  {
	replace distance`i' = . if distance`i' > 250 
	g expdistance`i' = exp(-distance`i'/100)
}
egen conflictexposure_4 = rowtotal(expdistance*)



ren NAME_1 state_gadm 
ren NAME_2 district_gadm
drop *distance* 
duplicates drop state_gadm district_gadm , force // one district has a duplicate, don't know why
save `alternative'

use "$data/conflictexposure.dta", clear
merge 1:1 state_gadm district_gadm using `alternative'


set scheme s1mono

twoway(hist conflictexposure_0,width(0.05) xscale(range(0 1))  xlabel(0(0.2)1) ylabel(0(5)20)  color(red)) ///
	(hist Land_250_1757	,width(0.05) xscale(range(0 1))  xlabel(0(0.2)1) ylabel(0(5)20) fcolor(none) lcolor(black) legend(order(1 "Replication" 2 "Original"  )))
graph export "$output/conflictExposure_both.pdf", replace
	
local controls_gis "latitude_gadm longitude_gadm altit nprug precip ramank dryrice wrice wheat kmal"
drop if district_gadm=="Nicobar Islands" | district_gadm=="South Andaman" | district_gadm=="North and Middle Andaman" | district_gadm=="Lakshadweep"

local measures conflictexposure_0 conflictexposure_1 conflictexposure_2 conflictexposure_3 conflictexposure_4 
foreach measure of local measures {
xi: reg lnlights_001 `measure' lnpdgpd1990, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)	
	estadd scalar stb = beta[1,1]
	estimates store main1
	
xi: reg lnlights_001 `measure' lnpdgpd1990 i.state_gadm, r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main2

xi: reg lnlights_001 `measure' lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estadd beta
	matrix beta = e(beta)
	estadd scalar stb = beta[1,1]
	estimates store main3
	
esttab main3 using "$output/table1_`measure'_HCED.tex", ///
	replace fragment keep(`measure') ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Land_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

/*First stage*/

xi: reg `measure' instrument lnpdgpd1990, r beta
	estadd ysumm
	estimates store iv_firststage1

xi: reg `measure' instrument lnpdgpd1990 i.state_gadm, r beta
	estadd ysumm
	estimates store iv_firststage2

xi: reg `measure' instrument lnpdgpd1990 i.state_gadm `controls_gis', r beta
	estadd ysumm
	estimates store iv_firststage3
	
esttab iv_firststage1 iv_firststage2 iv_firststage3 using "$output/table2a_`measure'_HCED.tex", ///
	replace fragment keep(instrument) ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(instrument "Proximity to Khyber Pass") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")	

/*Second stage*/

xi: ivreg2 lnlights_001 (`measure'=instrument) lnpdgpd1990 , r ffirst
	estadd ysumm
	estadd beta
	matrix beta = e(beta)	
	estadd scalar stb = beta[1,1]
	estimates store iv_secondstage1
	
	
xi: ivreg2 lnlights_001 (`measure'=instrument) lnpdgpd1990  i.state_gadm, r ffirst
	estadd ysumm
	estadd beta
	matrix beta = e(beta)	
	estadd scalar stb = beta[1,1]
	estimates store iv_secondstage2

xi: ivreg2 lnlights_001 (`measure'=instrument) lnpdgpd1990  i.state_gadm `controls_gis', r ffirst
	estadd ysumm
	estadd beta
	matrix beta = e(beta)	
	estadd scalar stb = beta[1,1]
	estimates store iv_secondstage3

esttab  iv_secondstage3 using "$output/table2b_`measure'_HCED.tex", ///
	replace fragment keep(`measure') ///
	b(3) se(3) posthead(\cmidrule(lr){2-4}) ///
	cells(b(star fmt(3)) se(fmt(3) par) p(fmt(3) par([ ]))) staraux star(* 0.10 ** 0.05 *** 0.01) collabels(none) ///
	label booktabs noconstant obslast nodepvars nomtitles nolines gaps ///
	scalars("stb Standardized beta coefficient" "r2 \(R^{2}\)") sfmt(3) ///
	coeflabel(Land_250_1757 "Pre-colonial conflict exposure") ///
	indicate("Population density = lnpdgpd1990" "State FE = *state*" "Geographic controls = `controls_gis'")		
}	

