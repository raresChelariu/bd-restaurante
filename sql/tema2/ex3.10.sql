-- Restaurante3.10: Afisati, in dreptul fiecarei rezervari din 2024, tipul rezervarii
--                  (restaurant intreg / cel putin o masa / mixta).
--                  Solutia nu foloseste UNION / INTERSECT.
-- Abordare: LEFT JOIN cu subconsultari DISTINCT pentru fiecare tip de rezervare.

SELECT
    r.id_rezervare,
    r.data_ora_rezervare,
    CASE
        WHEN rr.id_rezervare IS NOT NULL
         AND rm.id_rezervare IS NOT NULL THEN 'mixta'
        WHEN rr.id_rezervare IS NOT NULL THEN 'restaurant intreg'
        ELSE                                  'cel putin o masa'
    END AS tip_rezervare
FROM rezervari r
LEFT JOIN (SELECT DISTINCT id_rezervare FROM rezervari_restaurante) rr
       ON rr.id_rezervare = r.id_rezervare
LEFT JOIN (SELECT DISTINCT id_rezervare FROM rezervari_mese) rm
       ON rm.id_rezervare = r.id_rezervare
WHERE EXTRACT(YEAR FROM r.data_ora_rezervare) = 2024
ORDER BY r.data_ora_rezervare;
