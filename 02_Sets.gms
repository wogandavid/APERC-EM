* APERC Energy Model 2019.01.02 created by David Wogan, APERC
*
* Based on OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012

* This file declares all sets and elements used in the model, including all sectors and subsectors.
* Sets = groupings of technologies or fuels
* Elements = technologies or fuels

* INSTRUCTIONS
* 1. When updating a sector model, be sure to add any new sets or elements to this file, in the correct location.

set TECHNOLOGY a list of all processes and activities
/
* 1. Production
$ontext 
IMPCOAL1 - import coal
IMPOIL1 - import oil
IMPNATGAS - import natural gas
IMPURANIUM1 - import uranium
IMPDSL1 - import diesel
IMPGSL1 - import gasoline
IMPCOAL1 - import coal
$offtext
IMPOIL1
IMPNATGAS
IMPURANIUM1
IMPDSL1
IMPGSL1
* 2. Refining
* SRE basic refining input-output process
SRE
* 3. Power
* power generation technologies
$ontext 
 ELCOAL coal-fired plant
 ELNUKE nuclear plant
 ELNATGAS natural gas plant
 ELHYD hydro dam
 ELDAM Consumes and generates electricity
 RIV supplies water to hydro power plants
$offtext
 ELCOAL
 ELNUKE
 ELNATGAS
 ELHYD
 ELDAM
 RIV
* transmission
$ontext
 HVTexp export to high voltage line
 HVTimp import from high voltage line
 HVTu backstop high voltage technology 
$offtext
 HVTexp
 HVTimp
 HVTu
* 4. Hydrogen

* 5. Buildings
$ontext
RHO residential heating - oil units []
RHE residential heating - electricity units []
RL1 residential lighting - technology 1 units []
RHu - backstop technology for heating
RLu - backstop technology for lighting
$offtext
RHO
RHE
RL1
RHu
RLu
* 6. Transport
$ontext
TRND diesel vehicle
TRNE electric vehicle
TRNG gasoline vehicle
TRNu backstop vehicle technology
$offtext
TRND
TRNE
TRNG
TRNu
* 7. Industry

* 8. Agriculture
/;

set FUEL / 
* 1. Production
URANIUM, COAL, OIL, NATGAS, HYD,
* 2. Refining
DSL, GSL, 
* 3. Power
ELC, ELCtrade,
* 4. Hydrogen

* 5. Buildings
RH, RL, 
* 6. Transport
TRN, 
* 7. Industry

* 8. Agriculture

* 9. Other
 DUMMYF 
 /;

* list of economies in model
set ECONOMY  / tokyo, OSAKA /;

* list of years in model
set YEAR /2018*2030/;
YearVal(YEAR) = 2018+ord(YEAR)-1;

* list of timeslices in model
set TIMESLICE       / ID, IN, SD, SN, WD, WN /;

set MODE_OF_OPERATION       / 1, 2 /;

* emissions
set EMISSION  / CO2, NOX /;

* technologies that have storage ability
set STORAGE / DAM /;

set BOUNDARY_INSTANCES  / endc1 /;