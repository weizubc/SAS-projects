
/**********************************************************
Purpose: summarize variable statistics(n mean median std p10 p90), first winsorize some variables to exclude outliers

Input:
 dsetin  : dataset to input
 byvar   : var to group dataset into categories
 vars    : variables to summarize and compare
 median  :if yes, then produce both mean and median stat , otherwise only produce table with means stat
 winsor  :if yes, then winsorize the variables at 1% first

Output
 dsetout : dataset to output with univariate analysis tables
************************************************************/


%macro sum(dsetin=combine,dsetout=table,vars=ta sale mcap,winsor=yes);

%if &winsor=yes %then %do;

filename mfile 'C:\Users\weiz\Desktop\tosave\macro';

%include mfile(winsorize);

%winsor(dsetin=&dsetin, dsetout=new, byvar=none, vars=&vars, type=winsor, pctl=1 99);

%end;

%else %do;

data new;
set &dsetin;
run;

%end;

proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) mean=&vars;
run;

Proc transpose data=table out=mean prefix=mean name=variable;
run;

proc sort data=mean;by variable;run;



proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) median=&vars;
run;

Proc transpose data=table out=median prefix=p50_ name=variable;
run;

proc sort data=median;by variable;run;



proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) n=&vars;
run;

Proc transpose data=table out=n prefix=n name=variable;
run;

proc sort data=n;by variable;run;


proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) std=&vars;
run;

Proc transpose data=table out=std prefix=std name=variable;
run;

proc sort data=std;by variable;run;



proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) p5=&vars;
run;

Proc transpose data=table out=p5 prefix=p5_ name=variable;
run;

proc sort data=p5;by variable;run;



proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) p95=&vars;
run;

Proc transpose data=table out=p95 prefix=p95_ name=variable;
run;

proc sort data=p95;by variable;run;


proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) min=&vars;
run;

Proc transpose data=table out=min prefix=min name=variable;
run;

proc sort data=min;by variable;run;


proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) max=&vars;
run;

Proc transpose data=table out=max prefix=max name=variable;
run;

proc sort data=max;by variable;run;



data &dsetout;
merge n mean std min p5 median p95 max;
by variable;
run;


%mend sum;

