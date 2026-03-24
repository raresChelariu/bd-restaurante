-- Restaurante3.5: Câte persoane au fost angajate în 2023?

SELECT COUNT(*) AS nr_angajati_2023
FROM angajati
WHERE EXTRACT(YEAR FROM data_angajarii) = 2023;
