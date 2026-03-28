-- Restaurante3.4: Afisati, in dreptul fiecarei rezervari din 2024, daca este o rezervare
--                 pentru intreg restaurantul, pentru (cel putin) o masa, sau mixta.

SELECT
    r.id_rezervare,
    r.data_ora_rezervare,
    CASE
        WHEN EXISTS (SELECT 1 FROM rezervari_restaurante rr WHERE rr.id_rezervare = r.id_rezervare)
         AND EXISTS (SELECT 1 FROM rezervari_mese       rm WHERE rm.id_rezervare = r.id_rezervare)
            THEN 'mixta'
        WHEN EXISTS (SELECT 1 FROM rezervari_restaurante rr WHERE rr.id_rezervare = r.id_rezervare)
            THEN 'restaurant intreg'
        ELSE
            'cel putin o masa'
    END AS tip_rezervare
FROM rezervari r
WHERE EXTRACT(YEAR FROM r.data_ora_rezervare) = 2024
ORDER BY r.data_ora_rezervare;
