# Dicționar de Termeni – Baze de Date / SQL / PostgreSQL

> Termenii sunt adăugați pe măsură ce apar în scripturile SQL.

---

## Termeni de bază

**Baza de date** *(Database)*
O colecție organizată de date stocate și gestionate pe un calculator. Ex: toată informația despre restaurante, angajați și comenzi se află într-o bază de date.

**Tabel** *(Table)*
O structură cu rânduri și coloane, asemănătoare unui tabel Excel. Fiecare tabel stochează un tip specific de informație. Ex: tabelul `angajati` conține toți angajații.

**Coloană** *(Column)*
O categorie de informații dintr-un tabel. Fiecare coloană are un nume și un tip de date. Ex: `nume`, `data_angajare`.

**Rând / Înregistrare** *(Row / Record)*
Un set complet de date pentru un element din tabel. Ex: un rând din tabelul `angajati` reprezintă un singur angajat.

**NULL**
O valoare specială care înseamnă "lipsă de valoare" sau "necunoscut". Nu este `0` și nu este spațiu gol — este absența completă a unei valori. Ex: un angajat fără manager are `id_manager = NULL`.

---

## Tipuri de date

**`INT` / `INTEGER`**
Număr întreg (fără virgulă). Ex: `42`, `-5`, `0`.

**`VARCHAR(n)`**
Șir de caractere (text) cu lungimea maximă `n`. Ex: `VARCHAR(100)` poate stoca texte de până la 100 de caractere.

**`NUMERIC(p, s)`**
Număr cu zecimale precise. `p` = numărul total de cifre, `s` = câte sunt după virgulă. Ex: `NUMERIC(10,2)` → `99999999.99`

**`DATE`**
Dată calendaristică (an, lună, zi). Ex: `'2023-05-20'`.

**`TIMESTAMP`**
Dată + oră (an, lună, zi, oră, minut, secundă). Ex: `'2023-05-20 19:30:00'`.

---

## Constrângeri *(Constraints)*

**`PRIMARY KEY`** *(Cheie primară)*
O coloană (sau combinație de coloane) care identifică **unic** fiecare rând dintr-un tabel. Nu poate fi `NULL` și nu se poate repeta. Ex: `id_angajat` este cheia primară a tabelului `angajati`.

**`FOREIGN KEY`** *(Cheie străină)*
O coloană care face referire la cheia primară dintr-un alt tabel, creând o legătură între tabele. Garantează că nu poți introduce date invalide. Ex: `id_restaurant` din tabelul `mese` trebuie să existe în tabelul `restaurante`.

**`NOT NULL`**
Constrângere care interzice valorile `NULL` într-o coloană. Ex: un angajat trebuie să aibă obligatoriu un `nume`.

**`CHECK`**
Constrângere care verifică că valorile dintr-o coloană respectă o condiție. Ex: `CHECK (tip IN ('mancare', 'bautura'))` permite doar aceste două valori în coloana `tip`.

**`DEFAULT`**
Valoarea atribuită automat dacă nu este specificată la inserare. Ex: `DEFAULT NOW()` pune data și ora curentă.

---

## Comenzi SQL

**`CREATE TABLE`**
Creează un tabel nou în baza de date, definind coloanele, tipurile de date și constrângerile.

**`INSERT INTO`**
Adaugă rânduri noi într-un tabel.
```sql
INSERT INTO angajati (nume, prenume) VALUES ('Pop', 'Ion');
```

**`SELECT`**
Interogare — citește date dintr-un tabel sau mai multe.
```sql
SELECT * FROM angajati; -- afișează toți angajații
```

**`FROM`**
Specifică tabelul/tabelele din care se citesc datele.

**`WHERE`**
Filtrează rândurile — păstrează doar rândurile care îndeplinesc condiția.
```sql
WHERE oras = 'Cluj-Napoca'
```

**`ORDER BY`**
Sortează rezultatele după una sau mai multe coloane. `ASC` = crescător (implicit), `DESC` = descrescător.

**`DISTINCT`**
Elimină rândurile duplicate din rezultat. Ex: dacă doi angajați au fost angajați în 2023, `DISTINCT` va afișa `2023` o singură dată.

---

## Funcții SQL

**`EXTRACT(parte FROM data)`**
Extrage o componentă dintr-o dată sau timestamp.
```sql
EXTRACT(YEAR  FROM data_angajare)  -- returnează anul
EXTRACT(MONTH FROM data_angajare)  -- returnează luna (1-12)
EXTRACT(DAY   FROM data_angajare)  -- returnează ziua
```

**`::INT`** *(cast)*
Convertește o valoare la tipul întreg. `EXTRACT` returnează un număr cu zecimale (ex: `2023.0`), `::INT` îl transformă în număr întreg curat (`2023`).

**`AS`** *(alias)*
Dă un nume alternativ (mai lizibil) unei coloane sau expresii din rezultatul interogării.
```sql
EXTRACT(YEAR FROM data_angajare)::INT AS an_angajare
```
