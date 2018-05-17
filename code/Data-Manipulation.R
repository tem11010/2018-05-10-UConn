##### Data Manipulation #####

# Make sure packages are installed
install.packages(c("tidyr", "dplyr", "knitr", 
     "rmarkdown", "formatR"))

library(dplyr) # Needed for subsetting data
library(tidyr) # Needed for reshaping data
library(ggplot2) # Needed for graphing

# Read in our dataset
gap <- read.csv(file = "data/gapminder-FiveYearData.csv")


##### dplyr #####

### Subsetting Data


# Always a good idea to take a look at our dataset
head(gap)
str(gap)

# Using dplyr's select() function to subset our data by column
# We can specify only the columns we want
yr_country_gdp <- select(gap, year, country, gdpPercap)

# Check the result
head(yr_country_gdp)

# Pipes: (the %>%)
# Think of this like an assembly line, the pipe sends the data to the next step
# the gap dataset is piped to the select() function.  
# It always becomes the first argument for the next function in line (in this case, select)
yr_country_gdp <- gap %>% select(year, country, gdpPercap)

# We can pipe through multiple steps
# gap dataset gets piped to filter().  
# Filter subsets the dataset to only include rows from Europe
# Then, the result gets piped to select, where we subset by column
yr_country_gdp_eu <- gap %>% 
     filter(continent == "Europe") %>%
     select(year, country, gdpPercap)

# Let's look at the result
head(yr_country_gdp_eu)

# Instead of using pipes, we could nest functions this way.  This does the same as above
# Get's hard to read and understand if there are many (10, 20, 30+) steps.
yr_country_gdp_eu <- select(filter(gap, continent == "Europe"), year, country, gdpPercap)

# the filter function can do multiple filters at once to subset rows
Africa_07 <- gap %>% 
     filter(year == 2007, continent == "Africa") %>%
     select(year, country, lifeExp)

# Check the result
head(Africa_07)


### Summarizing Data


# We can summarize data, making new columns in the process
# The following calculates the mean GDP for the entire dataset
mean_gdp <- gap %>% 
     summarize(meanGDP = mean(gdpPercap))

# Show the result
mean_gdp

# The above is not so useful, we could just do it this way instead
mean(gap$gdpPercap)


# Summarizing becomes more useful when we summarize separately for different continents
# The following calculates meanGDP for each continent by using a group_by() term
# group_by() and summarize() work hand-in-hand, you usually need both
gdp_by_cont <- gap %>%
     group_by(continent) %>%
     summarize(meanGDP = mean(gdpPercap))

# Display the result, 4 rows of data with continent name, and mean GDP
gdp_by_cont

# You can group by multiple columns to show summarizes for each continent-year combination
# Summarize can create multiple summaries: in this case: mean of 2 columns, sd, sample size
gdp_by_cont <- gap %>%
     group_by(continent, year) %>%
     summarize(meanGDP = mean(gdpPercap), 
          sd_gdp = sd(gdpPercap), 
          mean_pop = mean(pop), 
          sample_size = n()
          )

# Take a look at the result
head(gdp_by_cont)

# summarize() and other 
gdp_by_cont %>% 
     data.frame() %>% 
     head()

# We can even use pipes to send datasets to ggplot
# Again, whatever is piped to ggplot becomes ggplot()'s first argument
gdp_by_cont %>%
     ggplot(aes(x = mean_pop, y = meanGDP)) + 
          geom_point()

# We can create new columns (without summarizing), using the mutate() function
# You can do math with column names (as below), or any other R function
bill_gdp <- gap %>%
     filter(year == 2007) %>%
     mutate(billGDP = gdpPercap * pop / 10^9)

# Take a look at the result
head(bill_gdp)

# Most of data wrangling with dplyr can be accomplised with these five functions
# Subsetting with select() and filter()
# Summarizing with group_by() and summarize()
# Making new columns with mutate()


##### tidyr #####

### Wide vs Long Data


# Read in the same dataset, but in wide format
gap_wide <- read.csv(file = "data/gapminder_wide.csv")

# Take a look at this new dataset
# More columns and less rows than the original dataset
# Wide format is more like datasheets.  
# But ggplot and many analyses need long format, more like the original gap dataset
head(gap_wide)
str(gap_wide)


# Remind ourselves what the gap dataset looks like
head(gap)

### Let's reshape from wide to long

# First, we use gather to put all the pop, lifeExp and gdpPerCap columns into two columns
# Obstype_year column becomes the original column names
# obs_values becomes the values
# This will make a dataset with many more rows and many fewer columns
# Note: tidyr works with pipes too
gap_long <- gap_wide %>%
     gather(obstype_year, obs_values, starts_with('pop'), 
          starts_with('lifeExp'), starts_with('gdpPerCap'))

# Take a look at the result
str(gap_long)
head(gap_long)


# In addition to the above step, we also need to separate the obstype_year column
# It contains two kinds of information in it: the observation type, and the year
# We give it two column names to put the separated data into, and a separator to use
gap_long <- gap_long %>%
     separate(obstype_year, into = c("obs_type", "year"), 
          sep = "_")

# Take a look at the result
head(gap_long)
str(gap_long)

# This should look like the same format as the gap dataset, though perhaps sorted differently
head(gap)
str(gap)

# The following takes the long dataset and goes back to the original wide format.  
# We're just reversing the separate() and gather() steps
wide <- gap_long %>%
     unite(var_names, obs_type, year, sep = "_") %>%
     spread(var_names, obs_values)

# Take a look at the result
str(wide)

# Most of reshaping data can be done with four functions
# gather() and spread() to go back and forth between wide and long
# separate() and unite() to combine or separate columns
