
# DivertSovTravel Module
### November 13, 2018

This module reduces household single-occupant vehicle (SOV) travel to achieve goals that are inputs to the model. The purpose of this module is to enable users to do 'what if' analysis of the potential of light-weight vehicles (e.g. bicycles, electric bikes, electric scooters) and infrastructure to support their use to reduce SOV travel. The user inputs a goal for diverting a portion of SOV travel within a 20-mile tour distance (round trip distance). The model predicts the proportion of each household's DVMT that occurs in SOV tours having round trip distances of 20 miles or less. It then reduces SOV travel to achieve the overall goal. The reductions are allocated to households as a function of their likelihood to travel by non-automotive modes as calculated by the CalculateAltModeTrips module. The proportions of diverted DVMT are saved and used by the ApplyDvmtReductions module to calculate reductions in household DVMT due to SOV diversion and travel demand management. The module also calculates the number trips per miles of the diverted DVMT. This is used to calculate the added non-auto trips due to the diversion of SOV travel to bikes, electric bikes, scooters and other light-weight vehicles.

## Model Parameter Estimation

This module estimates a model which predicts the proportion of household travel occurring in single-occupant vehicle tours that have round trip distances of 20 miles or less. The model is estimated in 2 stages. In the first stage, models are estimated to predict the likelihood that a household had no qualifying SOV tours on the survey day, and to predict the amount of DVMT in qualifying tours if there were one or more qualifying tours on the survey day. These two models are then applied stochastically to the survey households 1000 times and the results averaged to arrive at an estimate of the average DVMT in qualifying SOV tours for each household. The average household DVMT model from the CalculateHouseholDvmt module is also run and the ratio of estimated average DVMT in qualifying SOV tours is divided by the estimated average DVMT to arrive at an estimate of the average proportion of household DVMT that is in qualifying tours. In the second step, a linear model of the log odds corresponding to the proportions is estimated. In addition, the median trip length in qualifying tours is calculated.

Two data frames from the VE2001NHTS package are used to develop these models. The Hh_df data frame includes attributes of households used as dependent variables in the models. The HhTours_df data frame is used to identify qualifying tours. The miles in qualifying tours is summed by household and added to the Hh_df data frame. The average household DVMT model from the CalculateHouseholDvmt model is run to estimate the average DVMT of each survey household. Households having incomplete data (mostly because of missing income data) and zero vehicle households are removed from the dataset resulting in 51,924 household records.

In the first stage of model development, a binomial logit model is estimated to predict the likelihood that a household had any qualifying SOV tours on the survey day. A linear model is also estimated which predicts the miles of travel in qualifying SOV tours if any. The summary statics for the estimation of the binomial logit model follows. The model accounts for a small proportion of the variability in the data, but all of the independent variables are highly significant. The number of children in the household and if the number of vehicles is less than the number of drivers increase the probability that the household had no qualifying SOV travel. The population density of the neighborhood (block group), the number of drivers, and if the household lives in a single-family dwelling decreases the probability that the household had qualifying SOV travel. These effects are sensible.

```

Call:
glm(formula = makeFormula("ZeroSov", IndepVars_), family = binomial, 
    data = TestHh_df)

Deviance Residuals: 
   Min      1Q  Median      3Q     Max  
-1.851  -1.074  -0.858   1.212   2.229  

Coefficients:
                Estimate Std. Error z value Pr(>|z|)    
(Intercept)     1.840056   0.052714  34.907  < 2e-16 ***
LogDensity     -0.160016   0.005235 -30.568  < 2e-16 ***
IsSF           -0.093948   0.023757  -3.955 7.67e-05 ***
Drivers        -0.545541   0.015255 -35.762  < 2e-16 ***
NumChild        0.134328   0.009011  14.908  < 2e-16 ***
NumVehLtNumDvr  0.486979   0.031602  15.410  < 2e-16 ***
---
Signif. codes:  0 �***� 0.001 �**� 0.01 �*� 0.05 �.� 0.1 � � 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 71339  on 51923  degrees of freedom
Residual deviance: 69122  on 51918  degrees of freedom
AIC: 69134

Number of Fisher Scoring iterations: 4

```

The summary statistics for the linear model of qualifying SOV travel if any is shown below. In this model a power transform of the qualifying SOV DVMT is the dependent variable. Power transformation is done to help linearize the relationship since the qualifying SOV DVMT is highly skewed with a long right hand tail. The power transformation is calculated to minimize skewness of the distribution. As with the previous model, this one accounts for a small portion of the observed variability but the independent variables are highly significant. The amount of qualifying SOV DVMT increases with the income of the household, the number of drivers, and the household DVMT. The amount of qualifying SOV DVMT is decreased by the density of the neighborhood, the number of children in the household, and if the number of vehicles is less than the number of drivers.

```

Call:
lm(formula = PowSovDvmt ~ LogDensity + LogIncome + Drivers + 
    NumChild + NumVehLtNumDvr + LogDvmt, data = TestHh_df)

Residuals:
     Min       1Q   Median       3Q      Max 
-2.26120 -0.50860  0.04233  0.51570  2.62267 

Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
(Intercept)     1.109701   0.067675  16.397  < 2e-16 ***
LogDensity     -0.006855   0.002864  -2.394 0.016692 *  
LogIncome       0.031088   0.008098   3.839 0.000124 ***
Drivers         0.155075   0.011835  13.103  < 2e-16 ***
NumChild       -0.080322   0.005144 -15.614  < 2e-16 ***
NumVehLtNumDvr -0.235957   0.016171 -14.591  < 2e-16 ***
LogDvmt         0.173857   0.022690   7.662 1.88e-14 ***
---
Signif. codes:  0 �***� 0.001 �**� 0.01 �*� 0.05 �.� 0.1 � � 1

Residual standard error: 0.7176 on 28842 degrees of freedom
Multiple R-squared:  0.0714,	Adjusted R-squared:  0.0712 
F-statistic: 369.6 on 6 and 28842 DF,  p-value: < 2.2e-16

```

The two models were applied jointly (using the estimation dataset) in a stochastic manner 1000 times to simulate that many travel days. In the case of the binomial logit model which predicts the likelihood of no qualifying SOV travel, the predicted probability is compared with a random draw from a uniform distribution in the range 0 to 1 to determine whether the household has any qualifying SOV travel. In the case of the linear model which predicts the amount of qualifying SOV travel, the model predictions are used to estimate the mean of a distribution where the standard deviation of the distribution that is estimated so that the standard deviation of the resulting estimates equals the standard deviation of the observed estimates. With each application of the model, a random value is drawn from a normal distribution described by the modeled mean and the estimated standard deviation. The mean qualifying SOV DVMT for each household is calculated from the results of the 1000 simulations.

The estimated average ratio of qualifying SOV DVMT to household average DVMT is calculated from the simulated results and the estimate of average DVMT calculated from applying the average DVMT model from the CalculateHouseholdDvmt module. A linear model of the estimated ratio is estimate. In this model, the dependent variable is the logit of the ratio (log of the odds ratio) keeps the predicted ratios in the range of 0 to 1 and does a better job of linearizing the relationship. The summary statistics for this model follow. The model explains almost all of the variability and all of the independent variables are highly significant. This is to be expected since the model estimates relationships derived from the two previous models.

```

Call:
lm(formula = makeFormula(EndTerms_), data = EstData_df)

Residuals:
     Min       1Q   Median       3Q      Max 
-1.34148 -0.03876  0.00357  0.04395  0.31038 

Coefficients:
                     Estimate Std. Error t value Pr(>|t|)    
(Intercept)        -0.6577413  0.0107366  -61.26   <2e-16 ***
LogDensity          0.1868316  0.0013063  143.03   <2e-16 ***
IsSF                0.0600450  0.0007995   75.10   <2e-16 ***
LogIncome           0.0373011  0.0005818   64.12   <2e-16 ***
Drivers             0.4206443  0.0008942  470.43   <2e-16 ***
NumChild           -0.1616617  0.0003719 -434.69   <2e-16 ***
NumVehLtNumDvr     -0.5118391  0.0011441 -447.39   <2e-16 ***
LogDvmt            -0.7224906  0.0033026 -218.76   <2e-16 ***
LogDensity:LogDvmt -0.0276046  0.0003220  -85.72   <2e-16 ***
---
Signif. codes:  0 �***� 0.001 �**� 0.01 �*� 0.05 �.� 0.1 � � 1

Residual standard error: 0.06775 on 51915 degrees of freedom
Multiple R-squared:  0.9789,	Adjusted R-squared:  0.9789 
F-statistic: 3.015e+05 on 8 and 51915 DF,  p-value: < 2.2e-16

```

The signs of the coefficients are sensible. The ratio of the average qualifying SOV DVMT of the household to the average DVMT of the household increases with:

* Income - because higher income enables more discretionary travel and freedom to travel alone;

* Drivers - because having more drivers increases the probability of solo travel and decreases the need to travel as a passenger;

* Density - because higher density neighborhoods have more activity in close proximity and decrease the need for trip linking of multiple household members; and,

* Single-family dwelling - because living in a single-family dwelling makes it easier to make spur-of-the-moment SOV trips because the vehicle is more accessible and there are usually no worries about finding a good parking space when arriving back home.

The ratio of qualifying SOV DVMT decreases with increasing:

* Number of children - because younger children often need to be taken along to shuttle them to activities or to maintain supervision while running errands;

* Number of vehicles is less than the number of drivers - because when not each driver has a car available it is more likely that they will need to travel together; and,

* Household DVMT - because travel to work establishes a base level of vehicle travel and typically has lower vehicle occupancy than travel for other purposes. Travel beyond work travel is therefore less likely to be SOV travel than work travel and therefore will reduce the SOV DVMT ratio.

Finally, the module calculates the median trip length for SOV tours of 20 miles of less in length from the household tour data. The distribution of trip lengths is shown in the following figure.

![sov_trip_length_dist.png](sov_trip_length_dist.png)

The inverse of the median trip length, miles per trip, is saved for use in calculating the increase in bike trips due to the diversion of SOV trips.

## How the Module Works

This function calculates the proportional reduction in the DVMT of individual households to meet the user-supplied goal for diverting a proportion of travel in SOV tours 20 miles or less in length to bikes, electric bikes, scooters or other similar modes. The user supplies the diversion goal for each Azone and model year. The following procedural steps are followed to complete the calculation:

* The SOV proportions model described is applied to calculate the proportion of the DVMT of each household that is in qualifying SOV tours (i.e. having lengths of 20 miles or less);

* The total diversion of DVMT in qualifying SOV tours for the Azone is calculated by:

  * Calculating the qualifying SOV tour DVMT of each household by multiplying the modeled proportion of DVMT in qualifying tours by the household DVMT;

  * Summing the qualifying SOV tour DVMT of households in the Azone and multiplying by the diversion goal for the Azone;

* The total DVMT diverted is allocated to households in the Azone as a function of their relative amounts of qualifying SOV travel and alternative modes tripmaking. This is implemented in the following steps:

  * A utility function is defined as follows:

     `U = log(SovDvmt / mean(SovDvmt)) + B * log(AltTrips / mean(AltTrips))`

     Where:

     `SovDvmt` and `mean(SovDvmt)` are the household's qualifying SOV DVMT and the population mean respectively,

     `AltTrips` and `mean(AltTrips)` are the number of the household's alternative mode trips and the population mean respectively, and

     `B` is a parameter that is estimated to keep the maximum proportion of SOV diversion for all households within bounds as explained below.

  * The proportion of total diverted DVMT allocated to each household is `exp(U) / sum(exp(U))` where `exp(U)` is the exponentiated value of the utility for the household and `sum(exp(U))` is the sum of the exponentiated values for all households.

  * The value of `B` is solved such that the maximum proportional diversion for any household is midway between the objective of the Azone and 1. For example, Azone objective is 0.2, the maximum diversion would be 0.6. The value is solved iteratively using a binary search algorithm.

* The DVMT diversion allocated to each household is divided by the average DVMT of each household to calculate the proportion of household DVMT that is diverted. This is the output of the module that gets saved to the datastore.


## User Inputs
The following table(s) document each input file that must be provided in order for the module to run correctly. User input files are comma-separated valued (csv) formatted text files. Each row in the table(s) describes a field (column) in the input file. The table names and their meanings are as follows:

NAME - The field (column) name in the input file. Note that if the 'TYPE' is 'currency' the field name must be followed by a period and the year that the currency is denominated in. For example if the NAME is 'HHIncomePC' (household per capita income) and the input values are in 2010 dollars, the field name in the file must be 'HHIncomePC.2010'. The framework uses the embedded date information to convert the currency into base year currency amounts. The user may also embed a magnitude indicator if inputs are in thousand, millions, etc. The VisionEval model system design and users guide should be consulted on how to do that.

TYPE - The data type. The framework uses the type to check units and inputs. The user can generally ignore this, but it is important to know whether the 'TYPE' is 'currency'

UNITS - The units that input values need to represent. Some data types have defined units that are represented as abbreviations or combinations of abbreviations. For example 'MI/HR' means miles per hour. Many of these abbreviations are self evident, but the VisionEval model system design and users guide should be consulted.

PROHIBIT - Values that are prohibited. Values may not meet any of the listed conditions.

ISELEMENTOF - Categorical values that are permitted. Value must be one of the listed values.

UNLIKELY - Values that are unlikely. Values that meet any of the listed conditions are permitted but a warning message will be given when the input data are processed.

DESCRIPTION - A description of the data.

### azone_prop_sov_dvmt_diverted.csv
|NAME                |TYPE   |UNITS      |PROHIBIT     |ISELEMENTOF |UNLIKELY |DESCRIPTION                                                                                                                                                                            |
|:-------------------|:------|:----------|:------------|:-----------|:--------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|Geo                 |       |           |             |Azones      |         |Must contain a record for each Azone and model run year.                                                                                                                               |
|Year                |       |           |             |            |         |Must contain a record for each Azone and model run year.                                                                                                                               |
|PropSovDvmtDiverted |double |Proportion |NA, < 0, > 1 |            |         |Goals for the proportion of household DVMT in single occupant vehicle tours with round-trip distances of 20 miles or less be diverted to bicycling or other slow speed modes of travel |

## Datasets Used by the Module
The following table documents each dataset that is retrieved from the datastore and used by the module. Each row in the table describes a dataset. All the datasets must be present in the datastore. One or more of these datasets may be entered into the datastore from the user input files. The table names and their meanings are as follows:

NAME - The dataset name.

TABLE - The table in the datastore that the data is retrieved from.

GROUP - The group in the datastore where the table is located. Note that the datastore has a group named 'Global' and groups for every model run year. For example, if the model run years are 2010 and 2050, then the datastore will have a group named '2010' and a group named '2050'. If the value for 'GROUP' is 'Year', then the dataset will exist in each model run year group. If the value for 'GROUP' is 'BaseYear' then the dataset will only exist in the base year group (e.g. '2010'). If the value for 'GROUP' is 'Global' then the dataset will only exist in the 'Global' group.

TYPE - The data type. The framework uses the type to check units and inputs. Refer to the model system design and users guide for information on allowed types.

UNITS - The units that input values need to represent. Some data types have defined units that are represented as abbreviations or combinations of abbreviations. For example 'MI/HR' means miles per hour. Many of these abbreviations are self evident, but the VisionEval model system design and users guide should be consulted.

PROHIBIT - Values that are prohibited. Values in the datastore do not meet any of the listed conditions.

ISELEMENTOF - Categorical values that are permitted. Values in the datastore are one or more of the listed values.

|NAME                |TABLE     |GROUP |TYPE      |UNITS      |PROHIBIT     |ISELEMENTOF |
|:-------------------|:---------|:-----|:---------|:----------|:------------|:-----------|
|Azone               |Azone     |Year  |character |ID         |             |            |
|PropSovDvmtDiverted |Azone     |Year  |double    |Proportion |NA, < 0, > 1 |            |
|Bzone               |Bzone     |Year  |character |ID         |             |            |
|D1B                 |Bzone     |Year  |compound  |PRSN/SQMI  |NA, < 0      |            |
|Azone               |Household |Year  |character |ID         |             |            |
|Bzone               |Household |Year  |character |ID         |             |            |
|Dvmt                |Household |Year  |compound  |MI/DAY     |NA, < 0      |            |
|Vehicles            |Household |Year  |vehicles  |VEH        |NA, < 0      |            |
|Age0to14            |Household |Year  |people    |PRSN       |NA, < 0      |            |
|Age15to19           |Household |Year  |people    |PRSN       |NA, < 0      |            |
|Drivers             |Household |Year  |people    |PRSN       |NA, < 0      |            |
|Income              |Household |Year  |currency  |USD.2001   |NA, < 0      |            |
|HouseType           |Household |Year  |character |category   |             |SF, MF, GQ  |
|BikeTrips           |Household |Year  |compound  |TRIP/DAY   |NA, < 0      |            |
|WalkTrips           |Household |Year  |compound  |TRIP/DAY   |NA, < 0      |            |
|TransitTrips        |Household |Year  |compound  |TRIP/DAY   |NA, < 0      |            |

## Datasets Produced by the Module
The following table documents each dataset that is retrieved from the datastore and used by the module. Each row in the table describes a dataset. All the datasets must be present in the datastore. One or more of these datasets may be entered into the datastore from the user input files. The table names and their meanings are as follows:

NAME - The dataset name.

TABLE - The table in the datastore that the data is retrieved from.

GROUP - The group in the datastore where the table is located. Note that the datastore has a group named 'Global' and groups for every model run year. For example, if the model run years are 2010 and 2050, then the datastore will have a group named '2010' and a group named '2050'. If the value for 'GROUP' is 'Year', then the dataset will exist in each model run year. If the value for 'GROUP' is 'BaseYear' then the dataset will only exist in the base year group (e.g. '2010'). If the value for 'GROUP' is 'Global' then the dataset will only exist in the 'Global' group.

TYPE - The data type. The framework uses the type to check units and inputs. Refer to the model system design and users guide for information on allowed types.

UNITS - The units that input values need to represent. Some data types have defined units that are represented as abbreviations or combinations of abbreviations. For example 'MI/HR' means miles per hour. Many of these abbreviations are self evident, but the VisionEval model system design and users guide should be consulted.

PROHIBIT - Values that are prohibited. Values in the datastore do not meet any of the listed conditions.

ISELEMENTOF - Categorical values that are permitted. Values in the datastore are one or more of the listed values.

DESCRIPTION - A description of the data.

|NAME             |TABLE     |GROUP |TYPE   |UNITS      |PROHIBIT     |ISELEMENTOF |DESCRIPTION                                                                                           |
|:----------------|:---------|:-----|:------|:----------|:------------|:-----------|:-----------------------------------------------------------------------------------------------------|
|PropDvmtDiverted |Household |Year  |double |proportion |NA, < 0, > 1 |            |Proportion of household DVMT diverted to bicycling, electric bikes, or other 'low-speed' travel modes |