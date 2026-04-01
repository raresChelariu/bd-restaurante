-- Ex8: Calculati ponderea fiecarui restaurant in totalul comenzilor
--      (ca numar de comenzi) din 2023.
--
-- Tabele implicate: restaurante, mese, comenzi
--   restaurante: id_restaurant, den_rest, adresa_rest, id_localitate, locuri_restaurant
--   mese:        id_masa, id_restaurant, masa_nr, observatii
--   comenzi:     id_comanda, data_ora_comanda, id_client, id_masa, observatii

SELECT
    r.den_rest,
    COUNT(c.id_comanda)                                         AS nr_comenzi,
    SUM(COUNT(c.id_comanda)) OVER ()                            AS total_general,
    ROUND(
        COUNT(c.id_comanda) * 100.0
        / SUM(COUNT(c.id_comanda)) OVER (),
        2
    )                                                           AS pondere_procent
FROM restaurante r
LEFT JOIN mese m    ON m.id_restaurant = r.id_restaurant
LEFT JOIN comenzi c ON c.id_masa       = m.id_masa
                   AND EXTRACT(YEAR FROM c.data_ora_comanda) = 2023
GROUP BY r.id_restaurant, r.den_rest
ORDER BY pondere_procent DESC;

-- Explicatie:
-- SUM(COUNT(c.id_comanda)) OVER ():
--   - COUNT(c.id_comanda) este agregarea normala per grup (restaurant)
--   - SUM(...) OVER () este window function care insumeaza toate grupurile
--   - OVER () fara PARTITION BY inseamna "totalul intregii interogari"
-- Aceasta este tehnica din ex3.14 din tema (window function peste agregare).
-- Filtrul pe an e pus in ON (nu WHERE) pentru a pastra restaurantele cu 0 comenzi.
