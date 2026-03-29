-- Ex3: Care restaurante au mai mult de 3 angajati?
--      Afisati numele restaurantului si numarul de angajati.
--
-- Tabele implicate: restaurante, angajati
--   restaurante: id_restaurant, den_rest, adresa_rest, id_localitate, locuri_restaurant
--   angajati:    id_angajat, nume_angajat, prenume_angajat, cnp_angajat,
--                data_nasterii, data_angajarii, id_restaurant, salariu

SELECT
    r.den_rest,
    COUNT(a.id_angajat) AS nr_angajati
FROM restaurante r
JOIN angajati a ON a.id_restaurant = r.id_restaurant
GROUP BY r.id_restaurant, r.den_rest
HAVING COUNT(a.id_angajat) > 3
ORDER BY nr_angajati DESC;

-- Explicatie:
-- HAVING filtreaza DUPA agregare (spre deosebire de WHERE care filtreaza inainte).
-- Nu putem scrie WHERE nr_angajati > 3 deoarece alias-urile din SELECT
--   nu sunt inca disponibile in WHERE (se evalueaza inainte de SELECT).
-- HAVING COUNT(...) > 3 functioneaza corect.
