# Load necessary libraries
library(dplyr)
library(lubridate)
library(forecast)
library(ggplot2)

# Load the data
shootings <- read.csv("C:/Users/darra/OneDrive/Desktop/Postgraduate Course/Social Forecasting/Final Project/NYC Shoooting Data.csv")

# Format the date
shootings$OCCUR_DATE <- as.Date(shootings$OCCUR_DATE, format = "%m/%d/%Y")

# Create 'YearMonth' variable
shootings$YearMonth <- format(shootings$OCCUR_DATE, "%Y-%m")

# Aggregate monthly counts for all shootings
total_shootings <- shootings %>%
  group_by(YearMonth) %>%
  summarise(Count = n(), .groups = 'drop')

# Create a Date variable
total_shootings$YearMonth <- as.Date(paste0(total_shootings$YearMonth, "-01"))

# Create a time series object
ts_shootings <- ts(total_shootings$Count, start = c(year(min(total_shootings$YearMonth)), month(min(total_shootings$YearMonth))), frequency = 12)

autoplot(ts_shootings) +
  geom_vline(xintercept = 2017, linetype = "dashed", color = "red") +
  ggtitle("Total Monthly NYC Shootings (2006–2019) with Train/Test Split") +
  ylab("Number of Shootings") +
  xlab("Year") +
  scale_x_continuous(breaks = seq(2006, 2019, 1)) +
  theme_light() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    axis.title = element_text(size = 13),
    axis.text = element_text(size = 10)
  )

# Define training and testing periods
train_ts <- window(ts_shootings, end = c(2016, 12))
test_ts <- window(ts_shootings, start = c(2017, 1))

# Fit an automatic ARIMA model
model_arima <- auto.arima(train_ts)

# Forecast into testing period
h <- length(test_ts)
forecast_arima <- forecast(model_arima, h = h)

# Evaluate accuracy
accuracy(forecast_arima, test_ts)

# Plot the forecast
autoplot(forecast_arima) +
  autolayer(test_ts, series="Actual") +
  ggtitle("Forecast vs Actual Total NYC Shootings") +
  xlab("Time") + ylab("Shootings per Month") +
  theme_minimal()

# Check residuals
checkresiduals(forecast_arima)

# Plotting forecast vs actual
autoplot(train_ts) +  # Training period
  autolayer(forecast_arima, series = "Forecast (ARIMA)", PI = FALSE) +  # Forecast
  autolayer(test_ts, series = "Actual (Test)", linetype = "dashed") +  # Actual test period
  labs(title = "Forecast vs Actual: NYC Total Shootings",
       x = "Year",
       y = "Number of Shootings") +
  scale_x_continuous(breaks = seq(2006, 2019, 1)) +
  guides(colour = guide_legend(title = "Series")) +
  theme_minimal()