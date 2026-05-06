## Restaurante3.14: Calculati ponderea fiecarui furnizor in totalul
## aprovizionarilor din 2023.

## ============================================================
## DATA FRAME-URI SI COLOANE IMPLICATE
## ============================================================
## Data frame: comenzi_produse_furnizori
##   - id_furnizor, data_ora_comanda, pret_total
## Data frame: furnizori
##   - id_furnizor, den_furn

## ============================================================
## EXPLICATIE PAS CU PAS (de la incepator la incepator)
## ============================================================
## Cerinta: pondere = (cat a livrat furnizorul) / (totalul livrarilor) * 100
##
## In SQL am folosit functia de fereastra SUM(SUM(...)) OVER ()
## ca sa avem pe fiecare rand si totalul general, pe langa totalul propriu.
## In R e mult mai simplu: dupa group_by + summarise, putem aplica un
## mutate global care vede toate randurile rezultate.
##
## PASUL 1: Filtram doar pe 2023
##   filter(year(data_ora_comanda) == 2023)
##
## PASUL 2: Adaugam numele furnizorului (pentru afisare)
##   inner_join(furnizori %>% select(id_furnizor, den_furn), by = "id_furnizor")
##   Folosim select() inainte de join ca sa luam doar coloanele utile.
##
## PASUL 3: Calculam totalul per furnizor
##   group_by(id_furnizor, den_furn) %>%
##       summarise(total_furnizor = sum(pret_total))
##   Aici fiecare furnizor are un singur rand, cu suma livrarilor lui.
##
## PASUL 4: Calculam totalul general si ponderea
##   mutate() vede toate randurile dupa summarise (pentru ca am facut "drop"
##   la grupare):
##     total_general = sum(total_furnizor)  -> aceeasi valoare pe toate randurile
##     pondere_procent = round(total_furnizor * 100 / total_general, 2)
##   round(x, 2) rotunjeste la 2 zecimale.
##
## PASUL 5: Sortam descrescator dupa pondere
##   arrange(desc(pondere_procent))
##   Furnizorii cu cea mai mare pondere apar primii.

library(tidyverse)
load("../restaurante.RData")

rezultat <- comenzi_produse_furnizori %>%
    filter(year(data_ora_comanda) == 2023) %>%
    inner_join(furnizori %>% select(id_furnizor, den_furn), by = "id_furnizor") %>%
    group_by(id_furnizor, den_furn) %>%
    summarise(total_furnizor = sum(pret_total), .groups = "drop") %>%
    mutate(total_general   = sum(total_furnizor),
           pondere_procent = round(total_furnizor * 100 / total_general, 2)) %>%
    arrange(desc(pondere_procent))

print(rezultat)
