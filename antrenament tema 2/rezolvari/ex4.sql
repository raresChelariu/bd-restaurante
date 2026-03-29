-- Ex4: Pentru fiecare restaurant, afisati numarul de comenzi
--      in 2021, 2022 si 2023 pe coloane separate.
--
-- Tabele implicate: restaurante, mese, comenzi
--   restaurante: id_restaurant, den_rest, adresa_rest, id_localitate, locuri_restaurant
--   mese:        id_masa, id_restaurant, masa_nr, observatii
--   comenzi:     id_comanda, data_ora_comanda, id_client, id_masa, observatii

SELECT
    r.den_rest,
    SUM(CASE WHEN EXTRACT(YEAR FROM c.data_ora_comanda) = 2021 THEN 1 ELSE 0 END) AS nr_comenzi_2021,
    SUM(CASE WHEN EXTRACT(YEAR FROM c.data_ora_comanda) = 2022 THEN 1 ELSE 0 END) AS nr_comenzi_2022,
    SUM(CASE WHEN EXTRACT(YEAR FROM c.data_ora_comanda) = 2023 THEN 1 ELSE 0 END) AS nr_comenzi_2023
FROM restaurante r
LEFT JOIN mese m    ON m.id_restaurant = r.id_restaurant
LEFT JOIN comenzi c ON c.id_masa       = m.id_masa
GROUP BY r.id_restaurant, r.den_rest
ORDER BY r.den_rest;

-- Explicatie:
-- Tehnica "pivot": SUM(CASE WHEN conditie THEN 1 ELSE 0 END)
--   numara randurile care satisfac conditia in cadrul fiecarui grup.
-- Alternativa: COUNT(CASE WHEN ... THEN 1 END) — COUNT ignora NULL,
--   deci CASE fara ELSE (implicit NULL) functioneaza la fel.
-- LEFT JOIN asigura ca restaurantele fara comenzi apar cu 0 pe toate coloanele.
-- Aceasta este tehnica de baza din ex3.7 din tema (acolo aplicata pe valori, nu numaratori).
