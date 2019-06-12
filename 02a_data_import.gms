* =======================================================================================================
* Import data
* Configure model policies and adjustments
* =======================================================================================================


* ## BEGIN EXCEL CALLS
* parameters listed in Excel file
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

  par=AnnualEmissionLimit rng=AnnualEmissionLimit! Rdim=3
  par=TotalTechnologyAnnualActivityUpperLimit rng=TotalTechnologyAnnualActivityUp! Rdim=3
$offecho
*  par=TradeRoute rng=TradeRoute! Rdim=4
$call GDXXRW C:\Users\david\OneDrive\Documents\GitHub\APERC-EM\TOKYO_data.xlsx @task1.txt
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

  AnnualEmissionLimit
  TotalTechnologyAnnualActivityUpperLimit
;
*  TradeRoute
* ## END OF EXCEL CALLS
* ## Parameters not in Excel file

$include new-data.gms

AnnualExogenousEmission(r,e,y) = 0;
AnnualEmissionLimit(r,e,y) = 9999;
*display AnnualEmissionLimit;

ModelPeriodExogenousEmission(r,e) = 0;
ModelPeriodEmissionLimit(r,e) = 9999;
*display ModelPeriodEmissionLimit;

StorageUpperLimit(r,s) = 9999;
StorageLowerLimit(r,s) = 0;
*display StorageUpperLimit;
* display StorageLowerLimit;

DiscountRate(r,t) = 0.05;
*display DiscountRate;

parameter TechnologyToStorage /
  tokyo.ELDAM.DAM.2  1
/;
*display TechnologyToStorage;

parameter TechnologyFromStorage /
  tokyo.ELDAM.DAM.1  1
/;

VariableCost(r,t,m,y)$(VariableCost(r,t,m,y) = 0) = 0.00041868;

AvailabilityFactor(r,t,y)$(AvailabilityFactor(r,t,y) = 0) = 1;

CapacityFactor(r,t,y)$(CapacityFactor(r,t,y) = 0) = 1;

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
  osaka.ELCOAL    0
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