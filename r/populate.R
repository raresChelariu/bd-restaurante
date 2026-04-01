##############################################################################
## Baze de date - Restaurante3
## Popularea tabelelor PostgreSQL din R
## (echivalent R al populate.sql)
##############################################################################
## Presupune ca baza de date `restaurante` exista si tabelele sunt create
## (via create_tables.sql). Ruleaza INAINTE de create_tables.R.
## Ordinea inserarii respecta dependentele FK.
##############################################################################

library(DBI)
library(RPostgres)

## Curata memoria
rm(list = ls())


###  A. Conexiune PostgreSQL

con <- dbConnect(RPostgres::Postgres(), dbname = "restaurante", user = "postgres",
                 host = "localhost", password = "postgres")


###  B. Stergere date existente (ordine inversa FK)

for (tbl in c("comenzi_produse_furnizori", "rezervari_mese", "rezervari_restaurante",
              "rezervari", "bonuri_fiscale", "com_mancare", "com_bauturi", "comenzi",
              "ture", "bucatari", "chelneri", "manageri", "angajati", "mese",
              "meniuri_mancare", "bauturi", "furnizori", "restaurante", "produse",
              "clienti", "localitati")) {
    dbExecute(con, paste("DELETE FROM", tbl))
}


###  C. 1. LOCALITATI

localitati <- data.frame(
    id_localitate   = c(1, 2, 3),
    nume_localitate = c("Bucuresti", "Cluj-Napoca", "Iasi"),
    judet           = c("Ilfov", "Cluj", "Iasi"),
    stringsAsFactors = FALSE
)
dbWriteTable(con, "localitati", localitati, append = TRUE, row.names = FALSE)


###  D. 2. CLIENTI

clienti <- data.frame(
    id_client = c(1, 2, 3, 4, 5),
    nume      = c("Stanescu", "Radu", "Georgescu", "Petrescu", "Marin"),
    prenume   = c("Mihai", "Ana Maria", "Alexandru", "Ioana", "Bogdan"),
    telefon   = c("0722-111-222", "0744-333-444", "0766-555-666", "0788-777-888", "0755-999-000"),
    e_mail    = c("mihai.stanescu@gmail.com", "ana.radu@yahoo.com", "alex.georgescu@gmail.com",
                  "ioana.petrescu@hotmail.com", "bogdan.marin@gmail.com"),
    stringsAsFactors = FALSE
)
dbWriteTable(con, "clienti", clienti, append = TRUE, row.names = FALSE)


###  E. 3. PRODUSE

produse <- data.frame(
    id_produs        = 1:14,
    den_produs       = c("Carne de porc", "Varza alba", "Lapte acru",
                         "Struguri Feteasca Neagra", "Hamei si malt", "Apa minerala",
                         "Sfecla rosie", "Faina alba", "Branza de vaci",
                         "Struguri Feteasca Regala", "Prune", "Boabe de cafea",
                         "Pui intreg", "Oua"),
    categorie_produs = c("Carne", "Legume", "Lactate", "Fructe/Vinificatie",
                         "Ingrediente bere", "Bauturi nealcoolice", "Legume",
                         "Cereale", "Lactate", "Fructe/Vinificatie", "Fructe",
                         "Bauturi calde", "Carne", "Produse lactate"),
    stringsAsFactors = FALSE
)
dbWriteTable(con, "produse", produse, append = TRUE, row.names = FALSE)


###  F. 4. RESTAURANTE

restaurante <- data.frame(
    id_restaurant     = c(1, 2, 3),
    den_rest          = c("La Mama", "Caru cu Bere", "Vatra"),
    adresa_rest       = c("Str. Epictet 1, Sector 1", "Str. Stavropoleos 5, Sector 3",
                          "Str. Memorandumului 12"),
    id_localitate     = c(1, 1, 2),
    locuri_restaurant = c(60L, 120L, 40L),
    stringsAsFactors  = FALSE
)
dbWriteTable(con, "restaurante", restaurante, append = TRUE, row.names = FALSE)


###  G. 5. FURNIZORI

furnizori <- data.frame(
    id_furnizor   = c(1, 2, 3, 4),
    den_furn      = c("Lactate Dorna SRL", "Bauturi Maramures SRL",
                      "Agricola Bacau SA", "Panificatie Buftea SRL"),
    tip_furn      = c("Produse lactate", "Bauturi alcoolice",
                      "Carne si legume", "Produse de panif."),
    adresa_furn   = c("Str. Dornei 5", "Bd. Unirii 12",
                      "Str. Marasesti 8", "Sos. Bucuresti-Ploi."),
    id_localitate = c(3, 2, 1, 1),
    stringsAsFactors = FALSE
)
dbWriteTable(con, "furnizori", furnizori, append = TRUE, row.names = FALSE)


###  H. 6. BAUTURI

bauturi <- data.frame(
    id_bautura              = c(1, 2, 3, 4, 5, 6, 7, 8),
    denumire_in_meniu       = c("Vin Feteasca Neagra (250ml)", "Bere Ursus (500ml)",
                                "Apa minerala Borsec (500ml)", "Vin Feteasca Regala (250ml)",
                                "Palinca de prune (50ml)", "Cafea espresso",
                                "Tuica Cluj (50ml)", "Vin de Tarnave (250ml)"),
    data_adaugarii_in_meniu = as.Date(c("2020-01-10", "2020-01-10", "2020-01-10",
                                        "2020-03-01", "2020-06-01", "2020-01-10",
                                        "2021-03-01", "2021-03-01")),
    tip_bautura             = c("vin rosu", "bere", "apa minerala", "vin alb",
                                "rachiu", "cafea", "rachiu", "vin alb"),
    alcoolica               = c(13.5, 5.0, 0.0, 12.0, 45.0, 0.0, 40.0, 11.5),
    id_produs               = c(4, 5, 6, 10, 11, 12, 11, 10),
    cantitate_portie        = c(250, 500, 500, 250, 50, 30, 50, 250),
    pret_unitar             = c(35.00, 15.00, 8.00, 40.00, 30.00, 12.00, 20.00, 38.00),
    stringsAsFactors        = FALSE
)
dbWriteTable(con, "bauturi", bauturi, append = TRUE, row.names = FALSE)


###  I. 7. MENIURI_MANCARE

meniuri_mancare <- data.frame(
    id_sortiment_mancare    = 1:12,
    denumire_in_meniu       = c("Mici cu mustar", "Sarmale cu mamaliga", "Ciorba de burta",
                                "Tochitura moldoveneasca", "Salata de boeuf", "Pastrama de oaie",
                                "Cozonac cu nuca", "Placinta cu branza", "Ciorba ardeleneasca",
                                "Varza cu carne", "Langos cu smantana", "Papanasi cu smantana"),
    data_adaugarii_in_meniu = as.Date(c("2019-03-01", "2019-03-01", "2019-03-01",
                                        "2019-05-01", "2019-04-01", "2019-06-01",
                                        "2020-12-01", "2020-01-10", "2021-01-05",
                                        "2021-01-05", "2021-03-01", "2021-03-01")),
    tip_mancare             = c("gratar", "traditionala", "ciorba", "traditionala",
                                "salata", "gratar", "desert", "patiserie",
                                "ciorba", "traditionala", "patiserie", "desert"),
    id_produs               = c(1, 2, 3, 1, 9, 13, 8, 9, 1, 2, 8, 14),
    gramaj_portie           = c(200, 350, 400, 300, 250, 300, 200, 250, 400, 400, 200, 200),
    pret_unitar             = c(32.00, 38.00, 25.00, 45.00, 22.00, 55.00,
                                18.00, 20.00, 28.00, 35.00, 22.00, 25.00),
    stringsAsFactors        = FALSE
)
dbWriteTable(con, "meniuri_mancare", meniuri_mancare, append = TRUE, row.names = FALSE)


###  J. 8. MESE

mese <- data.frame(
    id_masa       = 1:8,
    id_restaurant = c(1, 1, 1, 2, 2, 3, 3, 3),
    masa_nr       = c(1L, 2L, 3L, 1L, 2L, 1L, 2L, 3L),
    observatii    = c("Langa fereastra", "Terasa interioara", "Rezervata fumatori",
                      "Sala principala", "Etaj, vedere la hol",
                      "Langa semineu", "Terasa", "Cabinet privat"),
    stringsAsFactors = FALSE
)
dbWriteTable(con, "mese", mese, append = TRUE, row.names = FALSE)


###  K. 9. ANGAJATI

angajati <- data.frame(
    id_angajat      = 1:10,
    nume_angajat    = c("Popescu", "Ionescu", "Dumitrescu", "Constantin", "Popa",
                        "Moldovan", "Stanescu", "Florescu", "Vasile", "Dinu"),
    prenume_angajat = c("Ion", "Maria", "Andrei", "Elena", "Gheorghe",
                        "Cristina", "Radu", "Ioana", "Dumitru", "Mihaela"),
    cnp_angajat     = c("1800510400001", "2850320400002", "1950615400003",
                        "2980920400004", "1780228400005", "2820410400006",
                        "1960825400007", "2991105400008", "1751130400009", "6000715400010"),
    data_nasterii   = as.Date(c("1980-05-10", "1985-03-20", "1995-06-15",
                                "1998-09-20", "1978-02-28", "1982-04-10",
                                "1996-08-25", "1999-11-05", "1975-11-30", "2000-07-15")),
    data_angajarii  = as.Date(c("2019-05-15", "2020-03-10", "2021-06-01",
                                "2022-09-15", "2023-02-20", "2020-04-01",
                                "2021-08-15", "2022-11-01", "2019-11-20", "2023-07-10")),
    id_restaurant   = c(1, 1, 1, 1, 1, 2, 2, 2, 3, 3),
    salariu         = c(6500, 5000, 3500, 3500, 5500, 7000, 3500, 3500, 6000, 3000),
    stringsAsFactors = FALSE
)
dbWriteTable(con, "angajati", angajati, append = TRUE, row.names = FALSE)


###  L. 10. MANAGERI

manageri <- data.frame(
    id_manager    = c(1, 6, 9),
    id_restaurant = c(1, 2, 3),
    data_numirii  = as.Date(c("2019-05-15", "2020-04-01", "2019-11-20")),
    stringsAsFactors = FALSE
)
dbWriteTable(con, "manageri", manageri, append = TRUE, row.names = FALSE)


###  M. 11. CHELNERI

chelneri <- data.frame(
    id_chelner              = c(3, 4, 7, 8, 10),
    punctaj_ultima_evaluare = c(9.50, 8.80, 9.20, 8.50, 7.90),
    data_ultimei_evaluari   = as.Date(rep("2024-01-15", 5)),
    stringsAsFactors        = FALSE
)
dbWriteTable(con, "chelneri", chelneri, append = TRUE, row.names = FALSE)


###  N. 12. BUCATARI

bucatari <- data.frame(
    id_bucatar                = c(2, 5),
    specializari              = c("Bucatarie traditionala romaneasca", "Grill si preparate la gratar"),
    data_ultimei_specializari = as.Date(c("2022-03-10", "2023-05-20")),
    stringsAsFactors          = FALSE
)
dbWriteTable(con, "bucatari", bucatari, append = TRUE, row.names = FALSE)


###  O. 13. TURE

ture <- data.frame(
    id_angajat            = c(3, 3, 3, 3, 3, 3, 4, 4, 4, 7, 7, 7, 7, 8, 8, 10, 10, 10),
    data_ora_inceput_tura = as.POSIXct(c(
        "2021-03-15 11:00:00", "2021-06-20 18:00:00", "2023-01-10 18:00:00",
        "2023-02-14 18:00:00", "2023-08-22 18:00:00", "2024-03-08 19:00:00",
        "2022-04-10 10:00:00", "2023-01-20 11:00:00", "2023-05-20 10:00:00",
        "2022-09-05 19:00:00", "2023-01-25 19:00:00", "2023-07-08 20:00:00",
        "2024-04-12 18:00:00",
        "2023-04-15 18:00:00", "2023-11-15 17:00:00",
        "2023-03-15 18:00:00", "2023-09-10 10:00:00", "2024-01-20 10:00:00"
    ), tz = "UTC"),
    ora_ora_sfarsit_tura  = as.POSIXct(c(
        "2021-03-15 23:00:00", "2021-06-20 23:00:00", "2023-01-10 23:00:00",
        "2023-02-14 23:00:00", "2023-08-22 23:00:00", "2024-03-08 23:00:00",
        "2022-04-10 18:00:00", "2023-01-20 16:00:00", "2023-05-20 18:00:00",
        "2022-09-05 23:00:00", "2023-01-25 23:00:00", "2023-07-08 23:00:00",
        "2024-04-12 23:00:00",
        "2023-04-15 23:00:00", "2023-11-15 23:00:00",
        "2023-03-15 23:00:00", "2023-09-10 18:00:00", "2024-01-20 18:00:00"
    ), tz = "UTC"),
    observatii            = rep(NA_character_, 18),
    stringsAsFactors      = FALSE
)
dbWriteTable(con, "ture", ture, append = TRUE, row.names = FALSE)


###  P. 14. COMENZI

comenzi <- data.frame(
    id_comanda       = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18),
    data_ora_comanda = as.POSIXct(c(
        "2021-03-15 12:30:00", "2021-06-20 19:00:00", "2022-04-10 13:45:00",
        "2022-09-05 20:00:00", "2023-02-14 19:30:00", "2023-05-20 12:00:00",
        "2023-07-08 21:00:00", "2023-11-15 18:30:00", "2024-01-20 13:00:00",
        "2024-03-08 20:00:00", "2024-04-12 19:00:00", "2023-08-22 20:30:00",
        "2023-01-10 19:00:00", "2023-01-20 12:30:00", "2023-01-25 20:00:00",
        "2023-04-15 19:30:00", "2023-09-10 13:00:00", "2023-03-15 19:00:00"
    ), tz = "UTC"),
    id_client        = c(2, 3, 4, 2, 1, 1, 2, 3, 5, 4, 2, 1, 3, 4, 2, 5, 2, 3),
    id_masa          = c(1, 2, 3, 4, 1, 2, 4, 5, 6, 1, 4, 3, 1, 2, 4, 5, 7, 8),
    observatii       = rep(NA_character_, 18),
    stringsAsFactors = FALSE
)
dbWriteTable(con, "comenzi", comenzi, append = TRUE, row.names = FALSE)


###  Q. 15. COM_BAUTURI

com_bauturi <- data.frame(
    id_comanda          = c(1, 3, 4, 5, 7, 7, 8, 10, 11, 12, 12, 13, 15, 16, 16, 17, 18),
    id_bautura          = c(2, 1, 5, 3, 5, 6, 4, 2,  4,  1,  2,  1,  6,  4,  5,  1,  7),
    cantitate_comandata = c(2, 1, 1, 2, 2, 1, 1, 2,  2,  2,  1,  1,  1,  1,  1,  1,  1),
    pret_unitar         = c(15.00, 35.00, 30.00, 8.00, 30.00, 12.00, 40.00, 15.00,
                            40.00, 35.00, 15.00, 35.00, 12.00, 40.00, 30.00, 35.00, 20.00),
    stringsAsFactors    = FALSE
)
dbWriteTable(con, "com_bauturi", com_bauturi, append = TRUE, row.names = FALSE)


###  R. 16. COM_MANCARE

com_mancare <- data.frame(
    id_comanda           = c(1, 2, 2, 3, 4, 4, 5, 6, 6, 8, 9, 9, 10, 10, 11, 13, 14, 14, 15, 15, 16, 17, 18, 18),
    id_sortiment_mancare = c(1, 2, 3, 4, 5, 6, 1, 2, 3, 7, 9, 10, 4, 1, 6, 4, 1, 3, 5, 6, 8, 9, 11, 12),
    id_portie_comandata  = c(2, 1, 1, 1, 1, 1, 2, 2, 1, 2, 1, 1, 1, 2, 1, 1, 3, 1, 1, 1, 2, 2, 2, 1),
    pret_unitar          = c(32.00, 38.00, 25.00, 45.00, 22.00, 55.00, 32.00, 38.00, 25.00,
                             18.00, 28.00, 35.00, 45.00, 32.00, 55.00, 45.00, 32.00, 25.00,
                             22.00, 55.00, 20.00, 28.00, 22.00, 25.00),
    stringsAsFactors     = FALSE
)
dbWriteTable(con, "com_mancare", com_mancare, append = TRUE, row.names = FALSE)


###  S. 17. BONURI_FISCALE

bonuri_fiscale <- data.frame(
    id_bon_f       = 1:18,
    nr_bon_f       = c("BON-2021-001", "BON-2021-002", "BON-2022-001", "BON-2022-002",
                       "BON-2023-001", "BON-2023-002", "BON-2023-003", "BON-2023-004",
                       "BON-2024-001", "BON-2024-002", "BON-2024-003", "BON-2023-005",
                       "BON-2023-006", "BON-2023-007", "BON-2023-008", "BON-2023-009",
                       "BON-2023-010", "BON-2023-011"),
    data_ora_bon_f = as.POSIXct(c(
        "2021-03-15 13:00:00", "2021-06-20 19:30:00", "2022-04-10 14:15:00",
        "2022-09-05 20:30:00", "2023-02-14 20:00:00", "2023-05-20 12:30:00",
        "2023-07-08 21:30:00", "2023-11-15 19:00:00", "2024-01-20 13:30:00",
        "2024-03-08 20:30:00", "2024-04-12 19:30:00", "2023-08-22 21:00:00",
        "2023-01-10 19:30:00", "2023-01-20 13:00:00", "2023-01-25 20:30:00",
        "2023-04-15 20:00:00", "2023-09-10 13:30:00", "2023-03-15 19:30:00"
    ), tz = "UTC"),
    id_comanda     = 1:18,
    suma_bon_f     = c(94.00, 63.00, 80.00, 107.00, 80.00, 101.00, 72.00, 76.00,
                       63.00, 139.00, 135.00, 85.00, 80.00, 121.00, 89.00, 110.00,
                       91.00, 89.00),
    cod_locatie    = c("LOC-001", "LOC-001", "LOC-001", "LOC-002",
                       "LOC-001", "LOC-001", "LOC-002", "LOC-002",
                       "LOC-003", "LOC-001", "LOC-002", "LOC-001",
                       "LOC-001", "LOC-001", "LOC-002", "LOC-002",
                       "LOC-003", "LOC-003"),
    id_client      = c(2, 3, 4, 2, 1, 1, 2, 3, 5, 4, 2, 1, 3, 4, 2, 5, 2, 3),
    stringsAsFactors = FALSE
)
dbWriteTable(con, "bonuri_fiscale", bonuri_fiscale, append = TRUE, row.names = FALSE)


###  T. 18. REZERVARI

rezervari <- data.frame(
    id_rezervare       = 1:21,
    data_ora_rezervare = as.POSIXct(c(
        "2024-01-10 10:00:00", "2024-02-05 11:00:00", "2024-03-10 09:00:00",
        "2024-03-28 14:00:00", "2024-04-25 10:00:00", "2024-06-01 12:00:00",
        "2024-07-10 11:00:00", "2023-12-20 10:00:00", "2024-01-18 14:00:00",
        "2024-01-22 10:00:00", "2024-02-12 09:00:00", "2024-03-05 11:00:00",
        "2023-06-01 10:00:00", "2023-06-12 11:00:00", "2023-07-08 14:00:00",
        "2023-07-15 09:00:00", "2023-08-01 10:00:00", "2023-08-18 11:00:00",
        "2023-09-05 14:00:00", "2023-10-10 10:00:00", "2023-10-18 11:00:00"
    ), tz = "UTC"),
    id_client          = c(1, 2, 3, 4, 5, 1, 2, 3, 2, 3, 4, 5, 1, 1, 2, 2, 3, 3, 4, 5, 5),
    data_ora_sosire    = as.POSIXct(c(
        "2024-01-15 18:00:00", "2024-02-14 19:30:00", "2024-03-20 20:00:00",
        "2024-04-05 12:00:00", "2024-05-10 18:30:00", "2024-06-15 19:00:00",
        "2024-07-20 20:00:00", "2023-12-31 21:00:00", "2024-01-25 19:00:00",
        "2024-01-30 20:00:00", "2024-02-20 12:00:00", "2024-03-15 18:00:00",
        "2023-06-10 19:30:00", "2023-06-20 20:00:00", "2023-07-15 12:00:00",
        "2023-07-20 19:00:00", "2023-08-10 20:00:00", "2023-08-25 12:30:00",
        "2023-09-15 19:00:00", "2023-10-20 12:00:00", "2023-10-25 19:30:00"
    ), tz = "UTC"),
    data_ora_plecare   = as.POSIXct(c(
        "2024-01-15 22:00:00", "2024-02-14 21:30:00", "2024-03-20 23:00:00",
        "2024-04-05 14:00:00", "2024-05-10 23:00:00", "2024-06-15 22:00:00",
        "2024-07-20 24:00:00", "2024-01-01 02:00:00", "2024-01-25 21:00:00",
        "2024-01-30 23:00:00", "2024-02-20 14:00:00", "2024-03-15 21:00:00",
        "2023-06-10 22:00:00", "2023-06-20 23:30:00", "2023-07-15 14:30:00",
        "2023-07-20 22:00:00", "2023-08-10 23:00:00", "2023-08-25 14:30:00",
        "2023-09-15 22:00:00", "2023-10-20 14:00:00", "2023-10-25 23:00:00"
    ), tz = "UTC"),
    stringsAsFactors   = FALSE
)
dbWriteTable(con, "rezervari", rezervari, append = TRUE, row.names = FALSE)


###  U. 19. REZERVARI_RESTAURANTE

rezervari_restaurante <- data.frame(
    id_rezervare  = c(1, 3, 5, 7, 7, 8, 14, 17, 21),
    id_restaurant = c(1, 2, 3, 1, 2, 3,  1,  2,  3),
    observatii    = c("Eveniment corporate", "Petrecere aniversara", "Receptie privata",
                      "Conferinta", NA, "Revelion", "Zi de nastere",
                      "Reuniune de clasa", "Eveniment cultural"),
    stringsAsFactors = FALSE
)
dbWriteTable(con, "rezervari_restaurante", rezervari_restaurante, append = TRUE, row.names = FALSE)


###  V. 20. REZERVARI_MESE

rezervari_mese <- data.frame(
    id_rezervare = c(2, 3, 3, 4, 6, 6, 7, 9, 10, 10, 11, 12, 13, 15, 16, 18, 19, 20),
    id_masa      = c(1, 4, 5, 3, 6, 7, 4, 2,  4,  5,  8,  6,  1,  3,  1,  8,  7,  3),
    observatii   = rep(NA_character_, 18),
    stringsAsFactors = FALSE
)
dbWriteTable(con, "rezervari_mese", rezervari_mese, append = TRUE, row.names = FALSE)


###  W. 21. COMENZI_PRODUSE_FURNIZORI

comenzi_produse_furnizori <- data.frame(
    id_comanda_furnizor = 1:12,
    data_ora_comanda    = as.POSIXct(c(
        "2023-01-15 09:00:00", "2023-02-10 09:00:00", "2023-03-05 09:00:00",
        "2023-04-20 09:00:00", "2023-05-10 09:00:00", "2023-06-15 09:00:00",
        "2023-07-15 09:00:00", "2023-08-10 09:00:00", "2023-09-20 09:00:00",
        "2023-10-15 09:00:00", "2023-11-20 09:00:00", "2022-05-10 09:00:00"
    ), tz = "UTC"),
    id_restaurant       = c(1, 1, 1, 1, 2, 1, 2, 1, 2, 2, 1, 2),
    id_furnizor         = c(1, 2, 3, 2, 3, 1, 4, 3, 4, 2, 1, 3),
    id_produs           = c(3, 4, 1, 5, 13, 2, 8, 1, 8, 11, 6, 13),
    cantitate           = c(50, 100, 200, 150, 50, 80, 60, 60, 100, 50, 200, 40),
    pret_total          = c(250.00, 2200.00, 3000.00, 1200.00, 1650.00, 960.00,
                            720.00, 1680.00, 1000.00, 900.00, 600.00, 1280.00),
    stringsAsFactors    = FALSE
)
dbWriteTable(con, "comenzi_produse_furnizori", comenzi_produse_furnizori, append = TRUE, row.names = FALSE)


###  X. Inchide conexiunea
dbDisconnect(con)
message("Populare finalizata cu succes!")
