data check;
set patstat.gdp;
if missing(country);

run;




%macro create(start=2000,end=2008);
%local i;
%local j;

%do i=&start %to &end %by 1;

%do j=1 %to 4 %by 1;

data year&i._&j;
set patstat.nation;
rdyear=&i;
rdquarter=&j;
run;

data check;
set check year&i._&j;
run;

%end;
%end;

%mend create;


%create;



data patstat.c25_2000_2008;
set check;
run;
