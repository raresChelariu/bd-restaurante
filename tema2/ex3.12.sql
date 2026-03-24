-- Restaurante3.12: Care sunt comenzile care conțin mai multe băuturi decât comanda X?
-- Înlocuiți X cu id-ul real al comenzii de referință.
-- "Mai multe băuturi" = cantitate totală de băuturi comandate mai mare.

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
