* =======================================================================================================
* APERC Energy Model 2019.01.02 created by David Wogan, ASIA PACIFIC ENERGY RESEARCH CENTRE, Tokyo, Japan
* david.wogan@aperc.ieej.or.jp
*
* Based on OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
*
* Files required are:
* osemosys.gms (this file)
* osemosys_dec.gms
* itomori_data1.gms
* osemosys_equ.gms
*
* declarations for sets, parameters, variables
$offlisting
$include osemosys_dec.gms
*
* specify ITOMORI Example Economy data
$include itomori_data1.gms
*
* define model equations
$offlisting
*
* declare equations
$include osemosys_equ.gms
*
* solve the model
option lp=cbc;
model osemosys /all/;
option limrow=1e1, limcol=1e1, solprint=on;
solve osemosys minimizing z using lp;
*
* create results in file SelResults.CSV
$include osemosys_res.gms
*
* =======================================================================================================
