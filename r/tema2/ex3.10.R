## Restaurante3.10: Afisati, in dreptul fiecarei rezervari din 2024,
## tipul rezervarii (restaurant intreg / cel putin o masa / mixta).
## Solutia nu foloseste UNION / INTERSECT.

library(tidyverse)
load("../restaurante.RData")

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
