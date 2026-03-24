-- ============================================================
-- Exercițiul Restaurante3.1
-- ============================================================
-- Întrebare: "În ce ani s-au făcut angajări?"
--
-- Cu alte cuvinte: vrem să știm TOȚI ANII DIFERIȚI în care
-- a fost angajat cel puțin un angajat.
-- ============================================================


-- Soluție:
-- 1. Extragem ANUL din coloana "data_angajare" folosind EXTRACT.
-- 2. Folosim DISTINCT pentru a nu afișa același an de mai multe ori
--    (mai mulți angajați pot fi angajați în același an).
-- 3. Sortăm rezultatele cu ORDER BY pentru a le afișa în ordine crescătoare.

SELECT DISTINCT
    EXTRACT(YEAR FROM data_angajare)::INT AS an_angajare
    -- EXTRACT(YEAR FROM ...) scoate doar componenta "an" dintr-o dată.
    -- ::INT convertește rezultatul la număr întreg (fără zecimale).
    -- AS an_angajare dă un nume mai ușor de citit coloanei din rezultat.
FROM angajati
ORDER BY an_angajare;


-- ============================================================
-- Rezultat așteptat (pe baza datelor din populate.sql):
-- ============================================================
--  an_angajare
-- -------------
--  2019
--  2020
--  2021
--  2022
--  2023
-- ============================================================
-- Explicație: avem angajați din 5 ani diferiți.
-- Chiar dacă există mai mulți angajați per an (ex. 2021: Andrei și Radu),
-- DISTINCT face ca fiecare an să apară o singură dată.
-- ============================================================
