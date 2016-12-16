/**************************************************
A common task in data cleaning is to identify
observations with a duplicate ID number. If we set
the data set by ID, then the observations which
are not duplicated will be both the first and the
last with that ID number. We can therefore write
any observations which are not both first.id and
last.id to a separate data set and examine them.
**************************************************/


%macro checkdup(dataset,var1,var2=null);

%if &var2=null %then %do;

proc sort data=&dataset out=sample; by &var1;run;

data single_&var1 dup_&var1;
set sample;
by &var1;
if first.&var1 and last.&var1 then output single_&var1;
else output dup_&var1;
run;

%end;

%else %do;

proc sort data=&dataset out=sample nodupkey; by &var1 &var2;run;

data dup_&var1;
    set sample;
    by &var1;
    if not (first.&var1 and last.&var1) then output dup_&var1;
run;

proc sort data=sample; by &var2;run;

data dup_&var2;
    set sample;
    by &var2;
    if not (first.&var2 and last.&var2) then output dup_&var2;
run;

%end;

%mend;



*check if one var1 is matched with one var2 or one var1 is matched with multiple var2 or opposite;
*if there is no obs in dup_var1 and no obs in dup_var2 then one var1 is matched with one var2;
*if there is no obs in dup_var1 and obs in dup_var2 then several var1 is matched with one var2;
*if there is obs in dup_var1 and no obs in dup_var2 then one var1 is matched with several var2;






