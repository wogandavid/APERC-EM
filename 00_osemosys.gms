* =======================================================================================================
* APERC Energy Model 2019.06.03 created by David Wogan, ASIA PACIFIC ENERGY RESEARCH CENTRE, Tokyo, Japan
* david.wogan@aperc.ieej.or.jp
*
* Based on OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
*
* Files required are:
* 00_osemosys.gms (this file)
* 01_osemosys_declarations.gms
* 02_sets.gms
* 0_data_import.gms
* 04_osemosys_equations.gms
* 05_osemosys_results.gms
*
* declarations for sets, parameters, variables
$offlisting
$include 01_osemosys_declarations.gms
*
* All sets of technologies and fuels
$include 02_sets.gms

* Import data
* Note: when you build your sector:
* 1. rename the file to sectornumber_name_data.gms
* 2. move the data file to your sector folder
* 3. change the path to your folder.
$include 02a_data_import.gms

*
* define model equations
$offlisting
*
* declare equations
$include 04_osemosys_equations.gms
*
* solve the model
option LP=cbc;
model osemosys /all/;
option limrow=1e4, limcol=1e4, solprint=on, savepoint=2;
solve osemosys minimizing z using LP;
*
* create results in file SelResults.CSV
$include 05_osemosys_results.gms
*
* =======================================================================================================
