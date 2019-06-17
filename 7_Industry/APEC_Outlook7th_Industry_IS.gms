**********************************
**********************************
$onecho > APEC_Outlook7th_Industry.txt
set=e      rng=P_IND!A2 rdim=1
set=yt     rng=P_IND!B2 rdim=1
set=y1     rng=P_IND!C2 rdim=1
set=y2     rng=P_IND!D2 rdim=1
set=y3     rng=P_IND!E2 rdim=1
set=y4     rng=P_IND!F2 rdim=1
set=y5     rng=P_IND!G2 rdim=1

par=FLG    rng=P_IND!K1 rdim=1 cdim=1
par=DAT    rng=P_DAT!C1 rdim=2 cdim=1
$offecho
$call gdxxrw.exe APEC_Outlook7th_Industry_IS.xlsx@APEC_Outlook7th_Industry.txt
$gdxin APEC_Outlook7th_Industry_IS.gdx

Sets e(*) economy, yt(*) year type, y1(*),y2(y1),y3(y1),y4(y1),y5(y1);
$load e,yt,y1,y2,y3,y4,y5

Parameters
FLG(e,yt),
DAT(*,e,y1),
REG(*,y1),
RST(e,*);
$Load FLG DAT
$gdxin

RST(e,'k')=eps;
RST(e,'c1')=eps;
RST(e,'c2')=eps;
RST(e,'c3')=eps;


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


Loop((e,yt),
    If(FLG(e,yt)=1,
         REG('DUM1',y1) = DAT('DUM1',e,y1);
         REG('DUM2',y1) = DAT('DUM2',e,y1);
         REG('GDP/POP',y1)   = DAT('GDP',e,y1)/DAT('POP',e,y1);
         REG('ITM/POP',y1)   = DAT('ITM',e,y1)/DAT('POP',e,y1);
         REG('L_GDP/POP',y1) = log(REG('GDP/POP',y1));
         REG('L_ITM/POP',y1) = log(REG('ITM/POP',y1))$(DAT('ITM',e,y1)>0);

         If(ord(yt)=1,Solve  LS_y1 using lp minimizing z;);
         If(ord(yt)=2,Solve  LS_y2 using lp minimizing z;);
         If(ord(yt)=3,Solve  LS_y3 using lp minimizing z;);
         If(ord(yt)=4,Solve  LS_y4 using lp minimizing z;);
         If(ord(yt)=5,Solve  LS_y5 using lp minimizing z;);

         RST(e,'k')=k.l;
         RST(e,'c1')=c1.l;
         RST(e,'c2')=c2.l;
         RST(e,'c3')=c3.l;
    );
);



Display RST,REG;
$onecho > APEC_Outlook7th_Industry_Output.txt
par=RST rng=P_RST!A1
$offecho

execute_unload 'APEC_Outlook7th_Industry_IS.gdx',RST;
execute 'gdxxrw.exe APEC_Outlook7th_Industry_IS.gdx@APEC_Outlook7th_Industry_Output';

