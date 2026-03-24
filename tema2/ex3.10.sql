-- Restaurante3.10: Afișați, în dreptul fiecărei rezervări din 2024, tipul rezervării
--                  (restaurant întreg / cel puțin o masă / mixtă).
--                  Soluția nu folosește UNION / INTERSECT.
-- Abordare: LEFT JOIN cu subconsultări DISTINCT pentru fiecare tip de rezervare.

SELECT
    r.id_rezervare,
    r.data_ora_rezervare,
    CASE
        WHEN rr.id_rezervare IS NOT NULL
         AND rm.id_rezervare IS NOT NULL THEN 'mixtă'
        WHEN rr.id_rezervare IS NOT NULL THEN 'restaurant întreg'
        ELSE                                  'cel puțin o masă'
    END AS tip_rezervare
FROM rezervari r
LEFT JOIN (SELECT DISTINCT id_rezervare FROM rezervari_restaurante) rr
       ON rr.id_rezervare = r.id_rezervare
LEFT JOIN (SELECT DISTINCT id_rezervare FROM rezervari_mese) rm
       ON rm.id_rezervare = r.id_rezervare
WHERE EXTRACT(YEAR FROM r.data_ora_rezervare) = 2024
ORDER BY r.data_ora_rezervare;
