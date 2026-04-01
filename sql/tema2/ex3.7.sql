-- Restaurante3.7: Pentru fiecare produs, afisati pe coloane separate valoarea
--                 comenzilor pentru anii 2021, 2022 si 2023.

WITH valori AS (
    -- valoare din bauturi comandate
    SELECT
        b.id_produs,
        EXTRACT(YEAR FROM c.data_ora_comanda)::INT         AS an,
        SUM(cb.cantitate_comandata * cb.pret_unitar)       AS valoare
    FROM com_bauturi cb
    JOIN comenzi c  ON c.id_comanda  = cb.id_comanda
    JOIN bauturi b  ON b.id_bautura  = cb.id_bautura
    GROUP BY b.id_produs, EXTRACT(YEAR FROM c.data_ora_comanda)::INT

    UNION ALL

    -- valoare din mancare comandata
    SELECT
        mm.id_produs,
        EXTRACT(YEAR FROM c.data_ora_comanda)::INT         AS an,
        SUM(cm.pret_unitar)                                AS valoare
    FROM com_mancare cm
    JOIN comenzi c        ON c.id_comanda           = cm.id_comanda
    JOIN meniuri_mancare mm ON mm.id_sortiment_mancare = cm.id_sortiment_mancare
    GROUP BY mm.id_produs, EXTRACT(YEAR FROM c.data_ora_comanda)::INT
)
SELECT
    p.id_produs,
    p.den_produs,
    COALESCE(SUM(CASE WHEN an = 2021 THEN valoare END), 0) AS valoare_2021,
    COALESCE(SUM(CASE WHEN an = 2022 THEN valoare END), 0) AS valoare_2022,
    COALESCE(SUM(CASE WHEN an = 2023 THEN valoare END), 0) AS valoare_2023
FROM produse p
LEFT JOIN valori v ON v.id_produs = p.id_produs
GROUP BY p.id_produs, p.den_produs
ORDER BY p.id_produs;
