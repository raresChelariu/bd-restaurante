-- Ex7: Afisati fiecare angajat (nume, prenume) si categoria sa:
--        'manager'       - daca apare in tabelul manageri
--        'chelner'       - daca apare in tabelul chelneri
--        'bucatar'       - daca apare in tabelul bucatari
--        'alt angajat'   - altfel
--      Ordonati dupa categorie, apoi dupa nume.
--
-- Tabele implicate: angajati, manageri, chelneri, bucatari
--   angajati: id_angajat, nume_angajat, prenume_angajat, cnp_angajat,
--             data_nasterii, data_angajarii, id_restaurant, salariu
--   manageri: id_manager, id_restaurant, data_numirii
--   chelneri: id_chelner, punctaj_ultima_evaluare, data_ultimei_evaluari
--   bucatari: id_bucatar, specializari, data_ultimei_specializari

SELECT
    a.nume_angajat,
    a.prenume_angajat,
    CASE
        WHEN EXISTS (SELECT 1 FROM manageri  m WHERE m.id_manager  = a.id_angajat) THEN 'manager'
        WHEN EXISTS (SELECT 1 FROM chelneri  c WHERE c.id_chelner  = a.id_angajat) THEN 'chelner'
        WHEN EXISTS (SELECT 1 FROM bucatari  b WHERE b.id_bucatar  = a.id_angajat) THEN 'bucatar'
        ELSE 'alt angajat'
    END AS categorie
FROM angajati a
ORDER BY categorie, a.nume_angajat, a.prenume_angajat;

-- Explicatie:
-- CASE evalueaza conditiile in ordine si se opreste la primul WHEN adevarat.
-- EXISTS (SELECT 1 FROM ...) verifica daca exista cel putin un rand care satisface conditia.
--   SELECT 1 e conventional - nu conteaza ce selectezi, important e daca exista randuri.
-- Subinterogarea este "corelata" deoarece foloseste a.id_angajat din interogarea exterioara.
-- Aceeasi tehnica CASE + EXISTS este folosita in ex3.4 din tema.
