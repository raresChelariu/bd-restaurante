-- Restaurante3.12: Care sunt comenzile care contin mai multe bauturi decat comanda X?
-- Inlocuiti X cu id-ul real al comenzii de referinta.
-- "Mai multe bauturi" = cantitate totala de bauturi comandate mai mare.

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
