* =======================================================================================================
* APERC Energy Model 2019.06.03 created by David Wogan, ASIA PACIFIC ENERGY RESEARCH CENTRE, Tokyo, Japan
* david.wogan@aperc.ieej.or.jp
*
* Based on OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
*
* Files required are:
* 0_osemosys.gms (this file)
* 1_osemosys_dec.gms
* 2_tokyo_data.gms
* 3_osemosys_equ.gms
* 4_osemosys_res.gms
*
* declarations for sets, parameters, variables
$offlisting
$include 1_osemosys_dec.gms
*
* specify tokyo Example Economy data
$include 2_tokyo_data.gms
*
* define model equations
$offlisting
*
* declare equations
$include 3_osemosys_equ.gms
*
* solve the model
option LP=cbc;
model osemosys /all/;
option limrow=1e4, limcol=1e4, solprint=on, savepoint=2;
solve osemosys minimizing z using LP;
*
* create results in file SelResults.CSV
$include 4_osemosys_res.gms
*
* =======================================================================================================
