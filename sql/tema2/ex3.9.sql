-- Restaurante3.9: Pentru fiecare client si luna calendaristica, afisati numarul
--                 rezervarilor, cu un subtotal la nivel de an calendaristic si un total general.

WITH baza AS (
    SELECT
        cl.id_client,
        cl.nume,
        cl.prenume,
        EXTRACT(YEAR  FROM r.data_ora_rezervare)::INT AS an,
        EXTRACT(MONTH FROM r.data_ora_rezervare)::INT AS luna
    FROM rezervari r
    JOIN clienti cl ON cl.id_client = r.id_client
)
SELECT
    id_client,
    nume,
    prenume,
    an,
    luna,
    COUNT(*) AS nr_rezervari
FROM baza
GROUP BY GROUPING SETS (
    (id_client, nume, prenume, an, luna),   -- detaliu: client + an + luna
    (id_client, nume, prenume, an),          -- subtotal: client + an
    ()                                       -- total general
)
ORDER BY
    id_client NULLS LAST,
    an        NULLS LAST,
    luna      NULLS LAST;
