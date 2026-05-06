## Restaurante3.8: Care este cel mai mare numar de rezervari
## pentru o luna calendaristica?

## ============================================================
## DATA FRAME-URI SI COLOANE IMPLICATE
## ============================================================
## Data frame: rezervari
##   - data_ora_rezervare (POSIXct - timestamp) -> de aici scoatem an si luna

## ============================================================
## EXPLICATIE PAS CU PAS (de la incepator la incepator)
## ============================================================
## Cerinta: care e cea mai aglomerata luna (in numar de rezervari).
## Trebuie facut in DOUA pasuri:
##   1) numar rezervari pe fiecare (an, luna) -> obtinem o lista de numere
##   2) iau MAXIMUL din acele numere
##
## PASUL 1: Adaugam coloanele "an" si "luna"
##   data_ora_rezervare e un timestamp. Cu lubridate (din tidyverse) avem:
##     year(data)  -> anul
##     month(data) -> luna ca numar (1..12)
##   Le adaugam cu mutate():
##     mutate(an = year(data_ora_rezervare), luna = month(data_ora_rezervare))
##
## PASUL 2: Numaram rezervarile pe fiecare (an, luna)
##   In dplyr exista o scurtatura: count(an, luna) e echivalent cu
##   group_by(an, luna) %>% summarise(n = n()).
##   Folosim "name = 'nr_rezervari'" ca sa dam un nume frumos coloanei
##   (in loc de "n" implicit).
##
## PASUL 3: Luam maximul
##   summarise(max_rezervari_pe_luna = max(nr_rezervari))
##   max() returneaza cea mai mare valoare din coloana.
##
## SCURTAT: tot codul incape intr-un singur lant cu pipe.

library(tidyverse)
load("../restaurante.RData")

rezultat <- rezervari %>%
    mutate(an = year(data_ora_rezervare),
           luna = month(data_ora_rezervare)) %>%
    count(an, luna, name = "nr_rezervari") %>%
    summarise(max_rezervari_pe_luna = max(nr_rezervari))

print(rezultat)
