-- Ex8: Care clienti NU au facut nicio comanda pana acum?
--      Afisati numele si prenumele clientului, ordonat alfabetic.
--
-- Tabele implicate: clienti, comenzi
--   clienti: id_client, nume, prenume, telefon, e_mail
--   comenzi: id_comanda, data_ora_comanda, id_client, id_masa, observatii

SELECT cl.nume, cl.prenume
FROM clienti cl
WHERE NOT EXISTS (
    SELECT 1
    FROM comenzi c
    WHERE c.id_client = cl.id_client
)
ORDER BY cl.nume, cl.prenume;

-- Varianta alternativa cu EXCEPT:
-- SELECT id_client FROM clienti
-- EXCEPT
-- SELECT DISTINCT id_client FROM comenzi;
-- (dar aceasta nu afiseaza si numele)

-- Explicatie:
-- NOT EXISTS returneaza TRUE daca subinterogarea nu gaseste niciun rand.
-- Subinterogarea cauta comenzi ale clientului curent (cl.id_client).
-- Daca nu exista nicio comanda, clientul este inclus in rezultat.
-- Aceasta este opusul lui EXISTS folosit in ex3.4 si ex7.
