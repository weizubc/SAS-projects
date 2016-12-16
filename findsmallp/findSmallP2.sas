
options mprint mlogic symbolgen;
options nomprint nomlogic nosymbolgen;

libname smallp "C:\Users\weiz\Desktop\job hunting\sas_projects\findsmallp";

/* input dataset named input, output dataset named finaloutput*/

data input;
set smallp.testinput;
/*dep variable*/
rename dep=y;
/*key variable we want to find small p*/
rename nonzero_ancitetn=x;
/* control variable you have to include in the model, for example, industry dummies and year dummies ff1-ff48 yr2001-yr2008 */
%global controlx;
%let controlx=dayear1-dayear22 affind1-affind22 x15;
/* other indep variable you want to shuffle around, upper limit is 12 varaibles, hope it is enough.*/

rename samestate=x1; 
rename sameindff=x2;
rename tender=x3;
rename hostile=x4;
rename wholebuy=x5;
rename allstock=x6;
rename allcash=x7;
rename wret=x8;
rename wmbe=x9;
rename wroa=x10;
rename size=x11;
rename wbooklev=x12;
rename patent_an_log=x13;
rename patent_an_log=x14;
rename nonzero_tncitean=x15;
run;

%put &controlx;

%macro saveP(data=input,initial=0);
* produce &otherx which stored the combination names of X1-Xn;
ods listing close;
ods output ParameterEstimates=output;

proc reg data=&data;
model y=%str(x &controlx &otherx ) ;
run;
quit;
ods output close;

ods listing;

data output;
set output;
length otherx $200;
otherx="&otherx";
if _n_=2;
run;

%if &initial=1 %then
%do;
data finaloutput;
set output;
run;
%end;

%else 

%do;
data finaloutput;
set finaloutput output;
run;
%end;

%mend saveP;


%macro cn1(n=3);
%global otherx;
%do i1=1 %to &n;
%let otherx=x&i1;
%put &otherx;
%saveP;
%end;

%mend cn1;



%macro cn2(n=3);

%global otherx;
%do i1=1 %to &n;

%do i2=&i1+1 %to &n;
%let otherx=x&i1;
%let otherx=%str(&otherx x&i2);
%put &otherx;
%saveP;
%end;
%end;

%mend cn2;


%macro cn3(n=3);
%global otherx;

%do i1=1 %to &n;

%do i2=&i1+1 %to &n;

%do i3=&i2+1 %to &n;
%let otherx=x&i1;
%let otherx=%str(&otherx x&i2 x&i3);
%put &otherx;
%saveP;
%end;
%end;
%end;

%mend cn3;


%macro cn4(n=4);
%global otherx;

%do i1=1 %to &n;

%do i2=&i1+1 %to &n;

%do i3=&i2+1 %to &n;
%do i4=&i3+1 %to &n;
%let otherx=x&i1;
%let otherx=%str(&otherx x&i2 x&i3 x&i4);
%put &otherx;
%saveP;
%end;
%end;
%end;
%end;

%mend cn4;


%macro cn5(n=5);
%global otherx;

%do i1=1 %to &n;

%do i2=&i1+1 %to &n;

%do i3=&i2+1 %to &n;
%do i4=&i3+1 %to &n;
%do i5=&i4+1 %to &n;
%let otherx=x&i1;
%let otherx=%str(&otherx x&i2 x&i3 x&i4 x&i5);
%put &otherx;
%saveP;
%end;
%end;
%end;
%end;
%end;

%mend cn5;


%macro cn6(n=6);
%global otherx;

%do i1=1 %to &n;

%do i2=&i1+1 %to &n;

%do i3=&i2+1 %to &n;
%do i4=&i3+1 %to &n;
%do i5=&i4+1 %to &n;
%do i6=&i5+1 %to &n;
%let otherx=x&i1;
%let otherx=%str(&otherx x&i2 x&i3 x&i4 x&i5 x&i6);
%put &otherx;
%saveP;
%end;
%end;
%end;
%end;
%end;
%end;

%mend cn6;


%macro cn7(n=7);
%global otherx;

%do i1=1 %to &n;

%do i2=&i1+1 %to &n;

%do i3=&i2+1 %to &n;
%do i4=&i3+1 %to &n;
%do i5=&i4+1 %to &n;
%do i6=&i5+1 %to &n;
%do i7=&i6+1 %to &n;
%let otherx=x&i1;
%let otherx=%str(&otherx x&i2 x&i3 x&i4 x&i5 x&i6 x&i7);
%put &otherx;
%saveP;
%end;
%end;
%end;
%end;
%end;
%end;
%end;

%mend cn7;


%macro cn8(n=8);
%global otherx;

%do i1=1 %to &n;

%do i2=&i1+1 %to &n;

%do i3=&i2+1 %to &n;
%do i4=&i3+1 %to &n;
%do i5=&i4+1 %to &n;
%do i6=&i5+1 %to &n;
%do i7=&i6+1 %to &n;
%do i8=&i7+1 %to &n;
%let otherx=x&i1;
%let otherx=%str(&otherx x&i2 x&i3 x&i4 x&i5 x&i6 x&i7 x&i8);
%put &otherx;
%saveP;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;

%mend cn8;

%macro cn9(n=9);
%global otherx;

%do i1=1 %to &n;

%do i2=&i1+1 %to &n;

%do i3=&i2+1 %to &n;
%do i4=&i3+1 %to &n;
%do i5=&i4+1 %to &n;
%do i6=&i5+1 %to &n;
%do i7=&i6+1 %to &n;
%do i8=&i7+1 %to &n;
%do i9=&i8+1 %to &n;
%let otherx=x&i1;
%let otherx=%str(&otherx x&i2 x&i3 x&i4 x&i5 x&i6 x&i7 x&i8 x&i9);
%put &otherx;
%saveP;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;

%mend cn9;


%macro cn10(n=10);
%global otherx;

%do i1=1 %to &n;

%do i2=&i1+1 %to &n;

%do i3=&i2+1 %to &n;
%do i4=&i3+1 %to &n;
%do i5=&i4+1 %to &n;
%do i6=&i5+1 %to &n;
%do i7=&i6+1 %to &n;
%do i8=&i7+1 %to &n;
%do i9=&i8+1 %to &n;
%do i10=&i9+1 %to &n;
%let otherx=x&i1;
%let otherx=%str(&otherx x&i2 x&i3 x&i4 x&i5 x&i6 x&i7 x&i8 x&i9 x&i10);
%put &otherx;
%saveP;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;

%mend cn10;

%macro cn11(n=11);
%global otherx;

%do i1=1 %to &n;

%do i2=&i1+1 %to &n;

%do i3=&i2+1 %to &n;
%do i4=&i3+1 %to &n;
%do i5=&i4+1 %to &n;
%do i6=&i5+1 %to &n;
%do i7=&i6+1 %to &n;
%do i8=&i7+1 %to &n;
%do i9=&i8+1 %to &n;
%do i10=&i9+1 %to &n;
%do i11=&i10+1 %to &n;
%let otherx=x&i1;
%let otherx=%str(&otherx x&i2 x&i3 x&i4 x&i5 x&i6 x&i7 x&i8 x&i9 x&i10 x&i11);
%put &otherx;
%saveP;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%mend cn11;


%macro cn12(n=12);
%global otherx;

%do i1=1 %to &n;

%do i2=&i1+1 %to &n;

%do i3=&i2+1 %to &n;
%do i4=&i3+1 %to &n;
%do i5=&i4+1 %to &n;
%do i6=&i5+1 %to &n;
%do i7=&i6+1 %to &n;
%do i8=&i7+1 %to &n;
%do i9=&i8+1 %to &n;
%do i10=&i9+1 %to &n;
%do i11=&i10+1 %to &n;
%do i12=&i11+1 %to &n;
%let otherx=x&i1;
%let otherx=%str(&otherx x&i2 x&i3 x&i4 x&i5 x&i6 x&i7 x&i8 x&i9 x&i10 x&i11 x&i12);
%put &otherx;
%saveP;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%mend cn12;


%macro cn13(n=13);
%global otherx;

%do i1=1 %to &n;
%do i2=&i1+1 %to &n;
%do i3=&i2+1 %to &n;
%do i4=&i3+1 %to &n;
%do i5=&i4+1 %to &n;
%do i6=&i5+1 %to &n;
%do i7=&i6+1 %to &n;
%do i8=&i7+1 %to &n;
%do i9=&i8+1 %to &n;
%do i10=&i9+1 %to &n;
%do i11=&i10+1 %to &n;
%do i12=&i11+1 %to &n;
%do i13=&i12+1 %to &n;

%let otherx=x&i1;
%let otherx=%str(&otherx x&i2 x&i3 x&i4 x&i5 x&i6 x&i7 x&i8 x&i9 x&i10 x&i11 x&i12 x&i13);
%put &otherx;
%saveP;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%mend cn13;


%macro cn14(n=14);
%global otherx;

%do i1=1 %to &n;

%do i2=&i1+1 %to &n;

%do i3=&i2+1 %to &n;
%do i4=&i3+1 %to &n;
%do i5=&i4+1 %to &n;
%do i6=&i5+1 %to &n;
%do i7=&i6+1 %to &n;
%do i8=&i7+1 %to &n;
%do i9=&i8+1 %to &n;
%do i10=&i9+1 %to &n;
%do i11=&i10+1 %to &n;
%do i12=&i11+1 %to &n;
%do i13=&i12+1 %to &n;
%do i14=&i13+1 %to &n;

%let otherx=x&i1;
%let otherx=%str(&otherx x&i2 x&i3 x&i4 x&i5 x&i6 x&i7 x&i8 x&i9 x&i10 x&i11 x&i12 x&i13 x&i14);
%put &otherx;
%saveP;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%mend cn14;

%macro cn15(n=15);
%global otherx;

%do i1=1 %to &n;
%do i2=&i1+1 %to &n;
%do i3=&i2+1 %to &n;
%do i4=&i3+1 %to &n;
%do i5=&i4+1 %to &n;
%do i6=&i5+1 %to &n;
%do i7=&i6+1 %to &n;
%do i8=&i7+1 %to &n;
%do i9=&i8+1 %to &n;
%do i10=&i9+1 %to &n;
%do i11=&i10+1 %to &n;
%do i12=&i11+1 %to &n;
%do i13=&i12+1 %to &n;
%do i14=&i13+1 %to &n;
%do i15=&i14+1 %to &n;

%let otherx=x&i1;
%let otherx=%str(&otherx x&i2 x&i3 x&i4 x&i5 x&i6 x&i7 x&i8 x&i9 x&i10 x&i11 x&i12 x&i13 x&i14 x&i15);
%put &otherx;
%saveP;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%end;
%mend cn15;

%macro findsmallP(n=2);
%global otherx;
%let otherx=%str();
%saveP(initial=1);

%do i=1 %to &n;
%cn&i(n=&n);
%end;
%mend findsmallP;



/* n is the number of x1-xn you want to shuffle to find small p of x */
%findsmallP(n=4);



proc sort data=finaloutput nodupkey ; 
by probt;
run;




