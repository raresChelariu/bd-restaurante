-- Restaurante3.11: Afisati primele trei comenzi pentru fiecare restaurant din orasul X.
-- Inlocuiti 'X' cu numele real al localitatii.
-- "Primele trei" = primele 3 in ordine cronologica (data_ora_comanda).
-- select * from localitati;

SELECT
    restaurant,
    id_comanda,
    data_ora_comanda,
    rang
FROM (
    SELECT
        r.den_rest                                                         AS restaurant,
        c.id_comanda,
        c.data_ora_comanda,
        ROW_NUMBER() OVER (
            PARTITION BY r.id_restaurant
            ORDER BY c.data_ora_comanda
        )                                                                  AS rang
    FROM comenzi c
    JOIN mese m        ON m.id_masa       = c.id_masa
    JOIN restaurante r ON r.id_restaurant = m.id_restaurant
    JOIN localitati l  ON l.id_localitate = r.id_localitate
    WHERE l.nume_localitate = 'Bucuresti'
) sub
WHERE rang <= 3
ORDER BY restaurant, rang;
