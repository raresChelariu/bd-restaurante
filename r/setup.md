# Setup — Cum rulez scripturile R in RStudio

---

## Pasul 0: Instaleaza pachetele necesare (o singura data)

Deschide RStudio si in **Console** (panoul din stanga-jos) scrie pe rand:

```r
install.packages("tidyverse")
install.packages("DBI")
install.packages("RPostgres")
install.packages("rstudioapi")
```

Fiecare comanda dureaza cateva secunde — asteapta pana apare din nou promptul `>`.
Acest pas se face **o singura data**. Dupa instalare nu mai trebuie repetat.

---

## Pasul 1: Creeaza baza de date si tabelele in PostgreSQL

Acest pas se face in **pgAdmin** (sau alt client PostgreSQL), NU in RStudio.

1. Deschide **pgAdmin**
2. Click dreapta pe **Databases** → **Create** → **Database**
   - Name: `restaurante`
   - Click **Save**
3. Click dreapta pe baza de date `restaurante` → **Query Tool**
4. Deschide fisierul `create_tables.sql` (File → Open, sau copy-paste continutul)
5. Apasa **Execute** (butonul ▶ sau F5)
6. Verifica sa apara mesajul de succes fara erori

Dupa acest pas ai baza de date goala cu toate cele 21 de tabele create.

---

## Pasul 2: Populeaza tabelele (din RStudio)

1. In RStudio: **File** → **Open File** → navigheza la `r/populate.R`
2. **IMPORTANT**: Modifica datele de conectare daca e necesar (linia 18):
   ```r
   con <- dbConnect(RPostgres::Postgres(),
                    dbname = "restaurante",
                    user = "postgres",        # ← utilizatorul tau PostgreSQL
                    host = "localhost",
                    password = "postgres")     # ← parola ta PostgreSQL
   ```
   Daca la instalarea PostgreSQL ai pus o alta parola, inlocuieste `"postgres"` cu parola ta.
3. Apasa **Source** (butonul din dreapta-sus al editorului) sau `Ctrl+Shift+S`
   - Aceasta ruleaza INTREG scriptul de la inceput la sfarsit
   - In consola ar trebui sa apara: `Populare finalizata cu succes!`

Dupa acest pas, tabelele din PostgreSQL contin date.

---

## Pasul 3: Importa tabelele in R (din RStudio)

1. In RStudio: **File** → **Open File** → navigheza la `r/create_tables.R`
2. **IMPORTANT**: Modifica datele de conectare daca e necesar (linia 19), la fel ca la Pasul 2
3. Apasa **Source** (`Ctrl+Shift+S`)
4. In panoul **Environment** (dreapta-sus) ar trebui sa vezi toate tabelele importate:
   `angajati`, `bauturi`, `comenzi`, `clienti`, etc.
5. Scriptul salveaza automat fisierul `restaurante.RData` in folderul `r/`

Dupa acest pas ai un fisier `restaurante.RData` care contine toate tabelele ca data frames R.

---

## Pasul 4: Ruleaza exercitiile din tema1

1. In RStudio: **File** → **Open File** → deschide oricare fisier din `r/tema1/`
   (de exemplu `ex3.1.R`)
2. Apasa **Source** (`Ctrl+Shift+S`)
3. Rezultatul apare in **Console**

Poti rula exercitiile in orice ordine — fiecare incarca automat datele din `restaurante.RData`.

---

## Rezumat ordine de rulare

```
pgAdmin:  create_tables.sql      (creeaza tabelele goale)
     ↓
RStudio:  r/populate.R           (insereaza datele in PostgreSQL)
     ↓
RStudio:  r/create_tables.R      (importa tabelele in R → restaurante.RData)
     ↓
RStudio:  r/tema1/ex3.1.R        (exercitii — orice ordine)
          r/tema1/ex3.2.R
          r/tema1/ex3.3.R
          r/tema1/ex3.4.R
```

---

## Sfaturi utile RStudio

- **Source** (`Ctrl+Shift+S`) = ruleaza tot scriptul
- **Run** (`Ctrl+Enter`) = ruleaza doar linia curenta sau selectia — util pentru a rula linie cu linie si a vedea ce face fiecare pas
- **Environment** (dreapta-sus) = vezi toate variabilele din memorie; click pe un data frame pentru a-l vedea ca tabel
- **Console** (stanga-jos) = aici apar rezultatele si erorile
- **Help** (dreapta-jos) = scrie `?functie` in consola (ex: `?filter`) pentru documentatie

---

## Probleme frecvente

### "could not find function" / "there is no package called"
Pachetul nu e instalat. Ruleaza in consola:
```r
install.packages("numele_pachetului")
```

### "connection refused" / "could not connect to server"
Serviciul PostgreSQL nu e pornit. Pe Windows:
1. Apasa `Win+R`, scrie `services.msc`, Enter
2. Cauta `postgresql` in lista
3. Click dreapta → **Start**

### "password authentication failed"
Parola din script nu corespunde cu parola PostgreSQL.
Modifica parametrul `password = "..."` in script.

### "relation does not exist"
Tabelele nu sunt create. Intoarce-te la Pasul 1 si ruleaza `create_tables.sql` in pgAdmin.

### "duplicate key value violates unique constraint"
Datele sunt deja inserate. Nu e o problema — scriptul `populate.R` sterge datele vechi
automat inainte de reinserare (liniile cu `DELETE FROM`).
