-- Restaurante3.8: Care este cel mai mare numar de rezervari pentru o luna calendaristica?

-- ============================================================
-- TABELE SI COLOANE IMPLICATE
-- ============================================================
-- Tabela: rezervari
--   - data_ora_rezervare (TIMESTAMP) -> de aici scoatem anul si luna

-- ============================================================
-- EXPLICATIE PAS CU PAS (de la incepator la incepator)
-- ============================================================
-- Cerinta: care e cel mai mare numar de rezervari intr-o luna calendaristica?
-- "O luna calendaristica" inseamna combinatia an + luna (ex: ianuarie 2023).
-- Deci NU vrem sa amestecam ianuarie 2023 cu ianuarie 2024.
--
-- IDEEA: Mai intai numar rezervarile pe fiecare luna, apoi iau MAX-ul.
-- Asta inseamna ca avem nevoie de DOUA pasi - asa ca folosim o subconsultare.
--
-- PASUL 1 (subconsultarea interna): cate rezervari pe fiecare luna?
--   Scot anul si luna din data_ora_rezervare:
--     EXTRACT(YEAR  FROM data_ora_rezervare) AS an
--     EXTRACT(MONTH FROM data_ora_rezervare) AS luna
--   Numar randurile cu COUNT(*) si grupez dupa an si luna:
--     SELECT an, luna, COUNT(*) AS nr_rezervari
--     FROM rezervari
--     GROUP BY an, luna
--   Asta imi da o lista cu fiecare luna si cate rezervari are.
--   Ii pun un alias: "rezervari_pe_luna".
--
-- PASUL 2 (consultarea externa): MAX din toate aceste numere
--   SELECT MAX(nr_rezervari) FROM (subconsultarea de mai sus)
--   Asta imi da un singur numar: cea mai aglomerata luna.
--
-- DE CE NU MERGE INTR-UN SINGUR PAS?
--   Nu poti scrie SELECT MAX(COUNT(*)) - SQL nu permite agregari imbricate
--   direct. Trebuie sa faci primul COUNT in subconsultare, apoi MAX afara.
--
-- DETALIU: ::INT
--   EXTRACT returneaza un NUMERIC. Cu "::INT" il convertim la intreg.
--   Pentru calcul nu schimba nimic, dar afisarea e mai curata.

SELECT MAX(nr_rezervari) AS max_rezervari_pe_luna
FROM (
    SELECT
        EXTRACT(YEAR  FROM data_ora_rezervare)::INT AS an,
        EXTRACT(MONTH FROM data_ora_rezervare)::INT AS luna,
        COUNT(*)                                    AS nr_rezervari
    FROM rezervari
    GROUP BY
        EXTRACT(YEAR  FROM data_ora_rezervare),
        EXTRACT(MONTH FROM data_ora_rezervare)
) AS rezervari_pe_luna;
