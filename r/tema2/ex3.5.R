## Restaurante3.5: Cate persoane au fost angajate in 2023?

library(tidyverse)
load("../restaurante.RData")

rezultat <- angajati %>%
    filter(year(data_angajarii) == 2023) %>%
    summarise(nr_angajati_2023 = n())

print(rezultat)
