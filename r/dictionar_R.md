# Dictionar de termeni R folositi in proiect

Acest fisier explica fiecare termen si concept R folosit in scripturile din folderul `r/`.

---

## 1. Concepte fundamentale

### `<-` (operator de atribuire)
Echivalentul lui `=` din alte limbaje. Atribuie o valoare unei variabile.
```r
x <- 5          # variabila x primeste valoarea 5
nume <- "Ion"   # variabila nume primeste textul "Ion"
```

### `#` (comentariu)
Tot ce urmeaza dupa `#` pe o linie este ignorat de R (ca `--` in SQL).

### `TRUE` / `FALSE`
Valorile logice (boolean) in R. Echivalent cu 1/0 sau adevarat/fals.

### `NA` / `NA_character_`
Valoarea lipsa in R — echivalentul lui `NULL` din SQL.
- `NA` — valoare lipsa generica
- `NA_character_` — valoare lipsa de tip text (character)

### `L` (sufix pentru numere intregi)
`60L` inseamna numarul intreg 60. Fara `L`, R il trateaza ca numar cu zecimale (double).
```r
60    # numar cu zecimale (double): 60.0
60L   # numar intreg (integer): 60
```

---

## 2. Tipuri de date in R

### `numeric` / `double`
Numere cu zecimale: `35.00`, `13.5`, `250`.

### `integer`
Numere intregi: `60L`, `1L`.

### `character`
Siruri de caractere (text), scrise intre ghilimele: `"Bucuresti"`, `"LOC-001"`.

### `Date`
Data calendaristica (fara ora): `as.Date("2024-01-15")`.

### `POSIXct`
Data + ora (timestamp): `as.POSIXct("2024-01-15 18:00:00")`.

### `data.frame`
Tabel de date in R — echivalentul unui tabel SQL. Are randuri si coloane.
Fiecare coloana are un nume si un tip de date.

---

## 3. Functii de baza R

### `c(...)` — combine / concatenare
Creeaza un vector (o lista de valori de acelasi tip). Cea mai folosita functie in R.
```r
c(1, 2, 3)                          # vector de numere: 1, 2, 3
c("Bucuresti", "Cluj", "Iasi")      # vector de texte
```

### `1:14` — operator de secventa
Genereaza o secventa de numere intregi de la 1 la 14: `1, 2, 3, ..., 14`.
Echivalent cu `c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)`.

### `rep(valoare, de_cate_ori)` — repeta
Repeta o valoare de un numar de ori.
```r
rep(NA_character_, 18)   # creeaza 18 valori NA (lipsa) de tip text
rep("2024-01-15", 5)     # repeta data de 5 ori
```

### `data.frame(...)` — creeaza un tabel
Creeaza un data frame (tabel) din coloane.
```r
localitati <- data.frame(
    id_localitate   = c(1, 2, 3),            # coloana 1
    nume_localitate = c("Bucuresti", "Cluj"), # coloana 2
    stringsAsFactors = FALSE                  # parametru de configurare
)
```

### `stringsAsFactors = FALSE`
Spune lui R sa pastreze textele ca text simplu (character), nu sa le converteasca
in "factori" (o structura speciala R pentru categorii). Mereu folosit la `data.frame()`.

### `as.Date("2024-01-15")` — conversie la data
Transforma un text in obiect de tip data calendaristica.
Formatul asteptat: `"AAAA-LL-ZZ"` (an-luna-zi).

### `as.POSIXct("2024-01-15 18:00:00", tz = "UTC")` — conversie la timestamp
Transforma un text in obiect de tip data+ora (timestamp).
- `tz = "UTC"` — specifica fusul orar (UTC = ora universala coordonata)

### `print(obiect)` — afisare
Afiseaza un obiect in consola R.

### `message("text")` — mesaj informativ
Afiseaza un mesaj in consola (similar cu `print`, dar pentru mesaje de stare).

### `paste("text1", "text2", sep = " ")` — concatenare text
Lipeste mai multe texte intr-unul singur.
```r
paste("SELECT * FROM", "angajati")   # rezultat: "SELECT * FROM angajati"
```

### `nrow(tabel)` — numar de randuri
Returneaza numarul de randuri dintr-un data frame.

### `assign(nume, valoare)` — atribuire dinamica
Creeaza o variabila cu un nume dat ca text.
```r
assign("angajati", date)   # este echivalent cu: angajati <- date
```
Util cand numele variabilei vine dintr-o alta variabila (ex: dintr-un loop).

### `rm(list = ls())` — sterge totul din memorie
- `ls()` — listeaza toate variabilele existente in memorie
- `rm(...)` — sterge variabile din memorie (remove)
- `rm(list = ls())` — sterge TOATE variabilele (curata memoria)
- `rm(con, temp, i)` — sterge doar variabilele `con`, `temp` si `i`

### `is.na(valoare)` — verifica daca e NA
Returneaza `TRUE` daca valoarea este lipsa (NA), `FALSE` altfel.
```r
is.na(NA)        # TRUE
is.na("text")    # FALSE
```

---

## 4. Structuri de control

### `for (i in 1:n) { ... }` — bucla for
Executa un bloc de cod de mai multe ori.
```r
for (i in 1:3) {
    print(i)       # afiseaza 1, apoi 2, apoi 3
}
```

---

## 5. Pachete (libraries)

### Ce este un pachet?
Un pachet (library/package) este o colectie de functii suplimentare. Trebuie instalat
o singura data cu `install.packages()`, apoi incarcat in fiecare sesiune cu `library()`.

### `install.packages("nume_pachet")` — instalare (o singura data)
Descarca si instaleaza pachetul de pe internet.

### `library(nume_pachet)` — incarcare (la fiecare rulare)
Incarca pachetul in sesiunea curenta pentru a-i putea folosi functiile.

### Pachetele folosite in proiect:

| Pachet | Ce face |
|--------|---------|
| `tidyverse` | Colectie de pachete pentru manipulare date. Include `dplyr`, `lubridate`, `ggplot2` etc. |
| `dplyr` | Functii pentru interogarea si transformarea datelor (echivalent SELECT, JOIN, WHERE etc.) |
| `lubridate` | Functii pentru lucrul cu date calendaristice (ex: `year()`) — inclus in tidyverse |
| `DBI` | Interfata generica pentru conectarea R la baze de date |
| `RPostgres` | Driver specific pentru PostgreSQL — folosit impreuna cu DBI |
| `rstudioapi` | Functii specifice RStudio (editor-ul R) — folosit pentru a afla calea fisierului curent |

---

## 6. Functii DBI / RPostgres (conexiune la baza de date)

### `dbConnect(driver, dbname, user, host, password)` — deschide conexiunea
Stabileste conexiunea la baza de date PostgreSQL.
```r
con <- dbConnect(RPostgres::Postgres(),
                 dbname = "restaurante",    # numele bazei de date
                 user = "postgres",         # utilizatorul PostgreSQL
                 host = "localhost",        # serverul (local)
                 password = "postgres")     # parola
```
- `RPostgres::Postgres()` — specifica driverul PostgreSQL
- `::` — operator care acceseaza o functie dintr-un pachet specific

### `dbDisconnect(con)` — inchide conexiunea
Inchide conexiunea la baza de date. Trebuie apelat la final.

### `dbGetQuery(con, "SELECT ...")` — executa SELECT si returneaza rezultat
Trimite o interogare SQL la baza de date si returneaza rezultatul ca data frame.
```r
# returneaza un data frame cu toate randurile din tabelul angajati
angajati <- dbGetQuery(con, "SELECT * FROM angajati")
```

### `dbExecute(con, "DELETE FROM ...")` — executa SQL fara rezultat
Trimite o comanda SQL care nu returneaza date (DELETE, INSERT, UPDATE, CREATE).
```r
dbExecute(con, "DELETE FROM clienti")   # sterge toate randurile
```

### `dbWriteTable(con, "nume_tabel", data_frame, append, row.names)` — scrie tabel
Insereaza un data frame R intr-un tabel PostgreSQL existent.
```r
dbWriteTable(con, "localitati", localitati, append = TRUE, row.names = FALSE)
```
- `append = TRUE` — adauga randuri la tabelul existent (nu il suprascrie)
- `row.names = FALSE` — nu scrie numerele de rand ca o coloana suplimentara

---

## 7. Functii dplyr (echivalent SQL in R)

### `%>%` — pipe (conducta)
Operatorul pipe trimite rezultatul unei functii ca input in functia urmatoare.
Se citeste "apoi" sau "si apoi".
```r
# Fara pipe:
arrange(distinct(filter(angajati, salariu > 5000), nume_angajat), nume_angajat)

# Cu pipe (mult mai clar):
angajati %>%
    filter(salariu > 5000) %>%     # ia angajatii cu salariu > 5000
    distinct(nume_angajat) %>%      # pastreaza numele unice
    arrange(nume_angajat)           # sorteaza alfabetic
```

### Echivalente SQL → dplyr:

| SQL | dplyr | Explicatie |
|-----|-------|------------|
| `SELECT col1, col2` | `select(col1, col2)` | Selecteaza coloane |
| `WHERE conditie` | `filter(conditie)` | Filtreaza randuri |
| `ORDER BY col` | `arrange(col)` | Sorteaza |
| `DISTINCT` | `distinct()` | Valori unice |
| `AS alias` | `mutate(alias = expresie)` | Creeaza/modifica o coloana |
| `INNER JOIN` | `inner_join(tabel, by = "col")` | Join intern |
| `LEFT JOIN` | `left_join(tabel, by = "col")` | Join stanga |
| `INTERSECT` | `dplyr::intersect(t1, t2)` | Intersectia a doua tabele |
| `CASE WHEN` | `case_when(cond ~ val, ...)` | Logica conditionala |
| `EXTRACT(YEAR FROM data)` | `year(data)` | Extrage anul dintr-o data |

### `filter(conditie)` — WHERE
Pastreaza doar randurile care indeplinesc conditia.
```r
comenzi %>% filter(year(data_ora_comanda) == 2023)
# echivalent: WHERE EXTRACT(YEAR FROM data_ora_comanda) = 2023
```
- `==` este operatorul de comparatie (egalitate) in R, nu `=`
- `>=`, `<=`, `!=`, `>`, `<` — ceilalti operatori de comparatie

### `select(col1, col2)` — SELECT (coloane)
Alege doar coloanele specificate.
```r
com_mancare %>% select(id_comanda)
# echivalent: SELECT id_comanda FROM com_mancare
```

### `mutate(col_noua = expresie)` — adauga/modifica coloana
Creeaza o coloana noua sau modifica una existenta.
```r
angajati %>% mutate(an_angajare = year(data_angajarii))
# echivalent: SELECT *, EXTRACT(YEAR FROM data_angajarii) AS an_angajare FROM angajati
```

### `distinct(col)` — DISTINCT
Pastreaza doar valorile unice.
```r
angajati %>% distinct(an_angajare)
# echivalent: SELECT DISTINCT an_angajare FROM angajati
```

### `arrange(col)` — ORDER BY
Sorteaza rezultatul dupa o coloana (crescator implicit).
```r
rezultat %>% arrange(nume_angajat, prenume_angajat)
# echivalent: ORDER BY nume_angajat, prenume_angajat
```

### `inner_join(tabel, by = "coloana")` — INNER JOIN
Combina doua tabele pastrind doar randurile care au corespondenta in ambele.
```r
comenzi %>% inner_join(clienti, by = "id_client")
# echivalent: comenzi JOIN clienti ON comenzi.id_client = clienti.id_client
```

### `left_join(tabel, by = "coloana")` — LEFT JOIN
Combina doua tabele pastrind TOATE randurile din tabelul din stanga,
chiar daca nu au corespondenta in dreapta (pune NA unde nu gaseste).
```r
rezervari %>% left_join(are_restaurant, by = "id_rezervare")
```

### `case_when(conditie1 ~ valoare1, conditie2 ~ valoare2, TRUE ~ implicit)` — CASE WHEN
Logica conditionala (if/else pe coloane).
```r
mutate(tip = case_when(
    !is.na(are_rest) & !is.na(are_masa) ~ "mixta",
    !is.na(are_rest)                    ~ "restaurant intreg",
    TRUE                                ~ "cel putin o masa"
))
```
- `~` separa conditia de valoare (se citeste "atunci")
- `TRUE ~ valoare` este echivalentul lui `ELSE` din SQL
- `!` este negatie (NOT): `!is.na(x)` = "x NU este NA"
- `&` este AND logic

### `dplyr::intersect(tabel1, tabel2)` — INTERSECT
Returneaza randurile comune celor doua tabele (ca INTERSECT din SQL).

### `year(data)` — EXTRACT(YEAR FROM ...)
Extrage anul dintr-o data. Vine din pachetul `lubridate` (inclus in tidyverse).

---

## 8. Functii pentru fisiere

### `load("cale/fisier.RData")` — incarca date salvate
Incarca toate data frame-urile salvate anterior cu `save.image()`.
```r
load("../restaurante.RData")   # .. = un nivel mai sus in directoare
```

### `save.image(file = "fisier.RData")` — salveaza totul
Salveaza toate variabilele din memoria R intr-un fisier `.RData`.

### `setwd(cale)` — schimba directorul de lucru
Seteaza directorul curent (set working directory).

### `dirname(cale)` — extrage directorul
Returneaza directorul dintr-o cale de fisier.
```r
dirname("C:/proiect/r/script.R")   # returneaza "C:/proiect/r"
```

### `rstudioapi::getSourceEditorContext()$path`
Returneaza calea completa a fisierului R deschis in RStudio. Folosit pentru a
seta automat directorul de lucru la locatia scriptului curent.

---

## 9. Operatori rezumat

| Operator | Sens | Exemplu |
|----------|------|---------|
| `<-` | atribuire | `x <- 5` |
| `==` | egal cu | `x == 5` |
| `!=` | diferit de | `x != 5` |
| `>=`, `<=` | mai mare/mic sau egal | `x >= 3` |
| `&` | SI logic (AND) | `a & b` |
| `!` | negatie (NOT) | `!is.na(x)` |
| `%>%` | pipe (si apoi) | `date %>% filter(...)` |
| `~` | atunci (in case_when) | `cond ~ valoare` |
| `::` | functie din pachet | `dplyr::intersect()` |
| `:` | secventa | `1:10` |
| `$` | acces coloana/camp | `tabel$coloana` |
