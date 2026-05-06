## Restaurante3.11: Afisati primele trei comenzi pentru fiecare restaurant
## din orasul X (in ordine cronologica).
## Inlocuiti valoarea variabilei `oras` cu numele real al localitatii.

## ============================================================
## DATA FRAME-URI SI COLOANE IMPLICATE
## ============================================================
## Data frame: comenzi
##   - id_comanda, data_ora_comanda, id_masa
## Data frame: mese
##   - id_masa, id_restaurant
## Data frame: restaurante
##   - id_restaurant, den_rest, id_localitate
## Data frame: localitati
##   - id_localitate, nume_localitate

## ============================================================
## EXPLICATIE PAS CU PAS (de la incepator la incepator)
## ============================================================
## Cerinta: pentru fiecare restaurant din orasul X, primele 3 comenzi
## in ordine cronologica.
##
## PROBLEMA: nu e un simplu arrange() + slice(1:3). Avem nevoie de
## "Top N per grup" - cele 3 comenzi se aleg PER restaurant.
##
## In SQL am folosit ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...).
## In R facem la fel cu group_by() + arrange() + row_number().
##
## PASUL 1: Setam orasul intr-o variabila pentru reutilizare
##   oras <- "Bucuresti"
##   Apoi folosim variabila in filter(): nume_localitate == oras.
##
## PASUL 2: Legam tabelele in lant
##   Trebuie sa ajungem de la comanda pana la oras:
##     comenzi -> mese -> restaurante -> localitati
##   inner_join() pentru fiecare pas, cu select() inainte ca sa luam doar
##   coloanele de care avem nevoie (evita conflicte si mentine codul curat).
##
## PASUL 3: Filtram pe orasul X
##   filter(nume_localitate == oras)
##
## PASUL 4: Numerotam comenzile in fiecare restaurant
##   group_by(id_restaurant) %>% arrange(data_ora_comanda, .by_group = TRUE)
##   ".by_group = TRUE" este IMPORTANT: spune lui arrange() sa pastreze
##   gruparea si sa sorteze IN INTERIORUL fiecarui grup.
##   Apoi mutate(rang = row_number()) -> numara 1, 2, 3, ... in fiecare grup.
##   ungroup() la final ca sa scoatem gruparea (nu mai avem nevoie de ea).
##
## PASUL 5: Pastram doar primele 3 din fiecare grup
##   filter(rang <= 3)
##
## PASUL 6: select() cu redenumire si arrange() final
##   "restaurant = den_rest" redenumeste pe loc coloana in select()
##   (echivalent cu "AS restaurant" din SQL).
##   arrange(restaurant, rang) ordoneaza pentru afisare.

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
