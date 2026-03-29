-- Ex1: In ce luni ale anului s-au plasat comenzi in 2023?
--      Afisati numarul lunii si ordonati crescator.
--
-- Tabele implicate: comenzi
--   comenzi: id_comanda, data_ora_comanda, id_client, id_masa, observatii

SELECT DISTINCT EXTRACT(MONTH FROM data_ora_comanda)::INT AS luna
FROM comenzi
WHERE EXTRACT(YEAR FROM data_ora_comanda) = 2023
ORDER BY luna;

-- Explicatie:
-- EXTRACT(MONTH FROM ...) extrage numarul lunii (1-12) din timestamp.
-- DISTINCT elimina duplicatele, astfel fiecare luna apare o singura data.
-- WHERE filtreaza doar comenzile din 2023.
-- ::INT converteste rezultatul EXTRACT din NUMERIC in INTEGER (optional, pt afisare curata).
