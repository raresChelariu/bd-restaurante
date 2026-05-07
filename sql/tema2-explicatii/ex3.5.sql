-- Restaurante3.5: Cate persoane au fost angajate in 2023?

-- ============================================================
-- TABELE SI COLOANE IMPLICATE
-- ============================================================
-- Tabela: angajati
--   - data_angajarii (DATE) -> data la care a fost angajata persoana
--   - folosim COUNT(*) ca sa numaram toate randurile care indeplinesc conditia

-- ============================================================
-- EXPLICATIE PAS CU PAS (de la incepator la incepator)
-- ============================================================
-- Salut! Cerinta zice "cate persoane au fost angajate in 2023".
-- "Cate" => trebuie sa numaram, deci o sa folosim COUNT.
-- "Persoane angajate" => sunt randurile din tabela "angajati".
-- "In 2023" => trebuie sa filtram dupa anul din data_angajarii.
--
-- PASUL 1: De unde luam datele?
--   Din tabela "angajati", pentru ca acolo sunt persoanele angajate.
--   FROM angajati
--
-- PASUL 2: Cum filtram doar 2023?
--   Avem coloana "data_angajarii" care este de tip DATE (de exemplu 2023-05-12).
--   Vrem doar randurile unde anul este 2023.
--   In PostgreSQL, ca sa scoatem anul dintr-o data, folosim functia EXTRACT:
--     EXTRACT(YEAR FROM data_angajarii) -> ne da anul ca numar (ex: 2023)
--   Apoi punem conditia: ... = 2023
--   WHERE EXTRACT(YEAR FROM data_angajarii) = 2023
--
-- PASUL 3: Cum numaram?
--   COUNT(*) numara toate randurile care au trecut de filtrul WHERE.
--   Ii dam si un nume frumos coloanei rezultate cu AS:
--     COUNT(*) AS nr_angajati_2023
--
-- Si gata! Punem totul cap la cap.

SELECT COUNT(*) AS nr_angajati_2023
FROM angajati
WHERE EXTRACT(YEAR FROM data_angajarii) = 2023;


select * from localitati;

select * from restaurante;