Chicago Food Inspections App
========================================================
author: John E Sukup III
date: 6/21/2015
width: 1440
height: 900

Project Impetus
========================================================

- Chicago restaurants are under constant scrutiny for adhering to strick health codes
- City inspectors need a tool to easily allow visualization of restaurants by risk level, gepgraphically
- Chicago Food Inspections App allows for easily viewing this data in one compact package

Summary of Data Set
========================================================
Information describing underlying data set

```r
load(file = "data.RData")
summary(data)
```

```
   dba.name            latitude       longitude     
 Length:67040       Min.   :41.64   Min.   :-87.91  
 Class :character   1st Qu.:41.85   1st Qu.:-87.70  
 Mode  :character   Median :41.89   Median :-87.66  
                    Mean   :41.89   Mean   :-87.68  
                    3rd Qu.:41.94   3rd Qu.:-87.63  
                    Max.   :42.02   Max.   :-87.53  
              risk            zip       
 Risk 1 (High)  :52087   Min.   :60601  
 Risk 2 (Medium):14139   1st Qu.:60613  
 Risk 3 (Low)   :  814   Median :60625  
                         Mean   :60629  
                         3rd Qu.:60643  
                         Max.   :60827  
```

Use
========================================================
1.  Users select a City of Chicago Zip Code from the drom down menu
2.  Map updates to show restaurants in that area and their Risk Level according to the City of Chicago
    (more on data set can be found at [here](https://data.cityofchicago.org/api/assets/BAD5301B-681A-4202-9D25-51B2CAE672FF))
3.  Markets can be clicked on to see restaurant name
4.  Color of marker indicates level of risk associated with restaurant (see legend)
5.  You can soom in using the "+/-" togggle on the upper left or by using your scroll wheel to get a closer view when markers overlap

Limitations
===
1.  Some latitude/longitude combinations for different restaurants are the same in the data set. This allows two or more locations to overlap and markers to "blend" colors.
2.  Some locations have multiple entries with different risk scores. This allows for overlap and markers to "blend" colors.
3.  Locations with multiple entires can have all their entires in the underlying data set accessed when clicked.
