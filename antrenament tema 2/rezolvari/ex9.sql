-- Ex9: Pentru fiecare restaurant, afisati rangul angajatilor dupa salariu
--      (in cadrul restaurantului), cu RANK (egalii primesc acelasi rang).
--
-- Tabele implicate: restaurante, angajati
--   restaurante: id_restaurant, den_rest, adresa_rest, id_localitate, locuri_restaurant
--   angajati:    id_angajat, nume_angajat, prenume_angajat, cnp_angajat,
--                data_nasterii, data_angajarii, id_restaurant, salariu

SELECT
    r.den_rest,
    a.nume_angajat,
    a.prenume_angajat,
    a.salariu,
    RANK() OVER (
        PARTITION BY r.id_restaurant
        ORDER BY a.salariu DESC
    ) AS rang_salariu
FROM angajati a
JOIN restaurante r ON r.id_restaurant = a.id_restaurant
ORDER BY r.den_rest, rang_salariu, a.nume_angajat;

-- Explicatie:
-- RANK() OVER (PARTITION BY id_restaurant ORDER BY salariu DESC):
--   - PARTITION BY id_restaurant: rangul se reseteaza pentru fiecare restaurant
--   - ORDER BY salariu DESC: salariul cel mai mare primeste rang 1
--   - RANK: doi angajati cu acelasi salariu primesc acelasi rang (ex: 1,2,2,4)
-- Comparatie:
--   RANK()       -> 1, 2, 2, 4   (sare peste 3)
--   DENSE_RANK() -> 1, 2, 2, 3   (nu sare)
--   ROW_NUMBER() -> 1, 2, 3, 4   (intotdeauna unic, nedeterminist la egalitati)
-- Aceasta este tehnica din ex3.15 din tema (RANK pentru topuri).
