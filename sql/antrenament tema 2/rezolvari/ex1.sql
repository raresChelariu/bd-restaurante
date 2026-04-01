-- Ex1: Cati clienti distincti au facut cel putin o rezervare in 2024?
--
-- Tabele implicate: rezervari
--   rezervari: id_rezervare, data_ora_rezervare, id_client,
--              data_ora_sosire, data_ora_plecare

SELECT COUNT(DISTINCT id_client) AS nr_clienti_cu_rezervari_2024
FROM rezervari
WHERE EXTRACT(YEAR FROM data_ora_rezervare) = 2024;

-- Explicatie:
-- COUNT(DISTINCT id_client) numara clientii unici, nu randurile.
-- Un client cu 5 rezervari in 2024 este numarat o singura data.
-- Comparatie cu ex3.5 din tema: acela folosea COUNT(*) fara DISTINCT
--   deoarece fiecare rand din angajati reprezinta un angajat distinct.
