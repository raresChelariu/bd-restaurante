-- Restaurante3.6: Pentru fiecare manager afisati numarul de subordonati.
-- Un subordonat = angajat care lucreaza la acelasi restaurant condus de manager,
-- exclusiv managerul insusi.

-- ============================================================
-- TABELE SI COLOANE IMPLICATE
-- ============================================================
-- Tabela: manageri
--   - id_manager (FK spre angajati.id_angajat) -> cine e managerul
--   - id_restaurant -> restaurantul pe care il conduce
-- Tabela: angajati (folosita de doua ori, cu alias-uri diferite!)
--   Ca "a" -> ca sa luam numele si prenumele managerului
--     - id_angajat, nume_angajat, prenume_angajat
--   Ca "sub" (subordonatii) -> ca sa numaram cati lucreaza in restaurant
--     - id_angajat, id_restaurant

-- ============================================================
-- EXPLICATIE PAS CU PAS (de la incepator la incepator)
-- ============================================================
-- Cerinta: pentru fiecare manager, sa stim cati subordonati are.
-- Definitie: subordonat = oricine lucreaza la restaurantul lui, in afara de el.
--
-- PASUL 1: Cu ce tabele lucram?
--   - "manageri" ca sa stim cine e manager si la ce restaurant
--   - "angajati" ca sa stim numele lui (e cheltuiala mica, dar trebuie sa-l afisam)
--   - "angajati" inca o data, ca sa numaram colegii din restaurant
--   ATENTIE: aceeasi tabela folosita de doua ori => trebuie alias-uri diferite!
--   De aceea folosim "a" pentru manager si "sub" pentru subordonati.
--
-- PASUL 2: Cum legam managerul de datele lui personale?
--   In tabela "manageri" avem doar id_manager (un numar).
--   Numele si prenumele sunt in "angajati".
--   JOIN angajati a ON a.id_angajat = m.id_manager
--   Adica: alipim randul din "angajati" care are acelasi id ca managerul.
--
-- PASUL 3: Cum gasim subordonatii?
--   Subordonatii sunt angajatii care lucreaza la acelasi restaurant ca managerul,
--   dar care nu sunt managerul.
--   LEFT JOIN angajati sub ON sub.id_restaurant = m.id_restaurant
--                          AND sub.id_angajat <> m.id_manager
--   De ce LEFT JOIN si nu JOIN simplu?
--     Daca un manager are zero subordonati, vrem totusi sa apara in rezultat
--     cu numarul 0. JOIN simplu l-ar fi exclus. LEFT JOIN il pastreaza.
--   "<>" inseamna "diferit de" (ca sa-l excludem pe manager din numaratoare).
--
-- PASUL 4: Cum numaram?
--   COUNT(sub.id_angajat) AS nr_subordonati
--   ATENTIE: NU folosim COUNT(*)! De ce?
--     COUNT(*) ar numara si randurile in care sub e NULL (de la LEFT JOIN
--     fara potriviri), si am obtine 1 in loc de 0.
--     COUNT(coloana) ignora valorile NULL. Asta vrem.
--
-- PASUL 5: GROUP BY
--   Pentru ca avem o functie de agregare (COUNT), trebuie sa grupam dupa
--   toate coloanele non-agregate pe care le afisam:
--   GROUP BY m.id_manager, a.nume_angajat, a.prenume_angajat
--
-- PASUL 6: ORDER BY ca sa fie usor de citit
--   ORDER BY a.nume_angajat, a.prenume_angajat (alfabetic)

SELECT
    m.id_manager,
    a.nume_angajat,
    a.prenume_angajat,
    COUNT(sub.id_angajat) AS nr_subordonati
FROM manageri m
JOIN angajati a   ON a.id_angajat   = m.id_manager
LEFT JOIN angajati sub ON sub.id_restaurant = m.id_restaurant
                      AND sub.id_angajat   <> m.id_manager
GROUP BY m.id_manager, a.nume_angajat, a.prenume_angajat
ORDER BY a.nume_angajat, a.prenume_angajat;
