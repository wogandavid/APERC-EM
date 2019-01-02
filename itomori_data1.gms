
* ITOMORI_DATA1.gms - specify ITOMORI Model data in format required by GAMS
*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble.Noble-Soft Systems - August 2012
*
* APERC Energy Model 2019.01.02 created by David Wogan, APERC
*
$offlisting
*
$ontext
* OSEMOSYS 2011.07.07
* Open Source energy Modeling SYStem
*
**       Based on UTOPIA version 5: BASE - UTOPIA Base Model
**       Energy and demands in Mtoe/a
**       Power plants in GW
**       Investment and fixed O&M Costs: Power plant: Million $ / GW (//$/kW)
**       Investment and fixed O&M Costs Costs: Other plant costs: Million $/Mtoe/a
**       Variable O&M (& Import) Costs: Million $ / Mtoe (//$/toe)
*
* Summary of Set: TECHNOLOGY
* ELCOAL = Coal fuelled power plant
* ELNUKE = Nuclear power plant
* ELHYD = Hydro power plant
* ELDAM = Consumes and generates electricity
* IMPDSL1 = Diesel supply
* IMPGSL1 = Gasoline supply
* IMPCOAL1 = Coal supply
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

* Summary of Set: FUEL
* DSL = Diesel (Mtoe)
* ELC = Electricity (Mtoe)
* GSL = Gasoline (Mtoe)
* COAL = Coal (Mtoe)
* HYD = Hydro (Mtoe)
* OIL = Oil (Mtoe)
* URANIUM = Uranium (Mtoe)
* RH = Heating demand (Mtoe)
* RL = Lighting demand (Mtoe)
* TRN = Transport demand (Mtoe)

* set TIMESLICE
* ID = Intermediate season, day
* IN = Intermediate season, night
* SD = Summer season, day
* SN = Summer season, night
* ID = Winter season, day
* IN = Winter season, night
$offtext

**
$offlisting
set EMISSION  / CO2, NOX /;
set TECHNOLOGY /
  ELCOAL, ELNUKE, ELNATGAS, ELHYD, ELDAM, 
  IMPCOAL1, IMPOIL1, IMPNATGAS, IMPURANIUM1, IMPDSL1, IMPGSL1, 
  RIV, 
  RHO, RHE, RL1, RHu, RLu
/;
* set     TECHNOLOGY      / ELCOAL, ELNUKE, ELHYD, ELDAM, E70, IMPDSL1, IMPGSL1, IMPCOAL1, IMPOIL1, IMPURANIUM1, RHE, RHO, RL1, SRE, TRND, TRNE, TRNG, RIV, RHu, RLu, TRNu/;

set FUEL /
  URANIUM, COAL, OIL, NATGAS, HYD, ELC, DSL, GSL, RH, RL, TRN
/;
* set     FUEL    /TRN/;

* SECTORAL sets:
set ELECTRICITY(TECHNOLOGY)   / ELCOAL, ELNUKE, ELNATGAS, ELHYD, ELDAM/;
set SUPPLY(TECHNOLOGY)        / IMPCOAL1, IMPOIL1, IMPNATGAS, IMPURANIUM1, IMPDSL1, IMPGSL1/;
set RESIDENTIAL(TECHNOLOGY)   / RHO, RHE, RL1, RHu, RLu/;
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

parameter YearSplit(TIMESLICE,YEAR) fraction of year in each timeslice;
  YearSplit('ID',y) = .1667;
  YearSplit('IN',y) = .0833;
  YearSplit('SD',y) = .1667;
  YearSplit('SN',y) = .0833;
  YearSplit('WD',y) = .3333;
  YearSplit('WN',y) = .1667;
*display YearSplit;

$onecho > task1.txt
  par=AccumulatedAnnualDemand rng=AccumulatedAnnualDemand!A2:D7 Rdim=3
  par=SpecifiedAnnualDemand rng=SpecifiedAnnualDemand!A2:D27 Rdim=3
  par=CapitalCost rng=CapitalCost!A2:D105 Rdim=3
  par=VariableCost rng=VariableCost!A2:E118 Rdim=4
  par=ResidualCapacity rng=ResidualCapacity!A2:D92 Rdim=3
  par=SalvageFactor rng=SalvageFactor!A2:D92 Rdim=3
  par=AvailabilityFactor rng=AvailabilityFactor!A2:D40 Rdim=3
  par=CapacityFactor rng=CapacityFactor!A2:D53 Rdim=3
  par=EmissionActivityRatio rng=EmissionActivityRatio!A2:D66 Rdim=5
  par=ReserveMarginTagTechnology rng=ReserveMarginTagTechnology!A2:D53 Rdim=3
  par=TotalAnnualMaxCapacity rng=TotalAnnualMaxCapacity!A2:D40 Rdim=3
  par=TotalAnnualMinCapacity rng=TotalAnnualMinCapacity!A2:D14 Rdim=3
  par=OperationalLife rng=OperationalLife!A2:C8 Rdim=2
$offecho

$call GDXXRW C:\Users\david\OneDrive\Documents\GitHub\osemosys_test\ITOMORI_data.xlsx @task1.txt
execute_load "ITOMORI_data.gdx", 
  AccumulatedAnnualDemand
  SpecifiedAnnualDemand
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

parameter SpecifiedDemandProfile(ECONOMY,FUEL,TIMESLICE,YEAR);
  SpecifiedDemandProfile('ITOMORI','RH','ID',y) = .12;
  SpecifiedDemandProfile('ITOMORI','RH','IN',y) = .06;
  SpecifiedDemandProfile('ITOMORI','RH','SD',y) = 0;
  SpecifiedDemandProfile('ITOMORI','RH','SN',y) = 0;
  SpecifiedDemandProfile('ITOMORI','RH','WD',y) = .5467;
  SpecifiedDemandProfile('ITOMORI','RH','WN',y) = .2733;

  SpecifiedDemandProfile('ITOMORI','RL','ID',y) = .15;
  SpecifiedDemandProfile('ITOMORI','RL','IN',y) = .05;
  SpecifiedDemandProfile('ITOMORI','RL','SD',y) = .15;
  SpecifiedDemandProfile('ITOMORI','RL','SN',y) = .05;
  SpecifiedDemandProfile('ITOMORI','RL','WD',y) = .5;
  SpecifiedDemandProfile('ITOMORI','RL','WN',y) = .1;
*display SpecifiedDemandProfile;

* Capacity to Activity Unit:
* energy produced when one unit of capacity is fully used in one year
* 0.753224421 is the level of energy production in Mtoe produced from 1 GW operating for 1 year
parameter CapacityToActivityUnit /
  ITOMORI.ELCOAL  0.753224421
  ITOMORI.ELNUKE  0.753224421
  ITOMORI.ELHYD   0.753224421
  ITOMORI.ELDAM   0.753224421
/;
CapacityToActivityUnit(r,t)$(CapacityToActivityUnit(r,t) = 0) = 1;
*display CapacityToActivityUnit;

parameter TechWithCapacityNeededToMeetPeakTS /
  ITOMORI.ELCOAL  1
  ITOMORI.ELNUKE  1
  ITOMORI.ELHYD   1
  ITOMORI.ELDAM   1
/;
*display TechWithCapacityNeededToMeetPeakTS;

parameter InputActivityRatio(ECONOMY,TECHNOLOGY,FUEL,MODE_OF_OPERATION,YEAR);
  InputActivityRatio(ECONOMY,'ELCOAL','COAL','1',YEAR) =       0.074639343     ;
  InputActivityRatio(ECONOMY,'ELNUKE','URANIUM','1',YEAR) =       0.059711474     ;
  InputActivityRatio(ECONOMY,'ELHYD','HYD','1',YEAR) =       0.074639343     ;
  InputActivityRatio(ECONOMY,'ELDAM','ELC','2',YEAR) =       0.033173307     ;
  InputActivityRatio(ECONOMY,'RHE','ELC','1',YEAR) = 1     ;
  InputActivityRatio(ECONOMY,'RHO','DSL','1',YEAR) =       0.034120832     ;
  InputActivityRatio(ECONOMY,'RL1','ELC','1',YEAR) = 1     ;
*  InputActivityRatio(ECONOMY,'SRE','OIL','1',YEAR) = 1     ;
*  InputActivityRatio(ECONOMY,'TRND','DSL','1',YEAR) =       0.103420273     ;
*  InputActivityRatio(ECONOMY,'TRNE','ELC','1',YEAR) =       0.028900354     ;
*  InputActivityRatio(ECONOMY,'TRNG','GSL','1',YEAR) =       0.103420273     ;
*display InputActivityRatio;

parameter OutputActivityRatio(ECONOMY,TECHNOLOGY,FUEL,MODE_OF_OPERATION,YEAR);
  OutputActivityRatio(ECONOMY,'ELCOAL','ELC','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'ELNUKE','ELC','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'ELHYD','ELC','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'ELDAM','ELC','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'IMPDSL1','DSL','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'IMPGSL1','GSL','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'IMPCOAL1','COAL','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'IMPOIL1','OIL','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'IMPURANIUM1','URANIUM','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'RHE','RH','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'RHO','RH','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'RHU','RH','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'RIV','HYD','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'RL1','RL','1',YEAR) = 1;
  OutputActivityRatio(ECONOMY,'RLU','RL','1',YEAR) = 1;
*  OutputActivityRatio(ECONOMY,'SRE','DSL','1',YEAR) = 0.7;
*  OutputActivityRatio(ECONOMY,'SRE','GSL','1',YEAR) = 0.3;
*  OutputActivityRatio(ECONOMY,'TRND','TRN','1',YEAR) = 1;
*  OutputActivityRatio(ECONOMY,'TRNE','TRN','1',YEAR) = 1;
*  OutputActivityRatio(ECONOMY,'TRNG','TRN','1',YEAR) = 1;
*  OutputActivityRatio(ECONOMY,'TRNU','TRN','1',YEAR) = 1;

*display OutputActivityRatio;

parameter fixedCost(ECONOMY,TECHNOLOGY,YEAR);
  fixedCost(ECONOMY,'ELCOAL',YEAR)  = 40;
  fixedCost(ECONOMY,'ELNUKE',YEAR)  = 500;
  fixedCost(ECONOMY,'ELHYD',YEAR)  = 75;
  fixedCost(ECONOMY,'ELDAM',YEAR)  = 30;
  fixedCost(ECONOMY,'RHO',YEAR) =        41.86799993     ;
  fixedCost(ECONOMY,'RL1',YEAR) =        396.0712794     ;
*  fixedCost(ECONOMY,'TRND',YEAR) =        2177.135997     ;
*  fixedCost(ECONOMY,'TRNE',YEAR) =        4186.799993     ;
*  fixedCost(ECONOMY,'TRNG',YEAR) =        2009.663997     ;

*display fixedCost;


VariableCost(r,t,m,y)$(VariableCost(r,t,m,y) = 0) = 0.00041868;

AvailabilityFactor(r,t,y)$(AvailabilityFactor(r,t,y) = 0) = 1;

CapacityFactor(r,t,y)$(CapacityFactor(r,t,y) = 0) = 1;
*display EmissionActivityRatio;

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
