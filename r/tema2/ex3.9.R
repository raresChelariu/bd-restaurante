## Restaurante3.9: Pentru fiecare client si luna calendaristica, afisati
## numarul rezervarilor, cu un subtotal la nivel de an calendaristic
## si un total general.

library(tidyverse)
load("../restaurante.RData")

baza <- rezervari %>%
    inner_join(clienti %>% select(id_client, nume, prenume), by = "id_client") %>%
    mutate(an = year(data_ora_rezervare),
           luna = month(data_ora_rezervare)) %>%
    select(id_client, nume, prenume, an, luna)

detaliu <- baza %>%
    group_by(id_client, nume, prenume, an, luna) %>%
    summarise(nr_rezervari = n(), .groups = "drop")

subtotal_an <- baza %>%
    group_by(id_client, nume, prenume, an) %>%
    summarise(nr_rezervari = n(), .groups = "drop") %>%
    mutate(luna = NA_integer_)

total_general <- baza %>%
    summarise(nr_rezervari = n()) %>%
    mutate(id_client = NA_real_,
           nume      = NA_character_,
           prenume   = NA_character_,
           an        = NA_integer_,
           luna      = NA_integer_)

rezultat <- bind_rows(detaliu, subtotal_an, total_general) %>%
    select(id_client, nume, prenume, an, luna, nr_rezervari) %>%
    arrange(id_client, an, luna)

print(rezultat)
