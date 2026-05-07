-- Restaurante3.11: Afisati primele trei comenzi pentru fiecare restaurant din orasul X.
-- Inlocuiti 'X' cu numele real al localitatii.
-- "Primele trei" = primele 3 in ordine cronologica (data_ora_comanda).

SELECT
    r.den_rest         AS restaurant,
    c.id_comanda,
    c.data_ora_comanda
FROM comenzi c
JOIN mese m        ON m.id_masa       = c.id_masa
JOIN restaurante r ON r.id_restaurant = m.id_restaurant
JOIN localitati l  ON l.id_localitate = r.id_localitate
WHERE l.nume_localitate = 'Bucuresti'
  AND (
      SELECT COUNT(*)
      FROM comenzi c2
      JOIN mese m2 ON m2.id_masa = c2.id_masa
      WHERE m2.id_restaurant       = r.id_restaurant
        AND c2.data_ora_comanda    < c.data_ora_comanda
  ) < 3
ORDER BY r.den_rest, c.data_ora_comanda;
