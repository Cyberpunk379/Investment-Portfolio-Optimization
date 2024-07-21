# Investment Portfolio Optimization

## Overview

This project focuses on optimizing an investment portfolio by analyzing the performance and risk of various selected stocks. The analysis includes calculations of the annual risk, expected returns, tracking error, and application of the Fama-French 3-factor model.

## Table of Contents

- [Overview](#overview)
- [Data Collection](#data-collection)
- [Analysis](#analysis)
  - [Annual Risk Analysis](#annual-risk-analysis)
  - [Mean Return vs Tracking Error](#mean-return-vs-tracking-error)
  - [Residuals of CAPM Model](#residuals-of-capm-model)
  - [Fama-French 3-Factor Model Analysis](#fama-french-3-factor-model-analysis)
- [Recommendations](#recommendations)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Data Collection

The data for this project includes stock prices and Fama-French factors. Stock prices were obtained using the `quantmod` package, and Fama-French data was downloaded from the Kenneth R. French Data Library.

## Analysis

### Annual Risk Analysis

Annual risk for each stock was calculated using the standard deviation of returns. The following stocks were analyzed:
- IXN: 6.24%
- QQQ: 6.57%
- IEF: 5.58%
- VNQ: 6.31%
- GLD: 0.76%

### Mean Return vs Tracking Error

A scatter plot was created to visualize the mean return versus the tracking error for each stock. The following observations were made:
- Stocks like IXN and QQQ have higher mean returns and tracking errors.
- GLD has a lower mean return but also a lower tracking error.

### Residuals of CAPM Model

Residual plots for each stock were created to check the linearity and normality assumptions of the CAPM model. The plots indicate that the residuals are approximately normally distributed, confirming the validity of the model.

### Fama-French 3-Factor Model Analysis

The Fama-French 3-factor model was applied to predict stock returns. Significant relationships with market risk premium and SMB were observed for IXN.

## Recommendations

Based on the analysis, the following recommendations are made:
1. **Diversify the Portfolio**: Include a mix of stocks with varying risk levels to balance the overall risk.
2. **Focus on High Returns with Manageable Risk**: Stocks like IXN and QQQ offer higher returns, but their tracking errors should be monitored closely.
3. **Consider Low Risk Options**: Incorporate stocks like GLD which have lower risk to provide stability to the portfolio.

## Getting Started

### Prerequisites

- R (version 4.0 or higher)
- RStudio
- Required R packages: `quantmod`, `ggplot2`, `timeDate`, `chron`, `curl`

### Installation

Clone the repository:
```sh
git clone https://github.com/Cyberpunk379/Investment-Portfolio-Optimization.git
cd Investment-Portfolio-Optimization
```

### Usage

1. Open `Investment_Portfolio_Optimization_Report.Rmd` in RStudio.
2. Knit the R Markdown file to generate the report.
3. Review the generated HTML report for analysis and insights.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.
