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
-- PROBLEMA: nu putem face simplu "ORDER BY data LIMIT 3" - asta ne-ar da
-- primele 3 comenzi din TOATE restaurantele combinate, nu primele 3 PER
-- restaurant. Avem nevoie de "Top N per grup".
--
-- IDEEA (fara functii de fereastra): SUBCONSULTARE CORELATA cu COUNT.
--   Pentru fiecare comanda c, ne intrebam:
--     "Cate alte comenzi din ACELASI restaurant sunt mai vechi decat c?"
--   Daca raspunsul este 0 -> c e prima.
--   Daca raspunsul este 1 -> c e a doua.
--   Daca raspunsul este 2 -> c e a treia.
--   => c este in TOP 3 daca raspunsul este < 3.
--
-- PASUL 1: Lantul de tabele (acelasi ca inainte)
--   comenzi -> mese -> restaurante -> localitati
--   ca sa putem filtra pe orasul cerut.
--
-- PASUL 2: Filtram dupa orasul X
--   WHERE l.nume_localitate = 'Bucuresti'
--
-- PASUL 3: Conditia "in top 3" prin subconsultare corelata
--   AND (
--       SELECT COUNT(*)
--       FROM comenzi c2
--       JOIN mese m2 ON m2.id_masa = c2.id_masa
--       WHERE m2.id_restaurant = r.id_restaurant       -- ACELASI restaurant
--         AND c2.data_ora_comanda < c.data_ora_comanda -- comenzi mai vechi
--   ) < 3
--   "Corelata" = subconsultarea foloseste valori din randul exterior
--   (r.id_restaurant, c.data_ora_comanda). Adica se re-evalueaza pentru
--   fiecare comanda candidata.
--
-- PASUL 4: Ordonare finala
--   ORDER BY r.den_rest, c.data_ora_comanda
--   => grupate pe restaurant, in ordinea timpului.
--
-- COMPARATIE CU VARIANTA OVER:
--   ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...) face exact acelasi
--   lucru, dar ascuns elegant intr-o functie. Subconsultarea corelata e
--   mai verbose dar arata explicit cum se calculeaza pozitia: numerar
--   cati sunt mai inainte.
--
-- ATENTIE LA EGALITATI:
--   Daca doua comenzi au exact aceeasi data_ora_comanda, ambele vor avea
--   acelasi numar de "comenzi mai vechi", deci ambele pot intra in top 3.
--   In acest caz s-ar putea sa primesti mai mult de 3 randuri per
--   restaurant (la fel ca DENSE_RANK <= 3, nu ca ROW_NUMBER).
--   Daca date_ora_comanda sunt distincte, totul e identic cu ROW_NUMBER.

SELECT
    r.den_rest         AS restaurant,
    c.id_comanda,
    c.data_ora_comanda
FROM comenzi c
JOIN mese m        ON m.id_masa       = c.id_masa
JOIN restaurante r ON r.id_restaurant = m.id_restaurant
JOIN localitati l  ON l.id_localitate = r.id_localitate
WHERE l.nume_localitate = 'Bucuresti'
  AND (
      SELECT COUNT(*)
      FROM comenzi c2
      JOIN mese m2 ON m2.id_masa = c2.id_masa
      WHERE m2.id_restaurant       = r.id_restaurant
        AND c2.data_ora_comanda    < c.data_ora_comanda
  ) < 3
ORDER BY r.den_rest, c.data_ora_comanda;
