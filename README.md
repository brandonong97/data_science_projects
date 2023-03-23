# Brandon's Portfolio

## Project 1 Overview: Comparing different machine learning tools to find the best model for predicting HDB prices
### In this example, we will see how linear regression performs before and after regularisation. We will also look at decision trees and random forest in predicting HDB prices. We will be using cross validation where our scoring will be negative root mean square error to find the best performing model on our training data. In this data, we will use dummy variables for our categorical features.

#### Linear Regression model performance
![](https://github.com/brandonong97/data_science_projects/blob/main/png_ref/lr_score.png)

#### Linear Regression with Ridge model performance
![](https://github.com/brandonong97/data_science_projects/blob/main/png_ref/lr_ridge_score.png)

#### Linear Regression with Lasso model performance
![](https://github.com/brandonong97/data_science_projects/blob/main/png_ref/lr_lasso_score.png)

#### Decision Tree model performance
![](https://github.com/brandonong97/data_science_projects/blob/main/png_ref/dt_score.png)

#### Random Forest model
![](https://github.com/brandonong97/data_science_projects/blob/main/png_ref/rf_score.png)

#### Best model features
![](https://github.com/brandonong97/data_science_projects/blob/main/png_ref/lr_ridge_coef.png)



## Project 2 Overview: 
### In this example, we will be looking at a typical warehousing where we will analyse how fresh supplies are delivered from warehouse to various chains. Our target will be to minimise cost while our constraints variables ar demand and supply where supply must be more than or equal to demand. This optimisation task will be using Gurobi. Our model will also be adding a uncertainty factor where demand follows a normal distribution.

#### Optimisation model under demand uncertainty
![](https://github.com/brandonong97/data_science_projects/blob/main/png_ref/optimisation_problem.png)

#### Vehicle route from supplier to restaurant
![](https://github.com/brandonong97/data_science_projects/blob/main/png_ref/vehicle_routing_scenario.png)


## Project 3 Overview: 
### In this example, we will be performing A/B testing on 2 hypothetical webpages to see which webpage can keep visitors staying longer on the site. We will be using 22 subjects for this experiment where half will test the first website while the other half will use the other website

#### Null hypothesis
![](https://github.com/brandonong97/data_science_projects/blob/main/png_ref/null_hypothesis.png)

#### T test
![](https://github.com/brandonong97/data_science_projects/blob/main/png_ref/t_test.png)

#### T test distribution
![](https://github.com/brandonong97/data_science_projects/blob/main/png_ref/t_test_dist.png)

#### Bernoulli trial
![](https://github.com/brandonong97/data_science_projects/blob/main/png_ref/bernoulli.png)
