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
  par=CapacityToActivityUnit rng=CapacityToActivityUnit! Rdim=2
  par=SalvageFactor rng=SalvageFactor! Rdim=3
  par=AvailabilityFactor rng=AvailabilityFactor! Rdim=3
  par=CapacityFactor rng=CapacityFactor! Rdim=3
  par=EmissionActivityRatio rng=EmissionActivityRatio! Rdim=5
  par=ReserveMarginTagTechnology rng=ReserveMarginTagTechnology! Rdim=3
  par=TotalAnnualMaxCapacity rng=TotalAnnualMaxCapacity! Rdim=3
  par=TotalAnnualMinCapacity rng=TotalAnnualMinCapacity! Rdim=3
  par=ReserveMargin rng=ReserveMargin! Rdim=2
  par=OperationalLife rng=OperationalLife! Rdim=2
  par=TradeRoute rng=TradeRoute! Rdim=4
  par=AnnualEmissionLimit rng=AnnualEmissionLimit! Rdim=3
  par=TotalTechnologyAnnualActivityUpperLimit rng=TotalTechnologyAnnualActivityUp! Rdim=3
$offecho

$call GDXXRW C:\GitHub\APERC-EM\sector_data.xlsx @task1.txt
execute_load "sector_data.gdx",
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
  CapacityToActivityUnit
  SalvageFactor
  AvailabilityFactor
  CapacityFactor
  EmissionActivityRatio
  ReserveMarginTagTechnology
  TotalAnnualMaxCapacity
  TotalAnnualMinCapacity
  ReserveMargin
  OperationalLife
  TradeRoute
  AnnualEmissionLimit
  TotalTechnologyAnnualActivityUpperLimit
;

* ## END OF EXCEL CALLS
* ## Parameters not in Excel file
* You can add these to the Excel file using the syntax above

AnnualExogenousEmission(r,ghg,y) = 0;
AnnualEmissionLimit(r,ghg,y) = 9999;
*display AnnualEmissionLimit;

ModelPeriodExogenousEmission(r,ghg) = 0;
ModelPeriodEmissionLimit(r,ghg) = 9999;
*display ModelPeriodEmissionLimit;

StorageUpperLimit(r,s) = 9999;
StorageLowerLimit(r,s) = 0;
*display StorageUpperLimit;
* display StorageLowerLimit;

DiscountRate(r,a) = 0.05;
*display DiscountRate;

parameter TechnologyToStorage /
  01_AUS.POWDAM.DAM.2  1
/;
*display TechnologyToStorage;

parameter TechnologyFromStorage /
  01_AUS.POWDAM.DAM.1  1
/;

VariableCost(r,a,m,y)$(VariableCost(r,a,m,y) = 0) = 0.00041868;

AvailabilityFactor(r,a,y)$(AvailabilityFactor(r,a,y) = 0) = 1;

CapacityFactor(r,a,y)$(CapacityFactor(r,a,y) = 0) = 1;

* Capacity to Activity Unit:
* energy produced when one unit of capacity is fully used in one year
* 0.753224421 is the level of energy production in Mtoe produced from 1 GW operating for 1 year
CapacityToActivityUnit(r,a)$(CapacityToActivityUnit(r,a) = 0) = 1;
*display CapacityToActivityUnit;

parameter TechWithCapacityNeededToMeetPeakTS /
  01_AUS.POWCOAL    1
  01_AUS.POWNUKE    1
  01_AUS.POWNATGAS  1
  01_AUS.POWHYD     1
  01_AUS.POWDAM     1
  27_WOR.POWCOAL    0
/;
*display TechWithCapacityNeededToMeetPeakTS;

EmissionsPenalty(r,ghg,y) = eps;
*display EmissionsPenalty;

parameter ReserveMarginTagFuel /
  01_AUS.ELC.2016  1
  01_AUS.ELC.2017  1
  27_WOR.ELC.2016  1
  27_WOR.ELC.2017  1
/;
*display ReserveMarginTagFuel;

OperationalLife(r,a)$(OperationalLife(r,a) = 0) = 1;
*display OperationalLife;

TotalAnnualMaxCapacity(r,a,y)$(TotalAnnualMaxCapacity(r,a,y) = 0) = 99999;

TotalAnnualMaxCapacityInvestment(r,a,y) = 99999;
*display TotalAnnualMaxCapacityInvestment;

TotalAnnualMinCapacityInvestment(r,a,y) = 0;

TotalTechnologyAnnualActivityUpperLimit(r,a,y) = 99999;
*display TotalTechnologyAnnualActivityUpperLimit;

TotalTechnologyAnnualActivityLowerLimit(r,a,y) = 0;

TotalTechnologyModelPeriodActivityUpperLimit(r,a) = 99999;
*display TotalTechnologyModelPeriodActivityUpperLimit;

TotalTechnologyModelPeriodActivityLowerLimit(r,a) = 0;

RETagTechnology(r,a,y) = 0;

RETagFuel(r,f,y) = 0;

REMinProductionTarget(r,y) = 0;

StorageInflectionTimes(y,l,b) = 0;