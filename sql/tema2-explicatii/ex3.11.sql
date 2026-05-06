-- Restaurante3.11: Afisati primele trei comenzi pentru fiecare restaurant din orasul X.
-- Inlocuiti 'X' cu numele real al localitatii.
-- "Primele trei" = primele 3 in ordine cronologica (data_ora_comanda).
-- select * from localitati;

-- ============================================================
-- TABELE SI COLOANE IMPLICATE
-- ============================================================
-- Tabela: comenzi
--   - id_comanda, data_ora_comanda, id_masa
-- Tabela: mese
--   - id_masa, id_restaurant
-- Tabela: restaurante
--   - id_restaurant, den_rest, id_localitate
-- Tabela: localitati
--   - id_localitate, nume_localitate

-- ============================================================
-- EXPLICATIE PAS CU PAS (de la incepator la incepator)
-- ============================================================
-- Cerinta: pentru fiecare restaurant din orasul X, primele 3 comenzi
-- in ordinea timpului (cele mai vechi 3).
--
-- PROBLEMA: nu putem face simplu "ORDER BY data LIMIT 3" - pentru ca asta
-- ne-ar da primele 3 comenzi din TOATE restaurantele combinate, nu primele 3
-- per restaurant. Avem nevoie de "Top N per grup".
-- => solutia clasica: functia de fereastra ROW_NUMBER().
--
-- PASUL 1: Legam tabelele in lant ca sa ajungem de la comanda la oras
--   comenzi -> mese (prin id_masa)
--   mese -> restaurante (prin id_restaurant)
--   restaurante -> localitati (prin id_localitate)
--   Ne trebuie tot lantul pentru ca "comenzi" nu stie direct de oras.
--
-- PASUL 2: Filtram dupa orasul X
--   WHERE l.nume_localitate = 'Bucuresti'
--   (Inlocuiesti cu orasul tau real.)
--
-- PASUL 3: Numerotam comenzile in fiecare restaurant
--   ROW_NUMBER() OVER (
--       PARTITION BY r.id_restaurant   -- "reseteaza numaratoarea la fiecare restaurant"
--       ORDER BY c.data_ora_comanda    -- "in ordine cronologica"
--   ) AS rang
--   Asa, prima comanda din fiecare restaurant primeste 1, a doua 2, etc.
--
-- PASUL 4: Pastram doar primele 3
--   PROBLEMA: nu putem pune ROW_NUMBER() in WHERE direct - functiile de
--   fereastra se calculeaza dupa ce se face filtrarea.
--   SOLUTIA: punem totul intr-o subconsultare si filtram afara:
--     SELECT ... FROM (subconsultarea) sub WHERE rang <= 3
--
-- PASUL 5: Ordonare finala pentru afisare
--   ORDER BY restaurant, rang
--   => grupate pe restaurant, in ordinea pozitiei (1, 2, 3).
--
-- TIP: Daca ar fi fost cerinta "ultimele 3", schimbam doar ORDER BY in interior:
--   ORDER BY c.data_ora_comanda DESC

SELECT
    restaurant,
    id_comanda,
    data_ora_comanda,
    rang
FROM (
    SELECT
        r.den_rest                                                         AS restaurant,
        c.id_comanda,
        c.data_ora_comanda,
        ROW_NUMBER() OVER (
            PARTITION BY r.id_restaurant
            ORDER BY c.data_ora_comanda
        )                                                                  AS rang
    FROM comenzi c
    JOIN mese m        ON m.id_masa       = c.id_masa
    JOIN restaurante r ON r.id_restaurant = m.id_restaurant
    JOIN localitati l  ON l.id_localitate = r.id_localitate
    WHERE l.nume_localitate = 'Bucuresti'
) sub
WHERE rang <= 3
ORDER BY restaurant, rang;
