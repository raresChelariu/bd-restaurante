-- Restaurante3.13: Care sunt produsele comandate de măcar toți clienții care au comandat produsul X?
-- Înlocuiți X cu id-ul real al produsului de referință.
-- Tehnică: dublu NOT EXISTS (împărțire relațională).
-- "Produsul P este în rezultat dacă nu există niciun client care a comandat X dar NU a comandat P."

WITH comenzi_produs AS (
    -- produse comandate prin băuturi
    SELECT c.id_client, b.id_produs
    FROM com_bauturi cb
    JOIN comenzi c ON c.id_comanda  = cb.id_comanda
    JOIN bauturi b ON b.id_bautura  = cb.id_bautura

    UNION

    -- produse comandate prin mâncare
    SELECT c.id_client, mm.id_produs
    FROM com_mancare cm
    JOIN comenzi c          ON c.id_comanda             = cm.id_comanda
    JOIN meniuri_mancare mm ON mm.id_sortiment_mancare  = cm.id_sortiment_mancare
)
SELECT DISTINCT p.id_produs, p.den_produs
FROM produse p
WHERE p.id_produs <> X   -- opțional: excludem produsul X din rezultat
  AND NOT EXISTS (
      -- există vreun client care a comandat X dar NU a comandat acest produs?
      SELECT 1
      FROM comenzi_produs cx
      WHERE cx.id_produs = X
        AND NOT EXISTS (
            SELECT 1
            FROM comenzi_produs cp
            WHERE cp.id_client = cx.id_client
              AND cp.id_produs  = p.id_produs
        )
  )
ORDER BY p.id_produs;
