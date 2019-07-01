* APERC Energy Model 2019.06.12 created by David Wogan, APERC
*
* Based on OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
*
* This file declares all sets and elements used in the model, including all sectors and subsectors.
* Sets = groupings of technologies or fuels
* Elements = technologies or fuels
*
* INSTRUCTIONS
* 1. When updating a sector model, be sure to add any new sets or elements to this file, in the correct location.
*
* ===============================================================================
* GLOBAL

* list of economies in model
set ECONOMY economies /
01_AUS
02_BD
03_CDA
04_CHL
05_PRC
06_HKC
07_INA
08_JPN
09_ROK
10_MAS
11_MEX
12_NZ
13_PNG
14_PE
15_RP
16_RUS
17_SIN
18_CT
19_THA
20_USA
21_VN
22_SEA
23_NEA
24_OAM
25_OCE
26_ROW
27_WOR
/
;

* economies to run in the model
set ECONOMYrun /01_AUS/;

* list of years in data
set YEAR /2016*2028/;
* list of years to run model

set year2 /2016*2018/;
YearVal(YEAR2) = 2016+ord(YEAR2)-1;
parameter StartYear / 2016 /;

* list of timeslices in model
set TIMESLICE       / ID, IN, SD, SN, WD, WN /;

set MODE_OF_OPERATION       / 1, 2 /;

* emissions
set EMISSION  / CO2, NOX /;

* technologies that have storage ability
set STORAGE / DAM /;

set BOUNDARY_INSTANCES  / endc1 /;

* ===============================================================================
* ACTIVITIES
* 'Activites' are processes like energy transformation technologies, importing or exporting 'Flows'.
Sets
* Production sector
PRD_tech "production sector technologies"
/
PRDimpcoal1 "import coal"
PRDimpoil1 "import oil"
PRDimpnatgas "import gas"
PRDimpuranium1 "import uranium"
PRDimpdiesel "import diesel fuel"
PRDimpgsl "import gasoline"
/
* Refining sector
REF_tech "refining sector technologies"
/
REFprocess1 "refining activity"
/
* Power sector
POW_tech
/
* power plants
 POWcoal "coal power plant"
 POWnuke "nuclear power plant"
 POWnatgas "natural gas power plant"
 POWhyd "hydro power plant"
 POWdam "storage"
 POWriv "produces water for power plant"
* transmission
 POWHVTexp "export to high voltage activity"
 POWHVTimp "import from high voltage activity"
 POWHVTu "backstop transmission technology"
/
* Hydrogen 'sector'

* Buildings
BLD_tech
/
BLDrho "residential heating - oil"
BLDrhe "residential heating - electricity"
BLDrl "residential lighting - technology "
BLDrhu - "backstop technology for heating"
BLDrlu - "backstop technology for lighting"
/
* Transport
TRN_tech
/
TRND "diesel vehicle"
TRNE "electric vehicle"
TRNG "gasoline vehicle"
TRNu "backstop vehicle technology"
/
* 7. Industry
*IND_tech

* 8. Agriculture
*AGR_tech

* aggregate all sector sets into one ACTIVITY set to match OSeMOSYS structure
set ACTIVITY aggregate all activities for OSeMOSYS
/set.PRD_tech, set.REF_tech, set.POW_tech, set.BLD_tech, set.TRN_tech/
;

* ===============================================================================
* FLOWS
* 'Flows' are: demands, fuel consumption, something produced by a activity (process). In other words
*  a flow is something that is received as an input or produced as an output by an activity.
* Note: update with codes from 'layout file'
Sets
* Production sector
PRD_fuel /URANIUM, COAL, OIL, NATGAS, HYD/
* Refining sector
REF_fuel /DSL, GSL/
* Power sector
POW_fuel /ELC, ELCtrade/
* Buildings sector
BLD_fuel /RH, RL/
* Transport sector
TRN_fuel /TRN/
* Industry sector
*IND_fuel //
* Agriculture sector
*AGR_fuel //
* Other fuels
OTH_fuel /DUMMYF/
* aggregate all sector sets into one ACTIVITY set to match OSeMOSYS structure
FLOW aggregate and flows for OSeMOSYS
/set.PRD_fuel,set.REF_fuel,set.POW_fuel,set.BLD_fuel,set.TRN_fuel
*IND_fuel,
*AGR_fuel,OTH_fuel
/
;

* ===============================================================================
