##############################################################################
## Baze de date - Restaurante3
## Importul tabelelor din PostgreSQL in R
## (echivalent R al create_tables.sql)
##############################################################################
## Presupune ca baza de date `restaurante` exista in PostgreSQL si are
## tabelele create (via create_tables.sql) si populate (via populate.R).
## Importa fiecare tabel ca data frame, apoi salveaza totul in restaurante.RData.
##############################################################################

# install.packages('tidyverse')
library(tidyverse)

## Curata memoria
rm(list = ls())

# install.packages('RPostgres')
library(RPostgres)


###  A. Deschide conexiunea la baza de date PostgreSQL

## Windows: serviciul PostgreSQL trebuie sa fie pornit
con <- dbConnect(RPostgres::Postgres(), dbname = "restaurante", user = "postgres",
                 host = "localhost", password = "postgres")


###  B. Afiseaza numele tabelelor din baza de date

tables <- dbGetQuery(con,
    "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")
tables


###  C. Importa fiecare tabel PostgreSQL ca data frame in R

for (i in 1:nrow(tables)) {
    temp <- dbGetQuery(con, paste("SELECT * FROM", tables[i, 1], sep = " "))
    assign(tables[i, 1], temp)
}


###  D. Inchide conexiunea si curata obiectele temporare
dbDisconnect(con)
rm(con, temp, i, tables)


###  E. Salveaza toate data frame-urile intr-un singur fisier .RData
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
save.image(file = "restaurante.RData")
