## Restaurante3.6: Pentru fiecare manager afisati numarul de subordonati.
## Un subordonat = angajat care lucreaza la acelasi restaurant condus de manager,
## exclusiv managerul insusi.

## ============================================================
## DATA FRAME-URI SI COLOANE IMPLICATE
## ============================================================
## Data frame: manageri
##   - id_manager (cheia spre angajati$id_angajat) -> cine e managerul
##   - id_restaurant -> restaurantul pe care il conduce
## Data frame: angajati (folosit de DOUA ori, in roluri diferite!)
##   1) Pentru a afla numele si prenumele managerului
##      - id_angajat, nume_angajat, prenume_angajat
##   2) Pentru a numara subordonatii din restaurant
##      - id_angajat, id_restaurant

## ============================================================
## EXPLICATIE PAS CU PAS (de la incepator la incepator)
## ============================================================
## Cerinta: pentru fiecare manager, sa stim cati subordonati are.
## Definitie: subordonat = oricine lucreaza la restaurantul lui, in afara de el.
##
## TRUC: in R nu putem da alias-uri ca in SQL (m, a, sub). In schimb,
## redenumim coloanele cand e nevoie cu select(coloana_noua = coloana_veche).
##
## PASUL 1: Calculam numarul de subordonati per manager (intermediar)
##   Pornim de la manageri si pastram doar id_manager si id_restaurant:
##     manageri %>% select(id_manager, id_restaurant)
##   Apoi facem inner_join cu angajati pe id_restaurant. Dar atentie:
##   angajati are si o coloana id_angajat care s-ar suprapune cu id_manager
##   dupa join. Ca sa fie clar, redenumim id_angajat in sub_id:
##     inner_join(angajati %>% select(sub_id = id_angajat, id_restaurant),
##                by = "id_restaurant")
##   Acum fiecare manager e duplicat de cate ori sunt angajati in restaurant.
##
## PASUL 2: Excludem managerul din numaratoare
##   filter(sub_id != id_manager)
##   "!=" e operatorul "diferit de" in R (echivalent cu <> din SQL).
##
## PASUL 3: Numaram subordonatii pe manager
##   group_by(id_manager) %>% summarise(nr_subordonati = n(), .groups = "drop")
##   ".groups = 'drop'" e o conventie buna: spune sa nu pastreze gruparea
##   dupa summarise (altfel R ne arata un avertisment).
##
## PASUL 4: Adaugam numele si prenumele managerului
##   Pornim din nou de la manageri si facem inner_join cu angajati pe
##   id_manager = id_angajat. In dplyr, cand cheile au nume diferite folosim:
##     by = c("id_manager" = "id_angajat")
##
## PASUL 5: Lipim numarul de subordonati cu LEFT JOIN
##   left_join(subordonati, by = "id_manager")
##   De ce left_join si nu inner_join? Ca sa pastram managerii care n-au
##   niciun subordonat. Pentru ei, nr_subordonati va fi NA dupa join.
##   replace_na(nr_subordonati, 0L) inlocuieste NA cu 0 (intreg).
##   "0L" inseamna intreg in R (fara L ar fi numar cu zecimale).
##
## PASUL 6: Aranjam coloanele si sortam
##   select(...) alege coloanele in ordinea dorita.
##   arrange(nume_angajat, prenume_angajat) ordoneaza alfabetic.

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
