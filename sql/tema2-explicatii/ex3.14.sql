-- Restaurante3.14: Calculati ponderea fiecarui furnizor in totalul aprovizionarilor din 2023.

-- ============================================================
-- TABELE SI COLOANE IMPLICATE
-- ============================================================
-- Tabela: comenzi_produse_furnizori (cpf)
--   - id_furnizor, data_ora_comanda, pret_total
-- Tabela: furnizori
--   - id_furnizor, den_furn

-- ============================================================
-- EXPLICATIE PAS CU PAS (de la incepator la incepator)
-- ============================================================
-- "Ponderea" = procentul fiecarui furnizor din total. Adica:
--   pondere = (suma_furnizor / suma_generala) * 100
--
-- IDEEA: avem nevoie de DOUA sume:
--   1) Suma per furnizor (ce a livrat fiecare in 2023)
--   2) Suma TOTALA (ce s-a livrat in toata 2023)
-- Apoi facem raportul.
--
-- VARIANTA CLASICA: 2 subconsultari => greoi.
-- VARIANTA INTELIGENTA: folosim functii de fereastra peste rezultatul agregat.
--
-- PASUL 1: GROUP BY furnizor, dupa filtrarea pe 2023
--   SUM(cpf.pret_total) -> suma livrarilor de la fiecare furnizor in 2023
--
-- PASUL 2: Suma totala intr-o functie de fereastra
--   SUM(SUM(cpf.pret_total)) OVER ()
--   Asta arata ciudat la prima vedere - SUM in interiorul SUM!
--   Explicatia:
--     - SUM(cpf.pret_total) este suma per grup (per furnizor) - calculul de baza.
--     - SUM(...) OVER () este o functie de fereastra. Fereastra "()" inseamna
--       "fereastra completa" - fara PARTITION BY si fara ORDER BY.
--     - Aplicata peste rezultatul agregat, ne da "suma sumelor" = totalul general.
--   Asadar acelasi numar (totalul general) apare in fiecare rand al rezultatului.
--
-- PASUL 3: Calculam procentul
--   ROUND(
--       SUM(cpf.pret_total) * 100.0
--       / SUM(SUM(cpf.pret_total)) OVER (),
--       2
--   ) AS pondere_procent
--   Inmultim cu 100.0 (cu zecimale!) ca sa nu avem impartire intreaga.
--   ROUND(..., 2) -> rotunjim la 2 zecimale (ex: 23.45).
--
-- PASUL 4: ORDER BY pondere_procent DESC
--   Cele mai importante furnizori apar primii.
--
-- DE CE NU SUBCONSULTARE?
--   Am fi putut scrie:
--     ... / (SELECT SUM(pret_total) FROM cpf WHERE EXTRACT(YEAR ...) = 2023)
--   E mai lung si mai greu de citit. SUM(SUM(...)) OVER() e mai elegant.

SELECT
    f.id_furnizor,
    f.den_furn,
    SUM(cpf.pret_total)                                                  AS total_furnizor,
    SUM(SUM(cpf.pret_total)) OVER ()                                     AS total_general,
    ROUND(
        SUM(cpf.pret_total) * 100.0
        / SUM(SUM(cpf.pret_total)) OVER (),
        2
    )                                                                    AS pondere_procent
FROM comenzi_produse_furnizori cpf
JOIN furnizori f ON f.id_furnizor = cpf.id_furnizor
WHERE EXTRACT(YEAR FROM cpf.data_ora_comanda) = 2023
GROUP BY f.id_furnizor, f.den_furn
ORDER BY pondere_procent DESC;
