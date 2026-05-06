## Restaurante3.8: Care este cel mai mare numar de rezervari
## pentru o luna calendaristica?

library(tidyverse)
load("../restaurante.RData")

rezultat <- rezervari %>%
    mutate(an = year(data_ora_rezervare),
           luna = month(data_ora_rezervare)) %>%
    count(an, luna, name = "nr_rezervari") %>%
    summarise(max_rezervari_pe_luna = max(nr_rezervari))

print(rezultat)
