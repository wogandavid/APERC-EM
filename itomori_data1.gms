* ITOMORI Example Economy data file for use with APERC Energy Model
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
set TECHNOLOGY / ELCOAL, ELNUKE, ELNATGAS, ELHYD, ELDAM, IMPCOAL1, IMPOIL1, IMPNATGAS, IMPURANIUM1, IMPDSL1, IMPGSL1, 
  RIV, RHO, RHE, RL1, RHu, RLu /;
* set     TECHNOLOGY      / ELCOAL, ELNUKE, ELHYD, ELDAM, E70, IMPDSL1, IMPGSL1, IMPCOAL1, IMPOIL1, IMPURANIUM1, RHE, RHO, RL1, SRE, TRND, TRNE, TRNG, RIV, RHu, RLu, TRNu/;

set FUEL / URANIUM, COAL, OIL, NATGAS, HYD, ELC, DSL, GSL, RH, RL, TRN /;
* set     FUEL    /TRN/;

* SECTORAL sets:
set ELECTRICITY(TECHNOLOGY)   / ELCOAL, ELNUKE, ELNATGAS, ELHYD, ELDAM /;
set SUPPLY(TECHNOLOGY)        / IMPCOAL1, IMPOIL1, IMPNATGAS, IMPURANIUM1, IMPDSL1, IMPGSL1 /;
set RESIDENTIAL(TECHNOLOGY)   / RHO, RHE, RL1, RHu, RLu /;
* set     REFINING(TECHNOLOGY)      / SRE/;
* set     TRANSPORT(TECHNOLOGY)     / TRND, TRNE, TRNG, TRNu/;

set YEAR /2018*2030/;
YearVal(YEAR) = 2018+ord(YEAR)-1;

set TIMESLICE       / ID, IN, SD, SN, WD, WN /;
set MODE_OF_OPERATION       / 1, 2 /;
set ECONOMY  / ITOMORI /;
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
  ITOMORI.ELDAM.DAM.2  1
/;
*display TechnologyToStorage;

parameter TechnologyFromStorage /
  ITOMORI.ELDAM.DAM.1  1
/;
*display TechnologyFromStorage;

parameter YearSplit /
  ID.2018  .1667
  ID.2019  .1667
  ID.2020  .1667
  ID.2021  .1667
  ID.2022  .1667
  ID.2023  .1667
  ID.2024  .1667
  ID.2025  .1667
  ID.2026  .1667
  ID.2027  .1667
  ID.2028  .1667
  ID.2029  .1667
  ID.2030  .1667
  IN.2018  .0833
  IN.2019  .0833
  IN.2020  .0833
  IN.2021  .0833
  IN.2022  .0833
  IN.2023  .0833
  IN.2024  .0833
  IN.2025  .0833
  IN.2026  .0833
  IN.2027  .0833
  IN.2028  .0833
  IN.2029  .0833
  IN.2030  .0833
  SD.2018  .1667
  SD.2019  .1667
  SD.2020  .1667
  SD.2021  .1667
  SD.2022  .1667
  SD.2023  .1667
  SD.2024  .1667
  SD.2025  .1667
  SD.2026  .1667
  SD.2027  .1667
  SD.2028  .1667
  SD.2029  .1667
  SD.2030  .1667
  SN.2018  .0833
  SN.2019  .0833
  SN.2020  .0833
  SN.2021  .0833
  SN.2022  .0833
  SN.2023  .0833
  SN.2024  .0833
  SN.2025  .0833
  SN.2026  .0833
  SN.2027  .0833
  SN.2028  .0833
  SN.2029  .0833
  SN.2030  .0833
  WD.2018  .3333
  WD.2019  .3333
  WD.2020  .3333
  WD.2021  .3333
  WD.2022  .3333
  WD.2023  .3333
  WD.2024  .3333
  WD.2025  .3333
  WD.2026  .3333
  WD.2027  .3333
  WD.2028  .3333
  WD.2029  .3333
  WD.2030  .3333
  WN.2018  .1667
  WN.2019  .1667
  WN.2020  .1667
  WN.2021  .1667
  WN.2022  .1667
  WN.2023  .1667
  WN.2024  .1667
  WN.2025  .1667
  WN.2026  .1667
  WN.2027  .1667
  WN.2028  .1667
  WN.2029  .1667
  WN.2030  .1667
/;
*option YearSplit:4:1:1; display YearSplit;

* BEGING EXCEL CALLS

$onecho > task1.txt
  par=AccumulatedAnnualDemand rng=AccumulatedAnnualDemand!A2:D14 Rdim=3
  par=SpecifiedDemandProfile rng=SpecifiedDemandProfile!A2:E157 Rdim=4
  par=SpecifiedAnnualDemand rng=SpecifiedAnnualDemand!A2:D27 Rdim=3

  par=InputActivityRatio rng=InputActivityRatio!A2:F105 Rdim=5
  par=OutputActivityRatio rng=OutputActivityRatio!A2:F222 Rdim=5
  par=FixedCost rng=FixedCost!A2:D92 Rdim=3

  par=CapitalCost rng=CapitalCost!A2:D118 Rdim=3
  par=VariableCost rng=VariableCost!A2:E131 Rdim=4
  par=ResidualCapacity rng=ResidualCapacity!A2:D92 Rdim=3
  par=SalvageFactor rng=SalvageFactor!A2:D105 Rdim=3
  par=AvailabilityFactor rng=AvailabilityFactor!A2:D40 Rdim=3
  par=CapacityFactor rng=CapacityFactor!A2:D66 Rdim=3
  par=EmissionActivityRatio rng=EmissionActivityRatio!A2:D66 Rdim=5
  par=ReserveMarginTagTechnology rng=ReserveMarginTagTechnology!A2:D66 Rdim=3
  par=TotalAnnualMaxCapacity rng=TotalAnnualMaxCapacity!A2:D40 Rdim=3
  par=TotalAnnualMinCapacity rng=TotalAnnualMinCapacity!A2:D14 Rdim=3
  par=OperationalLife rng=OperationalLife!A2:C8 Rdim=2
$offecho

$call GDXXRW C:\Users\david\OneDrive\Documents\GitHub\osemosys_test\ITOMORI_data.xlsx @task1.txt
execute_load "ITOMORI_data.gdx", 
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
;
* END OF EXCEL CALLS

*option SpecifiedDemandProfile:4:2:2; display SpecifiedDemandProfile;

*option InputActivityRatio:4:2:3; display InputActivityRatio;

*option OutputActivityRatio:4:2:3; display OutputActivityRatio;

*option FixedCost:4:0:1; display FixedCost;

VariableCost(r,t,m,y)$(VariableCost(r,t,m,y) = 0) = 0.00041868;

AvailabilityFactor(r,t,y)$(AvailabilityFactor(r,t,y) = 0) = 1;

CapacityFactor(r,t,y)$(CapacityFactor(r,t,y) = 0) = 1;
*display EmissionActivityRatio;

* Capacity to Activity Unit:
* energy produced when one unit of capacity is fully used in one year
* 0.753224421 is the level of energy production in Mtoe produced from 1 GW operating for 1 year
parameter CapacityToActivityUnit /
  ITOMORI.ELCOAL    0.753224421
  ITOMORI.ELNUKE    0.753224421
  ITOMORI.ELNATGAS  0.753224421
  ITOMORI.ELHYD     0.753224421
  ITOMORI.ELDAM     0.753224421
/;
CapacityToActivityUnit(r,t)$(CapacityToActivityUnit(r,t) = 0) = 1;
*display CapacityToActivityUnit;

parameter TechWithCapacityNeededToMeetPeakTS /
  ITOMORI.ELCOAL    1
  ITOMORI.ELNUKE    1
  ITOMORI.ELNATGAS  1
  ITOMORI.ELHYD     1
  ITOMORI.ELDAM     1
/;
*display TechWithCapacityNeededToMeetPeakTS;

EmissionsPenalty(r,e,y) = eps;
*display EmissionsPenalty;

parameter ReserveMarginTagFuel /
  ITOMORI.ELC.2018  1
  ITOMORI.ELC.2019  1
  ITOMORI.ELC.2020  1
  ITOMORI.ELC.2021  1
  ITOMORI.ELC.2022  1
  ITOMORI.ELC.2023  1
  ITOMORI.ELC.2024  1
  ITOMORI.ELC.2025  1
  ITOMORI.ELC.2026  1
  ITOMORI.ELC.2027  1
  ITOMORI.ELC.2028  1
  ITOMORI.ELC.2029  1
  ITOMORI.ELC.2030  1
/;
*display ReserveMarginTagFuel;

parameter ReserveMargin /
  ITOMORI.2018  1.18
  ITOMORI.2019  1.18
  ITOMORI.2020  1.18
  ITOMORI.2021  1.18
  ITOMORI.2022  1.18
  ITOMORI.2023  1.18
  ITOMORI.2024  1.18
  ITOMORI.2025  1.18
  ITOMORI.2026  1.18
  ITOMORI.2027  1.18
  ITOMORI.2028  1.18
  ITOMORI.2029  1.18
  ITOMORI.2030  1.18
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
