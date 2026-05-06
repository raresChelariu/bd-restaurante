## Restaurante3.10: Afisati, in dreptul fiecarei rezervari din 2024,
## tipul rezervarii (restaurant intreg / cel putin o masa / mixta).
## Solutia nu foloseste UNION / INTERSECT.

## ============================================================
## DATA FRAME-URI SI COLOANE IMPLICATE
## ============================================================
## Data frame: rezervari
##   - id_rezervare, data_ora_rezervare
## Data frame: rezervari_restaurante (rezervari pentru restaurant intreg)
##   - id_rezervare
## Data frame: rezervari_mese (rezervari pentru o anumita masa)
##   - id_rezervare

## ============================================================
## EXPLICATIE PAS CU PAS (de la incepator la incepator)
## ============================================================
## O rezervare poate fi:
##   - "restaurant intreg" -> apare doar in rezervari_restaurante
##   - "cel putin o masa"  -> apare doar in rezervari_mese
##   - "mixta"             -> apare in AMBELE
##
## IDEEA: pentru fiecare rezervare verificam in cele doua tabele.
##
## PASUL 1: Pregatim "indicatori" pentru fiecare tabela
##   are_restaurant: lista cu id_rezervare unice + o coloana are_rest = TRUE
##   are_masa:       lista cu id_rezervare unice + o coloana are_masa = TRUE
##   distinct() elimina duplicatele (echivalent SELECT DISTINCT).
##   mutate(are_rest = TRUE) adauga o coloana cu valoarea TRUE peste tot.
##   Cand vom face left_join, daca o rezervare NU se gaseste, are_rest va fi NA.
##
## PASUL 2: Pornim de la rezervari, filtrate pe 2024
##   filter(year(data_ora_rezervare) == 2024)
##
## PASUL 3: LEFT JOIN cu cei doi indicatori
##   left_join(are_restaurant, by = "id_rezervare")
##   left_join(are_masa,       by = "id_rezervare")
##   Dupa join avem doua coloane noi: are_rest si are_masa.
##   Fiecare e fie TRUE (apare in tabela respectiva) fie NA (nu apare).
##
## PASUL 4: case_when() decide tipul (echivalent CASE WHEN din SQL)
##   case_when(
##       conditie1 ~ valoare1,
##       conditie2 ~ valoare2,
##       TRUE      ~ valoare_default
##   )
##   "~" se citeste "atunci". "TRUE ~ ..." e ELSE-ul din SQL.
##   ATENTIE la ordine: verificam mai intai cazul "mixt" (ambele NOT NA),
##   apoi doar restaurant. ELSE-ul (TRUE ~ ...) prinde cazul cu doar masa.
##   Operatori logici in R:
##     !is.na(x) -> "x NU e NA" (echivalent IS NOT NULL)
##     &         -> AND logic
##     |         -> OR logic
##
## PASUL 5: select() finala si arrange()
##   Pastram doar coloanele relevante si sortam dupa data_ora_rezervare.

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
