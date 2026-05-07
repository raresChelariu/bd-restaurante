-- Restaurante3.13: Care sunt produsele comandate de macar toti clientii care au comandat produsul X?
-- Inlocuiti X cu id-ul real al produsului de referinta.
-- Tehnica: dublu NOT EXISTS (impartire relationala).

-- ============================================================
-- TABELE SI COLOANE IMPLICATE
-- ============================================================
-- Tabela: comenzi
--   - id_comanda, id_client
-- Tabela: com_bauturi
--   - id_comanda, id_bautura
-- Tabela: bauturi
--   - id_bautura, id_produs (face legatura cu produse)
-- Tabela: com_mancare
--   - id_comanda, id_sortiment_mancare
-- Tabela: meniuri_mancare
--   - id_sortiment_mancare, id_produs (face legatura cu produse)
-- Tabela: produse
--   - id_produs, den_produs

-- ============================================================
-- EXPLICATIE PAS CU PAS (de la incepator la incepator)
-- ============================================================
-- Aceasta problema se numeste "impartire relationala" - cea mai grea categorie
-- de probleme din SQL standard. Sa o luam pas cu pas.
--
-- ENUNTUL TRADUS: caut produsele P astfel incat orice client care a comandat
-- produsul X a comandat si produsul P. Cu alte cuvinte, P "acopera" toti
-- clientii lui X.
--
-- TRUCUL CLASIC: in loc sa verificam pozitiv ("toti clientii lui X au luat P"),
-- verificam negativ:
--   "P trece daca NU exista vreun client care a luat X dar NU a luat P"
-- Daca nu gasesc niciun astfel de contraexemplu, atunci P trece testul.
-- Asta e DUBLU NOT EXISTS.
--
-- PASUL 1: Construim o "tabela" cu toate (client, produs) comandate
--   Un client poate comanda un produs in doua moduri: ca bautura sau ca mancare.
--   Le unim pe ambele cu UNION (UNION elimina duplicatele).
--   O punem in CTE-ul "comenzi_produs".
--   Poti rula cele doua bucati separat (decomentate mai jos) ca sa vezi continutul:

-- prin bauturi: comenzi -> com_bauturi -> bauturi -> id_produs
SELECT c.id_client, b.id_produs
FROM com_bauturi cb
JOIN comenzi c ON c.id_comanda = cb.id_comanda
JOIN bauturi b ON b.id_bautura = cb.id_bautura;

-- prin mancare: comenzi -> com_mancare -> meniuri_mancare -> id_produs
SELECT c.id_client, mm.id_produs
FROM com_mancare cm
JOIN comenzi c          ON c.id_comanda            = cm.id_comanda
JOIN meniuri_mancare mm ON mm.id_sortiment_mancare = cm.id_sortiment_mancare;
--
-- PASUL 2: SELECT din produse, filtram cu dublu NOT EXISTS
--   Vrem fiecare produs P care indeplineste:
--   "NOT EXISTS un client cx care a luat X si NU a luat P"
--   In SQL:
--     NOT EXISTS (
--         SELECT 1 FROM comenzi_produs cx
--         WHERE cx.id_produs = X                    -- cx e un client care a luat X
--           AND NOT EXISTS (
--               SELECT 1 FROM comenzi_produs cp
--               WHERE cp.id_client = cx.id_client    -- acelasi client
--                 AND cp.id_produs = p.id_produs     -- a luat si P?
--           )
--     )
--   Tradus in vorbire: "nu exista un client cx care sa fi luat X si pentru
--   care sa nu existe un rand cu el si produsul P".
--
-- PASUL 3: Excludem produsul X din rezultat (optional)
--   WHERE p.id_produs <> X
--   Pentru ca tehnic vorbind X "se acopera pe sine" trivial - dar de regula
--   nu vrem sa apara X in lista raspunsurilor.
--
-- PASUL 4: DISTINCT si ORDER BY
--   DISTINCT pentru a evita duplicate teoretice, ORDER BY pentru lizibilitate.
--
-- DE CE "SELECT 1" IN EXISTS?
--   In NOT EXISTS / EXISTS nu conteaza CE selectezi, doar daca exista randuri.
--   "SELECT 1" e o conventie scurta - nu degeaba scriem 1, am putea scrie *.
--
-- INLOCUIESTI X cu un id real, de exemplu:
--   AND cx.id_produs = 12 (daca produsul de referinta are id_produs = 12)

WITH comenzi_produs AS (
    -- produse comandate prin bauturi
    SELECT c.id_client, b.id_produs
    FROM com_bauturi cb
    JOIN comenzi c ON c.id_comanda  = cb.id_comanda
    JOIN bauturi b ON b.id_bautura  = cb.id_bautura

    UNION

    -- produse comandate prin mancare
    SELECT c.id_client, mm.id_produs
    FROM com_mancare cm
    JOIN comenzi c          ON c.id_comanda             = cm.id_comanda
    JOIN meniuri_mancare mm ON mm.id_sortiment_mancare  = cm.id_sortiment_mancare
)
SELECT DISTINCT p.id_produs, p.den_produs
FROM produse p
WHERE p.id_produs <> X   -- optional: excludem produsul X din rezultat
  AND NOT EXISTS (
      -- exista vreun client care a comandat X dar NU a comandat acest produs?
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
