# Forecasting-demand-for-EV-charger
A group project awarded excellence prize in Public Data Competition 2022, Incheon
## packages

	require(geosphere)
	require(dplyr)
	require(tbart)
	require(sp)
	
Be careful when you use select function in dplyr. There is another select function in MASS package. So I write down as below to make it clear which the package use.

	pca=final %>% dplyr::select(evnum, building,  house, ave_traffic, tourist)
	


## files

	final=read.csv("/final_col_english_noname.csv")
	key=read.csv("/final_col_english_divisiononly.csv")

Here are the whole variable we gathered together.
* data features
**each row is parking lot. every parking lot is under specific "Gu" division**  
lat: latitude of parking lot  
lng: longtitude of parking lot  
    * continuous variable			
        * house : number of households by "Gu" division(minmax scaled)
        * evnum : number of electric cars by "Gu" division(minmax scaled)
        * building : number of living facilities within 500m from parking lot (minmax scaled)
        * charger : number of electric car chargers within 500m from parking lot(minmax scaled, reciprocal, if 0, then tranformed to 10 and then take reciprocal)
        * pop : population by "Gu" division(minmax scaled)
        * pop_density : pop data divided by area og "Gu" division(minmax scaled)
        * ave_traffic : average traffic amount within 500m from parking lot(minmax scaled)
        * toursit : number of visitiors of major tourist destination by "Gu" division(from 2018~2021,total sum)
    * dummy variable
        * type of parking lot(loc_typ1, loc_typ2): Korean parking lots are classified in 3 groups, which are "Nosang", "Nowae". If the parking lot is located roadside, its type is "Nosang". If the parking lot is located in specific area rather than district, its type is "Nowae". <br> loc_typ1 is filled if "Nosang". loc_typ2 is filled if "Nowae". 
        * 5-days no driving system : if the parking lot has '5-days no driving system', five_days is filled with 1. otherwise, no_five_days is filled with 1. 
        * available on weekends and holidays : if the parking lot is available on weekends, weekends is filled with 1. otherwise, no_weekends is filled with 1. 
        * cost : free vs no_free
				
## Variable selection
We concluded that dummy variables cannot carry important insight for our project. <br>  
Actually, it is hard to relate any dummy variable with demand for EV Charger. Since our project has no Y variable, in other words, unsupervised learning, we paid great attention to justify our idea.   
There are 3 populational variables(=[house, pop, pop_density]). Among the three, We agreed that house represent the demand for EV Charger the most.   
After cutting off dummy variables and populational variables, there are 6 variables left.   
   
### PCA  
I used PCA to select the variables. charger variable is directly related to the demand for the EV charger, so I made PCA analysis using 5 variables(=[evnum, house, tourist, traffic, building])
    

## P-median modeling
### About algorithm
[click here to see the structure of algorithm](https://raw.githubusercontent.com/ralaruri/p_median_python/master/formula.png) 
#### Example of 1-median problem
 
### p-median in R
P-median algorithm can be implemented with packages 'tbart' and 'sp'.  
you have to change the DataFrame into Spatial*DataFrame to apply allocations() function.
	
	coordinates(dtframe)<- ~lng+lat #changing to Spatial*DataFrame
	
I used Eucladian distance to major the distance between each parking lots. 

	eucdist=euc.dists(dtframe, dtframe)
	
### generating a function

	pmedian=function(num, ev.num, pop, building, ev.location, dtframe, dt_name)
	




