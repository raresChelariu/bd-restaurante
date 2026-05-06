-- Restaurante3.15: Pentru fiecare restaurant, aflati pozitiile in topul vanzarilor
--                  pe: luna ianuarie 2023, semestrul 1 din 2023, si intreg anul 2023.

-- ============================================================
-- TABELE SI COLOANE IMPLICATE
-- ============================================================
-- Tabela: restaurante
--   - id_restaurant, den_rest
-- Tabela: mese
--   - id_masa, id_restaurant
-- Tabela: comenzi
--   - id_comanda, id_masa, data_ora_comanda
-- Tabela: com_bauturi
--   - id_comanda, cantitate_comandata, pret_unitar
-- Tabela: com_mancare
--   - id_comanda, pret_unitar

-- ============================================================
-- EXPLICATIE PAS CU PAS (de la incepator la incepator)
-- ============================================================
-- Cerinta: pentru fiecare restaurant, vreau 3 clasamente:
--   - pozitia in topul vanzarilor pe ianuarie 2023
--   - pozitia in topul vanzarilor pe semestrul 1 (lunile 1-6) din 2023
--   - pozitia in topul vanzarilor pe intreg anul 2023
--
-- COMPLICATIE: vanzarile vin din DOUA surse: bauturi si mancare.
-- Trebuie sa adunam ambele inainte sa facem clasamentul.
--
-- PASUL 1: Calculam vanzarile din BAUTURI in CTE-ul "vanzari_bauturi"
--   Pentru fiecare restaurant, calculam 3 sume folosind CASE:
--     val_ian = SUM(CASE WHEN luna ianuarie 2023 THEN cantitate * pret ELSE 0 END)
--     val_s1  = SUM(CASE WHEN luna intre 1 si 6 in 2023 THEN cantitate * pret ELSE 0 END)
--     val_an  = SUM(CASE WHEN anul 2023 THEN cantitate * pret ELSE 0 END)
--   Drumul de tabele: restaurante -> mese -> comenzi -> com_bauturi (LEFT JOIN
--   ca sa pastram restaurantele fara comenzi).
--   GROUP BY r.id_restaurant
--
-- PASUL 2: Identic pentru MANCARE in CTE-ul "vanzari_mancare"
--   Numai ca aici avem doar pret_unitar (fara cantitate de inmultit).
--
-- PASUL 3: Combinam cele doua in CTE-ul "vanzari_totale"
--   total_ian = val_ian (bauturi) + val_ian (mancare)
--   total_s1  = val_s1  (bauturi) + val_s1  (mancare)
--   total_an  = val_an  (bauturi) + val_an  (mancare)
--   JOIN simplu intre cele doua CTE-uri pe id_restaurant.
--
-- PASUL 4: Atribuim ranguri cu RANK() OVER
--   RANK() OVER (ORDER BY total_ian DESC) -> pozitia pe ianuarie 2023
--   RANK() OVER (ORDER BY total_s1  DESC) -> pozitia pe semestrul 1
--   RANK() OVER (ORDER BY total_an  DESC) -> pozitia pe an
--   RANK vs ROW_NUMBER vs DENSE_RANK:
--     - RANK: la egalitate, doua restaurante au aceeasi pozitie 1, urmatorul are 3.
--     - DENSE_RANK: 1, 1, 2 (fara sarituri).
--     - ROW_NUMBER: 1, 2 (chiar la egalitate).
--   Pentru "pozitii in clasament" RANK e cea mai naturala alegere.
--
-- PASUL 5: ORDER BY den_rest
--   Sortam afisarea alfabetic, ca sa fie usor de citit (nu schimba pozitiile).
--
-- DE CE LEFT JOIN si nu JOIN?
--   Daca un restaurant nu are NICIO comanda, vrem sa apara totusi cu zero
--   vanzari (si pozitia ultima). JOIN simplu l-ar fi pierdut.

WITH vanzari_bauturi AS (
    SELECT
        r.id_restaurant,
        SUM(CASE WHEN EXTRACT(YEAR  FROM c.data_ora_comanda) = 2023
                  AND EXTRACT(MONTH FROM c.data_ora_comanda) = 1
                 THEN cb.cantitate_comandata * cb.pret_unitar ELSE 0 END) AS val_ian,
        SUM(CASE WHEN EXTRACT(YEAR  FROM c.data_ora_comanda) = 2023
                  AND EXTRACT(MONTH FROM c.data_ora_comanda) BETWEEN 1 AND 6
                 THEN cb.cantitate_comandata * cb.pret_unitar ELSE 0 END) AS val_s1,
        SUM(CASE WHEN EXTRACT(YEAR  FROM c.data_ora_comanda) = 2023
                 THEN cb.cantitate_comandata * cb.pret_unitar ELSE 0 END) AS val_an
    FROM restaurante r
    LEFT JOIN mese m         ON m.id_restaurant = r.id_restaurant
    LEFT JOIN comenzi c      ON c.id_masa        = m.id_masa
    LEFT JOIN com_bauturi cb ON cb.id_comanda    = c.id_comanda
    GROUP BY r.id_restaurant
),
vanzari_mancare AS (
    SELECT
        r.id_restaurant,
        SUM(CASE WHEN EXTRACT(YEAR  FROM c.data_ora_comanda) = 2023
                  AND EXTRACT(MONTH FROM c.data_ora_comanda) = 1
                 THEN cm.pret_unitar ELSE 0 END) AS val_ian,
        SUM(CASE WHEN EXTRACT(YEAR  FROM c.data_ora_comanda) = 2023
                  AND EXTRACT(MONTH FROM c.data_ora_comanda) BETWEEN 1 AND 6
                 THEN cm.pret_unitar ELSE 0 END) AS val_s1,
        SUM(CASE WHEN EXTRACT(YEAR  FROM c.data_ora_comanda) = 2023
                 THEN cm.pret_unitar ELSE 0 END) AS val_an
    FROM restaurante r
    LEFT JOIN mese m        ON m.id_restaurant  = r.id_restaurant
    LEFT JOIN comenzi c     ON c.id_masa         = m.id_masa
    LEFT JOIN com_mancare cm ON cm.id_comanda    = c.id_comanda
    GROUP BY r.id_restaurant
),
vanzari_totale AS (
    SELECT
        r.id_restaurant,
        r.den_rest,
        vb.val_ian + vm.val_ian AS total_ian,
        vb.val_s1  + vm.val_s1  AS total_s1,
        vb.val_an  + vm.val_an  AS total_an
    FROM restaurante r
    JOIN vanzari_bauturi vb ON vb.id_restaurant = r.id_restaurant
    JOIN vanzari_mancare vm ON vm.id_restaurant = r.id_restaurant
)
SELECT
    id_restaurant,
    den_rest,
    RANK() OVER (ORDER BY total_ian DESC) AS pozitie_ianuarie_2023,
    RANK() OVER (ORDER BY total_s1  DESC) AS pozitie_sem1_2023,
    RANK() OVER (ORDER BY total_an  DESC) AS pozitie_an_2023
FROM vanzari_totale
ORDER BY den_rest;
