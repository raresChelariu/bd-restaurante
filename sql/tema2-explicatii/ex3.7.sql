



-- Restaurante3.7: Pentru fiecare produs, afisati pe coloane separate valoarea
--                 comenzilor pentru anii 2021, 2022 si 2023.

-- ============================================================
-- TABELE SI COLOANE IMPLICATE
-- ============================================================
-- Tabela: produse
--   - id_produs, den_produs
-- Tabela: bauturi
--   - id_bautura, id_produs (face legatura cu produse)
-- Tabela: meniuri_mancare
--   - id_sortiment_mancare, id_produs (face legatura cu produse)
-- Tabela: comenzi
--   - id_comanda, data_ora_comanda (de aici scoatem anul)
-- Tabela: com_bauturi (detalii comanda - bauturi)
--   - id_comanda, id_bautura, cantitate_comandata, pret_unitar
-- Tabela: com_mancare (detalii comanda - mancare)
--   - id_comanda, id_sortiment_mancare, pret_unitar

-- ============================================================
-- EXPLICATIE PAS CU PAS (de la incepator la incepator)
-- ============================================================
-- Cerinta: pentru fiecare produs, vreau valoarea comenzilor pe ani -
-- separat: cat s-a vandut in 2021, in 2022 si in 2023.
-- Iesirea trebuie sa arate cam asa:
--   id_produs | den_produs | valoare_2021 | valoare_2022 | valoare_2023
--
-- PROBLEMA: produsele se vand in DOUA forme:
--   1) Ca BAUTURA (in tabela com_bauturi)
--   2) Ca MANCARE (in tabela com_mancare)
-- Nu putem face un singur SELECT pentru ambele - trebuie sa le combinam.
--
-- PASUL 1: Calculam valoarea pentru BAUTURI
--   Valoarea = cantitate_comandata * pret_unitar
--   Trebuie sa stim si anul: il luam din comenzi.data_ora_comanda
--   Si trebuie sa stim ce produs e: id_produs din bauturi.
--   Deci facem JOIN intre com_bauturi, comenzi si bauturi.
--   Grupam dupa id_produs si an, si calculam SUM(cantitate * pret).
--
-- PASUL 2: Calculam valoarea pentru MANCARE
--   La fel, dar din com_mancare. Aici nu mai apare cantitate_comandata,
--   ci doar pret_unitar (presupunem ca e pretul total deja).
--   JOIN cu comenzi (pentru an) si meniuri_mancare (pentru id_produs).
--
-- PASUL 3: Lipim cele doua liste cu UNION ALL
--   UNION ALL pune randurile una sub alta, fara sa elimine duplicatele
--   (mai rapid decat UNION). Le punem intr-un CTE numit "valori".
--   Un CTE = un fel de tabela temporara, definita cu WITH.
--
-- PASUL 4: Pivotam: ani pe coloane
--   Acum avem: id_produs, an, valoare. Vrem coloane separate.
--   Trucul: pentru fiecare an folosim CASE:
--     CASE WHEN an = 2021 THEN valoare END
--   Daca anul e 2021 ne da valoarea, altfel ne da NULL.
--   Apoi SUM(...) - aduna doar valorile non-NULL.
--   COALESCE(SUM(...), 0) -> daca e NULL (nicio comanda in acel an), pune 0.
--
-- PASUL 5: LEFT JOIN ca sa apara TOATE produsele
--   Vrem sa apara si produsele care n-au fost comandate niciodata
--   (cu 0, 0, 0 pe toate cele 3 coloane de ani).
--   FROM produse p LEFT JOIN valori v ON v.id_produs = p.id_produs
--
-- PASUL 6: GROUP BY si ORDER BY
--   GROUP BY p.id_produs, p.den_produs (cele non-agregate)
--   ORDER BY p.id_produs (sortare logica)

WITH valori AS (
    -- valoare din bauturi comandate
    SELECT
        b.id_produs,
        EXTRACT(YEAR FROM c.data_ora_comanda)::INT         AS an,
        SUM(cb.cantitate_comandata * cb.pret_unitar)       AS valoare
    FROM com_bauturi cb
    JOIN comenzi c  ON c.id_comanda  = cb.id_comanda
    JOIN bauturi b  ON b.id_bautura  = cb.id_bautura
    GROUP BY b.id_produs, EXTRACT(YEAR FROM c.data_ora_comanda)::INT

    UNION ALL

    -- valoare din mancare comandata
    SELECT
        mm.id_produs,
        EXTRACT(YEAR FROM c.data_ora_comanda)::INT         AS an,
        SUM(cm.pret_unitar)                                AS valoare
    FROM com_mancare cm
    JOIN comenzi c        ON c.id_comanda           = cm.id_comanda
    JOIN meniuri_mancare mm ON mm.id_sortiment_mancare = cm.id_sortiment_mancare
    GROUP BY mm.id_produs, EXTRACT(YEAR FROM c.data_ora_comanda)::INT
)
SELECT
    p.id_produs,
    p.den_produs,
    COALESCE(SUM(CASE WHEN an = 2021 THEN valoare END), 0) AS valoare_2021,
    COALESCE(SUM(CASE WHEN an = 2022 THEN valoare END), 0) AS valoare_2022,
    COALESCE(SUM(CASE WHEN an = 2023 THEN valoare END), 0) AS valoare_2023
FROM produse p
LEFT JOIN valori v ON v.id_produs = p.id_produs
GROUP BY p.id_produs, p.den_produs
ORDER BY p.id_produs;
