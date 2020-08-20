/*import the cleaned csv (';' have been replaced by ',' during cleaning)*/

%web_drop_table(WORK.PART2);

FILENAME REFFILE '/folders/myfolders/FETS/FETS/Data/cleaned_part2.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.PART2;
	GETNAMES=YES;
RUN;


/*Initial plot, all products */
proc sgplot data=PART2;
series x=date y=Sales_quantity /GROUP=Product_Reference;
run;

/*------ 1st product: FR001 ------*/
data FR001;
set PART2(where=(Product_Reference = "FR001"));
run;

/*Simple plot*/
proc sgplot data=FR001;
series x=date y=Sales_quantity;
run;

/*Diagnostic*/
proc timeseries data=FR001
plot=(series corr acf pacf iacf wn decomp tc sc);
id Date interval=month;
var Sales_Quantity;
decomp;
run;

/*Candidate models*/
*good for seasonality, trend, final effect;
proc esm data=FR001 outstat=FR001_winters lead=16 plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=WINTERS;
run;

*good for seasonality, trend;
proc esm data=FR001 lead=16 outstat=FR001_addwinters plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=ADDWINTERS;
run;

*good for seasonality;
proc esm data=FR001 outstat=FR001_addseasonal lead=16 plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=ADDSEASONAL;
run;

*good for seasonality, final effect;
proc esm data=FR001 lead=16 outstat=FR001_seasonal plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=SEASONAL;
run;

/*Selected model*/
proc esm data=FR001 lead=16 out=FR001_FORECASTS outstat=FR001_addwinters plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=ADDWINTERS;
run;

/*------ 2nd product: ESA15 ------*/
data ESA15;
set PART2(where=(Product_Reference = "ESA15"));
run;

/*Simple plot*/
proc sgplot data=ESA15;
series x=date y=Sales_quantity;
run;

/*Diagnostic*/
proc timeseries data=ESA15
plot=(series corr acf pacf iacf wn decomp tc sc);
id Date interval=month;
var Sales_Quantity;
run;

/*Candidate models*/
proc esm data=ESA15 outstat=ESA15_winters lead=16 plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=WINTERS;
run;

proc esm data=ESA15 lead=16 outstat=ESA15_addwinters plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=ADDWINTERS;
run;

proc esm data=ESA15 outstat=ESA15_addseasonal lead=16 plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=ADDSEASONAL;
run;

proc esm data=ESA15 lead=16 outstat=ESA15_seasonal plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=SEASONAL;
run;

/*Selected model*/
proc esm data=ESA15 lead=16 out=ESA15_forecasts outstat=ESA15_addwinters plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=ADDWINTERS;
run;


/*------ 3rd product: WW01A ------*/
data WW01A;
set PART2(where=(Product_Reference = "WW01A"));
run;

/*Simple plot*/
proc sgplot data=WW01A;
series x=date y=Sales_quantity;
run;

/*Diagnostic*/
proc timeseries data=WW01A
plot=(series corr acf pacf iacf wn decomp tc sc);
id Date interval=month;
var Sales_Quantity;
run;

/*Candidate models*/
proc esm data=WW01A outstat=WW01A_winters lead=16 plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=WINTERS;
run;

proc esm data=WW01A outstat=WW01A_seas lead=16 plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=SEASONAL;
run;

proc esm data=WW01A outstat=WW01A_addwinters lead=16 plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=ADDWINTERS;
run;

proc esm data=WW01A outstat=WW01A_addseas lead=16 plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=ADDSEASONAL;
run;

/*Selected model*/
proc esm data=WW01A lead=16 out=WW01A_forecasts outstat=WW01A_addwinters plot=forecasts;
id date interval=month;
forecast Sales_Quantity / model=ADDWINTERS;
run;
