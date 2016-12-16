/**********************************************************************
Purpose: generate the time-series average of cross-sectional correlation
         matrix for Pearson and Spearman correlations;

Author : Wei Zhang
Date   : 04/20/2006

Input  
 data  : the panel data
 byvar : the time-variable
 vars  : the variables to be included in the correlation matrix

Output
 pearson: the Pearson correlation matrix in SAS dataset
 spearmn: te nonparametric Spearman correlation matrix in SAS dataset
***********************************************************************/

 
%macro correlation(data=, byvar=none, vars=, pearson=, spearman=);

%if &byvar=none %then %do;
proc corr data=&data outp=&pearson outs=&spearman noprint;
var &vars; run;
%end;
%if &byvar~=none %then %do;
proc corr data=&data outp=pearson outs=spearman noprint;
by &byvar; var &vars; run;

data pearson; set pearson; by &byvar; retain id; if first.&byvar then id=0; id=id+1; if _name_='' then _name_=_type_; run;
proc sort; by id &byvar _name_; run;
proc means data=pearson noprint; by id _name_;
var _numeric_; output out=&pearson(drop=&byvar) mean=; run;

data spearman; set spearman; by &byvar; retain id; if first.&byvar then id=0; id=id+1; if _name_='' then _name_=_type_; run;
proc sort; by id &byvar _name_; run;
proc means data=spearman noprint; by id _name_;
var _numeric_; output out=&spearman(drop=&byvar) mean=; run;
%end;

%mend correlation;

