##############################################################################
## Restaurante3.2: Care sunt angajatii care s-au ocupat de comenzile
##                 clientului Stanescu pe parcursul anului 2023?
## (echivalent R al tema1/ex3.2.sql)
##############################################################################

library(tidyverse)

## Incarca data frames din fisierul .RData generat de create_tables.R
load("../restaurante.RData")


## Echivalent SQL:
## SELECT DISTINCT a.id_angajat, a.nume_angajat, a.prenume_angajat
## FROM comenzi c
## JOIN clienti cl  ON c.id_client     = cl.id_client
## JOIN mese m      ON c.id_masa       = m.id_masa
## JOIN angajati a  ON a.id_restaurant = m.id_restaurant
## JOIN ture t      ON t.id_angajat    = a.id_angajat
##                 AND c.data_ora_comanda BETWEEN t.data_ora_inceput_tura
##                                              AND t.ora_ora_sfarsit_tura
## WHERE cl.nume = 'Stanescu'
##   AND EXTRACT(YEAR FROM c.data_ora_comanda) = 2023
## ORDER BY a.nume_angajat, a.prenume_angajat;

rezultat <- comenzi %>%
    inner_join(clienti, by = "id_client") %>%
    filter(nume == "Stanescu", year(data_ora_comanda) == 2023) %>%
    inner_join(mese, by = "id_masa") %>%
    inner_join(angajati, by = "id_restaurant") %>%
    inner_join(ture, by = "id_angajat") %>%
    filter(data_ora_comanda >= data_ora_inceput_tura,
           data_ora_comanda <= ora_ora_sfarsit_tura) %>%
    distinct(id_angajat, nume_angajat, prenume_angajat) %>%
    arrange(nume_angajat, prenume_angajat)

print(rezultat)
