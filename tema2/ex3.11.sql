-- Restaurante3.11: Afișați primele trei comenzi pentru fiecare restaurant din orașul X.
-- Înlocuiți 'X' cu numele real al localității.
-- "Primele trei" = primele 3 în ordine cronologică (data_ora_comanda).

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
    WHERE l.nume_localitate = 'X'
) sub
WHERE rang <= 3
ORDER BY restaurant, rang;
