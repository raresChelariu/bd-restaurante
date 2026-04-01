##############################################################################
## Restaurante3.1: In ce ani s-au facut angajari?
## (echivalent R al tema1/ex3.1.sql)
##############################################################################

library(tidyverse)

## Incarca data frames din fisierul .RData generat de create_tables.R
load("../restaurante.RData")


## Echivalent SQL:
## SELECT DISTINCT EXTRACT(YEAR FROM data_angajarii)::INT AS an_angajare
## FROM angajati
## ORDER BY an_angajare;

rezultat <- angajati %>%
    mutate(an_angajare = year(data_angajarii)) %>%
    distinct(an_angajare) %>%
    arrange(an_angajare)

print(rezultat)
