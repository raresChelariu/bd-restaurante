-- Restaurante3.10: Afisati, in dreptul fiecarei rezervari din 2024, tipul rezervarii
--                  (restaurant intreg / cel putin o masa / mixta).
--                  Solutia nu foloseste UNION / INTERSECT.

-- ============================================================
-- TABELE SI COLOANE IMPLICATE
-- ============================================================
-- Tabela: rezervari
--   - id_rezervare, data_ora_rezervare
-- Tabela: rezervari_restaurante (rezervari pentru restaurant intreg)
--   - id_rezervare
-- Tabela: rezervari_mese (rezervari pentru o anumita masa)
--   - id_rezervare

-- ============================================================
-- EXPLICATIE PAS CU PAS (de la incepator la incepator)
-- ============================================================
-- O rezervare poate fi:
--   - "restaurant intreg" -> apare doar in rezervari_restaurante
--   - "cel putin o masa"  -> apare doar in rezervari_mese
--   - "mixta"             -> apare in AMBELE (a rezervat si restaurant si mese)
--
-- IDEEA: pentru fiecare rezervare verificam in cele doua tabele.
--   Daca exista in ambele -> mixta
--   Daca exista doar in rezervari_restaurante -> restaurant intreg
--   Daca exista doar in rezervari_mese -> cel putin o masa
--
-- PASUL 1: Plecam de la rezervari (toate rezervarile din 2024)
--   FROM rezervari r
--   WHERE EXTRACT(YEAR FROM r.data_ora_rezervare) = 2024
--
-- PASUL 2: LEFT JOIN cu rezervari_restaurante
--   Daca nu folosim DISTINCT, am putea avea duplicate (o rezervare are mai
--   multe restaurante? putin probabil, dar e mai sigur).
--   LEFT JOIN (SELECT DISTINCT id_rezervare FROM rezervari_restaurante) rr
--          ON rr.id_rezervare = r.id_rezervare
--   Daca rr.id_rezervare e NOT NULL -> rezervarea apare in tabela aceasta.
--   Daca e NULL -> nu apare.
--
-- PASUL 3: LEFT JOIN cu rezervari_mese (analog)
--   LEFT JOIN (SELECT DISTINCT id_rezervare FROM rezervari_mese) rm
--          ON rm.id_rezervare = r.id_rezervare
--
-- PASUL 4: CASE pentru a decide tipul
--   CASE
--       WHEN rr IS NOT NULL AND rm IS NOT NULL THEN 'mixta'
--       WHEN rr IS NOT NULL                    THEN 'restaurant intreg'
--       ELSE 'cel putin o masa'
--   END
--   Atentie la ordine! Verificam mai intai cazul "mixt" (ambele NOT NULL),
--   apoi doar restaurant. ELSE prinde cazul cu doar masa.
--   (Nu poate fi NIMIC, pentru ca o rezervare ori e pentru restaurant, ori
--   pentru masa - macar una din cele doua trebuie sa existe.)
--
-- DE CE NU UNION/INTERSECT?
--   Cu UNION/INTERSECT putem afla cine e in fiecare categorie, dar nu putem
--   afisa intr-o singura coloana eticheta corespunzatoare. Cu LEFT JOIN +
--   CASE rezolvam totul intr-o singura consultare clara.

SELECT
    r.id_rezervare,
    r.data_ora_rezervare,
    CASE
        WHEN rr.id_rezervare IS NOT NULL
         AND rm.id_rezervare IS NOT NULL THEN 'mixta'
        WHEN rr.id_rezervare IS NOT NULL THEN 'restaurant intreg'
        ELSE                                  'cel putin o masa'
    END AS tip_rezervare
FROM rezervari r
LEFT JOIN (SELECT DISTINCT id_rezervare FROM rezervari_restaurante) rr
       ON rr.id_rezervare = r.id_rezervare
LEFT JOIN (SELECT DISTINCT id_rezervare FROM rezervari_mese) rm
       ON rm.id_rezervare = r.id_rezervare
WHERE EXTRACT(YEAR FROM r.data_ora_rezervare) = 2024
ORDER BY r.data_ora_rezervare;
