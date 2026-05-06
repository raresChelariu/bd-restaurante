## Restaurante3.11: Afisati primele trei comenzi pentru fiecare restaurant
## din orasul X (in ordine cronologica).
## Inlocuiti valoarea variabilei `oras` cu numele real al localitatii.

library(tidyverse)
load("../restaurante.RData")

oras <- "Bucuresti"

rezultat <- comenzi %>%
    inner_join(mese %>% select(id_masa, id_restaurant), by = "id_masa") %>%
    inner_join(restaurante %>% select(id_restaurant, den_rest, id_localitate),
               by = "id_restaurant") %>%
    inner_join(localitati %>% select(id_localitate, nume_localitate),
               by = "id_localitate") %>%
    filter(nume_localitate == oras) %>%
    group_by(id_restaurant) %>%
    arrange(data_ora_comanda, .by_group = TRUE) %>%
    mutate(rang = row_number()) %>%
    ungroup() %>%
    filter(rang <= 3) %>%
    select(restaurant = den_rest, id_comanda, data_ora_comanda, rang) %>%
    arrange(restaurant, rang)

print(rezultat)
