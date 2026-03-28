-- Restaurante3.5: Cate persoane au fost angajate in 2023?

SELECT COUNT(*) AS nr_angajati_2023
FROM angajati
WHERE EXTRACT(YEAR FROM data_angajarii) = 2023;
