-- Ex5: Pentru fiecare comanda din 2023, afisati daca contine:
--        'doar bauturi', 'doar mancare' sau 'ambele'.
--      Rezolvat cu LEFT JOIN (fara EXISTS/INTERSECT).
--
-- Tabele implicate: comenzi, com_bauturi, com_mancare
--   comenzi:     id_comanda, data_ora_comanda, id_client, id_masa, observatii
--   com_bauturi: id_comanda, id_bautura, cantitate_comandata, pret_unitar
--   com_mancare: id_comanda, id_sortiment_mancare, id_portie_comandata, pret_unitar

SELECT
    c.id_comanda,
    c.data_ora_comanda,
    CASE
        WHEN cb.id_comanda IS NOT NULL AND cm.id_comanda IS NOT NULL THEN 'ambele'
        WHEN cb.id_comanda IS NOT NULL                               THEN 'doar bauturi'
        ELSE                                                              'doar mancare'
    END AS tip_continut
FROM comenzi c
LEFT JOIN (SELECT DISTINCT id_comanda FROM com_bauturi) cb ON cb.id_comanda = c.id_comanda
LEFT JOIN (SELECT DISTINCT id_comanda FROM com_mancare) cm ON cm.id_comanda = c.id_comanda
WHERE EXTRACT(YEAR FROM c.data_ora_comanda) = 2023
ORDER BY c.data_ora_comanda;

-- Explicatie:
-- LEFT JOIN cu (SELECT DISTINCT id_comanda FROM ...) reduce subquery-ul la o singura
--   aparitie per comanda, evitand multiplicarea randurilor.
-- Dupa LEFT JOIN:
--   cb.id_comanda IS NOT NULL => comanda are bauturi
--   cm.id_comanda IS NOT NULL => comanda are mancare
-- Aceasta este exact tehnica din ex3.10 din tema (varianta fara EXISTS).
-- Comparatie cu ex3.3 (tema1): acela folosea INTERSECT — acelasi rezultat, alta tehnica.
