-- Restaurante3.15: Pentru fiecare restaurant, aflati pozitiile in topul vanzarilor
--                  pe: luna ianuarie 2023, semestrul 1 din 2023, si intreg anul 2023.

WITH vanzari_bauturi AS (
    SELECT
        r.id_restaurant,
        SUM(CASE WHEN EXTRACT(YEAR  FROM c.data_ora_comanda) = 2023
                  AND EXTRACT(MONTH FROM c.data_ora_comanda) = 1
                 THEN cb.cantitate_comandata * cb.pret_unitar ELSE 0 END) AS val_ian,
        SUM(CASE WHEN EXTRACT(YEAR  FROM c.data_ora_comanda) = 2023
                  AND EXTRACT(MONTH FROM c.data_ora_comanda) BETWEEN 1 AND 6
                 THEN cb.cantitate_comandata * cb.pret_unitar ELSE 0 END) AS val_s1,
        SUM(CASE WHEN EXTRACT(YEAR  FROM c.data_ora_comanda) = 2023
                 THEN cb.cantitate_comandata * cb.pret_unitar ELSE 0 END) AS val_an
    FROM restaurante r
    LEFT JOIN mese m         ON m.id_restaurant = r.id_restaurant
    LEFT JOIN comenzi c      ON c.id_masa        = m.id_masa
    LEFT JOIN com_bauturi cb ON cb.id_comanda    = c.id_comanda
    GROUP BY r.id_restaurant
),
vanzari_mancare AS (
    SELECT
        r.id_restaurant,
        SUM(CASE WHEN EXTRACT(YEAR  FROM c.data_ora_comanda) = 2023
                  AND EXTRACT(MONTH FROM c.data_ora_comanda) = 1
                 THEN cm.pret_unitar ELSE 0 END) AS val_ian,
        SUM(CASE WHEN EXTRACT(YEAR  FROM c.data_ora_comanda) = 2023
                  AND EXTRACT(MONTH FROM c.data_ora_comanda) BETWEEN 1 AND 6
                 THEN cm.pret_unitar ELSE 0 END) AS val_s1,
        SUM(CASE WHEN EXTRACT(YEAR  FROM c.data_ora_comanda) = 2023
                 THEN cm.pret_unitar ELSE 0 END) AS val_an
    FROM restaurante r
    LEFT JOIN mese m        ON m.id_restaurant  = r.id_restaurant
    LEFT JOIN comenzi c     ON c.id_masa         = m.id_masa
    LEFT JOIN com_mancare cm ON cm.id_comanda    = c.id_comanda
    GROUP BY r.id_restaurant
),
vanzari_totale AS (
    SELECT
        r.id_restaurant,
        r.den_rest,
        vb.val_ian + vm.val_ian AS total_ian,
        vb.val_s1  + vm.val_s1  AS total_s1,
        vb.val_an  + vm.val_an  AS total_an
    FROM restaurante r
    JOIN vanzari_bauturi vb ON vb.id_restaurant = r.id_restaurant
    JOIN vanzari_mancare vm ON vm.id_restaurant = r.id_restaurant
)
SELECT
    id_restaurant,
    den_rest,
    RANK() OVER (ORDER BY total_ian DESC) AS pozitie_ianuarie_2023,
    RANK() OVER (ORDER BY total_s1  DESC) AS pozitie_sem1_2023,
    RANK() OVER (ORDER BY total_an  DESC) AS pozitie_an_2023
FROM vanzari_totale
ORDER BY den_rest;
