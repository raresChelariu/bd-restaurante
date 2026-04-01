-- Ex4: Care clienti au facut comenzi la restaurantul din localitatea 'Bucuresti' in 2023?
--      Afisati numele si prenumele clientului (fara duplicate), ordonat alfabetic.
--
-- Tabele implicate: clienti, comenzi, mese, restaurante, localitati
--   clienti:     id_client, nume, prenume, telefon, e_mail
--   comenzi:     id_comanda, data_ora_comanda, id_client, id_masa, observatii
--   mese:        id_masa, id_restaurant, masa_nr, observatii
--   restaurante: id_restaurant, den_rest, adresa_rest, id_localitate, locuri_restaurant
--   localitati:  id_localitate, nume_localitate, judet

SELECT DISTINCT
    cl.nume,
    cl.prenume
FROM clienti cl
JOIN comenzi c    ON c.id_client      = cl.id_client
JOIN mese m       ON m.id_masa        = c.id_masa
JOIN restaurante r ON r.id_restaurant = m.id_restaurant
JOIN localitati l  ON l.id_localitate = r.id_localitate
WHERE l.nume_localitate = 'Bucuresti'
  AND EXTRACT(YEAR FROM c.data_ora_comanda) = 2023
ORDER BY cl.nume, cl.prenume;

-- Explicatie:
-- Lantul de JOIN-uri: clienti -> comenzi -> mese -> restaurante -> localitati
-- DISTINCT elimina clientii care au facut mai multe comenzi in Bucuresti in 2023.
-- WHERE combina doua conditii: orasul si anul comenzii.
