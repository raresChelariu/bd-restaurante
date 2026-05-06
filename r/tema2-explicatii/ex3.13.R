## Restaurante3.13: Care sunt produsele comandate de macar toti clientii
## care au comandat produsul X?
## Inlocuiti valoarea variabilei `X` cu id-ul real al produsului de referinta.

## ============================================================
## DATA FRAME-URI SI COLOANE IMPLICATE
## ============================================================
## Data frame: comenzi
##   - id_comanda, id_client
## Data frame: com_bauturi
##   - id_comanda, id_bautura
## Data frame: bauturi
##   - id_bautura, id_produs
## Data frame: com_mancare
##   - id_comanda, id_sortiment_mancare
## Data frame: meniuri_mancare
##   - id_sortiment_mancare, id_produs
## Data frame: produse
##   - id_produs, den_produs

## ============================================================
## EXPLICATIE PAS CU PAS (de la incepator la incepator)
## ============================================================
## Aceasta e "impartirea relationala" - cea mai grea problema clasica de SQL.
##
## ENUNTUL TRADUS: caut produsele P astfel incat orice client care a comandat
## produsul X a comandat si produsul P. Cu alte cuvinte, P "acopera" toti
## clientii lui X.
##
## In SQL am folosit dublu NOT EXISTS. In R folosim aceeasi idee, dar
## mult mai usor de citit, prin anti_join + expand_grid:
##   "P trece daca pentru fiecare client_X, perechea (client_X, P) exista
##   efectiv intre comenzi - adica nu lipseste nicio combinatie."
##
## PASUL 1: Construim toate perechile (client, produs) comandate
##   Un client poate comanda un produs in doua moduri: bautura sau mancare.
##   Le facem pe ambele si le unim cu bind_rows().
##   Apoi distinct() ca sa avem fiecare pereche o singura data
##   (echivalent UNION din SQL, care elimina duplicatele).
##   Drumul prin bauturi: com_bauturi -> comenzi (id_client) -> bauturi (id_produs)
##   Drumul prin mancare: com_mancare -> comenzi (id_client) -> meniuri_mancare (id_produs)
##
## PASUL 2: Identificam clientii care au comandat produsul X
##   filter(id_produs == X) %>% distinct(id_client)
##   Asta e "publicul tinta": clientii pe care produsele candidate trebuie
##   sa-i acopere.
##
## PASUL 3: Identificam produsele candidate (toate, fara X)
##   filter(id_produs != X) %>% distinct(id_produs)
##   Excludem X ca sa nu apara in rezultat (s-ar acoperi banal pe sine).
##
## PASUL 4: Toate combinatiile cerute (matricea client_X x candidat)
##   expand_grid(id_client = ..., id_produs = ...)
##   expand_grid creeaza produsul cartezian: toate perechile posibile.
##   Daca avem 5 clienti X si 20 candidati, obtinem 100 de perechi.
##
## PASUL 5: Combinatiile efectiv comandate
##   semi_join(clienti_X, by = "id_client") -> pastreaza doar randurile in
##     care id_client e printre clientii_X.
##   semi_join(candidati, by = "id_produs") -> idem pentru produse candidate.
##   semi_join e ca un filtru bazat pe alt tabel (echivalent EXISTS).
##
## PASUL 6: Combinatiile lipsa
##   anti_join(actual, by = c(...)) -> "din required, scoate randurile care
##   apar in actual". Ce ramane sunt combinatiile (client_X, P) care
##   NU exista in date.
##   anti_join e exact echivalentul lui NOT EXISTS din SQL.
##
## PASUL 7: Rezultat = produsele care NU au combinatie lipsa
##   produse %>% filter(id_produs != X) %>% anti_join(lipsa, by = "id_produs")
##   Daca un produs P apare in "lipsa" inseamna ca cel putin un client_X
##   nu a comandat P -> P NU trece testul.
##   anti_join sterge produsele care apar in "lipsa", lasand doar produsele
##   care trec testul (acopera TOTI clientii_X).

library(tidyverse)
load("../restaurante.RData")

X <- 1

comenzi_produs <- bind_rows(
    com_bauturi %>%
        inner_join(comenzi %>% select(id_comanda, id_client), by = "id_comanda") %>%
        inner_join(bauturi %>% select(id_bautura, id_produs), by = "id_bautura") %>%
        select(id_client, id_produs),
    com_mancare %>%
        inner_join(comenzi %>% select(id_comanda, id_client), by = "id_comanda") %>%
        inner_join(meniuri_mancare %>% select(id_sortiment_mancare, id_produs),
                   by = "id_sortiment_mancare") %>%
        select(id_client, id_produs)
) %>%
    distinct()

clienti_X <- comenzi_produs %>%
    filter(id_produs == X) %>%
    distinct(id_client)

candidati <- produse %>%
    filter(id_produs != X) %>%
    distinct(id_produs)

required <- expand_grid(id_client = clienti_X$id_client,
                        id_produs = candidati$id_produs)

actual <- comenzi_produs %>%
    semi_join(clienti_X, by = "id_client") %>%
    semi_join(candidati, by = "id_produs")

lipsa <- required %>%
    anti_join(actual, by = c("id_client", "id_produs"))

rezultat <- produse %>%
    filter(id_produs != X) %>%
    anti_join(lipsa, by = "id_produs") %>%
    select(id_produs, den_produs) %>%
    arrange(id_produs)

print(rezultat)
