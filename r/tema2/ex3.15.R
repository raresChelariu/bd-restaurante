## Restaurante3.15: Pentru fiecare restaurant, aflati pozitiile in topul
## vanzarilor pe: luna ianuarie 2023, semestrul 1 din 2023,
## si intreg anul 2023.

library(tidyverse)
load("../restaurante.RData")

val_bauturi <- comenzi %>%
    inner_join(mese %>% select(id_masa, id_restaurant), by = "id_masa") %>%
    inner_join(com_bauturi %>%
                   select(id_comanda, cantitate_comandata, pret_unitar),
               by = "id_comanda") %>%
    mutate(an   = year(data_ora_comanda),
           luna = month(data_ora_comanda),
           valoare = cantitate_comandata * pret_unitar) %>%
    filter(an == 2023) %>%
    group_by(id_restaurant) %>%
    summarise(
        val_ian_b = sum(valoare[luna == 1]),
        val_s1_b  = sum(valoare[luna >= 1 & luna <= 6]),
        val_an_b  = sum(valoare),
        .groups   = "drop"
    )

val_mancare <- comenzi %>%
    inner_join(mese %>% select(id_masa, id_restaurant), by = "id_masa") %>%
    inner_join(com_mancare %>% select(id_comanda, pret_unitar),
               by = "id_comanda") %>%
    mutate(an   = year(data_ora_comanda),
           luna = month(data_ora_comanda),
           valoare = pret_unitar) %>%
    filter(an == 2023) %>%
    group_by(id_restaurant) %>%
    summarise(
        val_ian_m = sum(valoare[luna == 1]),
        val_s1_m  = sum(valoare[luna >= 1 & luna <= 6]),
        val_an_m  = sum(valoare),
        .groups   = "drop"
    )

rezultat <- restaurante %>%
    select(id_restaurant, den_rest) %>%
    left_join(val_bauturi, by = "id_restaurant") %>%
    left_join(val_mancare, by = "id_restaurant") %>%
    mutate(across(starts_with("val_"), ~replace_na(., 0)),
           total_ian = val_ian_b + val_ian_m,
           total_s1  = val_s1_b  + val_s1_m,
           total_an  = val_an_b  + val_an_m) %>%
    mutate(
        pozitie_ianuarie_2023 = min_rank(desc(total_ian)),
        pozitie_sem1_2023     = min_rank(desc(total_s1)),
        pozitie_an_2023       = min_rank(desc(total_an))
    ) %>%
    select(id_restaurant, den_rest,
           pozitie_ianuarie_2023, pozitie_sem1_2023, pozitie_an_2023) %>%
    arrange(den_rest)

print(rezultat)
