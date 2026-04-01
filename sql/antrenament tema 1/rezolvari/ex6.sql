-- Ex6: Care produse NU apar in nicio bautura din meniu?
--      Afisati id_produs si den_produs.
--
-- Tabele implicate: produse, bauturi
--   produse: id_produs, den_produs, categorie_produs
--   bauturi: id_bautura, denumire_in_meniu, data_adaugarii_in_meniu,
--            tip_bautura, alcoolica, id_produs, cantitate_portie, pret_unitar

SELECT id_produs, den_produs FROM produse
EXCEPT
SELECT b.id_produs, p.den_produs
FROM bauturi b
JOIN produse p ON p.id_produs = b.id_produs
ORDER BY id_produs;

-- Varianta alternativa cu NOT EXISTS (mai explicita):
-- SELECT p.id_produs, p.den_produs
-- FROM produse p
-- WHERE NOT EXISTS (
--     SELECT 1 FROM bauturi b WHERE b.id_produs = p.id_produs
-- )
-- ORDER BY p.id_produs;

-- Explicatie EXCEPT:
-- Primul SELECT: toate produsele.
-- Al doilea SELECT: produsele care apar in bauturi.
-- EXCEPT returneaza randurile din primul set care NU apar in al doilea.
-- ATENTIE: coloanele trebuie sa fie compatibile ca numar si tip in ambele SELECT-uri.
