-- Restaurante3.3: Care sunt comenzile care conțin și mâncare, și băutură?

SELECT id_comanda FROM com_mancare
INTERSECT
SELECT id_comanda FROM com_bauturi
ORDER BY id_comanda;
