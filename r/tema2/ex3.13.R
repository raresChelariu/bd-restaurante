## Restaurante3.13: Care sunt produsele comandate de macar toti clientii
## care au comandat produsul X?
## Inlocuiti valoarea variabilei `X` cu id-ul real al produsului de referinta.

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
