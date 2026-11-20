install.packages("readxl")

library(readxl)

liquidity_df <- read_excel(file.choose(), sheet = "Regression_Monthly")
dim(liquidity_df)  #dim() stands for dimensions.

# =====================================================================
# PROJECT: Macro-Liquidity Data Analysis & Econometrics in R
# NAME: Suchita Roy | Roll: BECO25331 | Div: 3 | Sem 3
# =====================================================================

install.packages("utf8")

#1. Required Libraries
library(utf8)
library(tidyverse)
library(readxl)
library(dplyr)
library(ggplot2)

# =====================================================================
# QUESTION 1: Data Structure Inspection & Subsetting
# =====================================================================
dim(liquidity_df)               # Check total rows and columns
str(liquidity_df)               # structure --> Inspect data types and structure
liquidity_df[ , 2]              # View 2nd column (Standing Deposit Facility /SDF balance) using square brackets (base R square bracket indexing [row, column])
View(liquidity_df[ , c(2, 7)])    # View selected columns side by side, c(2, 7) combines columns 2 and 7 (SDF and Net Foreign Assets)
summary(liquidity_df$d_absorb)  # Summary statistics of primary dependent variable
summary(liquidity_df)           # Overall dataset summary

#$ operator extracts the specific column d_absorb (monthly liquidity absorption change)
#summary() calculates descriptive statistics: minimum, 1st quartile, median, mean, 3rd quartile, and maximum.



# =====================================================================
# QUESTION 2: Data Filtering and Mutating Derived Financial Flows
# =====================================================================
#----------------------------------------------------------------------------------------
# Filter active policy windows with high absorption using dplyr

library(dplyr)
high_absorb_period <- liquidity_df %>%
  filter(window == 1 & d_absorb > 3000) %>%
  select(date, d_absorb, d_nfa, d_credit)

print(high_absorb_period)

#%>% is the pipe operator (from tidyverse), which passes the dataset smoothly from one step to the next.
#filter(...) isolates only the rows where the policy dummy window equals 1 and net absorption (d_absorb) is greater than 3,000 crores.
#select(...) keeps only the specific columns you want to look at (date, d_absorb, d_nfa, d_credit) and stores the result in a new object called high_absorb_period.

#---------------------------------------------------------------------------------------
# Filter categorical check using %in%

liquidity_df %>%
  filter(crr_chg %in% c(0, 1)) %>%
  count(crr_chg)

#%in% checks if values match a specific set (0 or 1 for CRR change months)
#count() tallies up how many months fall into each category.

#---------------------------------------------------------------------------------------
# Create a new derived column using mutate (Net Banking Credit minus Deposits flow)

liquidity_df <- liquidity_df %>%
  mutate(net_banking_flow = d_credit - d_dep)

select(liquidity_df, date, d_credit, d_dep, net_banking_flow) %>% head()

#mutate() creates a brand-new column in your dataset named net_banking_flow. 
#It calculates this new variable by subtracting bank deposit growth (d_dep) 
# ----> from bank credit expansion (d_credit) for every month.


# =====================================================================
# QUESTION 3: Conditional Logic, Categorization and Counter Loops
# =====================================================================
#----------------------------------------------------------------------------
# Simple if/else decision check on average absorption

avg_absorb <- mean(liquidity_df$d_absorb, na.rm = TRUE) #Calculates the arithmetic mean of liquidity absorption. 

#na.rm = TRUE tells R to ignore any missing values (NA) so they don't break the calculation.

if (avg_absorb >= 3500) {
  print("Result: High Systemic Liquidity Absorption Period")
} else {
  print("Result: Normal/Low Systemic Liquidity Absorption Period")
}

#if / else control flow block.
#Testing a condition: if the average absorption is 3,500 or higher
#it prints one statement; otherwise, it prints the alternative.

#-----------------------------------------------------------------------------
# Vectorised categorization using ifelse() and dplyr::case_when()

liquidity_df <- liquidity_df %>%
  mutate(absorption_tier = dplyr::case_when(
    d_absorb >= 4500 ~ "Surplus Absorption",
    d_absorb >= 2000 ~ "Moderate Absorption",
    TRUE              ~ "Low/Negative Absorption"
  ))

#dplyr::case_when() acts like a multiple if-else statement inside a dataset.
#It scans every row's absorption value and labels it as "Surplus Absorption", "Moderate Absorption", or "Low/Negative Absorption" 
#(TRUE acts as the catch-all "otherwise" condition).

#-----------------------------------------------------------------------------
# Iterative counting loop with if condition
high_credit_count <- 0

for (val in liquidity_df$d_credit) {
  if (!is.na(val) && val > 5000) {
    high_credit_count <- high_credit_count + 1
  }
}
cat("Total months with credit expansion above 5000:", high_credit_count, "\n")

#cat() is extremely useful because it lets you combine text and numerical results together into clean, readable sentences.
#high_credit_count <- 0 sets up a starting counter at zero.
#for (val in liquidity_df$d_credit) loops through every single month's credit value one by one.
#if (!is.na(val) && val > 5000) checks that the value is not missing and is greater than 5,000. 
#If true, it adds +1 to the counter.
#cat() prints out the final total count cleanly to the console.

# =====================================================================
# QUESTION 4: Visualizing Economic Relationships with ggplot2
# =====================================================================
#GRAPHICAL ANALYSIS OF NFA CHANGES AND SYSTEMIC LIQUIDITY ABSORPTION

# Objective:
# To examine the relationship between monthly changes in
# Net Foreign Assets (d_nfa) and systemic liquidity absorption
# (d_absorb) using a scatter plot and OLS trend line.
#---------------------------------------------------------------------------
# Scatter plot with OLS linear regression trend line

# Initial plotting attempt (Where i include all)

ggplot(liquidity_df, aes(x = d_nfa, y = d_absorb)) +
  geom_point(color = "steelblue", size = 2.5, alpha = 0.7) +
  geom_smooth(method = "lm", color = "firebrick", se = TRUE) +
  labs(
    title = "Net Foreign Asset Changes vs. Systemic Liquidity Absorption",
    subtitle = "Empirical Macroeconomic Relationship & Trend Line",
    x = "Change in Net Foreign Assets (d_nfa, in ₹ crore)",
    y = "Net Liquidity Absorption (d_absorb, in ₹ crore)"
  ) +
  theme_minimal()

#Initializes the plot using ggplot(). 

#aes() stands for aesthetics, 
#--->mapping the horizontal X-axis to Net Foreign Asset changes (d_nfa) &
#--->the vertical Y-axis to liquidity absorption changes (d_absorb).

#geom_point() adds a scatter plot layer where each dot represents one month. 
#--->It colors them steel blue, sets their size to 2.5 &
#--->applies alpha = 0.7 for slight transparency 
# so overlapping dots are visible.

#geom_smooth(method = "lm") adds an Ordinary Least Squares (OLS) linear regression trend line in firebrick red
#--->complete with standard error shading (se = TRUE) to show statistical confidence.
#labs() adds clean labels (Main Title, Subtitle, X-axis label, and Y-axis label).
#theme_minimal() applies a professional, clutter-free white background grid style to the chart.

#Warning in output we get----------------------------->

# Now,------------------------------------------------------------
# Data inspection and handling
# ------------------------------------------------------------

# Checking observations with non-finite values

liquidity_df[
  !is.finite(liquidity_df$d_nfa) |
    !is.finite(liquidity_df$d_absorb),
]

# Counting observations with non-finite values

sum(
  !is.finite(liquidity_df$d_nfa) |
    !is.finite(liquidity_df$d_absorb)
)

# The first observation contains missing monthly changes.
# Monthly changes require preceding-month data, which is
# unavailable for the first observation.

#-----------------------------------------------------------------
# A separate dataset is created for Q4 using valid observations.
# The original dataset remains unchanged.

liquidity_df_q4 <- liquidity_df %>%
  filter(is.finite(d_nfa), is.finite(d_absorb))

# Checking observations retained and excluded

nrow(liquidity_df_q4)

nrow(liquidity_df) - nrow(liquidity_df_q4)


# ------------------------------------------------------------
# Final scatter plot with OLS trend line
# ------------------------------------------------------------

ggplot(liquidity_df_q4, aes(x = d_nfa, y = d_absorb)) +
  geom_point(color = "steelblue", size = 2.5, alpha = 0.7) +
  geom_smooth(method = "lm", color = "firebrick", se = TRUE) +
  labs(
    title = "Net Foreign Asset Changes vs. Systemic Liquidity Absorption",
    subtitle = "Empirical Macroeconomic Relationship & Trend Line",
    x = "Change in Net Foreign Assets (d_nfa, in Rs. crore)",
    y = "Net Liquidity Absorption (d_absorb, in Rs. crore)"
  ) +
  theme_minimal()


# ------------------------------------------------------------
# Interpretation (Q4)
# ------------------------------------------------------------

# The scatter plot examines the relationship between monthly
# changes in Net Foreign Assets and systemic liquidity absorption.
#
# The OLS trend line indicates a positive linear association
# between the two variables in the observed data.
#
# This represents an association and does not establish causality.
# Further statistical analysis is required to examine the
# strength and significance of the relationship.


