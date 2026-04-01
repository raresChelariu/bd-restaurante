-- Ex7: Care clienti au facut mai multe rezervari decat clientul
--      cu id_client = 1? (inlocuiti 1 cu un id valid)
--
-- Tabele implicate: clienti, rezervari
--   clienti:   id_client, nume, prenume, telefon, e_mail
--   rezervari: id_rezervare, data_ora_rezervare, id_client,
--              data_ora_sosire, data_ora_plecare

SELECT
    cl.nume,
    cl.prenume,
    COUNT(r.id_rezervare) AS nr_rezervari
FROM clienti cl
JOIN rezervari r ON r.id_client = cl.id_client
GROUP BY cl.id_client, cl.nume, cl.prenume
HAVING COUNT(r.id_rezervare) > (
    SELECT COUNT(*)
    FROM rezervari
    WHERE id_client = 1
)
ORDER BY nr_rezervari DESC;

-- Explicatie:
-- Subquery-ul scalar (SELECT COUNT(*) FROM rezervari WHERE id_client = 1)
--   se executa O SINGURA DATA si intoarce un singur numar.
-- HAVING compara COUNT-ul fiecarui grup cu aceasta valoare.
-- Aceasta este tehnica din ex3.12 din tema (HAVING cu subquery scalar).
-- Diferenta fata de WHERE: HAVING se aplica DUPA agregare (GROUP BY).
