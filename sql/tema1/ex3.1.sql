-- Restaurante3.1: In ce ani s-au facut angajari?

SELECT DISTINCT EXTRACT(YEAR FROM data_angajarii)::INT AS an_angajare
FROM angajati
ORDER BY an_angajare;
