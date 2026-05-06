## Restaurante3.7: Pentru fiecare produs, afisati pe coloane separate
## valoarea comenzilor pentru anii 2021, 2022 si 2023.

library(tidyverse)
load("../restaurante.RData")

val_bauturi <- com_bauturi %>%
    inner_join(comenzi %>% select(id_comanda, data_ora_comanda),
               by = "id_comanda") %>%
    inner_join(bauturi %>% select(id_bautura, id_produs),
               by = "id_bautura") %>%
    mutate(an = year(data_ora_comanda),
           valoare = cantitate_comandata * pret_unitar) %>%
    select(id_produs, an, valoare)

val_mancare <- com_mancare %>%
    inner_join(comenzi %>% select(id_comanda, data_ora_comanda),
               by = "id_comanda") %>%
    inner_join(meniuri_mancare %>% select(id_sortiment_mancare, id_produs),
               by = "id_sortiment_mancare") %>%
    mutate(an = year(data_ora_comanda),
           valoare = pret_unitar) %>%
    select(id_produs, an, valoare)

valori <- bind_rows(val_bauturi, val_mancare)

rezultat <- produse %>%
    left_join(
        valori %>%
            group_by(id_produs) %>%
            summarise(
                valoare_2021 = sum(valoare[an == 2021]),
                valoare_2022 = sum(valoare[an == 2022]),
                valoare_2023 = sum(valoare[an == 2023]),
                .groups = "drop"
            ),
        by = "id_produs"
    ) %>%
    mutate(across(starts_with("valoare_"), ~replace_na(., 0))) %>%
    select(id_produs, den_produs, valoare_2021, valoare_2022, valoare_2023) %>%
    arrange(id_produs)

print(rezultat)
