* OSEMOSYS_EQU.GMS - model equations
*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
*
* OSEMOSYS 2011.07.07
* Open Source energy Modeling SYStem
*
* ============================================================================
*
* ######################
* # Objective Function #
* ######################
*
*minimize cost: sum(YEAR,TECHNOLOGY,ECONOMY) TotalDiscountedCost[y,a,r];
free variable z;
equation cost;
cost.. z =e= sum((y,a,r), TotalDiscountedCost(y,a,r));
*
* ####################
* # Constraints #
* ####################
equation EQ_SpecifiedDemand1(YEAR2,TIMESLICE,FUEL,ECONOMY);
EQ_SpecifiedDemand1(y,l,f,r).. SpecifiedAnnualDemand(r,f,y)*SpecifiedDemandProfile(r,f,l,y) / YearSplit(l,y) =e= RateOfDemand(y,l,f,r);
*
* ############### Storage #############
*
equation S1_StorageCharge(STORAGE,YEAR2,TIMESLICE,ECONOMY);
S1_StorageCharge(s,y,l,r).. sum((a,m), (RateOfActivity(y,l,a,m,r) * TechnologyToStorage(r,a,s,m))) * YearSplit(l,y) =e= StorageCharge(s,y,l,r);

equation S2_StorageDischarge(STORAGE,YEAR2,TIMESLICE,ECONOMY);
S2_StorageDischarge(s,y,l,r).. sum((a,m), (RateOfActivity(y,l,a,m,r) * TechnologyFromStorage(r,a,s,m))) * YearSplit(l,y) =e= StorageDischarge(s,y,l,r);

equation S3_NetStorageCharge(STORAGE,YEAR2,TIMESLICE,ECONOMY);
S3_NetStorageCharge(s,y,l,r).. NetStorageCharge(s,y,l,r) =e= StorageCharge(s,y,l,r) - StorageDischarge(s,y,l,r);

equation S4_StorageLevelAtInflection(BOUNDARY_INSTANCES,STORAGE,ECONOMY);
S4_StorageLevelAtInflection(b,s,r).. sum((l,y), (NetStorageCharge(s,y,l,r)/YearSplit(l,y)*StorageInflectionTimes(y,l,b))) =e= StorageLevel(s,b,r);

equation S5_StorageLowerLimit(BOUNDARY_INSTANCES,STORAGE,ECONOMY);
S5_StorageLowerLimit(b,s,r).. StorageLevel(s,b,r) =g= StorageLowerLimit(r,s);

equation S6_StorageUpperLimit(BOUNDARY_INSTANCES,STORAGE,ECONOMY);
S6_StorageUpperLimit(b,s,r).. StorageLevel(s,b,r) =l= StorageUpperLimit(r,s);
*
* ############### Capacity Adequacy A #############
*
equation CBa1_TotalNewCapacity(YEAR2,ACTIVITY,ECONOMY);
CBa1_TotalNewCapacity(y,a,r).. AccumulatedNewCapacity(y,a,r) =e= sum(yy$((YearVal(y)-YearVal(yy) < OperationalLife(r,a)) AND (YearVal(y)-YearVal(yy) >= 0)), NewCapacity(yy,a,r));

equation CBa2_TotalAnnualCapacity(YEAR2,ACTIVITY,ECONOMY);
CBa2_TotalAnnualCapacity(y,a,r).. AccumulatedNewCapacity(y,a,r)+ ResidualCapacity(r,a,y) =e= TotalCapacityAnnual(y,a,r);

equation CBa3_TotalActivityOfEachTechnology(YEAR2,ACTIVITY,TIMESLICE,ECONOMY);
CBa3_TotalActivityOfEachTechnology(y,a,l,r).. sum(m, RateOfActivity(y,l,a,m,r)) =e= RateOfTotalActivity(y,l,a,r);

equation CBa4_Constraint_Capacity(YEAR2,TIMESLICE,ACTIVITY,ECONOMY);
CBa4_Constraint_Capacity(y,l,a,r)$(TechWithCapacityNeededToMeetPeakTS(r,a) <> 0).. RateOfTotalActivity(y,l,a,r) =l= TotalCapacityAnnual(y,a,r) * CapacityFactor(r,a,y)*CapacityToActivityUnit(r,a);
* Note that the PlannedMaintenance equation below ensures that all other technologies have a capacity great enough to at least meet the annual average.
*
* ############### Capacity Adequacy B #############
*
equation CBb1_PlannedMaintenance(YEAR2,ACTIVITY,ECONOMY);
CBb1_PlannedMaintenance(y,a,r).. sum(l, RateOfTotalActivity(y,l,a,r)*YearSplit(l,y)) =l= TotalCapacityAnnual(y,a,r)*CapacityFactor(r,a,y)* AvailabilityFactor(r,a,y)*CapacityToActivityUnit(r,a);
*
* ##############* Energy Balance A #############
*
* #### This first set of equations computes 'fuel' production ####
equation EBa1_RateOfFuelProduction1(YEAR2,TIMESLICE,FUEL,ACTIVITY,MODE_OF_OPERATION,ECONOMY);
EBa1_RateOfFuelProduction1(y,l,f,a,m,r).. RateOfActivity(y,l,a,m,r)*OutputActivityRatio(r,a,f,m,y) =e= RateOfProductionByTechnologyByMode(y,l,a,m,f,r);

equation EBa2_RateOfFuelProduction2(YEAR2,TIMESLICE,FUEL,ACTIVITY,ECONOMY);
EBa2_RateOfFuelProduction2(y,l,f,a,r).. sum(m, RateOfProductionByTechnologyByMode(y,l,a,m,f,r)) =e= RateOfProductionByTechnology(y,l,a,f,r);

equation EBa3_RateOfFuelProduction3(YEAR2,TIMESLICE,FUEL,ECONOMY);
EBa3_RateOfFuelProduction3(y,l,f,r).. sum(a, RateOfProductionByTechnology(y,l,a,f,r)) =e= RateOfProduction(y,l,f,r);

* #### This set of equations computes 'fuel' consumption ####
equation EBa4_RateOfFuelUse1(YEAR2,TIMESLICE,FUEL,ACTIVITY,MODE_OF_OPERATION,ECONOMY);
EBa4_RateOfFuelUse1(y,l,f,a,m,r).. RateOfActivity(y,l,a,m,r)*InputActivityRatio(r,a,f,m,y) =e= RateOfUseByTechnologyByMode(y,l,a,m,f,r);

equation EBa5_RateOfFuelUse2(YEAR2,TIMESLICE,FUEL,ACTIVITY,ECONOMY);
EBa5_RateOfFuelUse2(y,l,f,a,r).. sum(m, RateOfUseByTechnologyByMode(y,l,a,m,f,r)) =e= RateOfUseByTechnology(y,l,a,f,r);

equation EBa6_RateOfFuelUse3(YEAR2,TIMESLICE,FUEL,ECONOMY);
EBa6_RateOfFuelUse3(y,l,f,r).. sum(a, RateOfUseByTechnology(y,l,a,f,r)) =e= RateOfUse(y,l,f,r);

* #### These equations perform supply and demand balance
equation EBa7_EnergyBalanceEachTS1(YEAR2,TIMESLICE,FUEL,ECONOMY);
EBa7_EnergyBalanceEachTS1(y,l,f,r).. RateOfProduction(y,l,f,r)*YearSplit(l,y) =e= Production(y,l,f,r);

equation EBa8_EnergyBalanceEachTS2(YEAR2,TIMESLICE,FUEL,ECONOMY);
EBa8_EnergyBalanceEachTS2(y,l,f,r).. RateOfUse(y,l,f,r)*YearSplit(l,y) =e= Use(y,l,f,r);

equation EBa9_EnergyBalanceEachTS3(YEAR2,TIMESLICE,FUEL,ECONOMY);
EBa9_EnergyBalanceEachTS3(y,l,f,r).. RateOfDemand(y,l,f,r)*YearSplit(l,y) =e= Demand(y,l,f,r);

equation EBa10_EnergyBalanceEachTS4(ECONOMY,ECONOMY2,TIMESLICE,FUEL,YEAR2);
EBa10_EnergyBalanceEachTS4(r,rr,l,f,y).. Trade(r,rr,l,f,y) =e= -Trade(rr,r,l,f,y);

equation EBa11_EnergyBalanceEachTS5(YEAR2,TIMESLICE,FUEL,ECONOMY);
EBa11_EnergyBalanceEachTS5(y,l,f,r).. Production(y,l,f,r) =g= Demand(y,l,f,r) + Use(y,l,f,r) + sum(rr,Trade(r,rr,l,f,y)*TradeRoute(r,rr,f,y));
*
* ##############* Energy Balance B #############
*
equation EBb1_EnergyBalanceEachYear1(YEAR2,FUEL,ECONOMY);
EBb1_EnergyBalanceEachYear1(y,f,r).. sum(l, Production(y,l,f,r)) =e= ProductionAnnual(y,f,r);

equation EBb2_EnergyBalanceEachYear2(YEAR2,FUEL,ECONOMY);
EBb2_EnergyBalanceEachYear2(y,f,r).. sum(l, Use(y,l,f,r)) =e= UseAnnual(y,f,r);

equation EBb3_EnergyBalanceEachYear3(ECONOMY,ECONOMY2,FUEL,YEAR2);
EBb3_EnergyBalanceEachYear3(r,rr,f,y).. sum(l,Trade(r,rr,l,f,y)*TradeRoute(r,rr,f,y)) =e= TradeAnnual(r,rr,f,y);

equation EBb4_EnergyBalanceEachYear4(YEAR2,FUEL,ECONOMY);
EBb4_EnergyBalanceEachYear4(y,f,r).. ProductionAnnual(y,f,r) =g= UseAnnual(y,f,r) + sum(rr,TradeAnnual(r,rr,f,y)*TradeRoute(r,rr,f,y)) + AccumulatedAnnualDemand(r,f,y);
*
* ##############* Accounting Technology Production/Use #############
*
equation Acc1_FuelProductionByTechnology(YEAR2,TIMESLICE,ACTIVITY,FUEL,ECONOMY);
Acc1_FuelProductionByTechnology(y,l,a,f,r).. RateOfProductionByTechnology(y,l,a,f,r) * YearSplit(l,y) =e= ProductionByTechnology(y,l,a,f,r);

equation Acc2_FuelUseByTechnology(YEAR2,TIMESLICE,ACTIVITY,FUEL,ECONOMY);
Acc2_FuelUseByTechnology(y,l,a,f,r).. RateOfUseByTechnology(y,l,a,f,r) * YearSplit(l,y) =e= UseByTechnology(y,l,a,f,r);

equation Acc3_AverageAnnualRateOfActivity(YEAR2,ACTIVITY,MODE_OF_OPERATION,ECONOMY);
Acc3_AverageAnnualRateOfActivity(y,a,m,r).. sum(l, RateOfActivity(y,l,a,m,r)*YearSplit(l,y)) =e= TotalAnnualTechnologyActivityByMode(y,a,m,r);

equation Acc3_ModelPeriodCostByECONOMY(ECONOMY);
Acc3_ModelPeriodCostByECONOMY(r)..sum((y,a), TotalDiscountedCost(y,a,r)) =e= ModelPeriodCostByECONOMY(r);
*
* ############### Captial Costs #############
*
equation CC1_UndiscountedCapitalInvestment(YEAR2,ACTIVITY,ECONOMY);
CC1_UndiscountedCapitalInvestment(y,a,r).. CapitalCost(r,a,y) * NewCapacity(y,a,r) =e= CapitalInvestment(y,a,r);

equation CC2_DiscountingCapitalInvestmenta(YEAR2,ACTIVITY,ECONOMY);
CC2_DiscountingCapitalInvestmenta(y,a,r).. CapitalInvestment(y,a,r)/((1+DiscountRate(r,a))**(YearVal(y)-StartYear)) =e= DiscountedCapitalInvestment(y,a,r);
*
* ##############* Salvage Value #############
*
equation SV1_SalvageValueAtEndOfPeriod1(YEAR2,ACTIVITY,ECONOMY);
SV1_SalvageValueAtEndOfPeriod1(y,a,r)$((YearVal(y) + OperationalLife(r,a)-1 > smax(yy, YearVal(yy))) and (DiscountRate(r,a) > 0))..
SalvageValue(y,a,r) =e= CapitalCost(r,a,y)*NewCapacity(y,a,r)*(1-(((1+DiscountRate(r,a))**(smax(yy, YearVal(yy)) - YearVal(y)+1) -1)
/((1+DiscountRate(r,a))**OperationalLife(r,a)-1)));

equation SV2_SalvageValueAtEndOfPeriod2(YEAR2,ACTIVITY,ECONOMY);
SV2_SalvageValueAtEndOfPeriod2(y,a,r)$((YearVal(y) + OperationalLife(r,a)-1 > smax(yy, YearVal(yy))) and (DiscountRate(r,a) = 0))..
SalvageValue(y,a,r) =e= CapitalCost(r,a,y)*NewCapacity(y,a,r)*(1-smax(yy, YearVal(yy))- YearVal(y)+1)/OperationalLife(r,a);

equation SV3_SalvageValueAtEndOfPeriod3(YEAR2,ACTIVITY,ECONOMY);
SV3_SalvageValueAtEndOfPeriod3(y,a,r)$(YearVal(y) + OperationalLife(r,a)-1 <= smax(yy, YearVal(yy)))..
SalvageValue(y,a,r) =e= 0;

equation SV4_SalvageValueDiscToStartYr(YEAR2,ACTIVITY,ECONOMY);
SV4_SalvageValueDiscToStartYr(y,a,r)..
DiscountedSalvageValue(y,a,r) =e= SalvageValue(y,a,r)/((1+DiscountRate(r,a))**(1+smax(yy, YearVal(yy)) - smin(yy, YearVal(yy))));
*
* ############### Operating Costs #############
*
equation OC1_OperatingCostsVariable(YEAR2,ACTIVITY,ECONOMY);
OC1_OperatingCostsVariable(y,a,r).. sum(m, (TotalAnnualTechnologyActivityByMode(y,a,m,r)*VariableCost(r,a,m,y))) =e= AnnualVariableOperatingCost(y,a,r);

equation OC2_OperatingCostsFixedAnnual(YEAR2,ACTIVITY,ECONOMY);
OC2_OperatingCostsFixedAnnual(y,a,r).. TotalCapacityAnnual(y,a,r)*FixedCost(r,a,y) =e= AnnualFixedOperatingCost(y,a,r);

equation OC3_OperatingCostsTotalAnnual(YEAR2,ACTIVITY,ECONOMY);
OC3_OperatingCostsTotalAnnual(y,a,r).. AnnualFixedOperatingCost(y,a,r)+AnnualVariableOperatingCost(y,a,r) =e= OperatingCost(y,a,r);

equation OC4_DiscountedOperatingCostsTotalAnnual(YEAR2,ACTIVITY,ECONOMY);
OC4_DiscountedOperatingCostsTotalAnnual(y,a,r).. OperatingCost(y,a,r)/((1+DiscountRate(r,a))**(YearVal(y)-smin(yy, YearVal(yy))+0.5)) =e= DiscountedOperatingCost(y,a,r);
* ############### Total Discounted Costs #############
*
equation TDC1_TotalDiscountedCostByTechnology(YEAR2,ACTIVITY,ECONOMY);
TDC1_TotalDiscountedCostByTechnology(y,a,r).. DiscountedOperatingCost(y,a,r)+DiscountedCapitalInvestment(y,a,r)+DiscountedTechnologyEmissionsPenalty(y,a,r)-DiscountedSalvageValue(y,a,r) =e= TotalDiscountedCost(y,a,r);
*
* ############### Total Capacity Constraints ##############
*

equation TCC1_TotalAnnualMaxCapacityConstraint(YEAR2,ACTIVITY,ECONOMY);
TCC1_TotalAnnualMaxCapacityConstraint(y,a,r)$(TotalAnnualMaxCapacity(r,a,y) < 99999).. TotalCapacityAnnual(y,a,r) =l= TotalAnnualMaxCapacity(r,a,y);

equation TCC2_TotalAnnualMinCapacityConstraint(YEAR2,ACTIVITY,ECONOMY);
TCC2_TotalAnnualMinCapacityConstraint(y,a,r)$(TotalAnnualMinCapacity(r,a,y)>0).. TotalCapacityAnnual(y,a,r) =g= TotalAnnualMinCapacity(r,a,y);
*
* ############### New Capacity Constraints ##############
*
equation NCC1_TotalAnnualMaxNewCapacityConstraint(YEAR2,ACTIVITY,ECONOMY);
NCC1_TotalAnnualMaxNewCapacityConstraint(y,a,r)$(TotalAnnualMaxCapacityInvestment(r,a,y) < 9999).. NewCapacity(y,a,r) =l= TotalAnnualMaxCapacityInvestment(r,a,y);

equation NCC2_TotalAnnualMinNewCapacityConstraint(YEAR2,ACTIVITY,ECONOMY);
NCC2_TotalAnnualMinNewCapacityConstraint(y,a,r)$(TotalAnnualMinCapacityInvestment(r,a,y) > 0).. NewCapacity(y,a,r) =g= TotalAnnualMinCapacityInvestment(r,a,y);
*
* ################ Annual Activity Constraints ##############
*
equation AAC1_TotalAnnualTechnologyActivity(YEAR2,ACTIVITY,ECONOMY);
AAC1_TotalAnnualTechnologyActivity(y,a,r).. sum(l, (RateOfTotalActivity(y,l,a,r)*YearSplit(l,y))) =e= TotalTechnologyAnnualActivity(y,a,r);

equation AAC2_TotalAnnualTechnologyActivityUpperLimit(YEAR2,ACTIVITY,ECONOMY);
AAC2_TotalAnnualTechnologyActivityUpperLimit(y,a,r)$(TotalTechnologyAnnualActivityUpperLimit(r,a,y) <9999).. TotalTechnologyAnnualActivity(y,a,r) =l= TotalTechnologyAnnualActivityUpperLimit(r,a,y);

equation AAC3_TotalAnnualTechnologyActivityLowerLimit(YEAR2,ACTIVITY,ECONOMY);
AAC3_TotalAnnualTechnologyActivityLowerLimit(y,a,r)$(TotalTechnologyAnnualActivityLowerLimit(r,a,y) > 0).. TotalTechnologyAnnualActivity(y,a,r) =g= TotalTechnologyAnnualActivityLowerLimit(r,a,y);
*
* ################ Total Activity Constraints ##############
*
equation TAC1_TotalModelHorizenTechnologyActivity(ACTIVITY,ECONOMY);
TAC1_TotalModelHorizenTechnologyActivity(a,r).. sum(y, TotalTechnologyAnnualActivity(y,a,r)) =e= TotalTechnologyModelPeriodActivity(a,r);

equation TAC2_TotalModelHorizenTechnologyActivityUpperLimit(YEAR2,ACTIVITY,ECONOMY);
TAC2_TotalModelHorizenTechnologyActivityUpperLimit(y,a,r)$(TotalTechnologyModelPeriodActivityUpperLimit(r,a) < 9999).. TotalTechnologyModelPeriodActivity(a,r) =l= TotalTechnologyModelPeriodActivityUpperLimit(r,a);

equation TAC3_TotalModelHorizenTechnologyActivityLowerLimit(YEAR2,ACTIVITY,ECONOMY);
TAC3_TotalModelHorizenTechnologyActivityLowerLimit(y,a,r)$(TotalTechnologyModelPeriodActivityLowerLimit(r,a) > 0).. TotalTechnologyModelPeriodActivity(a,r) =g= TotalTechnologyModelPeriodActivityLowerLimit(r,a);
*
* ############### Reserve Margin Constraint #############* NTS: Should change demand for production
*
equation RM1_ReserveMargin_TechologiesIncluded_In_Activity_Units(YEAR2,TIMESLICE,ECONOMY);
RM1_ReserveMargin_TechologiesIncluded_In_Activity_Units(y,l,r).. sum (a, (TotalCapacityAnnual(y,a,r) *ReserveMarginTagTechnology(r,a,y) * CapacityToActivityUnit(r,a))) =e= TotalCapacityInReserveMargin(r,y);

equation RM2_ReserveMargin_FuelsIncluded(YEAR2,TIMESLICE,ECONOMY);
RM2_ReserveMargin_FuelsIncluded(y,l,r).. sum (f, (RateOfProduction(y,l,f,r) * ReserveMarginTagFuel(r,f,y))) =e= DemandNeedingReserveMargin(y,l,r);

equation RM3_ReserveMargin_Constraint(YEAR2,TIMESLICE,ECONOMY);
RM3_ReserveMargin_Constraint(y,l,r).. DemandNeedingReserveMargin(y,l,r) * ReserveMargin(r,y) =l= TotalCapacityInReserveMargin(r,y);
*
* ############### RE Production Target #############* NTS: Should change demand for production
*
equation RE1_FuelProductionByTechnologyAnnual(YEAR2,ACTIVITY,FUEL,ECONOMY);
RE1_FuelProductionByTechnologyAnnual(y,a,f,r).. sum(l, ProductionByTechnology(y,l,a,f,r)) =e= ProductionByTechnologyAnnual(y,a,f,r);

equation RE2_TechIncluded(YEAR,ECONOMY);
RE2_TechIncluded(y,r).. sum((a,f), (ProductionByTechnologyAnnual(y,a,f,r)*RETagTechnology(r,a,y))) =e= TotalREProductionAnnual(y,r);

equation RE3_FuelIncluded(YEAR2,ECONOMY);
RE3_FuelIncluded(y,r).. sum((l,f), (RateOfDemand(y,l,f,r)*YearSplit(l,y)*RETagFuel(r,f,y))) =e= RETotalDemandOfTargetFuelAnnual(y,r);

equation RE4_EnergyConstraint(YEAR2,ECONOMY);
RE4_EnergyConstraint(y,r).. REMinProductionTarget(r,y)*RETotalDemandOfTargetFuelAnnual(y,r) =l= TotalREProductionAnnual(y,r);

equation RE5_FuelUseByTechnologyAnnual(YEAR2,ACTIVITY,FUEL,ECONOMY);
RE5_FuelUseByTechnologyAnnual(y,a,f,r).. sum(l, (RateOfUseByTechnology(y,l,a,f,r)*YearSplit(l,y))) =e= UseByTechnologyAnnual(y,a,f,r);
*
* ################ Emissions Accounting ##############
*
equation E1_AnnualEmissionProductionByMode(YEAR2,ACTIVITY,EMISSION,MODE_OF_OPERATION,ECONOMY);
E1_AnnualEmissionProductionByMode(y,a,ghg,m,r).. EmissionActivityRatio(r,a,ghg,m,y)*TotalAnnualTechnologyActivityByMode(y,a,m,r) =e= AnnualTechnologyEmissionByMode(y,a,ghg,m,r);

equation E2_AnnualEmissionProduction(YEAR2,ACTIVITY,EMISSION,ECONOMY);
E2_AnnualEmissionProduction(y,a,ghg,r).. sum(m, AnnualTechnologyEmissionByMode(y,a,ghg,m,r)) =e= AnnualTechnologyEmission(y,a,ghg,r);

equation E3_EmissionsPenaltyByTechAndEmission(YEAR2,ACTIVITY,EMISSION,ECONOMY);
E3_EmissionsPenaltyByTechAndEmission(y,a,ghg,r).. AnnualTechnologyEmission(y,a,ghg,r)*EmissionsPenalty(r,ghg,y) =e= AnnualTechnologyEmissionPenaltyByEmission(y,a,ghg,r);

equation E4_EmissionsPenaltyByTechnology(YEAR2,ACTIVITY,ECONOMY);
E4_EmissionsPenaltyByTechnology(y,a,r).. sum(ghg, AnnualTechnologyEmissionPenaltyByEmission(y,a,ghg,r)) =e= AnnualTechnologyEmissionsPenalty(y,a,r);

equation E5_DiscountedEmissionsPenaltyByTechnology(YEAR2,ACTIVITY,ECONOMY);
E5_DiscountedEmissionsPenaltyByTechnology(y,a,r).. AnnualTechnologyEmissionsPenalty(y,a,r)/((1+DiscountRate(r,a))**(YearVal(y)-smin(yy, YearVal(yy))+0.5)) =e= DiscountedTechnologyEmissionsPenalty(y,a,r);

equation E6_EmissionsAccounting1(YEAR2,EMISSION,ECONOMY);
E6_EmissionsAccounting1(y,ghg,r).. sum(a, AnnualTechnologyEmission(y,a,ghg,r)) =e= AnnualEmissions(y,ghg,r);

equation E7_EmissionsAccounting2(EMISSION,ECONOMY);
E7_EmissionsAccounting2(ghg,r).. sum(y, AnnualEmissions(y,ghg,r)) =e= ModelPeriodEmissions(ghg,r)- ModelPeriodExogenousEmission(r,ghg);

equation E8_AnnualEmissionsLimit(YEAR2,EMISSION,ECONOMY);
E8_AnnualEmissionsLimit(y,ghg,r).. AnnualEmissions(y,ghg,r)+AnnualExogenousEmission(r,ghg,y) =l= AnnualEmissionLimit(r,ghg,y);

equation E9_ModelPeriodEmissionsLimit(EMISSION,ECONOMY);
E9_ModelPeriodEmissionsLimit(ghg,r).. ModelPeriodEmissions(ghg,r) =l= ModelPeriodEmissionLimit(r,ghg);
*
* ##########################################################################################
*
$ontext
TotalCapacityAnnual.FX('1990','TXE',r) = 0;
TotalCapacityAnnual.FX('1990','RHE',r) = 0;
TotalCapacityAnnual.FX('1991','RHE',r) = 0;
TotalCapacityAnnual.FX('1992','RHE',r) = 0;
TotalCapacityAnnual.FX('1993','RHE',r) = 0;
TotalCapacityAnnual.FX('1994','RHE',r) = 0;
TotalCapacityAnnual.FX('1995','RHE',r) = 0;
TotalCapacityAnnual.FX('1996','RHE',r) = 0;
TotalCapacityAnnual.FX('1997','RHE',r) = 0;
TotalCapacityAnnual.FX('1998','RHE',r) = 0;
TotalCapacityAnnual.FX('1999','RHE',r) = 0;
$offtext
