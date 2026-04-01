-- Ex3: Care este cel mai mare numar de comenzi plasate intr-o singura zi?
--
-- Tabele implicate: comenzi
--   comenzi: id_comanda, data_ora_comanda, id_client, id_masa, observatii

SELECT MAX(nr_comenzi) AS max_comenzi_pe_zi
FROM (
    SELECT
        DATE(data_ora_comanda) AS zi,
        COUNT(*)               AS nr_comenzi
    FROM comenzi
    GROUP BY DATE(data_ora_comanda)
) AS comenzi_pe_zi;

-- Explicatie:
-- Subquery-ul interior grupeaza comenzile pe zi si numara fiecare grup.
-- DATE(timestamp) sau CAST(timestamp AS DATE) extrage doar data (fara ora).
-- SELECT exterior aplica MAX() peste toate aceste numaratori.
-- Aceasta este exact structura din ex3.8 din tema (MAX peste COUNT grupat).
--
-- Bonus: daca vrei sa stii si CARE zi a avut maximul:
-- SELECT zi, nr_comenzi FROM (
--     SELECT DATE(data_ora_comanda) AS zi, COUNT(*) AS nr_comenzi
--     FROM comenzi GROUP BY DATE(data_ora_comanda)
-- ) sub
-- ORDER BY nr_comenzi DESC LIMIT 1;
