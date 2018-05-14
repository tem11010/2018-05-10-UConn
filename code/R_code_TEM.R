#-------------------------------------------------------#
#-------------------------------------------------------#

# DAY 1 - INTRO TO R AND RSTUDIO

#-------------------------------------------------------#
#-------------------------------------------------------#

library(gapminder)
library(ggplot2)
library(dplyr)

53 + 23
53 +
23  

3 + 5 * 2
(3 + 5) * 2


log(1) # natural logarithm
log10(10) # base-10 logarithm
exp(0.5) # exponent

# variable assignment
x <- 1/40
x

log(x)

x <- 100

x <- x + 1
x

y <- x * 2
y

# naming
# periods.between.words
# underscored_between_words
# camelCaseToSeparateWords

# can't
# start with a number
# spacing


# running a code chunk
mass <- 47.5
age <- 122
mass <- mass * 2.3
age <- age - 20
mass
age

# vectorization
1:5

2^(1:5)

x <- 1:4
y <- 5:8

x + y

# manage our environment
ls()

rm(age)
ls()

rm(list = ls())
ls()

# R packages
installed.packages()

update.packages("packagename")

install.packages("gapminder")

library(gapminder)


# getting help
help(ls)
?ls
?rm


# fuzzy search
??read.ta

vignette()
vignette("coin")


# stack overflow:
?dput
sessionInfo()




# Data Structures

# make a data frame

cats <- data.frame(coat = c("calico", "black", "tabby"),
                   weight = c(2.1, 5.0, 3.2),
                   likes_string = c(1, 0, 1))

write.csv(x = cats, file = "data/feline_data.csv")

cats

cats$weight

cats$coat

cats$weight + 2

cats$weight + cats$coat

class(cats$weight)
class(cats$coat)

str(cats)

str(cats$coat)
cats$coat

# change order of factors
cats$coats_reorder <- factor(x = cats$coat, 
                             levels = c("tabby", "calico", "black"), 
                             ordered = TRUE)
str(cats$coats_reorder)
levels(cats$coats_reorder)


# Exploring Data Frames

# read in data
gap <- read.csv(file = "data/gapminder-FiveYearData.csv")
cats <- read.csv(file = "data/feline_data.csv")

head(gap)

str(gap)

nrow(gap)
ncol(gap)
dim(gap)

colnames(gap)

# Subsetting data
x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
names(x) <- c("a", "b", "c", "d", "e")
x

x[1]
x[3]

x[c(1, 3)]

# slices
x[1:4]

x[-2]

x[-(2:4)]

x[-2:4]

# subsetting gapminder data

head(gap[1])

head(gap["pop"])

head(gap[, 1]) # subset by column

gap[3, ] # subset by row

gap[138, ]


albania <- gap[13:24, 3:6]

afghan <- gap[1:12, ]

afghan$gdp <- afghan$pop * afghan$gdpPercap
write.csv(x = afghan, file = "results/afghan_gdp.csv")



#-------------------------------------------------------#
#-------------------------------------------------------#

# DAY 2 - CONDITIONAL STATEMENTS, FUNCTIONS, AND GGPLOT

#-------------------------------------------------------#
#-------------------------------------------------------#

# conditonal statements

number <- 37
if (number > 100){        #if condition is true
  print("greater than 100") #perform this function
}else {                 # if condition is false
  print("less than 100") # perform alternative action
}
print("finished checking") 

#comparison operators:

# greater than  >
# less than  <
# equal to ==
# no equal to !=
#  >=
# <=

number <- 150
if (number > 100){        #if condition is true
  print("greater than 100") #perform this function
}

# more than test

number <- -3
if (number > 0){
  print(1)
} else if (number < 0){
  print(-1)
}else{
  print(0)
}


# combine tests 
number1 <- -15
number2 <- -40

# 'and'
if(number1 >= 0 & number2 >= 0){
  print("both numbers are positive")
} else{
  print("at least one is negative")
}

# 'or'

if (number1 >= 0 | number2 >= 0){
  print("at least one number is positive")
} else {
  print("both numbers are negative")
}


# Creating and using functions

fahr_to_kelvin <- function(temp){
  kelvin <- ((temp - 32) *(5 / 9)) + 273.15
  return(kelvin)
}

fahr_to_kelvin(32) # freezing point
fahr_to_kelvin(212) #boiling point

kelvin_to_celsius <- function(temp){
  celsius <- temp - 273.15
  return(celsius)
}

kelvin_to_celsius <- function(temp){
  celsius <- temp - 273.15
 celsius
}



kelvin_to_celsius(0)

celsius

# variable scope 


# mixing and match

fahr_to_celsius <- function(temp){
  temp_k <- fahr_to_kelvin(temp)
  temp_c <- kelvin_to_celsius(temp_k)
  return(temp_c)
}

fahr_to_celsius(32)

# nesting function
kelvin_to_celsius(fahr_to_kelvin(32))

# socrative solution:

celsius_to_fahr <- function(temp){
  
  fahr <- temp * 9/5 + 32
  return(fahr)
  
}

celsius_to_fahr(0)



#------------------------------------------------------#

# Making reproducible graphics

#------------------------------------------------------#
library(ggplot2)

# read in some data
gap <- read.csv(file = "data/gapminder-FiveYearData.csv")
head(gap)
str(gap)

plot(x = gap$gdpPercap, y = gap$lifeExp)

# ggplot image

ggplot(data = gap, aes(x = gdpPercap, y =lifeExp)) +
  geom_point()

ggplot(data = gap, aes(x = year, y = lifeExp))+
  geom_point()

head(gap)

ggplot(data = gap, aes(x = year, y = lifeExp, by = country))+
  geom_line(aes(color = continent))+
  geom_point(color = "blue")


ggplot(data = gap, aes(x = gdpPercap, y =lifeExp)) +
  scale_x_log10() +
  geom_point(alpha = 0.5)+
  geom_smooth(method = "lm")+
  theme_bw()+
  ggtitle(" Effects of per-capita GDP on Life Expectancy") +
  xlab("GDP per capita ($)")+
  ylab("Life Expectancy (Yrs)")

ggsave(file = "results/life_expectancy.pdf")
?ggsave

#faceting
ggplot(data = gap, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point() +
  scale_x_log10()+
  geom_smooth(method = "lm")+
  facet_wrap(~year)
  



