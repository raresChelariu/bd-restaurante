-- Ex5: Afisati id-urile tuturor produselor care apar fie in meniuri_mancare,
--      fie in bauturi (sau in ambele).
--      Ordonati crescator dupa id_produs.
--
-- Tabele implicate: meniuri_mancare, bauturi
--   meniuri_mancare: id_sortiment_mancare, denumire_in_meniu, data_adaugarii_in_meniu,
--                    tip_mancare, id_produs, gramaj_portie, pret_unitar
--   bauturi:         id_bautura, denumire_in_meniu, data_adaugarii_in_meniu,
--                    tip_bautura, alcoolica, id_produs, cantitate_portie, pret_unitar

SELECT id_produs FROM meniuri_mancare
UNION
SELECT id_produs FROM bauturi
ORDER BY id_produs;

-- Explicatie:
-- UNION combina rezultatele celor doua SELECT-uri si elimina duplicatele automat.
-- Astfel un produs care apare atat in mancare cat si in bauturi va fi afisat o singura data.
-- UNION ALL ar pastra duplicatele (util cand vrei sa numeri aparitiile).
-- Comparatie cu ex3.3 din tema:
--   INTERSECT  -> produse care apar in AMBELE tabele
--   UNION      -> produse care apar in CEL PUTIN UNUL
--   EXCEPT     -> produse care apar in primul DAR NU si in al doilea
