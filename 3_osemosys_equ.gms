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
*minimize cost: sum(YEAR,TECHNOLOGY,ECONOMY) TotalDiscountedCost[y,t,r];
free variable z;
equation cost;
cost.. z =e= sum((y,t,r), TotalDiscountedCost(y,t,r));
*
* ####################
* # Constraints #
* ####################
*:SpecifiedAnnualDemand[y,f,r]<>0
*s.t. EQ_SpecifiedDemand1(YEAR,TIMESLICE,FUEL,ECONOMY): SpecifiedAnnualDemand[y,f,r]*SpecifiedDemandProfile[y,l,f,r] / YearSplit[y,l]=RateOfDemand[y,l,f,r];
equation EQ_SpecifiedDemand1(YEAR,TIMESLICE,FUEL,ECONOMY);
EQ_SpecifiedDemand1(y,l,f,r).. SpecifiedAnnualDemand(r,f,y)*SpecifiedDemandProfile(r,f,l,y) / YearSplit(l,y) =e= RateOfDemand(y,l,f,r);
*
* ############### Storage #############
*
*s.t. S1_StorageCharge(STORAGE,YEAR,TIMESLICE,ECONOMY): sum(TECHNOLOGY,MODE_OF_OPERATION) RateOfActivity[y,l,t,m,r] * TechnologyToStorage[t,m,s,r] * YearSplit[y,l] = StorageCharge[s,y,l,r];
equation S1_StorageCharge(STORAGE,YEAR,TIMESLICE,ECONOMY);
S1_StorageCharge(s,y,l,r).. sum((t,m), (RateOfActivity(y,l,t,m,r) * TechnologyToStorage(r,t,s,m))) * YearSplit(l,y) =e= StorageCharge(s,y,l,r);
*s.t. S2_StorageDischarge(STORAGE,YEAR,TIMESLICE,ECONOMY): sum(TECHNOLOGY,MODE_OF_OPERATION) RateOfActivity[y,l,t,m,r] * TechnologyFromStorage[t,m,s,r] * YearSplit[y,l] = StorageDischarge[s,y,l,r];
equation S2_StorageDischarge(STORAGE,YEAR,TIMESLICE,ECONOMY);
S2_StorageDischarge(s,y,l,r).. sum((t,m), (RateOfActivity(y,l,t,m,r) * TechnologyFromStorage(r,t,s,m))) * YearSplit(l,y) =e= StorageDischarge(s,y,l,r);
*s.t. S3_NetStorageCharge(STORAGE,YEAR,TIMESLICE,ECONOMY): NetStorageCharge[s,y,l,r] = StorageCharge[s,y,l,r] - StorageDischarge[s,y,l,r];
equation S3_NetStorageCharge(STORAGE,YEAR,TIMESLICE,ECONOMY);
S3_NetStorageCharge(s,y,l,r).. NetStorageCharge(s,y,l,r) =e= StorageCharge(s,y,l,r) - StorageDischarge(s,y,l,r);
*s.t. S4_StorageLevelAtInflection(BOUNDARY_INSTANCES,STORAGE,ECONOMY): sum(TIMESLICE,YEAR) NetStorageCharge[s,y,l,r]/YearSplit[y,l]*StorageInflectionTimes[y,l,b] = StorageLevel[s,b,r];
equation S4_StorageLevelAtInflection(BOUNDARY_INSTANCES,STORAGE,ECONOMY);
S4_StorageLevelAtInflection(b,s,r).. sum((l,y), (NetStorageCharge(s,y,l,r)/YearSplit(l,y)*StorageInflectionTimes(y,l,b))) =e= StorageLevel(s,b,r);
*s.t. S5_StorageLowerLimit(BOUNDARY_INSTANCES,STORAGE,ECONOMY): StorageLevel[s,b,r] >= StorageLowerLimit[s,r];
equation S5_StorageLowerLimit(BOUNDARY_INSTANCES,STORAGE,ECONOMY);
S5_StorageLowerLimit(b,s,r).. StorageLevel(s,b,r) =g= StorageLowerLimit(r,s);
*s.t. S6_StorageUpperLimit(BOUNDARY_INSTANCES,STORAGE,ECONOMY): StorageLevel[s,b,r] <= StorageUpperLimit[s,r];
equation S6_StorageUpperLimit(BOUNDARY_INSTANCES,STORAGE,ECONOMY);
S6_StorageUpperLimit(b,s,r).. StorageLevel(s,b,r) =l= StorageUpperLimit(r,s);
*
* ############### Capacity Adequacy A #############
*
*s.t. CBa1_TotalNewCapacity{y in YEAR, t in TECHNOLOGY, r in ECONOMY}:AccumulatedNewCapacity[y,t,r] = sum{yy in YEAR: y-yy < OperationalLife[t,r] && y-yy>=0} NewCapacity[yy,t,r];
equation CBa1_TotalNewCapacity(YEAR,TECHNOLOGY,ECONOMY);
CBa1_TotalNewCapacity(y,t,r).. AccumulatedNewCapacity(y,t,r) =e= sum(yy$((YearVal(y)-YearVal(yy) < OperationalLife(r,t)) AND (YearVal(y)-YearVal(yy) >= 0)), NewCapacity(yy,t,r));
*s.t. CBa2_TotalAnnualCapacity(YEAR,TECHNOLOGY,ECONOMY): AccumulatedNewCapacity[y,t,r]+ ResidualCapacity[y,t,r] = TotalCapacityAnnual[y,t,r];
equation CBa2_TotalAnnualCapacity(YEAR,TECHNOLOGY,ECONOMY);
CBa2_TotalAnnualCapacity(y,t,r).. AccumulatedNewCapacity(y,t,r)+ ResidualCapacity(r,t,y) =e= TotalCapacityAnnual(y,t,r);
*s.t. CBa3_TotalActivityOfEachTechnology(YEAR,TECHNOLOGY,TIMESLICE,ECONOMY): sum(MODE_OF_OPERATION) RateOfActivity[y,l,t,m,r] = RateOfTotalActivity[y,l,t,r];
equation CBa3_TotalActivityOfEachTechnology(YEAR,TECHNOLOGY,TIMESLICE,ECONOMY);
CBa3_TotalActivityOfEachTechnology(y,t,l,r).. sum(m, RateOfActivity(y,l,t,m,r)) =e= RateOfTotalActivity(y,l,t,r);
*s.t. CBa4_Constraint_Capacity(YEAR,TIMESLICE,TECHNOLOGY,ECONOMY: TechWithCapacityNeededToMeetPeakTS[t,r]<>0): RateOfTotalActivity[y,l,t,r] <= TotalCapacityAnnual[y,t,r] * CapacityFactor[y,t,r]*CapacityToActivityUnit[t,r];
equation CBa4_Constraint_Capacity(YEAR,TIMESLICE,TECHNOLOGY,ECONOMY);
CBa4_Constraint_Capacity(y,l,t,r)$(TechWithCapacityNeededToMeetPeakTS(r,t) <> 0).. RateOfTotalActivity(y,l,t,r) =l= TotalCapacityAnnual(y,t,r) * CapacityFactor(r,t,y)*CapacityToActivityUnit(r,t);
* Note that the PlannedMaintenance equation below ensures that all other technologies have a capacity great enough to at least meet the annual average.
*
* ############### Capacity Adequacy B #############
*
*s.t. CBb1_PlannedMaintenance(YEAR,TECHNOLOGY,ECONOMY): sum(TIMESLICE) RateOfTotalActivity[y,l,t,r]*YearSplit[y,l] <= TotalCapacityAnnual[y,t,r]*CapacityFactor[y,t,r]* AvailabilityFactor[y,t,r]*CapacityToActivityUnit[t,r];
equation CBb1_PlannedMaintenance(YEAR,TECHNOLOGY,ECONOMY);
CBb1_PlannedMaintenance(y,t,r).. sum(l, RateOfTotalActivity(y,l,t,r)*YearSplit(l,y)) =l= TotalCapacityAnnual(y,t,r)*CapacityFactor(r,t,y)* AvailabilityFactor(r,t,y)*CapacityToActivityUnit(r,t);
*
* ##############* Energy Balance A #############
*
* #### This first set of equations computes 'fuel' production ####
*s.t. EBa1_RateOfFuelProduction1(YEAR,TIMESLICE,FUEL,TECHNOLOGY,MODE_OF_OPERATION,ECONOMY): RateOfActivity[y,l,t,m,r]*OutputActivityRatio[y,t,f,m,r] = RateOfProductionByTechnologyByMode[y,l,t,m,f,r];
equation EBa1_RateOfFuelProduction1(YEAR,TIMESLICE,FUEL,TECHNOLOGY,MODE_OF_OPERATION,ECONOMY);
EBa1_RateOfFuelProduction1(y,l,f,t,m,r).. RateOfActivity(y,l,t,m,r)*OutputActivityRatio(r,t,f,m,y) =e= RateOfProductionByTechnologyByMode(y,l,t,m,f,r);
*s.t. EBa2_RateOfFuelProduction2(YEAR,TIMESLICE,FUEL,TECHNOLOGY,ECONOMY): sum(MODE_OF_OPERATION) RateOfProductionByTechnologyByMode[y,l,t,m,f,r] = RateOfProductionByTechnology[y,l,t,f,r];
equation EBa2_RateOfFuelProduction2(YEAR,TIMESLICE,FUEL,TECHNOLOGY,ECONOMY);
EBa2_RateOfFuelProduction2(y,l,f,t,r).. sum(m, RateOfProductionByTechnologyByMode(y,l,t,m,f,r)) =e= RateOfProductionByTechnology(y,l,t,f,r);
*s.t. EBa3_RateOfFuelProduction3(YEAR,TIMESLICE,FUEL,ECONOMY): sum(TECHNOLOGY) RateOfProductionByTechnology[y,l,t,f,r] = RateOfProduction[y,l,f,r];
equation EBa3_RateOfFuelProduction3(YEAR,TIMESLICE,FUEL,ECONOMY);
EBa3_RateOfFuelProduction3(y,l,f,r).. sum(t, RateOfProductionByTechnology(y,l,t,f,r)) =e= RateOfProduction(y,l,f,r);

* #### This set of equations computes 'fuel' consumption ####
*s.t. EBa4_RateOfFuelUse1(YEAR,TIMESLICE,FUEL,TECHNOLOGY,MODE_OF_OPERATION,ECONOMY): RateOfActivity[y,l,t,m,r]*InputActivityRatio[y,t,f,m,r] = RateOfUseByTechnologyByMode[y,l,t,m,f,r];
equation EBa4_RateOfFuelUse1(YEAR,TIMESLICE,FUEL,TECHNOLOGY,MODE_OF_OPERATION,ECONOMY);
EBa4_RateOfFuelUse1(y,l,f,t,m,r).. RateOfActivity(y,l,t,m,r)*InputActivityRatio(r,t,f,m,y) =e= RateOfUseByTechnologyByMode(y,l,t,m,f,r);
*s.t. EBa5_RateOfFuelUse2(YEAR,TIMESLICE,FUEL,TECHNOLOGY,ECONOMY): sum(MODE_OF_OPERATION) RateOfUseByTechnologyByMode[y,l,t,m,f,r] = RateOfUseByTechnology[y,l,t,f,r];
equation EBa5_RateOfFuelUse2(YEAR,TIMESLICE,FUEL,TECHNOLOGY,ECONOMY);
EBa5_RateOfFuelUse2(y,l,f,t,r).. sum(m, RateOfUseByTechnologyByMode(y,l,t,m,f,r)) =e= RateOfUseByTechnology(y,l,t,f,r);
*s.t. EBa6_RateOfFuelUse3(YEAR,TIMESLICE,FUEL,ECONOMY): sum(TECHNOLOGY) RateOfUseByTechnology[y,l,t,f,r] = RateOfUse[y,l,f,r];
equation EBa6_RateOfFuelUse3(YEAR,TIMESLICE,FUEL,ECONOMY);
EBa6_RateOfFuelUse3(y,l,f,r).. sum(t, RateOfUseByTechnology(y,l,t,f,r)) =e= RateOfUse(y,l,f,r);

* #### These equations perform supply and demand balance
*s.t. EBa7_EnergyBalanceEachTS1(YEAR,TIMESLICE,FUEL,ECONOMY): RateOfProduction[y,l,f,r]*YearSplit[y,l] = Production[y,l,f,r];
equation EBa7_EnergyBalanceEachTS1(YEAR,TIMESLICE,FUEL,ECONOMY);
EBa7_EnergyBalanceEachTS1(y,l,f,r).. RateOfProduction(y,l,f,r)*YearSplit(l,y) =e= Production(y,l,f,r);
*s.t. EBa8_EnergyBalanceEachTS2(YEAR,TIMESLICE,FUEL,ECONOMY): RateOfUse[y,l,f,r]*YearSplit[y,l] = Use[y,l,f,r];
equation EBa8_EnergyBalanceEachTS2(YEAR,TIMESLICE,FUEL,ECONOMY);
EBa8_EnergyBalanceEachTS2(y,l,f,r).. RateOfUse(y,l,f,r)*YearSplit(l,y) =e= Use(y,l,f,r);
*s.t. EBa9_EnergyBalanceEachTS3(YEAR,TIMESLICE,FUEL,ECONOMY): RateOfDemand[y,l,f,r]*YearSplit[y,l] = Demand[y,l,f,r];
equation EBa9_EnergyBalanceEachTS3(YEAR,TIMESLICE,FUEL,ECONOMY);
EBa9_EnergyBalanceEachTS3(y,l,f,r).. RateOfDemand(y,l,f,r)*YearSplit(l,y) =e= Demand(y,l,f,r);
* s.t. EBa10_EnergyBalanceEachTS4{r in REGION, rr in REGION, l in TIMESLICE, f in FUEL, y in YEAR}: Trade[r,rr,l,f,y] = -Trade[rr,r,l,f,y];
equation EBa10_EnergyBalanceEachTS4(ECONOMY,ECONOMY2,TIMESLICE,FUEL,YEAR);
EBa10_EnergyBalanceEachTS4(r,rr,l,f,y).. Trade(r,rr,l,f,y) =e= -Trade(rr,r,l,f,y);
*s.t. EBa11_EnergyBalanceEachTS5(YEAR,TIMESLICE,FUEL,ECONOMY): Production[r,l,f,y] >= Demand[r,l,f,y] + Use[r,l,f,y] + sum{rr in REGION} Trade[r,rr,l,f,y]*TradeRoute[r,rr,f,y];
equation EBa11_EnergyBalanceEachTS5(YEAR,TIMESLICE,FUEL,ECONOMY);
EBa11_EnergyBalanceEachTS5(y,l,f,r).. Production(y,l,f,r) =g= Demand(y,l,f,r) + Use(y,l,f,r) + sum(rr,Trade(r,rr,l,f,y)*TradeRoute(r,rr,f,y));
*
* ##############* Energy Balance B #############
*
*s.t. EBb1_EnergyBalanceEachYear1(YEAR,FUEL,ECONOMY): sum(TIMESLICE) Production[y,l,f,r] = ProductionAnnual[y,f,r];
equation EBb1_EnergyBalanceEachYear1(YEAR,FUEL,ECONOMY);
EBb1_EnergyBalanceEachYear1(y,f,r).. sum(l, Production(y,l,f,r)) =e= ProductionAnnual(y,f,r);
*s.t. EBb2_EnergyBalanceEachYear2(YEAR,FUEL,ECONOMY): sum(TIMESLICE) Use[y,l,f,r] = UseAnnual[y,f,r];
equation EBb2_EnergyBalanceEachYear2(YEAR,FUEL,ECONOMY);
EBb2_EnergyBalanceEachYear2(y,f,r).. sum(l, Use(y,l,f,r)) =e= UseAnnual(y,f,r);
*s.t. EBb3_EnergyBalanceEachYear3{r in REGION, rr in REGION, f in FUEL, y in YEAR}: sum{l in TIMESLICE} Trade[r,rr,l,f,y] = TradeAnnual[r,rr,f,y];
equation EBb3_EnergyBalanceEachYear3(ECONOMY,ECONOMY2,FUEL,YEAR);
EBb3_EnergyBalanceEachYear3(r,rr,f,y).. sum(l,Trade(r,rr,l,f,y)*TradeRoute(r,rr,f,y)) =e= TradeAnnual(r,rr,f,y);
*s.t. EBb4_EnergyBalanceEachYear4{r in REGION, f in FUEL, y in YEAR}: ProductionAnnual[r,f,y] >= UseAnnual[r,f,y] + sum{rr in REGION} TradeAnnual[r,rr,f,y]*TradeRoute[r,rr,f,y] + AccumulatedAnnualDemand[r,f,y];
equation EBb4_EnergyBalanceEachYear4(YEAR,FUEL,ECONOMY);
EBb4_EnergyBalanceEachYear4(y,f,r).. ProductionAnnual(y,f,r) =g= UseAnnual(y,f,r) + sum(rr,TradeAnnual(r,rr,f,y)*TradeRoute(r,rr,f,y)) + AccumulatedAnnualDemand(r,f,y);
*
* ##############* Accounting Technology Production/Use #############
*
*s.t. Acc1_FuelProductionByTechnology(YEAR,TIMESLICE,TECHNOLOGY,FUEL,ECONOMY): RateOfProductionByTechnology[y,l,t,f,r] * YearSplit[y,l] = ProductionByTechnology[y,l,t,f,r];
equation Acc1_FuelProductionByTechnology(YEAR,TIMESLICE,TECHNOLOGY,FUEL,ECONOMY);
Acc1_FuelProductionByTechnology(y,l,t,f,r).. RateOfProductionByTechnology(y,l,t,f,r) * YearSplit(l,y) =e= ProductionByTechnology(y,l,t,f,r);
*s.t. Acc2_FuelUseByTechnology(YEAR,TIMESLICE,TECHNOLOGY,FUEL,ECONOMY): RateOfUseByTechnology[y,l,t,f,r] * YearSplit[y,l] = UseByTechnology[y,l,t,f,r];
equation Acc2_FuelUseByTechnology(YEAR,TIMESLICE,TECHNOLOGY,FUEL,ECONOMY);
Acc2_FuelUseByTechnology(y,l,t,f,r).. RateOfUseByTechnology(y,l,t,f,r) * YearSplit(l,y) =e= UseByTechnology(y,l,t,f,r);
*s.t. Acc3_AverageAnnualRateOfActivity(YEAR,TECHNOLOGY,MODE_OF_OPERATION,ECONOMY): sum(TIMESLICE) RateOfActivity[y,l,t,m,r]*YearSplit[y,l] = TotalAnnualTechnologyActivityByMode[y,t,m,r];
equation Acc3_AverageAnnualRateOfActivity(YEAR,TECHNOLOGY,MODE_OF_OPERATION,ECONOMY);
Acc3_AverageAnnualRateOfActivity(y,t,m,r).. sum(l, RateOfActivity(y,l,t,m,r)*YearSplit(l,y)) =e= TotalAnnualTechnologyActivityByMode(y,t,m,r);
*s.t. Acc3_ModelPeriodCostByECONOMY(ECONOMY):sum(YEAR,TECHNOLOGY)TotalDiscountedCost[y,t,r]=ModelPeriodCostByECONOMY[r];
equation Acc3_ModelPeriodCostByECONOMY(ECONOMY);
Acc3_ModelPeriodCostByECONOMY(r)..sum((y,t), TotalDiscountedCost(y,t,r)) =e= ModelPeriodCostByECONOMY(r);
*
* ############### Captial Costs #############
*
*s.t. CC1_UndiscountedCapitalInvestment(YEAR,TECHNOLOGY,ECONOMY): CapitalCost[y,t,r] * NewCapacity[y,t,r] = CapitalInvestment[y,t,r];
equation CC1_UndiscountedCapitalInvestment(YEAR,TECHNOLOGY,ECONOMY);
CC1_UndiscountedCapitalInvestment(y,t,r).. CapitalCost(r,t,y) * NewCapacity(y,t,r) =e= CapitalInvestment(y,t,r);
*s.t. CC2_DiscountingCapitalInvestmenta(YEAR,TECHNOLOGY,ECONOMY): CapitalInvestment[y,t,r]/((1+DiscountRate[t,r])^(y-StartYear)) = DiscountedCapitalInvestment[y,t,r];
equation CC2_DiscountingCapitalInvestmenta(YEAR,TECHNOLOGY,ECONOMY);
CC2_DiscountingCapitalInvestmenta(y,t,r).. CapitalInvestment(y,t,r)/((1+DiscountRate(r,t))**(YearVal(y)-StartYear)) =e= DiscountedCapitalInvestment(y,t,r);
*
* ##############* Salvage Value #############
*
*s.t. SV1_SalvageValueAtEndOfPeriod1(YEAR,TECHNOLOGY,ECONOMY: (y + OperationalLife[t,r]-1) > (max(yy in YEAR) max(yy)) && DiscountRate[t,r]>0): SalvageValue[y,t,r] = CapitalCost[y,t,r]*NewCapacity[y,t,r]*(1-(((1+DiscountRate[t,r])^(max(yy in YEAR) max(yy) - y+1)-1)/((1+DiscountRate[t,r])^OperationalLife[t,r]-1)));
equation SV1_SalvageValueAtEndOfPeriod1(YEAR,TECHNOLOGY,ECONOMY);
SV1_SalvageValueAtEndOfPeriod1(y,t,r)$((YearVal(y) + OperationalLife(r,t)-1 > smax(yy, YearVal(yy))) and (DiscountRate(r,t) > 0))..
SalvageValue(y,t,r) =e= CapitalCost(r,t,y)*NewCapacity(y,t,r)*(1-(((1+DiscountRate(r,t))**(smax(yy, YearVal(yy)) - YearVal(y)+1) -1)
/((1+DiscountRate(r,t))**OperationalLife(r,t)-1)));
*s.t. SV2_SalvageValueAtEndOfPeriod2(YEAR,TECHNOLOGY,ECONOMY: (y + OperationalLife[t,r]-1) > (max(yy in YEAR) max(yy)) && DiscountRate[t,r]=0): SalvageValue[y,t,r] = CapitalCost[y,t,r]*NewCapacity[y,t,r]*(1-(max(yy in YEAR) max(yy) - y+1)/OperationalLife[t,r]);
equation SV2_SalvageValueAtEndOfPeriod2(YEAR,TECHNOLOGY,ECONOMY);
SV2_SalvageValueAtEndOfPeriod2(y,t,r)$((YearVal(y) + OperationalLife(r,t)-1 > smax(yy, YearVal(yy))) and (DiscountRate(r,t) = 0))..
SalvageValue(y,t,r) =e= CapitalCost(r,t,y)*NewCapacity(y,t,r)*(1-smax(yy, YearVal(yy))- YearVal(y)+1)/OperationalLife(r,t);
*s.t. SV3_SalvageValueAtEndOfPeriod3(YEAR,TECHNOLOGY,ECONOMY: (y + OperationalLife[t,r]-1) <= (max(yy in YEAR) max(yy))): SalvageValue[y,t,r] = 0;
equation SV3_SalvageValueAtEndOfPeriod3(YEAR,TECHNOLOGY,ECONOMY);
SV3_SalvageValueAtEndOfPeriod3(y,t,r)$(YearVal(y) + OperationalLife(r,t)-1 <= smax(yy, YearVal(yy)))..
SalvageValue(y,t,r) =e= 0;
*s.t. SV4_SalvageValueDiscountedToStartYear(YEAR,TECHNOLOGY,ECONOMY): DiscountedSalvageValue[y,t,r] = SalvageValue[y,t,r]/((1+DiscountRate[t,r])^(1+max(yy in YEAR) max(yy)-min(yy in YEAR) min(yy)));
equation SV4_SalvageValueDiscToStartYr(YEAR,TECHNOLOGY,ECONOMY);
SV4_SalvageValueDiscToStartYr(y,t,r)..
DiscountedSalvageValue(y,t,r) =e= SalvageValue(y,t,r)/((1+DiscountRate(r,t))**(1+smax(yy, YearVal(yy)) - smin(yy, YearVal(yy))));
*
* ############### Operating Costs #############
*
*s.t. OC1_OperatingCostsVariable(YEAR,TIMESLICE,TECHNOLOGY,ECONOMY): sum(MODE_OF_OPERATION) TotalAnnualTechnologyActivityByMode[y,t,m,r]*VariableCost[y,t,m,r] = AnnualVariableOperatingCost[y,t,r];
* equation OC1_OperatingCostsVariable(YEAR,TIMESLICE,TECHNOLOGY,ECONOMY);
* OC1_OperatingCostsVariable(y,l,t,r).. sum(m, (TotalAnnualTechnologyActivityByMode(y,t,m,r)*VariableCost(r,t,m,y))) =e= AnnualVariableOperatingCost(y,t,r);
* TIMESLICE appears in equation (name), but not in equation contents, so equation should be as follows!!
equation OC1_OperatingCostsVariable(YEAR,TECHNOLOGY,ECONOMY);
OC1_OperatingCostsVariable(y,t,r).. sum(m, (TotalAnnualTechnologyActivityByMode(y,t,m,r)*VariableCost(r,t,m,y))) =e= AnnualVariableOperatingCost(y,t,r);
*s.t. OC2_OperatingCostsFixedAnnual(YEAR,TECHNOLOGY,ECONOMY): TotalCapacityAnnual[y,t,r]*FixedCost[y,t,r] = AnnualFixedOperatingCost[y,t,r];
equation OC2_OperatingCostsFixedAnnual(YEAR,TECHNOLOGY,ECONOMY);
OC2_OperatingCostsFixedAnnual(y,t,r).. TotalCapacityAnnual(y,t,r)*FixedCost(r,t,y) =e= AnnualFixedOperatingCost(y,t,r);
*s.t. OC3_OperatingCostsTotalAnnual(YEAR,TECHNOLOGY,ECONOMY): AnnualFixedOperatingCost[y,t,r]+AnnualVariableOperatingCost[y,t,r] = OperatingCost[y,t,r];
equation OC3_OperatingCostsTotalAnnual(YEAR,TECHNOLOGY,ECONOMY);
OC3_OperatingCostsTotalAnnual(y,t,r).. AnnualFixedOperatingCost(y,t,r)+AnnualVariableOperatingCost(y,t,r) =e= OperatingCost(y,t,r);
*s.t. OC4_DiscountedOperatingCostsTotalAnnual{y in YEAR, t in TECHNOLOGY, r in ECONOMY}: OperatingCost[y,t,r]/((1+DiscountRate[t,r])^(y-min{yy in YEAR} min(yy)+0.5)) = DiscountedOperatingCost[y,t,r];
equation OC4_DiscountedOperatingCostsTotalAnnual(YEAR,TECHNOLOGY,ECONOMY);
OC4_DiscountedOperatingCostsTotalAnnual(y,t,r).. OperatingCost(y,t,r)/((1+DiscountRate(r,t))**(YearVal(y)-smin(yy, YearVal(yy))+0.5)) =e= DiscountedOperatingCost(y,t,r);
* ############### Total Discounted Costs #############
*
*s.t. TDC1_TotalDiscountedCostByTechnology(YEAR,TECHNOLOGY,ECONOMY): DiscountedOperatingCost[y,t,r]+DiscountedCapitalInvestment[y,t,r]+DiscountedTechnologyEmissionsPenalty[y,t,r]-DiscountedSalvageValue[y,t,r] = TotalDiscountedCost[y,t,r];
equation TDC1_TotalDiscountedCostByTechnology(YEAR,TECHNOLOGY,ECONOMY);
TDC1_TotalDiscountedCostByTechnology(y,t,r).. DiscountedOperatingCost(y,t,r)+DiscountedCapitalInvestment(y,t,r)+DiscountedTechnologyEmissionsPenalty(y,t,r)-DiscountedSalvageValue(y,t,r) =e= TotalDiscountedCost(y,t,r);
*
* ############### Total Capacity Constraints ##############
*
*s.t. TCC1_TotalAnnualMaxCapacityConstraint(YEAR,TECHNOLOGY,ECONOMY: TotalAnnualMaxCapacity[y,t,r]<99999 ): TotalCapacityAnnual[y,t,r] <= TotalAnnualMaxCapacity[y,t,r];
equation TCC1_TotalAnnualMaxCapacityConstraint(YEAR,TECHNOLOGY,ECONOMY);
TCC1_TotalAnnualMaxCapacityConstraint(y,t,r)$(TotalAnnualMaxCapacity(r,t,y) < 99999).. TotalCapacityAnnual(y,t,r) =l= TotalAnnualMaxCapacity(r,t,y);
*s.t. TCC2_TotalAnnualMinCapacityConstraint(YEAR,TECHNOLOGY,ECONOMY: TotalAnnualMinCapacity[y,t,r]>0): TotalCapacityAnnual[y,t,r] >= TotalAnnualMinCapacity[y,t,r];
equation TCC2_TotalAnnualMinCapacityConstraint(YEAR,TECHNOLOGY,ECONOMY);
TCC2_TotalAnnualMinCapacityConstraint(y,t,r)$(TotalAnnualMinCapacity(r,t,y)>0).. TotalCapacityAnnual(y,t,r) =g= TotalAnnualMinCapacity(r,t,y);
*
* ############### New Capacity Constraints ##############
*
*s.t. NCC1_TotalAnnualMaxNewCapacityConstraint(YEAR,TECHNOLOGY,ECONOMY: TotalAnnualMaxCapacityInvestment[y,t,r]<9999): NewCapacity[y,t,r] <= TotalAnnualMaxCapacityInvestment[y,t,r];
equation NCC1_TotalAnnualMaxNewCapacityConstraint(YEAR,TECHNOLOGY,ECONOMY);
NCC1_TotalAnnualMaxNewCapacityConstraint(y,t,r)$(TotalAnnualMaxCapacityInvestment(r,t,y) < 9999).. NewCapacity(y,t,r) =l= TotalAnnualMaxCapacityInvestment(r,t,y);
*s.t. NCC2_TotalAnnualMinNewCapacityConstraint(YEAR,TECHNOLOGY,ECONOMY: TotalAnnualMinCapacityInvestment[y,t,r]>0): NewCapacity[y,t,r] >= TotalAnnualMinCapacityInvestment[y,t,r];
equation NCC2_TotalAnnualMinNewCapacityConstraint(YEAR,TECHNOLOGY,ECONOMY);
NCC2_TotalAnnualMinNewCapacityConstraint(y,t,r)$(TotalAnnualMinCapacityInvestment(r,t,y) > 0).. NewCapacity(y,t,r) =g= TotalAnnualMinCapacityInvestment(r,t,y);
*
* ################ Annual Activity Constraints ##############
*
*s.t. AAC1_TotalAnnualTechnologyActivity(YEAR,TECHNOLOGY,ECONOMY): sum(TIMESLICE) RateOfTotalActivity[y,l,t,r]*YearSplit[y,l] = TotalTechnologyAnnualActivity[y,t,r];
equation AAC1_TotalAnnualTechnologyActivity(YEAR,TECHNOLOGY,ECONOMY);
AAC1_TotalAnnualTechnologyActivity(y,t,r).. sum(l, (RateOfTotalActivity(y,l,t,r)*YearSplit(l,y))) =e= TotalTechnologyAnnualActivity(y,t,r);
*s.t. AAC2_TotalAnnualTechnologyActivityUpperLimit(YEAR,TECHNOLOGY,ECONOMY:TotalTechnologyAnnualActivityUpperLimit[y,t,r]<9999): TotalTechnologyAnnualActivity[y,t,r] <= TotalTechnologyAnnualActivityUpperLimit[y,t,r] ;
equation AAC2_TotalAnnualTechnologyActivityUpperLimit(YEAR,TECHNOLOGY,ECONOMY);
AAC2_TotalAnnualTechnologyActivityUpperLimit(y,t,r)$(TotalTechnologyAnnualActivityUpperLimit(r,t,y) <9999).. TotalTechnologyAnnualActivity(y,t,r) =l= TotalTechnologyAnnualActivityUpperLimit(r,t,y);
*s.t. AAC3_TotalAnnualTechnologyActivityLowerLimit(YEAR,TECHNOLOGY,ECONOMY: TotalTechnologyAnnualActivityLowerLimit[y,t,r]>0): TotalTechnologyAnnualActivity[y,t,r] >= TotalTechnologyAnnualActivityLowerLimit[y,t,r] ;
equation AAC3_TotalAnnualTechnologyActivityLowerLimit(YEAR,TECHNOLOGY,ECONOMY);
AAC3_TotalAnnualTechnologyActivityLowerLimit(y,t,r)$(TotalTechnologyAnnualActivityLowerLimit(r,t,y) > 0).. TotalTechnologyAnnualActivity(y,t,r) =g= TotalTechnologyAnnualActivityLowerLimit(r,t,y);
*
* ################ Total Activity Constraints ##############
*
*s.t. TAC1_TotalModelHorizenTechnologyActivity(TECHNOLOGY,ECONOMY): sum(YEAR) TotalTechnologyAnnualActivity[y,t,r] = TotalTechnologyModelPeriodActivity[t,r];
equation TAC1_TotalModelHorizenTechnologyActivity(TECHNOLOGY,ECONOMY);
TAC1_TotalModelHorizenTechnologyActivity(t,r).. sum(y, TotalTechnologyAnnualActivity(y,t,r)) =e= TotalTechnologyModelPeriodActivity(t,r);
*s.t. TAC2_TotalModelHorizenTechnologyActivityUpperLimit(YEAR,TECHNOLOGY,ECONOMY:TotalTechnologyModelPeriodActivityUpperLimit[t,r]<9999): TotalTechnologyModelPeriodActivity[t,r] <= TotalTechnologyModelPeriodActivityUpperLimit[t,r] ;
equation TAC2_TotalModelHorizenTechnologyActivityUpperLimit(YEAR,TECHNOLOGY,ECONOMY);
TAC2_TotalModelHorizenTechnologyActivityUpperLimit(y,t,r)$(TotalTechnologyModelPeriodActivityUpperLimit(r,t) < 9999).. TotalTechnologyModelPeriodActivity(t,r) =l= TotalTechnologyModelPeriodActivityUpperLimit(r,t);
*s.t. TAC3_TotalModelHorizenTechnologyActivityLowerLimit(YEAR,TECHNOLOGY,ECONOMY: TotalTechnologyModelPeriodActivityLowerLimit[t,r]>0): TotalTechnologyModelPeriodActivity[t,r] >= TotalTechnologyModelPeriodActivityLowerLimit[t,r] ;
equation TAC3_TotalModelHorizenTechnologyActivityLowerLimit(YEAR,TECHNOLOGY,ECONOMY);
TAC3_TotalModelHorizenTechnologyActivityLowerLimit(y,t,r)$(TotalTechnologyModelPeriodActivityLowerLimit(r,t) > 0).. TotalTechnologyModelPeriodActivity(t,r) =g= TotalTechnologyModelPeriodActivityLowerLimit(r,t);
*
* ############### Reserve Margin Constraint #############* NTS: Should change demand for production
*
*s.t. RM1_ReserveMargin_TechologiesIncluded_In_Activity_Units(YEAR,TIMESLICE,ECONOMY): sum (TECHNOLOGY) TotalCapacityAnnual[y,t,r] *ReserveMarginTagTechnology[y,t,r] * CapacityToActivityUnit[t,r] = TotalCapacityInReserveMargin[y,r];
equation RM1_ReserveMargin_TechologiesIncluded_In_Activity_Units(YEAR,TIMESLICE,ECONOMY);
RM1_ReserveMargin_TechologiesIncluded_In_Activity_Units(y,l,r).. sum (t, (TotalCapacityAnnual(y,t,r) *ReserveMarginTagTechnology(r,t,y) * CapacityToActivityUnit(r,t))) =e= TotalCapacityInReserveMargin(r,y);
*s.t. RM2_ReserveMargin_FuelsIncluded(YEAR,TIMESLICE,ECONOMY): sum (FUEL) RateOfProduction[y,l,f,r] * ReserveMarginTagFuel[y,f,r] = DemandNeedingReserveMargin[y,l,r];
equation RM2_ReserveMargin_FuelsIncluded(YEAR,TIMESLICE,ECONOMY);
RM2_ReserveMargin_FuelsIncluded(y,l,r).. sum (f, (RateOfProduction(y,l,f,r) * ReserveMarginTagFuel(r,f,y))) =e= DemandNeedingReserveMargin(y,l,r);
*s.t. RM3_ReserveMargin_Constraint(YEAR,TIMESLICE,ECONOMY): DemandNeedingReserveMargin[y,l,r] * ReserveMargin[y,r] <= TotalCapacityInReserveMargin[y,r];
equation RM3_ReserveMargin_Constraint(YEAR,TIMESLICE,ECONOMY);
RM3_ReserveMargin_Constraint(y,l,r).. DemandNeedingReserveMargin(y,l,r) * ReserveMargin(r,y) =l= TotalCapacityInReserveMargin(r,y);
*
* ############### RE Production Target #############* NTS: Should change demand for production
*
*s.t. RE1_FuelProductionByTechnologyAnnual(YEAR,TECHNOLOGY,FUEL,ECONOMY): sum(TIMESLICE) ProductionByTechnology[y,l,t,f,r] = ProductionByTechnologyAnnual[y,t,f,r];
equation RE1_FuelProductionByTechnologyAnnual(YEAR,TECHNOLOGY,FUEL,ECONOMY);
RE1_FuelProductionByTechnologyAnnual(y,t,f,r).. sum(l, ProductionByTechnology(y,l,t,f,r)) =e= ProductionByTechnologyAnnual(y,t,f,r);
*s.t. RE2_TechIncluded(YEAR,ECONOMY): sum(TECHNOLOGY,FUEL) ProductionByTechnologyAnnual[y,t,f,r]*RETagTechnology[y,t,r] = TotalREProductionAnnual[y,r];
equation RE2_TechIncluded(YEAR,ECONOMY);
RE2_TechIncluded(y,r).. sum((t,f), (ProductionByTechnologyAnnual(y,t,f,r)*RETagTechnology(r,t,y))) =e= TotalREProductionAnnual(y,r);
*s.t. RE3_FuelIncluded(YEAR,ECONOMY): sum(TIMESLICE,FUEL) RateOfDemand[y,l,f,r]*YearSplit[y,l]*RETagFuel[y,f,r] = RETotalDemandOfTargetFuelAnnual[y,r];
equation RE3_FuelIncluded(YEAR,ECONOMY);
RE3_FuelIncluded(y,r).. sum((l,f), (RateOfDemand(y,l,f,r)*YearSplit(l,y)*RETagFuel(r,f,y))) =e= RETotalDemandOfTargetFuelAnnual(y,r);
*s.t. RE4_EnergyConstraint(YEAR,ECONOMY):REMinProductionTarget[y,r]*RETotalDemandOfTargetFuelAnnual[y,r] <= TotalREProductionAnnual[y,r];
equation RE4_EnergyConstraint(YEAR,ECONOMY);
RE4_EnergyConstraint(y,r).. REMinProductionTarget(r,y)*RETotalDemandOfTargetFuelAnnual(y,r) =l= TotalREProductionAnnual(y,r);
*s.t. RE5_FuelUseByTechnologyAnnual(YEAR,TECHNOLOGY,FUEL,ECONOMY): sum(TIMESLICE) RateOfUseByTechnology[y,l,t,f,r]*YearSplit[y,l] = UseByTechnologyAnnual[y,t,f,r];
equation RE5_FuelUseByTechnologyAnnual(YEAR,TECHNOLOGY,FUEL,ECONOMY);
RE5_FuelUseByTechnologyAnnual(y,t,f,r).. sum(l, (RateOfUseByTechnology(y,l,t,f,r)*YearSplit(l,y))) =e= UseByTechnologyAnnual(y,t,f,r);
*
* ################ Emissions Accounting ##############
*
*s.t. E1_AnnualEmissionProductionByMode(YEAR,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,ECONOMY:EmissionActivityRatio[y,t,e,m,r]<>0): EmissionActivityRatio[y,t,e,m,r]*TotalAnnualTechnologyActivityByMode[y,t,m,r]=AnnualTechnologyEmissionByMode[y,t,e,m,r];
equation E1_AnnualEmissionProductionByMode(YEAR,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,ECONOMY);
* E1_AnnualEmissionProductionByMode(y,t,e,m,r)$(EmissionActivityRatio(r,t,e,m,y) <> 0).. EmissionActivityRatio(r,t,e,m,y)*TotalAnnualTechnologyActivityByMode(y,t,m,r) =e= AnnualTechnologyEmissionByMode(y,t,e,m,r);
E1_AnnualEmissionProductionByMode(y,t,e,m,r).. EmissionActivityRatio(r,t,e,m,y)*TotalAnnualTechnologyActivityByMode(y,t,m,r) =e= AnnualTechnologyEmissionByMode(y,t,e,m,r);
*s.t. E2_AnnualEmissionProduction(YEAR,TECHNOLOGY,EMISSION,ECONOMY): sum(MODE_OF_OPERATION) AnnualTechnologyEmissionByMode[y,t,e,m,r] = AnnualTechnologyEmission[y,t,e,r];
equation E2_AnnualEmissionProduction(YEAR,TECHNOLOGY,EMISSION,ECONOMY);
E2_AnnualEmissionProduction(y,t,e,r).. sum(m, AnnualTechnologyEmissionByMode(y,t,e,m,r)) =e= AnnualTechnologyEmission(y,t,e,r);
*s.t. E3_EmissionsPenaltyByTechAndEmission(YEAR,TECHNOLOGY,EMISSION,ECONOMY): AnnualTechnologyEmission[y,t,e,r]*EmissionsPenalty[y,e,r] = AnnualTechnologyEmissionPenaltyByEmission[y,t,e,r];
equation E3_EmissionsPenaltyByTechAndEmission(YEAR,TECHNOLOGY,EMISSION,ECONOMY);
E3_EmissionsPenaltyByTechAndEmission(y,t,e,r).. AnnualTechnologyEmission(y,t,e,r)*EmissionsPenalty(r,e,y) =e= AnnualTechnologyEmissionPenaltyByEmission(y,t,e,r);
*s.t. E4_EmissionsPenaltyByTechnology(YEAR,TECHNOLOGY,ECONOMY): sum(EMISSION) AnnualTechnologyEmissionPenaltyByEmission[y,t,e,r] = AnnualTechnologyEmissionsPenalty[y,t,r];
equation E4_EmissionsPenaltyByTechnology(YEAR,TECHNOLOGY,ECONOMY);
E4_EmissionsPenaltyByTechnology(y,t,r).. sum(e, AnnualTechnologyEmissionPenaltyByEmission(y,t,e,r)) =e= AnnualTechnologyEmissionsPenalty(y,t,r);
*s.t. E5_DiscountedEmissionsPenaltyByTechnology(YEAR,TECHNOLOGY,ECONOMY): AnnualTechnologyEmissionsPenalty[y,t,r]/((1+DiscountRate[t,r])^(y-min(yy in YEAR) min(yy)+0.5)) = DiscountedTechnologyEmissionsPenalty[y,t,r];
equation E5_DiscountedEmissionsPenaltyByTechnology(YEAR,TECHNOLOGY,ECONOMY);
E5_DiscountedEmissionsPenaltyByTechnology(y,t,r).. AnnualTechnologyEmissionsPenalty(y,t,r)/((1+DiscountRate(r,t))**(YearVal(y)-smin(yy, YearVal(yy))+0.5)) =e= DiscountedTechnologyEmissionsPenalty(y,t,r);
*s.t. E6_EmissionsAccounting1(YEAR,EMISSION,ECONOMY): sum(TECHNOLOGY) AnnualTechnologyEmission[y,t,e,r] = AnnualEmissions[y,e,r];
equation E6_EmissionsAccounting1(YEAR,EMISSION,ECONOMY);
E6_EmissionsAccounting1(y,e,r).. sum(t, AnnualTechnologyEmission(y,t,e,r)) =e= AnnualEmissions(y,e,r);
*s.t. E7_EmissionsAccounting2(EMISSION,ECONOMY): sum(YEAR) AnnualEmissions[y,e,r] = ModelPeriodEmissions[e,r]- ModelPeriodExogenousEmission[e,r];
equation E7_EmissionsAccounting2(EMISSION,ECONOMY);
E7_EmissionsAccounting2(e,r).. sum(y, AnnualEmissions(y,e,r)) =e= ModelPeriodEmissions(e,r)- ModelPeriodExogenousEmission(r,e);
*s.t. E8_AnnualEmissionsLimit(YEAR,EMISSION,ECONOMY): AnnualEmissions[y,e,r]+AnnualExogenousEmission[y,e,r] <= AnnualEmissionLimit[y,e,r];
equation E8_AnnualEmissionsLimit(YEAR,EMISSION,ECONOMY);
E8_AnnualEmissionsLimit(y,e,r).. AnnualEmissions(y,e,r)+AnnualExogenousEmission(r,e,y) =l= AnnualEmissionLimit(r,e,y);
*s.t. E9_ModelPeriodEmissionsLimit(EMISSION,ECONOMY): ModelPeriodEmissions[e,r] <= ModelPeriodEmissionLimit[e,r] ;
equation E9_ModelPeriodEmissionsLimit(EMISSION,ECONOMY);
E9_ModelPeriodEmissionsLimit(e,r).. ModelPeriodEmissions(e,r) =l= ModelPeriodEmissionLimit(r,e);
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
