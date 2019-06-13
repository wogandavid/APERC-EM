* OSEMOSYS_RES.GMS - create results in file SelResults.CSV
*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
*
* =======================================================================================================


FILE ANT /SelResults.CSV/;
PUT ANT; ANT.ND=6; ANT.PW=400; ANT.PC=5;
* Total emissions (by ECONOMY, emission)
loop((r,ghg),
put / "ModelPeriodEmissions",r.TL,ghg.TL,ModelPeriodEmissions.L(ghg,r);
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
loop((r,a),
put / "TotalAnnualCapacity",r.TL,a.TL;
loop(y, put TotalCapacityAnnual.L(y,a,r));
);
put /;
* New Annual Capacity (by ECONOMY, technology, year)
loop((r,a),
put / "NewAnnualCapacity",r.TL,a.TL;
loop(y, put NewCapacity.L(y,a,r));
);
put /;
* Annual Technology Production (by ECONOMY, technology, fuel, year)
loop((r,a,f)$(sum((y,m), OutputActivityRatio(r,a,f,m,y)) > 0),
put / "AnnualProductionByTechnology",r.TL,a.TL,f.TL;
loop(y, put ProductionByTechnologyAnnual.L(y,a,f,r));
);
put /;
* Annual Technology Use (by ECONOMY, technology, fuel, year)
loop((r,a,f)$(sum((y,m), InputActivityRatio(r,a,f,m,y)) > 0),
put / "AnnualUseByTechnology",r.TL,a.TL,f.TL;
loop(y, put UseByTechnologyAnnual.L(y,a,f,r));
);
put /;
* Technology Production in each TimeSlice (by ECONOMY, technology, fuel, timeslice, year)
loop((r,a,f)$(sum((y,m), OutputActivityRatio(r,a,f,m,y)) > 0),
loop(l,
put / "ProductionByTechnologyByTimeSlice",r.TL,a.TL,f.TL,l.TL;
loop(y, put ProductionByTechnology.L(y,l,a,f,r));
);
);
put /;
* Technology Use in each TimeSlice (by ECONOMY, technology, fuel, timeslice, year)
loop((r,a,f)$(sum((y,m), InputActivityRatio(r,a,f,m,y)) > 0),
loop(l,
put / "UseByTechnologyByTimeSlice",r.TL,a.TL,f.TL,l.TL;
loop(y, put UseByTechnology.L(y,l,a,f,r));
);
);
put /;
* Total Annual Emissions (by ECONOMY, emission, year)
loop((r,ghg),
put / "AnnualEmissions",r.TL,ghg.TL;
loop(y, put AnnualEmissions.L(y,ghg,r));
);
put /;
* Annual Emissions (by ECONOMY, technology, emission, year)
loop((r,a,ghg)$(sum((y,m), EmissionActivityRatio(r,a,ghg,m,y)) > 0),
put / "AnnualEmissionsByTechnology",r.TL,a.TL,ghg.TL;
loop(y, put AnnualTechnologyEmission.L(y,a,ghg,r));
);
put /;
PUTCLOSE ANT;