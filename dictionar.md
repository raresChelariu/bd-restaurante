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

---

## Operații pe mulțimi

**`INTERSECT`**
Returnează doar rândurile care apar în **ambele** query-uri (intersecția mulțimilor). Elimină automat duplicatele.
```sql
SELECT id_comanda FROM com_mancare
INTERSECT
SELECT id_comanda FROM com_bauturi;
-- doar comenzile care conțin și mâncare, și băutură
```

---

## JOIN – Combinarea tabelelor

**`JOIN` / `INNER JOIN`**
Combină rânduri din două tabele pe baza unei condiții. Păstrează doar rândurile care au corespondent în **ambele** tabele.
```sql
SELECT * FROM comenzi c
JOIN clienti cl ON c.id_client = cl.id_client;
```

**`ON`**
Specifică condiția de legătură dintre cele două tabele într-un `JOIN`.

---

## Condiții și expresii

**`BETWEEN ... AND ...`**
Verifică dacă o valoare se află într-un interval închis (inclusiv capetele).
```sql
WHERE data_ora_comanda BETWEEN '2023-01-01' AND '2023-12-31'
-- echivalent cu: >= '2023-01-01' AND <= '2023-12-31'
```

**`EXISTS`**
Verifică dacă un subquery returnează cel puțin un rând. Returnează `TRUE` dacă da, `FALSE` dacă nu.
```sql
WHERE EXISTS (SELECT 1 FROM rezervari_mese rm WHERE rm.id_rezervare = r.id_rezervare)
```

**`CASE WHEN ... THEN ... ELSE ... END`**
Expresie condițională (echivalentul `if/else`). Evaluează condiții în ordine și returnează prima valoare al cărei `WHEN` este adevărat.
```sql
CASE
    WHEN conditie1 THEN 'valoare1'
    WHEN conditie2 THEN 'valoare2'
    ELSE 'valoare_implicita'
END
```

**`IN (subquery)`**
Verifică dacă o valoare se află în mulțimea returnată de un subquery (sau o listă explicită).
```sql
WHERE id_comanda IN (SELECT id_comanda FROM com_mancare)
```

---

## Funcții de agregare

**`COUNT(*)`**
Numără toate rândurile dintr-un grup (inclusiv cele cu NULL).
```sql
SELECT COUNT(*) FROM angajati WHERE EXTRACT(YEAR FROM data_angajarii) = 2023;
```

**`SUM(expresie)`**
Calculează suma valorilor dintr-un grup. Ignoră `NULL`.
```sql
SUM(cantitate_comandata * pret_unitar)
```

**`MAX(expresie)`**
Returnează valoarea maximă dintr-un grup. Ignoră `NULL`.
```sql
MAX(nr_rezervari)
```

---

## Grupare și filtrare pe grupuri

**`GROUP BY`**
Grupează rândurile cu aceleași valori pe coloanele specificate, astfel încât funcțiile de agregare (`COUNT`, `SUM`, `MAX` etc.) să se aplice pe fiecare grup în parte.
```sql
SELECT id_restaurant, COUNT(*) FROM angajati GROUP BY id_restaurant;
```

**`HAVING`**
Filtrează grupurile rezultate după `GROUP BY`, similar cu `WHERE`, dar aplicat **după** agregare.
```sql
GROUP BY id_comanda
HAVING SUM(cantitate_comandata) > 5
-- păstrează doar comenzile cu mai mult de 5 băuturi
```

**`GROUPING SETS (...)`**
Permite calcularea mai multor niveluri de grupare într-o singură interogare. Echivalent cu mai multe `GROUP BY` unite prin `UNION ALL`, dar mai eficient. Rândurile de subtotal au `NULL` pe coloanele „însumate".
```sql
GROUP BY GROUPING SETS (
    (client, an, luna),  -- detaliu
    (client, an),        -- subtotal pe an
    ()                   -- total general
)
```

**`ROLLUP(...)`**
Scurtătură pentru `GROUPING SETS` cu subtotaluri ierarhice: generează automat toate combinațiile de la cel mai detaliat nivel până la totalul general.
```sql
GROUP BY ROLLUP(client, an, luna)
-- echivalent cu GROUPING SETS: (client,an,luna), (client,an), (client), ()
```

---

## JOIN avansat

**`LEFT JOIN`**
Păstrează **toate** rândurile din tabelul din stânga, chiar dacă nu au corespondent în tabelul din dreapta. Coloanele din dreapta vor fi `NULL` pentru rândurile fără corespondent.
```sql
LEFT JOIN angajati sub ON sub.id_restaurant = m.id_restaurant
-- rândurile fără subordonați apar cu sub.id_angajat = NULL
```

---

## Operații pe mulțimi (continuare)

**`UNION ALL`**
Combină rezultatele a două query-uri, păstrând **toate** rândurile, inclusiv duplicatele. Mai rapid decât `UNION` (care elimină duplicatele).
```sql
SELECT id_produs FROM bauturi
UNION ALL
SELECT id_produs FROM meniuri_mancare;
```

**`UNION`**
Ca `UNION ALL`, dar elimină rândurile duplicate din rezultatul final.

---

## Subconsultări *(Subqueries)*

**Subconsultare (subquery)**
O interogare `SELECT` inclusă în interiorul altei interogări. Poate apărea în `WHERE`, `FROM`, `HAVING` sau `SELECT`.
```sql
WHERE cantitate > (SELECT AVG(cantitate) FROM com_bauturi)
```

**`WITH nume AS (...)`** *(CTE – Common Table Expression)*
Definește o „interogare numită" reutilizabilă în cadrul aceleiași instrucțiuni `SELECT`. Face codul mai lizibil, evitând subqueries imbricate adânc.
```sql
WITH valori AS (
    SELECT id_produs, SUM(pret_total) AS total FROM ...
)
SELECT * FROM valori WHERE total > 1000;
```

---

## Funcții de fereastră *(Window Functions)*

**`ROW_NUMBER() OVER (...)`**
Atribuie un număr de ordine unic fiecărui rând dintr-o partiție, fără egalitate (mereu 1, 2, 3...).
```sql
ROW_NUMBER() OVER (PARTITION BY id_restaurant ORDER BY data_ora_comanda)
-- numerotează comenzile în ordine cronologică, separat pentru fiecare restaurant
```

**`RANK() OVER (...)`**
Ca `ROW_NUMBER()`, dar în caz de egalitate, rândurile ex-aequo primesc **același** rang, iar următorul rang sare (ex: 1, 2, 2, 4).
```sql
RANK() OVER (ORDER BY total_vanzari DESC)
```

**`PARTITION BY`**
Folosit în interiorul `OVER (...)` pentru a împărți rândurile în grupe independente înainte de aplicarea funcției de fereastră. Analog cu `GROUP BY`, dar **nu** reduce numărul de rânduri.
```sql
OVER (PARTITION BY id_restaurant ORDER BY data_ora_comanda)
```

**`SUM(...) OVER ()`**
Funcție de fereastră agregată: calculează suma **pe toate rândurile** simultan (fără a le reduce), utilă pentru a calcula ponderi procentuale.
```sql
SUM(total) OVER ()   -- suma globală, repetată pe fiecare rând
```

---

## Funcții scalare

**`ROUND(valoare, zecimale)`**
Rotunjește un număr la un anumit număr de zecimale.
```sql
ROUND(valoare * 100.0 / total, 2)   -- procent cu 2 zecimale
```

**`COALESCE(val1, val2, ...)`**
Returnează prima valoare non-`NULL` din listă. Util pentru a înlocui `NULL` cu o valoare implicită.
```sql
COALESCE(SUM(valoare), 0)   -- dacă suma e NULL, afișează 0
```

---

## Ordonare avansată

**`NULLS LAST`** / **`NULLS FIRST`**
Controlează unde apar rândurile cu `NULL` la sortare. Implicit, în PostgreSQL, `NULL` este mai mare decât orice valoare la `ORDER BY ASC`.
```sql
ORDER BY an NULLS LAST   -- rândurile cu an = NULL apar la final
```
