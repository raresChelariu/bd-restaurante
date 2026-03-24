-- Restaurante3.4: Afișați, în dreptul fiecărei rezervări din 2024, dacă este o rezervare
--                 pentru întreg restaurantul, pentru (cel puțin) o masă, sau mixtă.

SELECT
    r.id_rezervare,
    r.data_ora_rezervare,
    CASE
        WHEN EXISTS (SELECT 1 FROM rezervari_restaurante rr WHERE rr.id_rezervare = r.id_rezervare)
         AND EXISTS (SELECT 1 FROM rezervari_mese       rm WHERE rm.id_rezervare = r.id_rezervare)
            THEN 'mixtă'
        WHEN EXISTS (SELECT 1 FROM rezervari_restaurante rr WHERE rr.id_rezervare = r.id_rezervare)
            THEN 'restaurant întreg'
        ELSE
            'cel puțin o masă'
    END AS tip_rezervare
FROM rezervari r
WHERE EXTRACT(YEAR FROM r.data_ora_rezervare) = 2024
ORDER BY r.data_ora_rezervare;
