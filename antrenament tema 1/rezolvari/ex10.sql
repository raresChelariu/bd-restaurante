-- Ex10: Pentru fiecare restaurant, afisati numarul de rezervari din 2024
--       de fiecare tip: 'restaurant intreg', 'cel putin o masa', 'mixta'.
--       Afisati: numele restaurantului, nr_restaurant_intreg, nr_masa, nr_mixta.
--
-- Tabele implicate: restaurante, rezervari, rezervari_restaurante, rezervari_mese
--   restaurante:           id_restaurant, den_rest, adresa_rest, id_localitate, locuri_restaurant
--   rezervari:             id_rezervare, data_ora_rezervare, id_client,
--                          data_ora_sosire, data_ora_plecare
--   rezervari_restaurante: id_rezervare, id_restaurant, observatii
--   rezervari_mese:        id_rezervare, id_masa, observatii

-- Pasul 1: determinam tipul fiecarei rezervari din 2024 (similar ex3.4 din tema)
-- Pasul 2: legam rezervarile de restaurante si agregam

WITH tipuri_rezervari AS (
    SELECT
        r.id_rezervare,
        CASE
            WHEN EXISTS (SELECT 1 FROM rezervari_restaurante rr WHERE rr.id_rezervare = r.id_rezervare)
             AND EXISTS (SELECT 1 FROM rezervari_mese       rm WHERE rm.id_rezervare = r.id_rezervare)
                THEN 'mixta'
            WHEN EXISTS (SELECT 1 FROM rezervari_restaurante rr WHERE rr.id_rezervare = r.id_rezervare)
                THEN 'restaurant intreg'
            ELSE 'cel putin o masa'
        END AS tip_rezervare
    FROM rezervari r
    WHERE EXTRACT(YEAR FROM r.data_ora_rezervare) = 2024
)
SELECT
    rest.den_rest,
    SUM(CASE WHEN tr.tip_rezervare = 'restaurant intreg' THEN 1 ELSE 0 END) AS nr_restaurant_intreg,
    SUM(CASE WHEN tr.tip_rezervare = 'cel putin o masa'  THEN 1 ELSE 0 END) AS nr_masa,
    SUM(CASE WHEN tr.tip_rezervare = 'mixta'             THEN 1 ELSE 0 END) AS nr_mixta
FROM restaurante rest
JOIN rezervari_restaurante rr ON rr.id_restaurant = rest.id_restaurant
JOIN tipuri_rezervari tr       ON tr.id_rezervare  = rr.id_rezervare
GROUP BY rest.id_restaurant, rest.den_rest
ORDER BY rest.den_rest;

-- Explicatie:
-- WITH ... AS (...) defineste un CTE (Common Table Expression) - un SELECT temporar reutilizabil.
-- Primul CTE (tipuri_rezervari) reutilizeaza logica din ex3.4 pentru a clasifica rezervarile.
-- SUM(CASE WHEN ... THEN 1 ELSE 0 END) este tehnica clasica de "pivot" in SQL:
--   numara randurile care satisfac o conditie in cadrul unui GROUP BY.
-- JOIN pe rezervari_restaurante este necesar pentru a lega rezervarile de restaurante.
