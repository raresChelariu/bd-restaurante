-- Ex6: Afisati primele 2 comenzi (cronologic) pentru fiecare client.
--
-- Tabele implicate: clienti, comenzi
--   clienti: id_client, nume, prenume, telefon, e_mail
--   comenzi: id_comanda, data_ora_comanda, id_client, id_masa, observatii

SELECT
    cl.nume,
    cl.prenume,
    sub.id_comanda,
    sub.data_ora_comanda,
    sub.rang
FROM (
    SELECT
        c.id_comanda,
        c.data_ora_comanda,
        c.id_client,
        ROW_NUMBER() OVER (
            PARTITION BY c.id_client
            ORDER BY c.data_ora_comanda
        ) AS rang
    FROM comenzi c
) sub
JOIN clienti cl ON cl.id_client = sub.id_client
WHERE sub.rang <= 2
ORDER BY cl.nume, cl.prenume, sub.rang;

-- Explicatie:
-- ROW_NUMBER() OVER (PARTITION BY id_client ORDER BY data_ora_comanda):
--   - PARTITION BY id_client: reseteaza numerotarea pentru fiecare client
--   - ORDER BY data_ora_comanda: prima comanda primeste rang 1
-- WHERE rang <= 2: pastreaza doar primele 2 comenzi per client
-- Nu putem filtra cu WHERE direct in acelasi SELECT unde calculam ROW_NUMBER,
--   de aceea folosim un subquery (sau CTE cu WITH).
-- Aceasta este tehnica din ex3.11 din tema (top N per grup).
