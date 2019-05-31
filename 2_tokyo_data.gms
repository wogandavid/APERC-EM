* tokyo Example Economy data file for use with APERC Energy Model
*
* APERC Energy Model 2019.01.02 created by David Wogan, APERC
*
* Based on OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
*
$offlisting
*
$ontext
  **
  **  Energy and demands in Mtoe/a
  **  Power plants in GW
  **  Investment and fixed O&M Costs: Power plant: Million $ / GW (//$/kW)
  **  Investment and fixed O&M Costs Costs: Other plant costs: Million $/Mtoe/a
  **  Variable O&M (& Import) Costs: Million $ / Mtoe (//$/toe)
  *
  * Summary of Set: TECHNOLOGY
  * ELCOAL = Coal fuelled power plant
  * ELNATGAS = Natural gas fuelled power plant
  * ELNUKE = Nuclear power plant
  * ELHYD = Hydro power plant
  * ELDAM = Consumes and generates electricity
  * IMPDSL1 = Diesel supply
  * IMPGSL1 = Gasoline supply
  * IMPCOAL1 = Coal supply
  * IMPNATGAS = Uranium supply
  * IMPOIL1 = Crude oil supply
  * IMPURANIUM1 = Uranium supply
  * RHE = Residential electricity heating consuming electricity
  * RL1 = Residential lighting consuming electricity
  * SRE = Refinery
  * TRND = Transport in passenger km consuming diesel
  * TRNE = Transport in passenger km consuming electricity
  * TRNG = Transport in passenger km consuming gasoline
  * RIV = River to supply hydro power plants
  * RHu = Unmet heating demand
  * RLu = Unmet lighting demand
  * TRNu = Unmet transport demand
  *
  * Summary of Set: FUEL
  * DSL = Diesel (Mtoe)
  * ELC = Electricity (Mtoe)
  * GSL = Gasoline (Mtoe)
  * COAL = Coal (Mtoe)
  * HYD = Hydro (Mtoe)
  * OIL = Oil (Mtoe)
  * NATGAS = Natural gas
  * URANIUM = Uranium (Mtoe)
  * RH = Heating demand (Mtoe)
  * RL = Lighting demand (Mtoe)
  * TRN = Transport demand (Mtoe)
  *
  * set TIMESLICE
  * ID = Intermediate season, day
  * IN = Intermediate season, night
  * SD = Summer season, day
  * SN = Summer season, night
  * ID = Winter season, day
  * IN = Winter season, night
$offtext

*
$offlisting
set EMISSION  / CO2, NOX /;
set TECHNOLOGY /
  ELCOAL, ELNUKE, ELNATGAS, ELHYD, ELDAM, IMPCOAL1, IMPOIL1, IMPNATGAS, IMPURANIUM1, IMPDSL1, IMPGSL1,
  RIV, RHO, RHE, RL1, RHu, RLu, SRE, TRND, TRNE, TRNG, TRNu, HVTexp, HVTimp, HVTu
/;

set FUEL / URANIUM, COAL, OIL, NATGAS, HYD, ELC, DSL, GSL, RH, RL, TRN, ELCtrade, DUMMYF /;

* SECTORAL sets:
set ELECTRICITY(TECHNOLOGY)   / ELCOAL, ELNUKE, ELNATGAS, ELHYD, ELDAM, HVTexp, HVTimp, HVTu /;
set SUPPLY(TECHNOLOGY)        / IMPCOAL1, IMPOIL1, IMPNATGAS, IMPURANIUM1, IMPDSL1, IMPGSL1 /;
set RESIDENTIAL(TECHNOLOGY)   / RHO, RHE, RL1, RHu, RLu /;
set REFINING(TECHNOLOGY)      / SRE /;
set TRANSPORT(TECHNOLOGY)     / TRND, TRNE, TRNG, TRNu /;

set YEAR /2018*2020/;
YearVal(YEAR) = 2018+ord(YEAR)-1;

set TIMESLICE       / ID, IN, SD, SN, WD, WN /;
set MODE_OF_OPERATION       / 1, 2 /;
set ECONOMY  / tokyo, OSAKA /;
set STORAGE / DAM /;
set BOUNDARY_INSTANCES  / endc1 /;
$offlisting

display EMISSION;
display TECHNOLOGY;
display FUEL;
display YEAR;
display TIMESLICE;
display MODE_OF_OPERATION;
display ECONOMY;
display STORAGE;
display BOUNDARY_INSTANCES;

$offlisting
*
AnnualExogenousEmission(r,e,y) = 0;

AnnualEmissionLimit(r,e,y) = 9999;
*display AnnualEmissionLimit;

ModelPeriodExogenousEmission(r,e) = 0;

ModelPeriodEmissionLimit(r,e) = 9999;
*display ModelPeriodEmissionLimit;

StorageUpperLimit(r,s) = 9999;
*display StorageUpperLimit;

StorageLowerLimit(r,s) = 0;
* display StorageLowerLimit;

DiscountRate(r,t) = 0.05;
*display DiscountRate;

parameter StartYear / 2018 /;
*display StartYear;

parameter TechnologyToStorage /
  tokyo.ELDAM.DAM.2  1
/;
*display TechnologyToStorage;

parameter TechnologyFromStorage /
  tokyo.ELDAM.DAM.1  1
/;
*display TechnologyFromStorage;

* ## BEGIN EXCEL CALLS

$onecho > task1.txt
  par=YearSplit rng=YearSplit! Rdim=2
  par=AccumulatedAnnualDemand rng=AccumulatedAnnualDemand! Rdim=3
  par=SpecifiedDemandProfile rng=SpecifiedDemandProfile! Rdim=4
  par=SpecifiedAnnualDemand rng=SpecifiedAnnualDemand! Rdim=3
  par=InputActivityRatio rng=InputActivityRatio! Rdim=5
  par=OutputActivityRatio rng=OutputActivityRatio! Rdim=5
  par=FixedCost rng=FixedCost! Rdim=3
  par=CapitalCost rng=CapitalCost! Rdim=3
  par=VariableCost rng=VariableCost! Rdim=4
  par=ResidualCapacity rng=ResidualCapacity! Rdim=3
  par=SalvageFactor rng=SalvageFactor! Rdim=3
  par=AvailabilityFactor rng=AvailabilityFactor! Rdim=3
  par=CapacityFactor rng=CapacityFactor! Rdim=3
  par=EmissionActivityRatio rng=EmissionActivityRatio! Rdim=5
  par=ReserveMarginTagTechnology rng=ReserveMarginTagTechnology! Rdim=3
  par=TotalAnnualMaxCapacity rng=TotalAnnualMaxCapacity! Rdim=3
  par=TotalAnnualMinCapacity rng=TotalAnnualMinCapacity! Rdim=3
  par=OperationalLife rng=OperationalLife! Rdim=2
  par=TradeRoute rng=TradeRoute! Rdim=4
$offecho

$call GDXXRW C:\Users\david\OneDrive\Documents\GitHub\osemosys_test\tokyo_data.xlsx @task1.txt
execute_load "tokyo_data.gdx",
  YearSplit
  AccumulatedAnnualDemand
  SpecifiedAnnualDemand
  SpecifiedDemandProfile
  InputActivityRatio
  OutputActivityRatio
  FixedCost
  CapitalCost
  VariableCost
  ResidualCapacity
  SalvageFactor
  AvailabilityFactor
  CapacityFactor
  EmissionActivityRatio
  ReserveMarginTagTechnology
  TotalAnnualMaxCapacity
  TotalAnnualMinCapacity
  OperationalLife
  TradeRoute
;
* ## END OF EXCEL CALLS

*option YearSplit:4:1:1; display YearSplit;

*option SpecifiedDemandProfile:4:2:2; display SpecifiedDemandProfile;

*option InputActivityRatio:4:2:3; display InputActivityRatio;

*option OutputActivityRatio:4:2:3; display OutputActivityRatio;

*option FixedCost:4:0:1; display FixedCost;

*display TradeRoute;

VariableCost(r,t,m,y)$(VariableCost(r,t,m,y) = 0) = 0.00041868;

AvailabilityFactor(r,t,y)$(AvailabilityFactor(r,t,y) = 0) = 1;

CapacityFactor(r,t,y)$(CapacityFactor(r,t,y) = 0) = 1;
*display EmissionActivityRatio;

* Capacity to Activity Unit:
* energy produced when one unit of capacity is fully used in one year
* 0.753224421 is the level of energy production in Mtoe produced from 1 GW operating for 1 year
parameter CapacityToActivityUnit /
  tokyo.ELCOAL    0.753224421
  tokyo.ELNUKE    0.753224421
  tokyo.ELNATGAS  0.753224421
  tokyo.ELHYD     0.753224421
  tokyo.ELDAM     0.753224421
  osaka.ELCOAL     0.753224421
/;
CapacityToActivityUnit(r,t)$(CapacityToActivityUnit(r,t) = 0) = 1;
*display CapacityToActivityUnit;

parameter TechWithCapacityNeededToMeetPeakTS /
  tokyo.ELCOAL    1
  tokyo.ELNUKE    1
  tokyo.ELNATGAS  1
  tokyo.ELHYD     1
  tokyo.ELDAM     1
  osaka.ELCOAL     0
/;
*display TechWithCapacityNeededToMeetPeakTS;

EmissionsPenalty(r,e,y) = eps;
*display EmissionsPenalty;

parameter ReserveMarginTagFuel /
  tokyo.ELC.2018  1
  tokyo.ELC.2019  1
  osaka.ELC.2018  1
  osaka.ELC.2019  1

/;
*display ReserveMarginTagFuel;

parameter ReserveMargin /
  tokyo.2018  1.18
  tokyo.2019  1.18
  osaka.2018  1.18
  osaka.2019  1.18
/;
*display ReserveMargin;

OperationalLife(r,t)$(OperationalLife(r,t) = 0) = 1;
*display OperationalLife;

TotalAnnualMaxCapacity(r,t,y)$(TotalAnnualMaxCapacity(r,t,y) = 0) = 99999;
*display TotalAnnualMaxCapacity;

*display TotalAnnualMinCapacity;

TotalAnnualMaxCapacityInvestment(r,t,y) = 99999;
*display TotalAnnualMaxCapacityInvestment;

TotalAnnualMinCapacityInvestment(r,t,y) = 0;

TotalTechnologyAnnualActivityUpperLimit(r,t,y) = 99999;
*display TotalTechnologyAnnualActivityUpperLimit;

TotalTechnologyAnnualActivityLowerLimit(r,t,y) = 0;

TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 99999;
*display TotalTechnologyModelPeriodActivityUpperLimit;

TotalTechnologyModelPeriodActivityLowerLimit(r,t) = 0;

RETagTechnology(r,t,y) = 0;

RETagFuel(r,f,y) = 0;

REMinProductionTarget(r,y) = 0;

StorageInflectionTimes(y,l,b) = 0;

*end;

* tetsing

*Trade.fx('tokyo','osaka',l,'TRADEDELC','2018') = 1;
