/************************************************************************************
Purpose: 0. report well-organized Fama-MacBeth regression results 
         1. report the time-series average of each regression coefficient
	    and adjusted R-square (x.xxx)
         2. report the Newey-West t-stat in bracket (x.xx)
         3. indicate the signicance level by '*', '**' and '***' for 10%, 5% and 1%
         4. report the range of periods the total observations involved

by Wei Zhang, Nov 2006
**************************************************************************************/

** 1. run cross-sectional OLS regressions;

proc sort data=sample; by date;run;

let %y = depvar; *define dep var here;

proc reg data=sample outest=FB noprint;
 by date;
 model &y = indvars1 /adjrsq;
 model &y = indvars2 /adjrsq;
quit;

** 2. drop irrelevant estimates;
proc sort data=FB; by _model_ date; run;
data FB2; set FB; drop  &y _TYPE_  _DEPVAR_  _RMSE_ _IN_  _P_  _EDF_;
 rename _model_=model; run;

proc transpose data=FB2 out=FBny name=name prefix=coef;
 by model date; run;
data FBny; set FBny; retain code; 
 by model date; code=code+1; if first.date then code=1;run;

proc sort data=FBny; by model code name;run;

** 3. Newey-West t-stat for the time-series average of coefficients;

%let lag=3;*lags for Newey-West t-stat; 
proc model data=FBny; 
 by model code name;
 parms a; exogenous coef1 ; 
 instruments / intonly;
 coef1 =a; 
 fit coef1 / gmm kernel=(bart, %eval(&lag+1), 0);
 ods output parameterestimates=param1  fitstatistics=fitresult
 OutputStatistics=residual;
quit;

** 4. output into column table;

data param1; set param1; 
 tvalue2=put(tvalue,7.2); if probt<0.1 then p='*  ';
 if probt<0.05 then p='** '; if probt<0.01 then p='***';
 T=compress('('||tvalue2||')'); PARAM=compress(put(estimate,7.3)||p);
 run;

data param1a; set param1; keep model code name coef _name_; 
 _name_='PARAM'; coef=PARAM; run;
data param1b; set param1; keep model code name coef _name_;
 _name_='T'; coef=T; run;
data param2; set param1a param1b;run;
proc sort data=param2; by  code _name_ model;run;

proc transpose data=param2 out=param3; 
 by code name _name_; id model; var coef; run;
data param3; set param3; if _name_='T' then do;
 code=. ;name=.;end;run;

** 5. find the range of periods and obs used;

proc sort data=fb out=fb3; by _model_; run;
data fb3; set fb3; keep _model_ date num; num = _edf_+_p_;
 rename _model_=model; run;
proc sql; create table num(where=(model='MODEL1')) as select
 model, min(date) as start, max(date) as end, count(date) as range,
 sum(num) as obs from fb3 group by model;quit;
proc transpose data=num out=num; by model; var start -- obs; run;
data num; set num; rename _name_=name; MODEL1=put(col1, 7.0);
 drop model col1; run;

data param3; set param3 num; run;
 
** 6. output as excel file;

PROC EXPORT DATA= param3
            OUTFILE= "c:\result.xls" 
            DBMS=EXCEL2000 replace;
RUN;

