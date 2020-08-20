libname TS "/folders/myfolders/FETS/FETS/Data";

/*------ E1 ------*/
/*plot the data*/
title "E1";
proc sgplot data=TS.E1;
series x=Date y=y;
run;
title;


/*run diagnostic plots*/
*run stationarity plot;
proc arima data=TS.E1;
identify var=y stationarity=(adf=(0 1 2));
run;

*run identification plots and methods;
proc arima data=TS.E1;
identify var=y minic scan esacf /*p=(1:4) q=(1:4)*/;
run;
/*
note that giving a range for p, q for the identification methods returns
slightly different results, which when tested perform less than our final model
*/


/*candidate models*/
proc arima data=TS.E1 plots=all;
identify var=y;
estimate q=2 method=ml; *best;
estimate q=3 method=ml;
estimate p=1 q=1 method=ml;
run;

/*forecast*/
proc arima data=TS.E1 plots=all;
identify var=y;
estimate q=2 method=ml;
forecast id=date lead=12 interval=month out=forecast_e1 id=date;
run;


/*fit of selected model (on past data)*/
proc sgplot data=forecast_e1;
series x=date y=y;
series x=date y=forecast /y2axis;
run;


/*------ E2 ------*/
/*initial plot of the data*/
title "E2";
proc sgplot data=TS.E2;
series x=date y = y;
run;
title;

/*run diagnostic plots*/
*stationarity test;
proc arima data=TS.E2;
identify var=y stationarity=(adf=(0 1 2));
run;

*identification methods;
proc arima data=TS.E2;
identify var=y esacf minic scan;
run;


/*candidate models*/
proc arima data=TS.E2 plots=all;
identify var=y;
estimate q=3 method=ml;
estimate p=2 q=1 method=ml;
estimate p=2 q=2 method=ml;
run;


/*forecast of selected model*/
proc arima data=TS.E2 plots=all;
identify var=y;
estimate p=2 q=1 method=ml;
forecast lead=12 id=date interval=month;
run;


/*------ E3 ------*/
/*initial plot of the data*/
title "E3";
proc sgplot data=TS.E3;
series x=date y = PercentUnemployed;
run;
title;

/* Ljung-Box White Noise Probability test */
proc arima data = TS.E3 plots=all;
identify var=PercentUnemployed;
run;

/*------ E4 ------*/
/*initial plot of the data*/
title "E4";
proc sgplot data=TS.E4;
series x=date y=Biscuits;
run;
title;

/*White Noise test*/
proc arima data=ts.e4;
identify var=biscuits;
run;

/*diagnostics*/
proc timeseries data=ts.e4
plot=(series corr acf pacf iacf wn decomp tc sc);
id Date interval=week;
var Biscuits;
decomp;
run;


/*Candidate models*/
/*
Perfect score - WRONG
proc esm data=TS.E4 outstat=e4sim lead=12 plot=forecasts seasonality = 12;
id date interval=week;
forecast Biscuits / model=ADDWINTERS;
run;

proc esm data=TS.E4 outstat=e4dou lead=12 plot=forecasts;
id date interval=week;
forecast Biscuits / model=SEASONAL;
run;
*/

proc esm data=TS.E4 outstat=e4sim lead=12 plot=forecasts;
id date interval=week;
forecast Biscuits / model=SIMPLE;
run;

proc esm data=TS.E4 out=e4_out outstat=e4dam lead=12 plot=forecasts;
id date interval=week;
forecast Biscuits / model=DAMPTREND;
run;

proc esm data=TS.E4 outstat=e4dou lead=12 plot=forecasts;
id date interval=week;
forecast Biscuits / model=DOUBLE;
run;

proc esm data=TS.E4 outstat=e4lin lead=12 plot=forecasts ;
id date interval=week;
forecast Biscuits / model=LINEAR;
run;
