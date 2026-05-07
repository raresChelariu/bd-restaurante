-- Restaurante3.12: Care sunt comenzile care contin mai multe bauturi decat comanda X?
-- Inlocuiti X cu id-ul real al comenzii de referinta.
-- "Mai multe bauturi" = cantitate totala de bauturi comandate mai mare.

-- ============================================================
-- TABELE SI COLOANE IMPLICATE
-- ============================================================
-- Tabela: com_bauturi
--   - id_comanda, cantitate_comandata

-- ============================================================
-- EXPLICATIE PAS CU PAS (de la incepator la incepator)
-- ============================================================
-- Cerinta: gasim toate comenzile care au mai multe bauturi (cantitate totala)
-- decat o comanda specifica X.
--
-- IDEEA: facem comparatie a fiecarei comenzi cu un singur numar - totalul lui X.
--
-- PASUL 1: Calculam totalul de bauturi pentru fiecare comanda
--   Aici intr-un rand avem o comanda si numarul total de bauturi din ea.
--   Poti rula separat (decomentat mai jos) ca sa vezi rezultatul:
SELECT id_comanda, SUM(cantitate_comandata) AS total_bauturi
FROM com_bauturi
GROUP BY id_comanda;
--
-- PASUL 2: Calculam totalul pentru comanda X (un singur numar)
--   SELECT SUM(cantitate_comandata)
--   FROM com_bauturi
--   WHERE id_comanda = X
--   Asta returneaza un scalar (un singur numar).
--
-- PASUL 3: Comparam cu HAVING
--   DE CE HAVING si nu WHERE?
--     WHERE filtreaza randurile INAINTE de agregare.
--     HAVING filtreaza grupurile DUPA agregare (pe rezultatul lui SUM).
--   In cazul nostru vrem sa pastram doar comenzile al caror SUM > totalul lui X:
--     HAVING SUM(cantitate_comandata) > (subconsultarea pentru X)
--
-- PASUL 4: ORDER BY total_bauturi DESC
--   Cele mai mari comenzi apar primele - util sa vezi imediat top.
--
-- ATENTIE: trebuie sa inlocuiesti X cu id-ul real al unei comenzi
-- (de exemplu, daca vezi in date ca exista o comanda 1023, scrii 1023 in loc de X).

SELECT
    id_comanda,
    SUM(cantitate_comandata) AS total_bauturi
FROM com_bauturi
GROUP BY id_comanda
HAVING SUM(cantitate_comandata) > (
    SELECT SUM(cantitate_comandata)
    FROM com_bauturi
    WHERE id_comanda = X
)
ORDER BY total_bauturi DESC;
