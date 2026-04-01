-- Ex10: Pentru fiecare furnizor si an calendaristic, afisati valoarea totala
--       a aprovizionarilor, cu subtotal pe furnizor si total general.
--
-- Tabele implicate: furnizori, comenzi_produse_furnizori
--   furnizori: id_furnizor, den_furn, tip_furn, adresa_furn, id_localitate
--   comenzi_produse_furnizori: id_comanda_furnizor, data_ora_comanda,
--                              id_restaurant, id_furnizor, id_produs,
--                              cantitate, pret_total

WITH baza AS (
    SELECT
        f.id_furnizor,
        f.den_furn,
        EXTRACT(YEAR FROM cpf.data_ora_comanda)::INT AS an,
        cpf.pret_total
    FROM comenzi_produse_furnizori cpf
    JOIN furnizori f ON f.id_furnizor = cpf.id_furnizor
)
SELECT
    id_furnizor,
    den_furn,
    an,
    SUM(pret_total) AS valoare_totala
FROM baza
GROUP BY GROUPING SETS (
    (id_furnizor, den_furn, an),    -- detaliu: furnizor + an
    (id_furnizor, den_furn),         -- subtotal: per furnizor (an = NULL)
    ()                               -- total general (toate campurile = NULL)
)
ORDER BY
    id_furnizor NULLS LAST,
    an          NULLS LAST;

-- Explicatie:
-- GROUPING SETS genereaza mai multe niveluri de agregare intr-o singura interogare.
--   Echivalent cu 3 interogari GROUP BY separate unite prin UNION ALL, dar mai eficient.
-- Randurile cu an = NULL sunt subtotalurile pe furnizor.
-- Randul cu id_furnizor = NULL si den_furn = NULL este totalul general.
-- Alternativa mai simpla (dar mai putin flexibila):
--   ROLLUP(id_furnizor, den_furn, an) ar genera aceleasi niveluri in ordine ierarhica.
-- Aceasta este tehnica din ex3.9 din tema (GROUPING SETS).
