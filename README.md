# Overview
In this respository, I investigate linear prediction applied to time series. Two different time series data sets, one called _sunspots.dat_ and the other called _speech.dat_ have been attached. These data sets are benchmark sets for evaluating prediction techniques. The _sunspots_ set essentially measures the count of the number of sunspots observed via telescope in a given year. This data set was the first set ever (in1927) to be studided using linear autoregressive models (and hence linear prediction). The _speech_ set is sampled (voiced) speech waveform data.

# Numerical Analysis
The first half of each data is set to be the _training set_, and the second half is set to be the _test set_. Using the training set, correlation function is estimated, and then I applied Levinson-Durbin algorithm to design linear predictors for orders _P_=1,2,...,20. I plotted the training set performance measure in the sum of squared prediction erros. Also, I show plots the computed sum of squared prediction error obtained by using the model (designed for the training set) in predicting the test set as a function of the prediction order. I compare the training and test set sum of squared errors. 

# Findings
## _sunspot.dat_
As expected, the mean squared error (MSE) (or sum of squared error) for test set is larger than training set. Additionally, when the model order _p_ is increasing, the MSE is likely to decrease, but the improvement as _p_ increases becomes minor. 

<img src="https://github.com/user-attachments/assets/75e1be0a-2ebc-4652-9b25-95c3fc56bc14" width="300">

## _speech.dat_
I found that speech.dat has somewhat periodic data, which yielded taking first half training data and the other ans testing data yields minor difference. Thereby, when the linear prediction is applied in the similar manner, the MSE for training set and test set is very similar for _p_=1,...,50. Additionally, as _p_ increases, the MSE is likely to converge at some point.

![com1speech_mse_compare](https://github.com/user-attachments/assets/155f7916-aa4c-45c4-aaba-ee4076a46671)
