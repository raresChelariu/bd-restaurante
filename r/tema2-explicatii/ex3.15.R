## Restaurante3.15: Pentru fiecare restaurant, aflati pozitiile in topul
## vanzarilor pe: luna ianuarie 2023, semestrul 1 din 2023,
## si intreg anul 2023.

## ============================================================
## DATA FRAME-URI SI COLOANE IMPLICATE
## ============================================================
## Data frame: restaurante
##   - id_restaurant, den_rest
## Data frame: mese
##   - id_masa, id_restaurant
## Data frame: comenzi
##   - id_comanda, id_masa, data_ora_comanda
## Data frame: com_bauturi
##   - id_comanda, cantitate_comandata, pret_unitar
## Data frame: com_mancare
##   - id_comanda, pret_unitar

## ============================================================
## EXPLICATIE PAS CU PAS (de la incepator la incepator)
## ============================================================
## Cerinta: pentru fiecare restaurant, 3 clasamente:
##   - pozitia in topul vanzarilor pe ianuarie 2023
##   - pozitia pe semestrul 1 (lunile 1-6) din 2023
##   - pozitia pe intreg anul 2023
##
## COMPLICATIE: vanzarile vin din DOUA surse: bauturi si mancare.
## Trebuie adunate ambele inainte de clasament.
##
## PASUL 1: Calculam vanzarile din BAUTURI per restaurant in "val_bauturi"
##   Drumul: comenzi -> mese (pentru id_restaurant) -> com_bauturi (pentru
##   cantitate * pret).
##   Adaugam cu mutate():
##     an = year(data_ora_comanda)
##     luna = month(data_ora_comanda)
##     valoare = cantitate_comandata * pret_unitar
##   filter(an == 2023) ne lasa cu doar 2023.
##   Apoi group_by(id_restaurant) si summarise() cu 3 coloane diferite,
##   fiecare insumand doar randurile relevante:
##     val_ian_b = sum(valoare[luna == 1])           -> doar ianuarie
##     val_s1_b  = sum(valoare[luna >= 1 & luna <= 6]) -> semestrul 1
##     val_an_b  = sum(valoare)                       -> tot anul
##   Sintaxa "valoare[conditie]" este filtrarea de vector in R - exact
##   echivalentul lui SUM(CASE WHEN ... THEN valoare ELSE 0 END) din SQL.
##
## PASUL 2: Identic pentru MANCARE in "val_mancare"
##   Fara cantitate, doar pret_unitar (asa cum era si in SQL).
##
## PASUL 3: Combinam totul plecand de la "restaurante"
##   Pornim de la restaurante (ca sa includem chiar si pe cele fara comenzi).
##   left_join(val_bauturi) si left_join(val_mancare) - daca un restaurant
##   nu apare in vreuna, coloanele de valori vor fi NA.
##   replace_na(., 0) pune 0 in loc de NA.
##   "across(starts_with('val_'), ~replace_na(., 0))" aplica functia pe
##   toate coloanele care incep cu "val_".
##   Apoi adunam: total_ian = val_ian_b + val_ian_m, etc.
##
## PASUL 4: Atribuim ranguri cu min_rank()
##   min_rank() e echivalentul RANK() din SQL:
##     - daca doi sunt la egalitate, ambii primesc aceeasi pozitie,
##       apoi se sare peste pozitiile urmatoare.
##   Variante in R:
##     - min_rank()   -> echivalent RANK   (1, 1, 3)
##     - dense_rank() -> echivalent DENSE_RANK (1, 1, 2)
##     - row_number() -> echivalent ROW_NUMBER (1, 2, 3)
##   Pentru clasamente, min_rank e cea mai naturala alegere.
##   desc() inverseaza ordinea (vrem cei mai mari primii).
##
## PASUL 5: select() final si arrange() alfabetic
##   Ordonam dupa nume restaurant pentru afisare clara.
##   (Pozitiile raman aceleasi indiferent de ordinea de afisare.)

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
