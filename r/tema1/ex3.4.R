##############################################################################
## Restaurante3.4: Afisati, in dreptul fiecarei rezervari din 2024,
##                 daca este o rezervare pentru intreg restaurantul,
##                 pentru (cel putin) o masa, sau mixta.
## (echivalent R al tema1/ex3.4.sql)
##############################################################################

library(tidyverse)

## Incarca data frames din fisierul .RData generat de create_tables.R
load("../restaurante.RData")


## Echivalent SQL:
## SELECT r.id_rezervare, r.data_ora_rezervare,
##   CASE
##     WHEN EXISTS (SELECT 1 FROM rezervari_restaurante rr WHERE rr.id_rezervare = r.id_rezervare)
##      AND EXISTS (SELECT 1 FROM rezervari_mese       rm WHERE rm.id_rezervare = r.id_rezervare)
##         THEN 'mixta'
##     WHEN EXISTS (SELECT 1 FROM rezervari_restaurante rr WHERE rr.id_rezervare = r.id_rezervare)
##         THEN 'restaurant intreg'
##     ELSE 'cel putin o masa'
##   END AS tip_rezervare
## FROM rezervari r
## WHERE EXTRACT(YEAR FROM r.data_ora_rezervare) = 2024
## ORDER BY r.data_ora_rezervare;

## Pregateste indicatori de prezenta pentru fiecare tip de rezervare
are_restaurant <- rezervari_restaurante %>%
    distinct(id_rezervare) %>%
    mutate(are_rest = TRUE)

are_masa <- rezervari_mese %>%
    distinct(id_rezervare) %>%
    mutate(are_masa = TRUE)

rezultat <- rezervari %>%
    filter(year(data_ora_rezervare) == 2024) %>%
    left_join(are_restaurant, by = "id_rezervare") %>%
    left_join(are_masa, by = "id_rezervare") %>%
    mutate(tip_rezervare = case_when(
        !is.na(are_rest) & !is.na(are_masa) ~ "mixta",
        !is.na(are_rest)                    ~ "restaurant intreg",
        TRUE                                ~ "cel putin o masa"
    )) %>%
    select(id_rezervare, data_ora_rezervare, tip_rezervare) %>%
    arrange(data_ora_rezervare)

print(rezultat)
