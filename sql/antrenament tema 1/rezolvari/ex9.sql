-- Ex9: Care este valoarea totala cheltuita de fiecare client
--      (suma preturilor din com_bauturi + com_mancare, pe toate comenzile sale)?
--      Afisati numele, prenumele si totalul, inclusiv clientii cu total 0.
--      Ordonati descrescator dupa total.
--
-- Tabele implicate: clienti, comenzi, com_bauturi, com_mancare
--   clienti:     id_client, nume, prenume, telefon, e_mail
--   comenzi:     id_comanda, data_ora_comanda, id_client, id_masa, observatii
--   com_bauturi: id_comanda, id_bautura, cantitate_comandata, pret_unitar
--   com_mancare: id_comanda, id_sortiment_mancare, id_portie_comandata, pret_unitar

SELECT
    cl.nume,
    cl.prenume,
    COALESCE(SUM(cb.cantitate_comandata * cb.pret_unitar), 0)
    + COALESCE(SUM(cm.pret_unitar), 0) AS total_cheltuit
FROM clienti cl
LEFT JOIN comenzi c    ON c.id_client  = cl.id_client
LEFT JOIN com_bauturi cb ON cb.id_comanda = c.id_comanda
LEFT JOIN com_mancare cm ON cm.id_comanda = c.id_comanda
GROUP BY cl.id_client, cl.nume, cl.prenume
ORDER BY total_cheltuit DESC;

-- Explicatie:
-- LEFT JOIN este necesar pe tot lantul pentru a include clientii fara comenzi.
-- COALESCE(expresie, 0) inlocuieste NULL cu 0 (apare cand clientul n-are comenzi).
-- Valoarea bauturii = cantitate_comandata * pret_unitar.
-- Valoarea mancaruri = pret_unitar (pretul portiei comandate).
-- GROUP BY pe id_client (PK) garanteaza ca grupam corect chiar daca
--   doi clienti au acelasi nume.
