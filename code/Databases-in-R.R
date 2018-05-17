##### Databases in R #####


# Install required packages
install.packages(c("RSQLite", "dbplyr"))

library(RSQLite) # Database driver
library(DBI) # Database connection function
library(dplyr) # Needed for data manipulation
library(dbplyr) # Needed for dplyr database support
library(ggplot2) # Needed for graphing


### Connecting to a database


# Databases in R require a connection
# Here we use the SQLite driver to connect to the filename in dbname
# The connection is stored in conn
# Other drivers exist (e.g. Access, MySQL)
conn <- dbConnect(drv = SQLite(), dbname = "data/survey.db")

# Take a look at what tables are in the database
dbListTables(conn)

# Take a look at what fields are in the Survey table
dbListFields(conn, "Survey")



### Queries in R


# Run a select query on the database in R
coords <- dbGetQuery(conn, "SELECT lat, long FROM Site;")

# Show the resulting dataset
coords

# A more sophistocated SELECT query, using joins to combine tables
joined_data <- dbGetQuery(conn, 
     "SELECT Site.lat, Site.long, Visited.dated
     FROM Site JOIN Visited
     ON Site.name = Visited.site;")

# Show the resulting dataset
joined_data



### Dplyr with databases


# We start with the tbl() function, and give it a database connection and table name
# The resulting dataset can be piped to select and filter to subset, avoiding SQL
# To bring the full dataset into R, we need to run collect()
# Finally, the resulting data gets piped to ggplot and graphed
tbl(conn, "Survey") %>%
     select(person, quant, reading) %>%
     filter(quant == "sal") %>%
     collect() %>%
     ggplot(aes(x = person, y = reading)) + 
          geom_boxplot()


# Always disconnect a database connection when you are done with it
dbDisconnect(conn)