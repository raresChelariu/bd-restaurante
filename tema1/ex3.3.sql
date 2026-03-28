-- Restaurante3.3: Care sunt comenzile care contin si mancare, si bautura?

SELECT id_comanda FROM com_mancare
INTERSECT
SELECT id_comanda FROM com_bauturi
ORDER BY id_comanda;
