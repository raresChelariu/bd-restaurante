## Restaurante3.14: Calculati ponderea fiecarui furnizor in totalul
## aprovizionarilor din 2023.

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
