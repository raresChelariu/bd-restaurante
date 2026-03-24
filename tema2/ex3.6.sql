-- Restaurante3.6: Pentru fiecare manager afișați numărul de subordonați.
-- Un subordonat = angajat care lucrează la același restaurant condus de manager,
-- exclusiv managerul însuși.

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
