* New Steel sector demand model

set ECONOMY economies /
01_AUS
02_BD
03_CDA
04_CHL
05_PRC
06_HKC
07_INA
08_JPN
09_ROK
10_MAS
11_MEX
12_NZ
13_PNG
14_PE
15_RP
16_RUS
17_SIN
18_CT
19_THA
20_USA
21_VN
/
;

Set yt year type /yr1,yr2,yr3,yr4,yr5/;
Set y1 /1980*2016/;
Set y2(y1) /1987*2016/;
Set y3(y1) /1992*2016/;
Set y4(y1) /1980*2016/;
Set y5(y1) /1992*2016/;

$onecho > 7th_steel.txt
par=FLG    rng=flag!B1 rdim=1 cdim=1
par=DAT    rng=data!C1 rdim=2 cdim=1
$offecho
$call gdxxrw.exe 7th_steel.xlsx@7th_steel.txt
$gdxin 7th_steel.gdx

parameters 
FLG(ECONOMY,yt),
DAT(*,ECONOMY,y1),
REG(*,y1),
RST(ECONOMY,*);
$Load FLG DAT
$gdxin

display FLG;

RST(ECONOMY,'k')=eps;
RST(ECONOMY,'c1')=eps;
RST(ECONOMY,'c2')=eps;
RST(ECONOMY,'c3')=eps;

Variables
z    dummy objective
k    constant
d1   coeefficient for dummy variables
d2   coeefficient for dummy variables
c1   coefficient
c2   coefficient
c3   coefficient
;

Equations
obj    dummy objective
fit_y1(y1) linear model for projections
fit_y2(y2) linear model for projections
fit_y3(y3) linear model for projections
fit_y4(y4) linear model for projections
fit_y5(y5) linear model for projections;

obj..         z =n= 0;
fit_y1(y1)..  REG('L_ITM/POP',y1) =e= k + d1*REG('DUM1',y1)
                                        + d2*REG('DUM2',y1)
                                        + c1*ord(y1)
                                        + c2*REG('L_GDP/POP',y1)
                                        + c3*REG('L_ITM/POP',y1-1)
;
fit_y2(y2)..  REG('L_ITM/POP',y2) =e= k + d1*REG('DUM1',y2)
                                        + d2*REG('DUM2',y2)
                                        + c1*ord(y2)
                                        + c2*REG('L_GDP/POP',y2)
                                        + c3*REG('L_ITM/POP',y2-1)
;
fit_y3(y3)..  REG('L_ITM/POP',y3) =e= k + d1*REG('DUM1',y3)
                                        + d2*REG('DUM2',y3)
                                        + c1*ord(y3)
                                        + c2*REG('L_GDP/POP',y3)
                                        + c3*REG('L_ITM/POP',y3-1)
;
fit_y4(y4)..  REG('L_ITM/POP',y4) =e= k + d1*REG('DUM1',y4)
                                        + d2*REG('DUM2',y4)
                                        + c1*ord(y4)
                                        + c2*REG('L_GDP/POP',y4)
                                        + c3*REG('L_ITM/POP',y4-1)
;
fit_y5(y5)..  REG('L_ITM/POP',y5) =e= k + d1*REG('DUM1',y5)
                                        + d2*REG('DUM2',y5)
                                        + c1*ord(y5)
                                        + c2*REG('L_GDP/POP',y5)
                                        + c3*REG('L_ITM/POP',y5-1)
;


Option lp=ls;
Model  LS_y1 /obj,fit_y1/;
Model  LS_y2 /obj,fit_y2/;
Model  LS_y3 /obj,fit_y3/;
Model  LS_y4 /obj,fit_y4/;
Model  LS_y5 /obj,fit_y5/;

display yt;

Loop((ECONOMY,yt),
        If(FLG(ECONOMY,yt)=1,
         REG('DUM1',y1) = DAT('DUM1',ECONOMY,y1);
         REG('DUM2',y1) = DAT('DUM2',ECONOMY,y1);
         REG('GDP/POP',y1)   = DAT('GDP',ECONOMY,y1)/DAT('POP',ECONOMY,y1);
         REG('ITM/POP',y1)   = DAT('ITM',ECONOMY,y1)/DAT('POP',ECONOMY,y1);
         REG('L_GDP/POP',y1) = log(REG('GDP/POP',y1));
         REG('L_ITM/POP',y1) = log(REG('ITM/POP',y1))$(DAT('ITM',ECONOMY,y1)>0);

         If(ord(yt)=1,Solve  LS_y1 using lp minimizing z;);
         If(ord(yt)=2,Solve  LS_y2 using lp minimizing z;);
         If(ord(yt)=3,Solve  LS_y3 using lp minimizing z;);
         If(ord(yt)=4,Solve  LS_y4 using lp minimizing z;);
         If(ord(yt)=5,Solve  LS_y5 using lp minimizing z;);

         RST(ECONOMY,'k')=k.l;
         RST(ECONOMY,'c1')=c1.l;
         RST(ECONOMY,'c2')=c2.l;
         RST(ECONOMY,'c3')=c3.l;
    );
);

Display RST,REG;
$onecho > 7th_steel_results.txt
par=RST rng=P_RST!A1
$offecho

execute_unload '7th_steel_results.gdx',RST;
execute 'gdxxrw.exe 7th_steel_results.gdx@7th_steel_results';