* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
* 
* Trade additions by David Wogan, APERC - Jan 2019
*
* OSEMOSYS 2011.07.07
* Open Source energy Modeling SYStem
*
* ============================================================================
*
* #########################################
* ######################## Model Definition #############
* #########################################
*
* ##############
* # Sets #
* ##############
*
set YEAR;
alias (y,yy,YEAR);
set TECHNOLOGY;
alias (t,TECHNOLOGY)
set TIMESLICE;
alias (l,TIMESLICE);
set FUEL;
alias (f,FUEL);
set EMISSION;
alias (e,EMISSION);
set MODE_OF_OPERATION;
alias (m,MODE_OF_OPERATION);
set ECONOMY;
alias (r,rr,ECONOMY2,ECONOMY);
set BOUNDARY_INSTANCES;
alias (b,BOUNDARY_INSTANCES);
set STORAGE;
alias (s,STORAGE);
*
* ####################
* # Parameters #
* ####################
*
* ####### Global #############
*
parameter StartYear;
parameter YearSplit(TIMESLICE,YEAR);
parameter DiscountRate(ECONOMY,TECHNOLOGY);
parameter TradeRoute(ECONOMY,ECONOMY2,FUEL,YEAR);
*
* ####### Demands #############
*
parameter SpecifiedAnnualDemand(ECONOMY,FUEL,YEAR);
parameter SpecifiedDemandProfile(ECONOMY,FUEL,TIMESLICE,YEAR);
positive variable RateOfDemand(YEAR,TIMESLICE,FUEL,ECONOMY);
positive variable Demand(YEAR,TIMESLICE,FUEL,ECONOMY);
parameter AccumulatedAnnualDemand(ECONOMY,FUEL,YEAR);
*
* ######## Technology #############
*
* ######## Performance #############
*
parameter CapacityToActivityUnit(ECONOMY,TECHNOLOGY);
parameter TechWithCapacityNeededToMeetPeakTS(ECONOMY,TECHNOLOGY);
parameter CapacityFactor(ECONOMY,TECHNOLOGY,YEAR);
parameter AvailabilityFactor(ECONOMY,TECHNOLOGY,YEAR);
parameter OperationalLife(ECONOMY,TECHNOLOGY);
parameter ResidualCapacity(ECONOMY,TECHNOLOGY,YEAR);
parameter SalvageFactor(ECONOMY,TECHNOLOGY,YEAR);
parameter InputActivityRatio(ECONOMY,TECHNOLOGY,FUEL,MODE_OF_OPERATION,YEAR);
parameter OutputActivityRatio(ECONOMY,TECHNOLOGY,FUEL,MODE_OF_OPERATION,YEAR);
*
* ######## Technology Costs #############
*
parameter CapitalCost(ECONOMY,TECHNOLOGY,YEAR);
parameter VariableCost(ECONOMY,TECHNOLOGY,MODE_OF_OPERATION,YEAR);
parameter FixedCost(ECONOMY,TECHNOLOGY,YEAR);
*
* ######## Storage Parameters #############
*
parameter StorageInflectionTimes(YEAR,TIMESLICE,BOUNDARY_INSTANCES);
parameter TechnologyToStorage(ECONOMY,TECHNOLOGY,STORAGE,MODE_OF_OPERATION);
parameter TechnologyFromStorage(ECONOMY,TECHNOLOGY,STORAGE,MODE_OF_OPERATION);
parameter StorageUpperLimit(ECONOMY,STORAGE);
parameter StorageLowerLimit(ECONOMY,STORAGE);
*
* ######## Capacity Constraints #############
*
parameter TotalAnnualMaxCapacity(ECONOMY,TECHNOLOGY,YEAR);
parameter TotalAnnualMinCapacity(ECONOMY,TECHNOLOGY,YEAR);
*
* ######## Investment Constraints #############
*
parameter TotalAnnualMaxCapacityInvestment(ECONOMY,TECHNOLOGY,YEAR);
parameter TotalAnnualMinCapacityInvestment(ECONOMY,TECHNOLOGY,YEAR);
*
* ######## Activity Constraints #############
*
parameter TotalTechnologyAnnualActivityUpperLimit(ECONOMY,TECHNOLOGY,YEAR);
parameter TotalTechnologyAnnualActivityLowerLimit(ECONOMY,TECHNOLOGY,YEAR);
parameter TotalTechnologyModelPeriodActivityUpperLimit(ECONOMY,TECHNOLOGY);
parameter TotalTechnologyModelPeriodActivityLowerLimit(ECONOMY,TECHNOLOGY);
*
* ######## Reserve Margin ############
*
parameter ReserveMarginTagTechnology(ECONOMY,TECHNOLOGY,YEAR);
parameter ReserveMarginTagFuel(ECONOMY,FUEL,YEAR);
parameter ReserveMargin(ECONOMY,YEAR);
*
* ######## RE Generation Target ############
*
parameter RETagTechnology(ECONOMY,TECHNOLOGY,YEAR);
parameter RETagFuel(ECONOMY,FUEL,YEAR);
parameter REMinProductionTarget(ECONOMY,YEAR);
*
* ######### Emissions & Penalties #############
*
parameter EmissionActivityRatio(ECONOMY,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,YEAR);
parameter EmissionsPenalty(ECONOMY,EMISSION,YEAR);
parameter AnnualExogenousEmission(ECONOMY,EMISSION,YEAR);
parameter AnnualEmissionLimit(ECONOMY,EMISSION,YEAR);
parameter ModelPeriodExogenousEmission(ECONOMY,EMISSION);
parameter ModelPeriodEmissionLimit(ECONOMY,EMISSION);
*
parameter YearVal(YEAR);
*
* #####################
* # Model Variables #
* #####################
*
* ############### Capacity Variables ############*
*
positive variable NewCapacity(YEAR,TECHNOLOGY,ECONOMY);
positive variable AccumulatedNewCapacity(YEAR,TECHNOLOGY,ECONOMY);
positive variable TotalCapacityAnnual(YEAR,TECHNOLOGY,ECONOMY);
*
*############### Activity Variables #############
*
positive variable RateOfActivity(YEAR,TIMESLICE,TECHNOLOGY,MODE_OF_OPERATION,ECONOMY);
positive variable RateOfTotalActivity(YEAR,TIMESLICE,TECHNOLOGY,ECONOMY);
positive variable TotalTechnologyAnnualActivity(YEAR,TECHNOLOGY,ECONOMY);
positive variable TotalAnnualTechnologyActivityByMode(YEAR,TECHNOLOGY,MODE_OF_OPERATION,ECONOMY);
positive variable RateOfProductionByTechnologyByMode(YEAR,TIMESLICE,TECHNOLOGY,MODE_OF_OPERATION,FUEL,ECONOMY);
positive variable RateOfProductionByTechnology(YEAR,TIMESLICE,TECHNOLOGY,FUEL,ECONOMY);
positive variable ProductionByTechnology(YEAR,TIMESLICE,TECHNOLOGY,FUEL,ECONOMY);
positive variable ProductionByTechnologyAnnual(YEAR,TECHNOLOGY,FUEL,ECONOMY);
positive variable RateOfProduction(YEAR,TIMESLICE,FUEL,ECONOMY);
positive variable Production(YEAR,TIMESLICE,FUEL,ECONOMY);
positive variable RateOfUseByTechnologyByMode(YEAR,TIMESLICE,TECHNOLOGY,MODE_OF_OPERATION,FUEL,ECONOMY);
positive variable RateOfUseByTechnology(YEAR,TIMESLICE,TECHNOLOGY,FUEL,ECONOMY);
positive variable UseByTechnologyAnnual(YEAR,TECHNOLOGY,FUEL,ECONOMY);
positive variable RateOfUse(YEAR,TIMESLICE,FUEL,ECONOMY);
positive variable UseByTechnology(YEAR,TIMESLICE,TECHNOLOGY,FUEL,ECONOMY);
positive variable Use(YEAR,TIMESLICE,FUEL,ECONOMY);
*
positive variable ProductionAnnual(YEAR,FUEL,ECONOMY);
positive variable UseAnnual(YEAR,FUEL,ECONOMY);
*
positive variable Trade(ECONOMY,ECONOMY2,TIMESLICE,FUEL,YEAR);
positive variable TradeAnnual(ECONOMY,ECONOMY2,FUEL,YEAR);
*
*
* ############### Costing Variables #############
*
positive variable CapitalInvestment(YEAR,TECHNOLOGY,ECONOMY);
positive variable DiscountedCapitalInvestment(YEAR,TECHNOLOGY,ECONOMY);
*
positive variable SalvageValue(YEAR,TECHNOLOGY,ECONOMY);
positive variable DiscountedSalvageValue(YEAR,TECHNOLOGY,ECONOMY);
positive variable OperatingCost(YEAR,TECHNOLOGY,ECONOMY);
positive variable DiscountedOperatingCost(YEAR,TECHNOLOGY,ECONOMY);
*
positive variable AnnualVariableOperatingCost(YEAR,TECHNOLOGY,ECONOMY);
positive variable AnnualFixedOperatingCost(YEAR,TECHNOLOGY,ECONOMY);
positive variable VariableOperatingCost(YEAR,TIMESLICE,TECHNOLOGY,ECONOMY);
*
positive variable TotalDiscountedCost(YEAR,TECHNOLOGY,ECONOMY);
*
positive variable ModelPeriodCostByECONOMY (ECONOMY);
*
* ############### Storage Variables #############
*
free variable NetStorageCharge(STORAGE,YEAR,TIMESLICE,ECONOMY);
free variable StorageLevel(STORAGE,BOUNDARY_INSTANCES,ECONOMY);
free variable StorageCharge(STORAGE,YEAR,TIMESLICE,ECONOMY);
free variable StorageDischarge(STORAGE,YEAR,TIMESLICE,ECONOMY);
*
* ######## Reserve Margin #############
*
positive variable TotalCapacityInReserveMargin(ECONOMY,YEAR);
positive variable DemandNeedingReserveMargin(YEAR,TIMESLICE,ECONOMY);
*
* ######## RE Gen Target #############
*
free variable TotalGenerationByRETechnologies(YEAR,ECONOMY);
free variable TotalREProductionAnnual(YEAR,ECONOMY);
free variable RETotalDemandOfTargetFuelAnnual(YEAR,ECONOMY);
*
free variable TotalTechnologyModelPeriodActivity(TECHNOLOGY,ECONOMY);
*
* ######## Emissions #############
*
positive variable AnnualTechnologyEmissionByMode(YEAR,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,ECONOMY);
positive variable AnnualTechnologyEmission(YEAR,TECHNOLOGY,EMISSION,ECONOMY);
positive variable AnnualTechnologyEmissionPenaltyByEmission(YEAR,TECHNOLOGY,EMISSION,ECONOMY);
positive variable AnnualTechnologyEmissionsPenalty(YEAR,TECHNOLOGY,ECONOMY);
positive variable DiscountedTechnologyEmissionsPenalty(YEAR,TECHNOLOGY,ECONOMY);
positive variable AnnualEmissions(YEAR,EMISSION,ECONOMY);
free variable EmissionsProduction(YEAR,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,ECONOMY);
positive variable ModelPeriodEmissions(EMISSION,ECONOMY);
