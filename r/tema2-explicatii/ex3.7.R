## Restaurante3.7: Pentru fiecare produs, afisati pe coloane separate
## valoarea comenzilor pentru anii 2021, 2022 si 2023.

## ============================================================
## DATA FRAME-URI SI COLOANE IMPLICATE
## ============================================================
## Data frame: produse
##   - id_produs, den_produs
## Data frame: bauturi
##   - id_bautura, id_produs (face legatura cu produse)
## Data frame: meniuri_mancare
##   - id_sortiment_mancare, id_produs (face legatura cu produse)
## Data frame: comenzi
##   - id_comanda, data_ora_comanda
## Data frame: com_bauturi
##   - id_comanda, id_bautura, cantitate_comandata, pret_unitar
## Data frame: com_mancare
##   - id_comanda, id_sortiment_mancare, pret_unitar

## ============================================================
## EXPLICATIE PAS CU PAS (de la incepator la incepator)
## ============================================================
## Cerinta: pentru fiecare produs, valoarea comenzilor pe ani separate.
## Iesirea trebuie sa arate cam asa:
##   id_produs | den_produs | valoare_2021 | valoare_2022 | valoare_2023
##
## PROBLEMA: produsele se vand in DOUA forme:
##   1) Ca BAUTURA (in com_bauturi)
##   2) Ca MANCARE (in com_mancare)
## Trebuie sa le combinam.
##
## PASUL 1: Calculam valoarea pentru BAUTURI in tabelul "val_bauturi"
##   Drumul: com_bauturi -> comenzi (pentru data) -> bauturi (pentru id_produs).
##   inner_join leaga doua tabele pe baza coloanei comune (echivalent cu JOIN).
##   Folosim select() inainte de join ca sa luam doar coloanele de care avem
##   nevoie - asta evita conflictele de nume si tine codul curat.
##   mutate() adauga coloane noi (echivalent cu expresia de SELECT in SQL):
##     an = year(data_ora_comanda)
##     valoare = cantitate_comandata * pret_unitar
##
## PASUL 2: Calculam valoarea pentru MANCARE in tabelul "val_mancare"
##   La fel, dar din com_mancare. Aici nu avem cantitate, doar pret_unitar
##   (presupunem ca e pretul total deja).
##
## PASUL 3: Lipim cele doua tabele cu bind_rows
##   bind_rows(t1, t2) este echivalentul lui UNION ALL din SQL: aseaza
##   randurile unul sub altul, fara sa elimine duplicate.
##   Rezultatul il punem in "valori".
##
## PASUL 4: Pivotam: ani pe coloane
##   In SQL am folosit SUM(CASE WHEN an = 2021 THEN valoare END).
##   In R folosim filtrarea de vector intr-un summarise:
##     valoare_2021 = sum(valoare[an == 2021])
##   Sintaxa "valoare[an == 2021]" inseamna "ia doar valorile unde an=2021".
##   Apoi sum() le aduna. Daca nu exista nicio valoare pentru anul respectiv,
##   sum() pe vector gol returneaza 0 - exact ce vrem.
##   Grupam dupa id_produs ca sa avem o suma per produs.
##
## PASUL 5: LEFT JOIN ca sa apara TOATE produsele (chiar fara comenzi)
##   produse %>% left_join(valori_pivotate, by = "id_produs")
##   Daca un produs nu apare in "valori", coloanele de valori vor fi NA.
##   replace_na(., 0) le inlocuieste cu 0. Sintaxa "across(starts_with(...))"
##   aplica aceeasi transformare pe mai multe coloane simultan (toate cele
##   care incep cu "valoare_").
##
## PASUL 6: Selectam coloanele finale si sortam
##   select() alege ordinea coloanelor.
##   arrange(id_produs) sorteaza dupa id (echivalent cu ORDER BY).

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
