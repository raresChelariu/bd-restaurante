##############################################################################
## Restaurante3.3: Care sunt comenzile care contin si mancare, si bautura?
## (echivalent R al tema1/ex3.3.sql)
##############################################################################

library(tidyverse)

## Incarca data frames din fisierul .RData generat de create_tables.R
load("../restaurante.RData")


## Echivalent SQL:
## SELECT id_comanda FROM com_mancare
## INTERSECT
## SELECT id_comanda FROM com_bauturi
## ORDER BY id_comanda;

rezultat <- dplyr::intersect(
    com_mancare %>% select(id_comanda),
    com_bauturi %>% select(id_comanda)
) %>%
    arrange(id_comanda)

print(rezultat)
