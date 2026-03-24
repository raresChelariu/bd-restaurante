-- Restaurante3.1: În ce ani s-au făcut angajări?

SELECT DISTINCT EXTRACT(YEAR FROM data_angajarii)::INT AS an_angajare
FROM angajati
ORDER BY an_angajare;
