
/**********************************************************
Purpose: produce tables comparing the chacteristics of two categories, first winsorize some variables to exclude outliers
conduct two-sided t test for means comparison, in default asssume equal variances
conduct two-sided Wilcoxon-Mann-Whitney test for median/distribution comparison

Input
 dsetin  : dataset to input
 byvar   : var to group dataset into categories
 vars    : variables to summarize and compare
 median  :if yes, then produce both mean and median stat , otherwise only produce table with means stat
 winsor  :if yes, then winsorize the variables at 1% first

Output
 dsetout : dataset to output with univariate analysis tables
************************************************************/


%macro groupcompare(dsetin=combine,dsetout=table,byvar=,vars=ta sale mcap,equalvar="Unequal",median=yes,winsor=yes);

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

proc means data=new mean noprint nway;
var &vars;
class &byvar;
output out=table(drop=_type_ _freq_) mean=&vars ;
run;

Proc transpose data=table out=mean_output prefix=mean_&byvar name=variable;
id &byvar;
run;


proc means data=new std noprint nway;
var &vars;
class &byvar;
output out=table(drop=_type_ _freq_) std=&vars ;
run;

Proc transpose data=table out=std_output prefix=std_&byvar name=variable;
id &byvar;
run;


** ods trace on/listing  to trace the name of object which stores estimates, ods trace off to turn it off;
ods listing close;
** two sample ttest;
proc ttest data =new;
  class &byvar;
  var &vars;
  ods output Ttests=ttest_output equality=vtest_output;
run;
ods listing;

data ttest_output;
set ttest_output;
if variances=&equalvar;
keep variable tvalue probt;
run;

data vtest_output;
set vtest_output;
keep variable fvalue probf;
run;


* combining mean_output and ttest_output;
proc sort data=mean_output; by variable;run;

proc sort data=ttest_output; by variable;run;

proc sort data=std_output; by variable;run;

proc sort data=vtest_output; by variable;run;


data mean;
merge mean_output ttest_output std_output vtest_output;
by variable;
label variable=" ";
run;


***********************************;
**median and median test;

proc means data=new median noprint nway;
var &vars;
class &byvar;
output out=table(drop=_type_ _freq_) median=&vars;
run;

Proc transpose data=table out=median_output prefix=median_&byvar name=variable;
id &byvar;
run;

ods listing close;

proc npar1way data =new wilcoxon;
  class &byvar;
  var &vars;
  ods output WilcoxonTest=mtest_output;
run;

ods listing;

data mtest_output1;
set mtest_output;
if name1="Z_WIL";
rename nValue1=z_stat;
keep variable nvalue1;
run;


data mtest_output2;
set mtest_output;
if name1="P2_WIL";
rename nValue1=p_value;
keep variable nvalue1;
run;


* combining median_output and mtest_output;
proc sort data=median_output; by variable;run;
proc sort data=mtest_output1; by variable;run;
proc sort data=mtest_output2; by variable;run;

data median;
merge median_output mtest_output1 mtest_output2;
by variable;
label variable=" ";
run;


%if &median=yes %then %do;
* combining mean and median;
proc sort data=mean;by variable;run;
proc sort data=median; by variable;run;

data &dsetout;
merge mean median;
by variable;
run;
%end;

%else %do;
data &dsetout;
set mean;
run;
%end;


data &dsetout;
set &dsetout;
if probt<=0.01 then sigt="***";
else if 0.01<probt<=0.05 then sigt="**";
else if 0.05<probt<=0.1 then sigt="*";
else sigt="";

if probf<=0.01 then sigf="***";
else if 0.01<probf<=0.05 then sigf="**";
else if 0.05<probf<=0.1 then sigf="*";
else sigf="";

if p_value<=0.01 then sigp="***";
else if 0.01<p_value<=0.05 then sigp="**";
else if 0.05<p_value<=0.1 then sigp="*";
else sigp="";
run;


%mend groupcompare;


