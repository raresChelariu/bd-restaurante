-- Ex2: Pentru fiecare manager, afisati cati subordonati au un salariu
--      strict mai mare decat salariul managerului.
--
-- Tabele implicate: manageri, angajati
--   manageri: id_manager, id_restaurant, data_numirii
--   angajati: id_angajat, nume_angajat, prenume_angajat, cnp_angajat,
--             data_nasterii, data_angajarii, id_restaurant, salariu

SELECT
    a_mgr.nume_angajat,
    a_mgr.prenume_angajat,
    a_mgr.salariu AS salariu_manager,
    COUNT(a_sub.id_angajat) AS nr_subordonati_cu_salariu_mai_mare
FROM manageri m
JOIN angajati a_mgr ON a_mgr.id_angajat   = m.id_manager
LEFT JOIN angajati a_sub ON a_sub.id_restaurant = m.id_restaurant
                        AND a_sub.id_angajat   <> m.id_manager
                        AND a_sub.salariu       > a_mgr.salariu
GROUP BY m.id_manager, a_mgr.nume_angajat, a_mgr.prenume_angajat, a_mgr.salariu
ORDER BY a_mgr.nume_angajat, a_mgr.prenume_angajat;

-- Explicatie:
-- JOIN angajati a_mgr: aduce datele managerului (via id_manager = id_angajat).
-- LEFT JOIN angajati a_sub: cauta subordonati din acelasi restaurant,
--   care nu sunt managerul insusi (id_angajat <> m.id_manager),
--   si au salariu mai mare decat managerul.
-- LEFT JOIN asigura ca managerii fara astfel de subordonati apar cu COUNT = 0.
-- Aceasta este tehnica self-join: acelasi tabel (angajati) apare de doua ori
--   cu alias-uri diferite (a_mgr si a_sub), ca in ex3.6 din tema.
