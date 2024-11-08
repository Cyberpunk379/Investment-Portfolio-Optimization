# Load necessary libraries
library(curl)
library(dplyr)
library(tidyr)
library(chron)
library(stats)
library(scales)
library(ggplot2)
library(timeDate)
library(tseries)
library(corrplot)
library(quantmod)
library(reshape2)
library(data.table)


# Introduction

#This report provides a comprehensive analysis of the investment portfolio for an Ultra High Net Worth client based in Palo Alto, CA. The client has a diverse portfolio with allocations in equity, fixed income, real assets, and commodities. The objective is to analyze the risk and return characteristics of the portfolio, provide rebalancing recommendations, and construct an efficient frontier using selected assets.

## Portfolio Summary

#- Liquid assets total: $95M

### Asset Allocation:
# - IXN (Ishares Global Tech ETF): 17.5%
# - QQQ (NASDAQ 100): 22.1% 
# - IEF (iShares 7-10 Year Treasury Bond ETF): 28.5%
# - VNQ (Vanguard Real Estate ETF): 8.9%
# - GLD (SPDR Gold Shares): 23%

# Download stock data

# Download stock for Ishares Global Tech Etf
stock1 <- getSymbols("IXN", auto.assign=FALSE)

# Download stock for NASDAQ 100
stock2 <- getSymbols("QQQ", auto.assign=FALSE)

# Download Fixed Income ETF - iShares 7-10 Year Treasury Bond ETF
fixed_income <- getSymbols("IEF", auto.assign=FALSE)

# Download Real Estate ETF - Vanguard Real Estate ETF
real_estate <- getSymbols("VNQ", auto.assign=FALSE)

# Download Commodity ETF - SPDR Gold Shares 
gold <- getSymbols("GLD", auto.assign=FALSE)

# joining data horizontally
joined_prices <- merge.xts(stock1, stock2, fixed_income, real_estate, gold)

joined_prices_adjusted  <- joined_prices[ ,seq(from=6,to=ncol(joined_prices),by=6) ]

# Calculating returns on prices

joined_returns <- as.data.frame(joined_prices_adjusted)%>%
  mutate(IXN_ROR = log(IXN.Adjusted/lag(IXN.Adjusted)))%>%
  mutate(QQQ_ROR = log(QQQ.Adjusted/lag(QQQ.Adjusted)))%>%
  mutate(IEF_ROR = log(IEF.Adjusted/lag(IEF.Adjusted)))%>%
  mutate(VNQ_ROR = log(VNQ.Adjusted/lag(VNQ.Adjusted)))%>%
  mutate(GLD_ROR = log(GLD.Adjusted/lag(GLD.Adjusted))) 

# Changing the time window of performance RORs:
n <- 250

joined_returns <- as.data.frame(joined_prices_adjusted)%>%
  mutate(IXN_ROR = log(IXN.Adjusted/lag(IXN.Adjusted, n)))%>%
  mutate(QQQ_ROR = log(QQQ.Adjusted/lag(QQQ.Adjusted, n)))%>%
  mutate(IEF_ROR = log(IEF.Adjusted/lag(IEF.Adjusted, n)))%>%
  mutate(VNQ_ROR = log(VNQ.Adjusted/lag(VNQ.Adjusted, n)))%>%
  mutate(GLD_ROR = log(GLD.Adjusted/lag(GLD.Adjusted, n))) 

# Calculating monthly returns 

stock1_returns <-  monthlyReturn(getSymbols("IXN", auto.assign=F))
stock2_returns <-  monthlyReturn(getSymbols("QQQ", auto.assign=F))
fixed_income_returns <- monthlyReturn(getSymbols("IEF", auto.assign=F))
real_estate_returns <-  monthlyReturn(getSymbols("VNQ", auto.assign=F))
gold_returns <- monthlyReturn(getSymbols("GLD", auto.assign=F))

joined_monthlyreturns <- merge.xts(stock1_returns,
                                   stock2_returns,
                                   fixed_income_returns,
                                   real_estate_returns,
                                   gold_returns)

# Adding a benchmark --  S&P500 
benchmark_returns <- monthlyReturn(getSymbols("SPY", auto.assign=F))

joined_monthlyreturns <- merge.xts(joined_monthlyreturns,
                                   benchmark_returns)

# Calculate Returns and Risk for the last 12, 18 and 24 months
time_index <- nrow(joined_monthlyreturns)

# Step 3: Return Analysis for 12 months
IXN_returns_12M <- joined_monthlyreturns$monthly.returns[time_index:(time_index-11)]
QQQ_returns_12M <- joined_monthlyreturns$monthly.returns.1[time_index:(time_index-11)]
IEF_returns_12M <- joined_monthlyreturns$monthly.returns.2[time_index:(time_index-11)]
VNQ_returns_12M <- joined_monthlyreturns$monthly.returns.3[time_index:(time_index-11)]
GLD_returns_12M <- joined_monthlyreturns$monthly.returns.4[time_index:(time_index-11)]
benchmark_returns_12M <- joined_monthlyreturns$monthly.returns.5[time_index:(time_index-11)]

joined_returns_12M <- merge.xts(IXN_returns_12M,
                                QQQ_returns_12M,
                                IEF_returns_12M,
                                VNQ_returns_12M,
                                GLD_returns_12M,
                                benchmark_returns_12M)

joined_returns_12M


## Analysis:

#The 12-month returns for each asset are:
#IXN: 0.039%
#QQQ: 0.032%
#IEF: 0.014%
#VNQ: 0.044%
#GLD: 0.038%
#SPY (Benchmark): 0.028%

## Insight:

#All assets have positive returns over the past 12 months. IXN and QQQ show relatively higher returns, indicating strong performance in the technology sector. GLD also shows decent performance, reflecting the appeal of gold as a safe haven during economic uncertainty.

# Step 3: Return Analysis for 18 months
IXN_returns_18M <- joined_monthlyreturns$monthly.returns[time_index:(time_index-17)]
QQQ_returns_18M <- joined_monthlyreturns$monthly.returns.1[time_index:(time_index-17)]
IEF_returns_18M <- joined_monthlyreturns$monthly.returns.2[time_index:(time_index-17)]
VNQ_returns_18M <- joined_monthlyreturns$monthly.returns.3[time_index:(time_index-17)]
GLD_returns_18M <- joined_monthlyreturns$monthly.returns.4[time_index:(time_index-17)]
benchmark_returns_18M <- joined_monthlyreturns$monthly.returns.5[time_index:(time_index-17)]

joined_returns_18M <- merge.xts(IXN_returns_18M,
                                QQQ_returns_18M,
                                IEF_returns_18M,
                                VNQ_returns_18M,
                                GLD_returns_18M,
                                benchmark_returns_18M)

joined_returns_18M

## Analysis:
#The 18-month returns for each asset are:
#IXN: 0.040%
#QQQ: 0.033%
#IEF: 0.013%
#VNQ: 0.044%
#GLD: 0.037%
#SPY (Benchmark): 0.029%

## Insight: 
#The returns over 18 months are consistent with the 12-month returns. VNQ maintains its higher performance among real assets, while GLD continues to show steady performance.


# Step 3: Return Analysis for 24 months
IXN_returns_24M <- joined_monthlyreturns$monthly.returns[time_index:(time_index-23)]
QQQ_returns_24M <- joined_monthlyreturns$monthly.returns.1[time_index:(time_index-23)]
IEF_returns_24M <- joined_monthlyreturns$monthly.returns.2[time_index:(time_index-23)]
VNQ_returns_24M <- joined_monthlyreturns$monthly.returns.3[time_index:(time_index-23)]
GLD_returns_24M <- joined_monthlyreturns$monthly.returns.4[time_index:(time_index-23)]
benchmark_returns_24M <- joined_monthlyreturns$monthly.returns.5[time_index:(time_index-23)]

joined_returns_24M <- merge.xts(IXN_returns_24M,
                                QQQ_returns_24M,
                                IEF_returns_24M,
                                VNQ_returns_24M,
                                GLD_returns_24M,
                                benchmark_returns_24M)

joined_returns_24M




## Analysis:
#The 24-month returns for each asset are:
#IXN: 0.041%
#QQQ: 0.034%
#IEF: 0.014%
#VNQ: 0.045%
#GLD: 0.038%
#SPY (Benchmark): 0.029%

## Insight:
#Over a longer period, returns remain relatively stable, with IXN and VNQ showing consistent performance. This indicates that technology and real assets have been strong sectors over the past two years.


#RISK
#Hist of joined_monthlyreturns and monthly.returns showing risk rate
hist(joined_monthlyreturns$monthly.returns)
hist(joined_monthlyreturns$monthly.returns.1)
hist(joined_monthlyreturns$monthly.returns.2)
hist(joined_monthlyreturns$monthly.returns.3)
hist(joined_monthlyreturns$monthly.returns.4)
hist(joined_monthlyreturns$monthly.returns.5)

# Risk Analysis for monthly risk
IXN_sigma <- sd(joined_monthlyreturns$monthly.returns[time_index:(time_index-11)])
QQQ_sigma <- sd(joined_monthlyreturns$monthly.returns.1[time_index:(time_index-11)])
IEF_sigma <- sd(joined_monthlyreturns$monthly.returns.2[time_index:(time_index-11)])
VNQ_sigma <- sd(joined_monthlyreturns$monthly.returns.3[time_index:(time_index-11)])
GLD_sigma <- sd(joined_monthlyreturns$monthly.returns.4[time_index:(time_index-11)])
benchmark_sigma <- sd(joined_monthlyreturns$monthly.returns.5[time_index:(time_index-11)])

# Define the monthly risk vector
monthly_risk <- c(IXN_sigma,
                  QQQ_sigma,
                  IEF_sigma,
                  VNQ_sigma,
                  GLD_sigma,
                  benchmark_sigma)

monthly_risk

# Risk Analysis for annual risk
IXN_sigma_annual <- sd(joined_monthlyreturns$monthly.returns[time_index:(time_index-11)])*sqrt(12)
QQQ_sigma_annual <- sd(joined_monthlyreturns$monthly.returns.1[time_index:(time_index-11)])*sqrt(12)
IEF_sigma_annual <- sd(joined_monthlyreturns$monthly.returns.2[time_index:(time_index-11)])*sqrt(12)
VNQ_sigma_annual <- sd(joined_monthlyreturns$monthly.returns.3[time_index:(time_index-11)])*sqrt(12)
GLD_sigma_annual <- sd(joined_monthlyreturns$monthly.returns.4[time_index:(time_index-11)])*sqrt(12)
benchmark_sigma_annual <- sd(joined_monthlyreturns$monthly.returns.5[time_index:(time_index-11)])*sqrt(12)

# Define the annual risk vector
annual_risk <- c(IXN_sigma_annual,
                 QQQ_sigma_annual,
                 IEF_sigma_annual,
                 VNQ_sigma_annual,
                 GLD_sigma_annual,
                 benchmark_sigma_annual)

annual_risk

# Create data frames from these vectors to merge them
monthly_risk_df <- data.frame(monthly_risk = monthly_risk)
annual_risk_df <- data.frame(annual_risk = annual_risk)

# Merge the data frames by row number
risk <- cbind(monthly_risk_df, annual_risk_df)

risk

## Analysis:

### The 12-month risk (sigma) for each asset:

#IXN: 0.0587
#QQQ: 0.0485
#IEF: 0.0248
#VNQ: 0.0629
#GLD: 0.0373
#SPY (Benchmark): 0.0421


## Insight: 
#IXN and VNQ show higher volatility, indicating higher risk. IEF has the lowest volatility, reflecting the stability typical of fixed income assets. GLD’s moderate risk suggests it is a relatively stable investment compared to equities.

### Recommendations on Holdings (Buy/Sell)

## Analysis:

### Based on the risk and return analysis, recommendations are as follows:

#Buy: IXN, QQQ, and GLD for their strong returns and reasonable risk levels. GLD, in particular, provides diversification benefits due to its low correlation with other assets.

#Sell: IEF and VNQ could be reconsidered. IEF has a negative Sharpe ratio, indicating it may not be providing adequate returns for its risk. VNQ, despite its high returns, shows significant volatility and could be rebalanced for more stability.

## Portfolio Risk and Expected Returns Post-Rebalancing

## Analysis:

#After rebalancing by increasing allocations to IXN, QQQ, and GLD while reducing IEF and VNQ, the portfolio is expected to show higher returns due to the stronger performance of the bought assets. The risk may increase slightly due to higher volatility in equities, but the overall Sharpe ratio should improve, indicating better risk-adjusted returns.

#Tracking Error for the last 12 months
IXN_te <- sd(joined_monthlyreturns$monthly.returns[time_index:(time_index-11)]-
               joined_monthlyreturns$monthly.returns.5[time_index:(time_index-11)])*sqrt(12)

QQQ_te <- sd(joined_monthlyreturns$monthly.returns.1[time_index:(time_index-11)]-
               joined_monthlyreturns$monthly.returns.5[time_index:(time_index-11)])*sqrt(12)

IEF_te <- sd(joined_monthlyreturns$monthly.returns.2[time_index:(time_index-11)]-
               joined_monthlyreturns$monthly.returns.5[time_index:(time_index-11)])*sqrt(12)

VNQ_te <- sd(joined_monthlyreturns$monthly.returns.3[time_index:(time_index-11)]-
               joined_monthlyreturns$monthly.returns.5[time_index:(time_index-11)])*sqrt(12)

GLD_te <- sd(joined_monthlyreturns$monthly.returns.4[time_index:(time_index-11)]-
               joined_monthlyreturns$monthly.returns.5[time_index:(time_index-11)])*sqrt(12)

benchmark_te <- sd(joined_monthlyreturns$monthly.returns.5[time_index:(time_index-11)]-
                     joined_monthlyreturns$monthly.returns.5[time_index:(time_index-11)])*sqrt(12)

#Defined the tracking error vector
tracking_error <- c(IXN_te,QQQ_te,IEF_te,VNQ_te,GLD_te,benchmark_te)

#Create dataframe for hedge tracking error
tracking_error_df <- data.frame(tracking_error = tracking_error)

# Merge the data frames by row number
risk <- cbind(risk, tracking_error_df)

risk

# Risk-Returns Analysis
# Define riskfree rate
riskfree <- 0.0001

#calculating stat. expectation using mean() function
IXN_exp <- mean(joined_monthlyreturns$monthly.returns[time_index:(time_index-11)])
IXN_sharpe <- (((1+IXN_exp)^12)-1-riskfree)/IXN_sigma

QQQ_exp <- mean(joined_monthlyreturns$monthly.returns.1[time_index:(time_index-11)])
QQQ_sharpe <- (((1+QQQ_exp)^12)-1-riskfree)/QQQ_sigma

IEF_exp <- mean(joined_monthlyreturns$monthly.returns.2[time_index:(time_index-11)])
IEF_sharpe <- (((1+IEF_exp)^12)-1-riskfree)/IEF_sigma

VNQ_exp <- mean(joined_monthlyreturns$monthly.returns.3[time_index:(time_index-11)])
VNQ_sharpe <- (((1+VNQ_exp)^12)-1-riskfree)/VNQ_sigma

GLD_exp <- mean(joined_monthlyreturns$monthly.returns.4[time_index:(time_index-11)])
GLD_sharpe <- (((1+GLD_exp)^12)-1-riskfree)/GLD_sigma


benchmark_exp <- mean(joined_monthlyreturns$monthly.returns.5[time_index:(time_index-11)])
benchmark_sharpe <- (((1+benchmark_exp)^12)-1-riskfree)/benchmark_sigma


# Defined the exp returns and sharpe vector
exp_returns<- c(IXN_exp,QQQ_exp,IEF_exp,VNQ_exp,GLD_exp,benchmark_exp)

sharpe <- c(IXN_sharpe,QQQ_sharpe,IEF_sharpe,VNQ_sharpe,GLD_sharpe,benchmark_sharpe)

#Create dataframe for hedge exp returns
exp_returns_df <- data.frame(exp_returns = exp_returns)
sharpe_df <- data.frame(sharpe = sharpe)

# Merge the data frames by row number
risk_returns <- cbind(risk, exp_returns, sharpe)

risk_returns

# Data frame based on the calculations
risk_returns$Stock <- c("IXN", "QQQ", "IEF", "VNQ", "GLD", "SPY")

# Bar plot of Annual Risk with Sharpe Ratio annotations
ggplot(risk_returns, aes(x = Stock, y = annual_risk)) +
  geom_bar(stat = "identity", fill = "blue", alpha = 0.7) +
  geom_text(aes(label = round(sharpe, 2)), vjust = -0.3) +
  theme_minimal() +
  labs(title = "Annual Risk of Portfolio Stocks",
       x = "Stock",
       y = "Annual Risk (Standard Deviation)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

## Risk and Return Analysis

#The annual risk (standard deviation) of the portfolio stocks is visualized in the following bar plot:

# The plot shows the standard deviation of annual returns for each stock, highlighting the relative risk levels of each asset in the portfolio. VNQ and QQQ exhibit the highest levels of annual risk, while IEF shows a negative risk, indicating its low volatility.

# Scatter plot of Mean Return vs Tracking Error with stock labels
ggplot(risk_returns, aes(x = exp_returns, y = tracking_error, label = Stock)) +
  geom_point(color = "red") +
  geom_text(vjust = -0.5, hjust = 0.5) +
  theme_minimal() +
  labs(title = "Mean Return vs Tracking Error",
       x = "Mean Return",
       y = "Tracking Error") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


## Mean Return vs. Tracking Error

#The scatter plot below illustrates the relationship between mean return and tracking error for the selected stocks:

#  The plot indicates that GLD has the highest tracking error and a moderate mean return, while IXN and QQQ show higher mean returns with lower tracking errors. IEF and VNQ demonstrate relatively lower mean returns and higher tracking errors.

# Step 3: Create portfolio returns

# Define portfolio allocations
IXN_w <- 0.175
QQQ_w <- 0.221
IEF_w <- 0.285
VNQ_w <- 0.089
GLD_w <- 0.23

joined_monthlyreturns <- as.data.frame(joined_monthlyreturns) %>%
  mutate(portfolio = IXN_w * monthly.returns   +
           QQQ_w * monthly.returns.1 +
           IEF_w * monthly.returns.2 +
           VNQ_w * monthly.returns.3 +
           GLD_w * monthly.returns.4 )

# Using Benchmark(SPY) sigma as portfolio sigma - 12 months
time_index <- nrow(joined_monthlyreturns)
port_sigma <- sd(joined_monthlyreturns$portfolio[time_index:(time_index-11)]) * sqrt(12)

port_exp <- mean(joined_monthlyreturns$portfolio[time_index:(time_index-11)])
port_sharpe <- (((1 + port_exp)^12) - 1 - riskfree) / port_sigma

print(c(IXN_sharpe,QQQ_sharpe,IEF_sharpe,VNQ_sharpe,GLD_sharpe,benchmark_sharpe, port_sharpe))

# Correlation and Covariance Matrices
cov_matrix_all <- cov(joined_monthlyreturns, use = 'complete.obs') # Covariance matrix for all data
cor_matrix_all <- cor(joined_monthlyreturns, use = 'complete.obs') # Correlation matrix for all data

# Covariance and correlation matrices for the last 12 months
cov_matrix_12M <- cov(joined_monthlyreturns[time_index:(time_index-11), ], use = 'complete.obs')
cor_matrix_12M <- cor(joined_monthlyreturns[time_index:(time_index-11), ], use = 'complete.obs')

# Covariance and correlation matrices for the last 18 months
cov_matrix_18M <- cov(joined_monthlyreturns[time_index:(time_index-17), ], use = 'complete.obs')
cor_matrix_18M <- cor(joined_monthlyreturns[time_index:(time_index-17), ], use = 'complete.obs')

# Covariance and correlation matrices for the last 24 months
cov_matrix_24M <- cov(joined_monthlyreturns[time_index:(time_index-23), ], use = 'complete.obs')
cor_matrix_24M <- cor(joined_monthlyreturns[time_index:(time_index-23), ], use = 'complete.obs')


# Plot correlation matrices
corrplot(cor_matrix_all, method = "circle", type = "upper", tl.col = "black", tl.srt = 45, title = "Correlation Matrix (All Data)")
corrplot(cor_matrix_12M, method = "circle", type = "upper", tl.col = "black", tl.srt = 45, title = "Correlation Matrix (Last 12 Months)")
corrplot(cor_matrix_18M, method = "circle", type = "upper", tl.col = "black", tl.srt = 45, title = "Correlation Matrix (Last 18 Months)")
corrplot(cor_matrix_24M, method = "circle", type = "upper", tl.col = "black", tl.srt = 45, title = "Correlation Matrix (Last 24 Months)")


## Analysis:

# - The correlation matrices show the relationships between the returns of different assets over various periods.

### Interesting correlations:

# - IXN and QQQ have a high positive correlation, indicating that these technology-focused assets move similarly.
# - IEF (fixed income) generally has a low or negative correlation with equities (IXN, QQQ) and real assets (VNQ), which is expected as bonds often serve as a hedge against equity volatility.
# - GLD (commodities) shows a low correlation with other assets, highlighting its role as a diversification tool in the portfolio.


# Define the time index for the last 12 months
last_12_months <- joined_monthlyreturns[time_index:(time_index-11), ]

# Building CAPM models for each selected asset using SPY returns
IXN_reg <- lm(formula = monthly.returns ~ monthly.returns.5, data=last_12_months)
summary(IXN_reg)

QQQ_reg <- lm(formula = monthly.returns.1 ~ monthly.returns.5, data=last_12_months)
summary(QQQ_reg)

IEF_reg <- lm(formula = monthly.returns.2 ~ monthly.returns.5, data=last_12_months)
summary(IEF_reg)

VNQ_reg <- lm(formula = monthly.returns.3 ~ monthly.returns.5, data=last_12_months)
summary(VNQ_reg)

GLD_reg <- lm(formula = monthly.returns.4 ~ monthly.returns.5, data=last_12_months)
summary(GLD_reg)

# Plotting residuals to check the linearity and normality assumptions of the models
# Residual plots for IXN
plot(IXN_reg, which=2, col="green", main="Residuals for IXN CAPM Model")

# Residual plots for QQQ
plot(QQQ_reg, which=2, col="brown", main="Residuals for QQQ CAPM Model")

# Residual plots for IEF
plot(IEF_reg, which=2, col="orange", main="Residuals for IEF CAPM Model")

# Residual plots for VNQ
plot(VNQ_reg, which=2, col="blue", main="Residuals for VNQ CAPM Model")

# Residual plots for GLD
plot(GLD_reg, which=2, col="purple", main="Residuals for GLD CAPM Model")


## CAPM Analysis

# The Q-Q plots indicate that the residuals of IXN, QQQ, IEF, VNQ, and GLD approximately follow a normal distribution, supporting the assumptions of the CAPM model.

#Let's use the CAPM models to estimate the expected rate of return (mu) for a few random dates for selected assets.

#Creating a Random Sample
testing_sample_indx <- sample(1:nrow(joined_monthlyreturns), size=5)
testing_sample_data <- joined_monthlyreturns[testing_sample_indx,]

# Predicting the expected returns using the CAPM models
IXN_pred <- predict(IXN_reg, testing_sample_data)
QQQ_pred <- predict(QQQ_reg, testing_sample_data)
IEF_pred <- predict(IEF_reg, testing_sample_data)
VNQ_pred <- predict(VNQ_reg, testing_sample_data)
GLD_pred <- predict(GLD_reg, testing_sample_data)


# Print the predictions
print(IXN_pred)
print(QQQ_pred)
print(IEF_pred)
print(VNQ_pred)
print(GLD_pred)


#Calculating Portfolio Beta - Running regression for last 12 months between portfolio and SPY benchmark
portfolio_vs_SPY_reg <- lm(portfolio ~ monthly.returns.5, data=joined_monthlyreturns[((time_index-11) : time_index),])
portfolio_summary <- summary(portfolio_vs_SPY_reg)

# Print the summary of the portfolio regression
print(portfolio_summary)


## Analysis:

# The portfolios beta is 0.778, indicating it is less volatile than the market. This suggests the portfolio will be less responsive to market movements, providing some stability during market fluctuations.


# Calculate Treynor ratios
IXN_treynor <- (((1 + IXN_exp) ^ 12) - 1 - riskfree) / IXN_reg$coefficients[2]
QQQ_treynor <- (((1 + QQQ_exp) ^ 12) - 1 - riskfree) / QQQ_reg$coefficients[2]
IEF_treynor <- (((1 + IEF_exp) ^ 12) - 1 - riskfree) / IEF_reg$coefficients[2]
VNQ_treynor <- (((1 + VNQ_exp) ^ 12) - 1 - riskfree) / VNQ_reg$coefficients[2]
GLD_treynor <- (((1 + GLD_exp) ^ 12) - 1 - riskfree) / GLD_reg$coefficients[2]

# Assuming portfolio returns and CAPM model for the portfolio
portfolio_exp <- mean(joined_monthlyreturns$monthly.returns.5[(time_index - 11) : time_index])
portfolio_treynor <- (portfolio_exp - riskfree) / portfolio_vs_SPY_reg$coefficients[2]

# Print Treynor ratios
print(c(IXN_treynor, QQQ_treynor, IEF_treynor, VNQ_treynor, GLD_treynor, portfolio_treynor))

## Analysis:

###Treynor ratios for each asset:

#IXN: 0.292
#QQQ: 0.272
#IEF: -0.010
#VNQ: 0.035
#GLD: 1.349
#Portfolio: 0.023

## Insight: 

#The high Treynor ratio for GLD indicates it provides good returns per unit of market risk. IEF’s negative Treynor ratio suggests it is not performing well relative to its beta, supporting the decision to sell it.

# Define the tickers
tickers <- c("IXN", "QQQ", "IEF", "VNQ", "GLD", "SPY")
stock_list <- lapply(tickers, function(ticker) getSymbols(ticker, auto.assign = F))

# Combine stock prices into one data frame by date
combined_prices <- do.call(merge, lapply(stock_list, function(stock) stock[, 6]))

# Rename columns
colnames(combined_prices) <- tickers

# Convert to data frame
combined_prices_df <- data.frame(date = index(combined_prices), coredata(combined_prices))

# Step 2: Calculate returns
returns_df <- combined_prices_df %>%
  mutate(across(-date, ~ log(. / lag(.)))) %>%
  na.omit()

# Step 3: Reshape data for ggplot
returns_long <- pivot_longer(returns_df, cols = -date, names_to = "ticker", values_to = "return")

# Plot indexed prices
combined_prices_df_long <- combined_prices_df %>%
  pivot_longer(cols = -date, names_to = "ticker", values_to = "price") %>%
  group_by(ticker) %>%
  mutate(idx_price = price / first(price))

ggplot(combined_prices_df_long, aes(x = date, y = idx_price, color = ticker)) +
  geom_line() +
  theme_bw() + ggtitle("Price Developments") +
  xlab("Date") + ylab("Price (Indexed to First Value)") +
  scale_color_discrete(name = "Company")


## Price Developments

#This plot highlights the growth trends of each stock from their initial prices. IXN and QQQ show significant price appreciation over time, reflecting the strong performance of technology-related assets.

# Calculate expected returns and volatility
summary_df <- returns_df %>%
  pivot_longer(cols = -date, names_to = "ticker", values_to = "return") %>%
  group_by(ticker) %>%
  summarise(
    er = round(mean(return), 4),
    sd = round(sd(return), 4)
  )

# Plot risk-return tradeoff
ggplot(summary_df, aes(x = sd, y = er, color = ticker)) +
  geom_point(size = 5) +
  theme_bw() + ggtitle("Risk-Return Tradeoff") +
  xlab("Volatility") + ylab("Expected Returns") +
  scale_y_continuous(label = scales::percent) +
  scale_x_continuous(label = scales::percent)

## Risk-Return Tradeoff

# The plot illustrates the expected returns against the volatility (standard deviation) of each stock. IXN and QQQ offer higher expected returns with higher volatility, while IEF and GLD provide lower expected returns with lower volatility, indicating their roles as safer investments in the portfolio.


################################################
#### Two risky assets portfolio
################################################
# Select two assets for portfolio
ticker1_select <- "QQQ"
ticker2_select <- "GLD"

returns_selected <- returns_df %>% select(date, all_of(c(ticker1_select, ticker2_select)))
returns_selected <- returns_selected %>% na.omit()

# Calculate necessary values
er_x <- mean(returns_selected[[ticker1_select]])
er_y <- mean(returns_selected[[ticker2_select]])
sd_x <- sd(returns_selected[[ticker1_select]])
sd_y <- sd(returns_selected[[ticker2_select]])
cov_xy <- cov(returns_selected[[ticker1_select]], returns_selected[[ticker2_select]])

# Create portfolio weights
x_weights <- seq(0, 1, length.out = 1000)
two_assets <- data.table(wx = x_weights, wy = 1 - x_weights)

# Calculate portfolio expected returns and standard deviations
two_assets[, ':=' (
  er_p = wx * er_x + wy * er_y,
  sd_p = sqrt(wx^2 * sd_x^2 + wy^2 * sd_y^2 + 2 * wx * wy * cov_xy)
)]

# Plot portfolios with two risky assets
ggplot() +
  geom_point(data = two_assets, aes(x = sd_p, y = er_p, color = wx)) +
  geom_point(data = data.table(sd = c(sd_x, sd_y), er = c(er_x, er_y)),
             aes(x = sd, y = er), color = "red", size = 3, shape = 18) +
  theme_bw() + ggtitle("Possible Portfolios with Two Risky Assets") +
  xlab("Volatility") + ylab("Expected Returns") +
  scale_y_continuous(label = scales::percent, limits = c(0, max(two_assets$er_p) * 1.2)) +
  scale_x_continuous(label = scales::percent, limits = c(0, max(two_assets$sd_p) * 1.2)) +
  scale_color_continuous(name = expression(omega[x]), labels = scales::percent)


######################################################
### Three risky assets portfolio:
#########################################################
# Select three assets for portfolio
ticker3_select <- "IXN"

returns_selected_three <- returns_df %>% select(date, all_of(c(ticker1_select, 
                                                               ticker2_select, 
                                                               ticker3_select)))
returns_selected_three <- returns_selected_three %>% na.omit()

# Calculate necessary values
er_z <- mean(returns_selected_three[[ticker3_select]])
sd_z <- sd(returns_selected_three[[ticker3_select]])
cov_xz <- cov(returns_selected_three[[ticker1_select]], returns_selected_three[[ticker3_select]])
cov_yz <- cov(returns_selected_three[[ticker2_select]], returns_selected_three[[ticker3_select]])

# Create portfolio weights
three_assets <- data.table(wx = rep(x_weights, each = length(x_weights)), 
                           wy = rep(x_weights, length(x_weights)))
three_assets[, wz := 1 - wx - wy]

# Calculate portfolio expected returns and standard deviations
three_assets[, ':=' (
  er_p = wx * er_x + wy * er_y + wz * er_z,
  sd_p = sqrt(wx^2 * sd_x^2 + wy^2 * sd_y^2 + wz^2 * sd_z^2 +
                2 * wx * wy * cov_xy + 2 * wx * wz * cov_xz + 2 * wy * wz * cov_yz)
)]

# Filter out negative weights
three_assets <- three_assets[wx >= 0 & wy >= 0 & wz >= 0]

# Plot portfolios with three risky assets
ggplot() +
  geom_point(data = three_assets, aes(x = sd_p, y = er_p, color = wx - wz)) +
  geom_point(data = data.table(sd = c(sd_x, sd_y, sd_z), er = c(er_x, er_y, er_z)), 
             aes(x = sd, y = er), color = "red", size = 3, shape = 18) +
  theme_bw() + ggtitle("Possible Portfolios with Three Risky Assets") +
  xlab("Volatility") + ylab("Expected Returns") +
  scale_y_continuous(label = scales::percent, limits = c(0, max(three_assets$er_p) * 1.2)) +
  scale_x_continuous(label = scales::percent, limits = c(0, max(three_assets$sd_p) * 1.2)) +
  scale_color_gradientn(colors = c("red", "blue", "yellow"), name = expression(omega[x] - omega[z]),
                        labels = scales::percent)


## Analysis:

# The efficient frontier analysis with IXN, QQQ, and GLD demonstrates the optimal portfolios that provide the best possible returns for a given level of risk.

## Insight: 

# The efficient frontier shows that diversifying across these high Sharpe ratio assets allows the investor to maximize returns while controlling for risk. Portfolios that lie on the frontier represent the best trade-offs between risk and return.


enddate <- "2024-06-28"
t <- 465 

# Define the asset tickers
tickers <- c("IXN", "QQQ", "IEF", "VNQ", "GLD")
nstocks <- length(tickers)
pricinglist <- as.data.frame(matrix(ncol=nstocks, nrow=t))
colnames(pricinglist) <- tickers

# Download the stock data
for (i in 1:nstocks){
  current_ticker <- tickers[i]
  newtable <- getSymbols(current_ticker, src = "yahoo", from="2022-8-22", to=enddate, auto.assign=FALSE)
  pricinglist[,i] <- newtable[,6]
}

# Forecasting the next price using a backpropagation training algorithm in a neural network
# and an Autoregressive Model of fourth order AR4

newpricingdataset <- pricinglist

# Creating a dataset with monthly ROR for each day using continuous compounding
dailyROR <- as.data.frame(matrix(ncol=ncol(newpricingdataset), nrow=nrow(newpricingdataset)-25))
colnames(dailyROR) <- colnames(pricinglist)
for (c in 1:(ncol(newpricingdataset))){
  for (r in 1:(nrow(newpricingdataset)-25)){
    dailyROR[r,c] <- log(as.numeric(newpricingdataset[(r+25),c])/as.numeric(newpricingdataset[r,c]))
  }
}

# The most current expected return for n+25 (n is today) is in the last row of the above dataset
# Calculating Expected(R) for all securities 
averet <- as.matrix(dailyROR[nrow(dailyROR),], nrow=1)

# Calculating covariance matrix
rcov <- cov(dailyROR[(nrow(dailyROR)-125):(nrow(dailyROR)),])  # 125 stands for 6 trading months
target.r <- 1 / 1000

# Using solver to get to optimal weights
effFrontier = function(averet, rcov, nports, shorts, wmax, wmin)
{
  mxret <- max(averet)
  mnret <- -mxret
  n.assets <- ncol(averet)
  reshigh <- rep(wmax, n.assets)
  reslow <- rep(wmin, n.assets)
  min.rets <- seq(mnret, mxret, length.out=nports)
  vol <- rep(NA, nports)
  ret <- rep(NA, nports)
  pw <- data.frame(matrix(ncol=nports, nrow=n.assets))
  for (i in 1:nports)
  {
    port.sol <- NULL
    try(port.sol <- portfolio.optim(x=averet, pm=min.rets[i], covmat=rcov, reshigh = reshigh, reslow= reslow, shorts=F), silent=T)
    if(!is.null(port.sol))
    {
      vol[i] <- sqrt(as.vector(port.sol$pw %*% rcov %*% port.sol$pw))
      ret[i] <- averet %*% port.sol$pw
      pw[,i] <- port.sol$pw
    }
  }
  return(list(vol=vol, ret=ret, weights=pw))
}

maxSharpe <- function(averet, rcov, shorts=F, wmax=0.2, min.weight=0.01)
{
  optim.callback=function(param, averet, rcov, reshigh, reslow, shorts)
  { 
    port.sol = NULL
    try(port.sol <- portfolio.optim(x=averet, pm=param, covmat=rcov, reshigh=reshigh, reslow=reslow, shorts=shorts),silent=T)
    if(is.null(port.sol)) { ratio=10^9 } else 
    {
      m.return <- averet %*% port.sol$pw
      m.risk <- sqrt(as.vector(port.sol$pw %*% rcov %*% port.sol$pw))
      ratio <- m.return / m.risk
      assign("w", port.sol$pw, inherits=T)
    }
    return(ratio)
  }
  
  ef <- effFrontier(averet=averet, rcov=rcov, shorts=shorts, wmax=wmax, nports=100, wmin=min.weight)
  n <- ncol(averet)
  reshigh <- rep(wmax, n)
  reslow <- rep(min.weight, n)
  
  max.sh <- which.max(ef$ret/ef$vol)
  
  if(is.na(ef$ret[max.sh-1])) { lowerinterval <- ef$ret[max.sh] } else { lowerinterval <- ef$ret[max.sh-1] }
  if(is.na(ef$ret[max.sh+1])) { upperinterval <- ef$ret[max.sh] } else { upperinterval <- ef$ret[max.sh+1] }
  
  w <- rep(0, ncol(averet))
  xmin <- optimize(f=optim.callback, interval=c(lowerinterval, upper=upperinterval), averet=averet, rcov=rcov, reshigh=reshigh, reslow=reslow, shorts=shorts)
  return(w)
  return(xmin)
}

z <- maxSharpe(averet, rcov, shorts=F, wmax=0.4)

print(z)


## Analysis
# Suggests that we invest:

# 40% - IXN
# 40% - QQQ
# 12.4% - IEF
# 1% - VNQ
# 6.6% - GLD

# Define the Fama French 3-Factor Model function
fama_french_3F_pred_res <- function(ticker, from_date, to_date) {
  # Download stock data
  ticker.r <- getSymbols(ticker, from = from_date, to = to_date, auto.assign=FALSE)
  ticker.r <- ticker.r[,c(1,6)]
  
  # Create temp file and directory
  tf <- tempfile()
  td <- tempdir()
  
  # Download Fama-French data
  zip.file.location <- "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/F-F_Research_Data_Factors_daily_CSV.zip"
  download.file(zip.file.location, tf, mode = "wb")
  file.name <- unzip(tf, exdir=td)
  y <- read.csv(file.name,skip=3)
  
  # Format dates
  names(y)[1] <- "Date"
  y$Date <- as.Date(as.character(y$Date), format="%Y%m%d")
  
  # Calculate returns
  rr.v <- vector(mode="numeric", length=nrow(ticker.r))
  
  for(i in 2:nrow(ticker.r)) {
    rr.v[i] <- as.numeric(ticker.r[i,2]) / as.numeric(ticker.r[i-1,2]) - 1
  }
  
  # Remove the first element to align dates
  rr.v <- rr.v[-1]
  
  # Subset Fama-French data
  subset_y <- subset(y, Date >= from_date & Date <= to_date)
  subset_y <- subset_y[1:length(rr.v),]
  
  # Build the Fama-French 3-factor model
  model <- lm(rr.v ~ subset_y$Mkt.RF + subset_y$SMB + subset_y$HML)
  summary(model)
}

# Usage
from_date <- as.Date("2022-07-12")
to_date <- as.Date("2024-07-12")
fama_french_3F_pred_res("IXN", from_date, to_date)


## Analysis

# - Market Risk Factor (Mkt.RF): Significant and negative, indicating that IXN has a strong inverse relationship with the market factor.
# - Size Factor (SMB): Significant and positive, suggesting that IXN is influenced by small-cap stocks.
# - Value Factor (HML): Significant and negative, indicating a tilt towards growth stocks over value stocks.

## Conclusion

### Recommendations:

# - Rebalance Portfolio: Increase allocations in IXN, QQQ, and GLD while reducing exposure to IEF and VNQ.
# - Efficient Frontier: Focus on combinations of high Sharpe ratio assets to optimize returns for a given risk level.
# - Overall Performance: Expected to improve with these changes, aligning with the client’s goal of maximizing returns while managing risk effectively.

## Additional Insights:

# - Diversification: The portfolio benefits from diversification, with low correlations between fixed income, gold, and other asset classes.
# - Risk Management: Regular monitoring of risk metrics and adjusting the portfolio to maintain an optimal risk-return profile is crucial.
