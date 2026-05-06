## Restaurante3.12: Care sunt comenzile care contin mai multe bauturi
## decat comanda X? "Mai multe bauturi" = cantitate totala mai mare.
## Inlocuiti valoarea variabilei `X` cu id-ul real al comenzii de referinta.

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
