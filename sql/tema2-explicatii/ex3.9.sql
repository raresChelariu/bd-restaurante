-- Restaurante3.9: Pentru fiecare client si luna calendaristica, afisati numarul
--                 rezervarilor, cu un subtotal la nivel de an calendaristic si un total general.

-- ============================================================
-- TABELE SI COLOANE IMPLICATE
-- ============================================================
-- Tabela: rezervari
--   - id_client (FK spre clienti)
--   - data_ora_rezervare (de aici scoatem anul si luna)
-- Tabela: clienti
--   - id_client, nume, prenume

-- ============================================================
-- EXPLICATIE PAS CU PAS (de la incepator la incepator)
-- ============================================================
-- Cerinta este in 3 niveluri:
--   1) DETALIU: pentru fiecare client x an x luna => numar de rezervari
--   2) SUBTOTAL: pentru fiecare client x an => total pe acel an
--   3) TOTAL GENERAL: total peste tot
--
-- Cum facem asa ceva intr-o singura consultare? Cu GROUPING SETS!
--
-- PASUL 1: Pregatim datele de baza intr-un CTE numit "baza"
--   Aici doar facem JOIN intre rezervari si clienti, ca sa avem si numele
--   si prenumele clientului, plus anul si luna extrase din timestamp.
--   Niciun GROUP BY inca - doar pregatim "materia prima".
--
-- PASUL 2: Folosim GROUPING SETS in clauza GROUP BY
--   GROUPING SETS este un GROUP BY "mai destept" care genereaza simultan
--   mai multe niveluri de agregare:
--     GROUP BY GROUPING SETS (
--         (id_client, nume, prenume, an, luna),  -- nivel detaliu
--         (id_client, nume, prenume, an),         -- subtotal pe an
--         ()                                      -- () = TOATE intr-un singur grup => total general
--     )
--   La randurile de subtotal, "luna" va fi NULL (pentru ca nu se grupeaza pe ea).
--   La totalul general, TOATE coloanele non-agregate vor fi NULL.
--
-- PASUL 3: COUNT(*) ramane simplu
--   Pentru fiecare nivel, SQL numara automat randurile care intra in acel grup.
--
-- PASUL 4: ORDER BY cu NULLS LAST
--   Vrem sa apara mai intai detaliul (cu valori), apoi subtotalurile (cu luna NULL),
--   apoi totalul general (cu toate NULL). NULLS LAST le impinge la final.
--   Sortam si dupa id_client si an ca sa fie ordonat logic.
--
-- ALTERNATIVA: ROLLUP
--   Am fi putut folosi si:
--     GROUP BY ROLLUP (id_client, nume, prenume, an, luna)
--   Dar ROLLUP genereaza si subtotal pe (id_client, nume, prenume), care nu ne trebuie.
--   GROUPING SETS ne lasa sa specificam EXACT ce niveluri vrem.

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
