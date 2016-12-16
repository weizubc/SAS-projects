
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


%macro sumtable(dsetin=combine,dsetout=table,vars=ta sale mcap,stat=median mean n min max p5 p95,winsor=yes);

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

Proc transpose data=table out=mean prefix=stat name=variable;
run;

data mean;
set mean;
sort="mean";
run;


proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) median=&vars;
run;

Proc transpose data=table out=median prefix=stat name=variable;
run;

data median;
set median;
sort="median";
run;



proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) n=&vars;
run;

Proc transpose data=table out=n prefix=stat name=variable;
run;

data n;
set n;
sort="n";
run;


proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) std=&vars;
run;

Proc transpose data=table out=std prefix=stat name=variable;
run;

data std;
set std;
sort="std";
run;



proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) p5=&vars;
run;

Proc transpose data=table out=p5 prefix=stat name=variable;
run;

data p5;
set p5;
sort="p5";
run;



proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) p95=&vars;
run;

Proc transpose data=table out=p95 prefix=stat name=variable;
run;

data p95;
set p95;
sort="p95";
run;


proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) min=&vars;
run;

Proc transpose data=table out=min prefix=stat name=variable;
run;

data min;
set min;
sort="min";
run;


proc means data=new n mean std min p5 median p95 max noprint nway;
var &vars;
output out=table(drop=_type_ _freq_) max=&vars;
run;

Proc transpose data=table out=max prefix=stat name=variable;
run;

data max;
set max;
sort="max";
run;



data &dsetout(drop=variable sort);
set &stat;
name=trim(variable)||"_"||trim(sort);
rename stat1=&dsetin;
run;

proc sort data=&dsetout;by name;run;


%mend sumtable;

