## Restaurante3.12: Care sunt comenzile care contin mai multe bauturi
## decat comanda X? "Mai multe bauturi" = cantitate totala mai mare.
## Inlocuiti valoarea variabilei `X` cu id-ul real al comenzii de referinta.

## ============================================================
## DATA FRAME-URI SI COLOANE IMPLICATE
## ============================================================
## Data frame: com_bauturi
##   - id_comanda, cantitate_comandata

## ============================================================
## EXPLICATIE PAS CU PAS (de la incepator la incepator)
## ============================================================
## Cerinta: vreau comenzile cu mai multe bauturi (ca volum) decat o anumita
## comanda de referinta X.
##
## In SQL aveam HAVING SUM(...) > (subconsultare cu SUM pentru X).
## In R nu avem subconsultari direct - dar putem calcula valoarea de
## referinta separat si o folosim apoi in filter().
##
## PASUL 1: Setam id-ul comenzii de referinta intr-o variabila
##   X <- 1   (inlocuieste cu valoarea ta reala)
##
## PASUL 2: Calculam totalul pentru comanda X intr-o variabila numita "referinta"
##   filter(id_comanda == X) -> pastreaza doar liniile pentru comanda X
##   summarise(total = sum(cantitate_comandata)) -> obtinem un data frame
##     cu o singura coloana "total" si un singur rand.
##   pull(total) -> extrage valoarea ca numar simplu (nu data frame).
##   Asta e necesar ca s-o putem compara mai jos.
##
## PASUL 3: Calculam totalul pentru fiecare comanda
##   group_by(id_comanda) %>% summarise(total_bauturi = sum(cantitate_comandata))
##   Acum avem cate un rand pe comanda, cu cantitatea totala.
##
## PASUL 4: Pastram doar comenzile cu total > referinta
##   filter(total_bauturi > referinta)
##
## PASUL 5: Sortam descrescator
##   arrange(desc(total_bauturi))
##   desc() pune coloana in ordine descrescatoare (echivalent ORDER BY ... DESC).
##
## OBSERVATIE: comanda X insasi NU apare in rezultat - pentru ca ea are
## total egal cu referinta, nu strict mai mare.

library(tidyverse)
load("../restaurante.RData")

X <- 1

referinta <- com_bauturi %>%
    filter(id_comanda == X) %>%
    summarise(total = sum(cantitate_comandata)) %>%
    pull(total)

rezultat <- com_bauturi %>%
    group_by(id_comanda) %>%
    summarise(total_bauturi = sum(cantitate_comandata), .groups = "drop") %>%
    filter(total_bauturi > referinta) %>%
    arrange(desc(total_bauturi))

print(rezultat)
