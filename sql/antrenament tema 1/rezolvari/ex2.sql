-- Ex2: Cati angajati are fiecare restaurant?
--      Afisati numele restaurantului si numarul de angajati,
--      ordonat descrescator dupa numarul de angajati.
--
-- Tabele implicate: restaurante, angajati
--   restaurante: id_restaurant, den_rest, adresa_rest, id_localitate, locuri_restaurant
--   angajati:    id_angajat, nume_angajat, prenume_angajat, cnp_angajat,
--                data_nasterii, data_angajarii, id_restaurant, salariu

SELECT
    r.den_rest,
    COUNT(a.id_angajat) AS nr_angajati
FROM restaurante r
LEFT JOIN angajati a ON a.id_restaurant = r.id_restaurant
GROUP BY r.id_restaurant, r.den_rest
ORDER BY nr_angajati DESC;

-- Explicatie:
-- LEFT JOIN asigura ca apar si restaurantele fara angajati (cu COUNT = 0).
-- GROUP BY grupeaza rezultatele pe restaurant.
-- COUNT(a.id_angajat) numara angajatii; COUNT(*) ar numara si randurile NULL
--   rezultate din LEFT JOIN, deci e preferabila varianta cu coloana specifica.
