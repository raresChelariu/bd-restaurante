## Restaurante3.9: Pentru fiecare client si luna calendaristica, afisati
## numarul rezervarilor, cu un subtotal la nivel de an calendaristic
## si un total general.

## ============================================================
## DATA FRAME-URI SI COLOANE IMPLICATE
## ============================================================
## Data frame: rezervari
##   - id_client, data_ora_rezervare
## Data frame: clienti
##   - id_client, nume, prenume

## ============================================================
## EXPLICATIE PAS CU PAS (de la incepator la incepator)
## ============================================================
## Cerinta este in 3 niveluri:
##   1) DETALIU: client x an x luna -> numar rezervari
##   2) SUBTOTAL: client x an -> total pe acel an
##   3) TOTAL GENERAL: total pe toata lumea
##
## In SQL aveam GROUPING SETS - in R nu exista direct, dar facem
## acelasi lucru calculand cele 3 niveluri separat si apoi le lipim
## una sub alta cu bind_rows().
##
## PASUL 1: Pregatim datele de baza intr-un data frame numit "baza"
##   inner_join intre rezervari si clienti pentru nume si prenume.
##   Apoi extragem an si luna din timestamp.
##   Niciun group_by inca - doar pregatim "materia prima".
##
## PASUL 2: Calculam DETALIUL (cel mai detaliat nivel)
##   group_by(id_client, nume, prenume, an, luna) %>% summarise(n = n())
##   Aici avem un rand pentru fiecare combinatie distincta.
##
## PASUL 3: Calculam SUBTOTALUL pe an
##   group_by(id_client, nume, prenume, an) %>% summarise(n = n())
##   Apoi adaugam o coloana "luna = NA_integer_" ca sa avem aceleasi
##   coloane ca la detaliu (necesar pentru bind_rows).
##   "NA_integer_" e versiunea NA pentru intregi (R are NA pentru fiecare tip).
##
## PASUL 4: Calculam TOTALUL GENERAL
##   summarise(n = n()) fara group_by -> un singur rand.
##   Apoi adaugam toate coloanele lipsa cu mutate(... = NA_...).
##   Tipul NA trebuie sa fie compatibil cu coloana din detaliu:
##     id_client e numeric -> NA_real_
##     nume si prenume sunt text -> NA_character_
##     an si luna sunt intregi -> NA_integer_
##
## PASUL 5: Lipim cele trei niveluri
##   bind_rows(detaliu, subtotal_an, total_general)
##   Aseaza randurile unul sub altul, completand cu NA coloanele lipsa
##   (dar aici toate au aceleasi coloane).
##
## PASUL 6: select() pentru ordinea coloanelor + arrange()
##   arrange(id_client, an, luna) sorteaza crescator.
##   ATENTIE: arrange() pune NA la SFARSIT implicit - exact ce vrem,
##   ca subtotalurile (cu luna NA) sa apara dupa detaliu, iar totalul
##   general (cu toate NA) sa fie ultimul.

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
