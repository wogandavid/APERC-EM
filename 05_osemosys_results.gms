* OSEMOSYS_RES.GMS - create results in file SelResults.CSV
*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
*
* =======================================================================================================


FILE ANT /SelResults.CSV/;
PUT ANT; ANT.ND=6; ANT.PW=400; ANT.PC=5;
* Total emissions (by ECONOMY, emission)
loop((r,e),
put / "ModelPeriodEmissions",r.TL,e.TL,ModelPeriodEmissions.L(e,r);
);
put /;
* Total cost (by ECONOMY)
loop(r,
put / "ModelPeriodCostByECONOMY",r.TL,ModelPeriodCostByECONOMY.L(r);
);
put /;
* Accumulated Annual Demand (by ECONOMY, fuel, timeslice, year)
loop((r,f)$(sum(y, AccumulatedAnnualDemand(r,f,y)) > 0),
put / "AccumulatedAnnualDemand",r.TL,f.TL;
loop(y, put AccumulatedAnnualDemand(r,f,y));
);
put /;
* Demand by TimeSlice (by ECONOMY, fuel, timeslice, year)
loop((r,f)$(sum(y, SpecifiedAnnualDemand(r,f,y)) > 0),
loop(l,
put / "DemandByTimeSlice",r.TL,f.TL,l.TL;
loop(y, put Demand.L(y,l,f,r));
);
);
put /;
* Fuel Production by TimeSlice (by ECONOMY, fuel, timeslice, year)
loop((r,f,l),
put / "FuelProductionByTimeSlice",r.TL,f.TL,l.TL;
loop(y, put Production.L(y,l,f,r));
);
put /;
* Total Annual Capacity (by ECONOMY, technology, year)
loop((r,t),
put / "TotalAnnualCapacity",r.TL,t.TL;
loop(y, put TotalCapacityAnnual.L(y,t,r));
);
put /;
* New Annual Capacity (by ECONOMY, technology, year)
loop((r,t),
put / "NewAnnualCapacity",r.TL,t.TL;
loop(y, put NewCapacity.L(y,t,r));
);
put /;
* Annual Technology Production (by ECONOMY, technology, fuel, year)
loop((r,t,f)$(sum((y,m), OutputActivityRatio(r,t,f,m,y)) > 0),
put / "AnnualProductionByTechnology",r.TL,t.TL,f.TL;
loop(y, put ProductionByTechnologyAnnual.L(y,t,f,r));
);
put /;
* Annual Technology Use (by ECONOMY, technology, fuel, year)
loop((r,t,f)$(sum((y,m), InputActivityRatio(r,t,f,m,y)) > 0),
put / "AnnualUseByTechnology",r.TL,t.TL,f.TL;
loop(y, put UseByTechnologyAnnual.L(y,t,f,r));
);
put /;
* Technology Production in each TimeSlice (by ECONOMY, technology, fuel, timeslice, year)
loop((r,t,f)$(sum((y,m), OutputActivityRatio(r,t,f,m,y)) > 0),
loop(l,
put / "ProductionByTechnologyByTimeSlice",r.TL,t.TL,f.TL,l.TL;
loop(y, put ProductionByTechnology.L(y,l,t,f,r));
);
);
put /;
* Technology Use in each TimeSlice (by ECONOMY, technology, fuel, timeslice, year)
loop((r,t,f)$(sum((y,m), InputActivityRatio(r,t,f,m,y)) > 0),
loop(l,
put / "UseByTechnologyByTimeSlice",r.TL,t.TL,f.TL,l.TL;
loop(y, put UseByTechnology.L(y,l,t,f,r));
);
);
put /;
* Total Annual Emissions (by ECONOMY, emission, year)
loop((r,e),
put / "AnnualEmissions",r.TL,e.TL;
loop(y, put AnnualEmissions.L(y,e,r));
);
put /;
* Annual Emissions (by ECONOMY, technology, emission, year)
loop((r,t,e)$(sum((y,m), EmissionActivityRatio(r,t,e,m,y)) > 0),
put / "AnnualEmissionsByTechnology",r.TL,t.TL,e.TL;
loop(y, put AnnualTechnologyEmission.L(y,t,e,r));
);
put /;
PUTCLOSE ANT;