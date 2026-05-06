## Restaurante3.5: Cate persoane au fost angajate in 2023?

## ============================================================
## DATA FRAME-URI SI COLOANE IMPLICATE
## ============================================================
## Data frame: angajati
##   - data_angajarii (Date) -> data la care a fost angajata persoana
##   - folosim functia n() in summarise() ca sa numaram randurile

## ============================================================
## EXPLICATIE PAS CU PAS (de la incepator la incepator)
## ============================================================
## Salut! Cerinta zice "cate persoane au fost angajate in 2023".
## "Cate" => trebuie sa numaram (echivalentul lui COUNT din SQL).
## "Persoane angajate" => randurile din data frame-ul "angajati".
## "In 2023" => trebuie sa filtram dupa anul din data_angajarii.
##
## PASUL 1: De unde luam datele?
##   Pornim de la angajati. In dplyr scriem:
##     angajati %>%
##   "%>%" se numeste pipe si se citeste "apoi". Trimite rezultatul mai
##   departe in functia urmatoare.
##
## PASUL 2: Cum filtram doar 2023?
##   Avem coloana data_angajarii (tip Date, ex: 2023-05-12).
##   Pentru a scoate anul folosim year() din lubridate (inclus in tidyverse):
##     year(data_angajarii)  -> 2023
##   Apoi punem conditia in filter():
##     filter(year(data_angajarii) == 2023)
##   ATENTIE: in R folosim "==" pentru egalitate, NU "=" (ala e atribuire).
##
## PASUL 3: Cum numaram?
##   Folosim summarise() impreuna cu n() (numara randurile din grup):
##     summarise(nr_angajati_2023 = n())
##   Dam si un nume frumos coloanei rezultate (echivalent cu AS din SQL).
##
## PASUL 4: Salvam rezultatul si il afisam
##   "rezultat <- ..."  e atribuirea in R (echivalent cu = din alte limbaje).
##   print(rezultat) afiseaza tabelul in consola.

library(tidyverse)
load("../restaurante.RData")

rezultat <- angajati %>%
    filter(year(data_angajarii) == 2023) %>%
    summarise(nr_angajati_2023 = n())

print(rezultat)
