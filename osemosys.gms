*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
*
* APERC Energy Model 2019.01.01 created by David Wogan, APERC
*
* Files required are:
* osemosys.gms (this file)
* osemosys_dec.gms
* itomori_data.gms
* osemosys_equ.gms
*
*
* declarations for sets, parameters, variables
$offlisting
$include osemosys_dec.gms
* specify Itomori Model data
*$include itomori_data.gms
$include itomori_data1.gms
* define model equations
$offlisting
$include osemosys_equ.gms
* solve the model
model osemosys /all/;
option limrow=1e2, limcol=1e2, solprint=on;
solve osemosys minimizing z using lp;
* create results in file SelResults.CSV
$include osemosys_res.gms
