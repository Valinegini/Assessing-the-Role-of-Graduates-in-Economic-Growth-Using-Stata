// Close any open logs and set options
capture log close
set more off

// Clear any existing data in memory
clear all

// Specify the path to your CSV file
local path "E:\My University Doc\Fourth Semester\Research Proj Econ Pol & Sem\Proj\Canada123.csv"

// Create a log file to save the output
log using "E:\My University Doc\Fourth Semester\Research Proj Econ Pol & Sem\Proj\GDP_Analysis.log", text replace

// Import data using insheet
insheet using "`path'"

// Check the structure of the data
describe

// Check the number of observations for each country
count if country == "Canada"
di "Observations for Canada: " r(N)

count if country == "China"
di "Observations for China: " r(N)

// Check for any missing values in key variables
misstable summarize gdp gove edu cap rd unr

// Generate GDP and other variables
gen y = gdp
gen GovE_var = gove
gen Edu_var = edu
gen Cap_var = cap
gen RD_var = rd
gen Unr_var = unr

// Create a dummy variable for COVID-19 (1 for 2019, 2020, 2021)
gen covid_dummy = (year >= 2019 & year <= 2021) // Assuming 'year' is a variable in your dataset

//---------------------
// Analysis for Canada
//---------------------

// Filter for Canada
preserve
keep if country == "Canada"

// Check for missing values
misstable summarize y GovE_var Edu_var Cap_var RD_var Unr_var covid_dummy

// Run regressions on raw variables including the COVID dummy and withot COVID dummy
di as text "Regression Results for Canada"
reg y GovE_var Edu_var Cap_var RD_var Unr_var 
matrix list e(b)
reg y GovE_var Edu_var Cap_var RD_var Unr_var covid_dummy
matrix list e(b)
// Compute first differences for raw variables
gen lagy_can = y[_n-1]

gen lagGovE_can = GovE_var[_n-1]

gen lagEdu_can = Edu_var[_n-1]

gen lagCap_can = Cap_var[_n-1]

gen lagRD_can = RD_var[_n-1]

gen lagUnr_can = Unr_var[_n-1]


// Run regression on first differences for raw variables including the COVID dummy and withot COVID dummy
di as text "Lag egression Results for Canada"
reg y GovE_var Edu_var Cap_var RD_var Unr_var lagy_can lagGovE_can lagEdu_can lagCap_can lagRD_can lagUnr_can
matrix list e(b)
reg y GovE_var Edu_var Cap_var RD_var Unr_var lagy_can lagGovE_can lagEdu_can lagCap_can lagRD_can lagUnr_can  covid_dummy
matrix list e(b)
// Restore original data
restore

//---------------------
// Analysis for China
//---------------------

// Filter for China
preserve
keep if country == "China"

// Check for missing values
misstable summarize y GovE_var Edu_var Cap_var RD_var Unr_var covid_dummy

// Run regressions on raw variables including the COVID dummy and withot COVID dummy
di as text "Regression Results for China"
reg y GovE_var Edu_var Cap_var RD_var Unr_var 
matrix list e(b)
reg y GovE_var Edu_var Cap_var RD_var Unr_var covid_dummy
matrix list e(b)
// Compute first differences for raw variables
gen lagy_china = y[_n-1]

gen lagGovE_china = GovE_var[_n-1]

gen lagEdu_china = Edu_var[_n-1]

gen lagCap_china = Cap_var[_n-1]

gen lagRD_china = RD_var[_n-1]

gen lagUnr_china = Unr_var[_n-1]


// Run regression on first differences for raw variables including the COVID dummy and withot COVID dummy
di as text "Lag Regression Results for China"
reg y GovE_var Edu_var Cap_var RD_var Unr_var lagy_china lagGovE_china lagEdu_china lagCap_china  lagRD_china lagUnr_china
matrix list e(b)
reg y GovE_var Edu_var Cap_var RD_var Unr_var lagy_china lagGovE_china lagEdu_china lagCap_china  lagRD_china lagUnr_china covid_dummy
matrix list e(b)

// Close the log
log close