* APERC Energy Model 2019.06.12 created by David Wogan, APERC
*

* Based on OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012

* This file declares all sets and elements used in the model, including all sectors and subsectors.
* Sets = groupings of technologies or fuels
* Elements = technologies or fuels

* INSTRUCTIONS
* 1. When updating a sector model, be sure to add any new sets or elements to this file, in the correct location.

* ===============================================================================
* TECHNOLOGIES
Sets
* Production sector
PRD_tech "production sector technologies"
/
IMPCOAL1 "import coal"
IMPOIL1 "import oil"
IMPNATGAS "import gas"
IMPURANIUM1 "import uranium"
IMPDSL1 "import diesel fuel"
IMPGSL1 "import gasoline"
/
* Refining sector
REF_tech "refining sector technologies"
/
SRE "refining activity"
/
* Power sector
POW_tech
/
* power plants
 ELCOAL "coal power plant"
 ELNUKE "nuclear power plant"
 ELNATGAS "natural gas power plant"
 ELHYD "hydro power plant"
 ELDAM "storage"
 RIV "produces water for power plant"
* transmission
 HVTexp "export to high voltage activity"
 HVTimp "import from high voltage activity"
 HVTu "backstop transmission technology"
/
* Hydrogen 'sector'
* Buildings
BLD_tech
/
RHO "residential heating - oil"
RHE "residential heating - electricity"
RL1 "residential lighting - technology "
RHu - "backstop technology for heating"
RLu - "backstop technology for lighting"
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
* aggregate all sector sets into one TECHNOLOGY set to match OSeMOSYS structure
set TECHNOLOGY a list of all processes and activities
/set.PRD_tech, set.REF_tech, set.POW_tech, set.BLD_tech, set.TRN_tech/
;

* ===============================================================================
* FUELS
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
* aggregate all sector sets into one TECHNOLOGY set to match OSeMOSYS structure
FUEL a list of all fuels and flows
/set.PRD_fuel,REF_fuel,set.POW_fuel,set.BLD_fuel,set.TRN_fuel
*IND_fuel,
*AGR_fuel,OTH_fuel
/
;

* ===============================================================================
* OTHERS

* list of economies in model
set ECONOMY  /tokyo, osaka/;

* list of years in model
set YEAR /2018*2020/;
YearVal(YEAR) = 2018+ord(YEAR)-1;
parameter StartYear / 2018 /;

* list of timeslices in model
set TIMESLICE       / ID, IN, SD, SN, WD, WN /;

set MODE_OF_OPERATION       / 1, 2 /;

* emissions
set EMISSION  / CO2, NOX /;

* technologies that have storage ability
set STORAGE / DAM /;

set BOUNDARY_INSTANCES  / endc1 /;
