## Restaurante3.6: Pentru fiecare manager afisati numarul de subordonati.
## Un subordonat = angajat care lucreaza la acelasi restaurant condus de manager,
## exclusiv managerul insusi.

library(tidyverse)
load("../restaurante.RData")

subordonati <- manageri %>%
    select(id_manager, id_restaurant) %>%
    inner_join(angajati %>% select(sub_id = id_angajat, id_restaurant),
               by = "id_restaurant") %>%
    filter(sub_id != id_manager) %>%
    group_by(id_manager) %>%
    summarise(nr_subordonati = n(), .groups = "drop")

rezultat <- manageri %>%
    inner_join(angajati %>% select(id_angajat, nume_angajat, prenume_angajat),
               by = c("id_manager" = "id_angajat")) %>%
    left_join(subordonati, by = "id_manager") %>%
    mutate(nr_subordonati = replace_na(nr_subordonati, 0L)) %>%
    select(id_manager, nume_angajat, prenume_angajat, nr_subordonati) %>%
    arrange(nume_angajat, prenume_angajat)

print(rezultat)
