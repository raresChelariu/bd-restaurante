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
--   pondere = (suma_furnizor / suma_general) * 100
--
-- Avem nevoie de DOUA sume:
--   1) Suma per furnizor (cat a livrat fiecare in 2023)
--   2) Suma TOTALA din 2023 (pentru toti furnizorii la un loc)
--
-- PASUL 1: Suma per furnizor
--   Filtram pe anul 2023, grupam dupa furnizor si calculam SUM(pret_total).
--
-- PASUL 2: Suma totala
--   O scriem ca subconsultare scalara (returneaza UN SINGUR numar):
--     (SELECT SUM(pret_total)
--        FROM comenzi_produse_furnizori
--       WHERE EXTRACT(YEAR FROM data_ora_comanda) = 2023)
--   Acelasi numar va fi folosit la fiecare rand din rezultat.
--
-- PASUL 3: Calculam procentul
--   pondere = SUM(pret_total) * 100.0 / total_general
--   Inmultim cu 100.0 (cu zecimale!) ca sa evitam impartirea intreaga.
--   ROUND(..., 2) -> rotunjim la 2 zecimale (ex: 23.45).
--
-- PASUL 4: ORDER BY pondere_procent DESC
--   Cei mai importanti furnizori apar primii.

SELECT
    f.id_furnizor,
    f.den_furn,
    SUM(cpf.pret_total) AS total_furnizor,
    ROUND(
        SUM(cpf.pret_total) * 100.0
        / (SELECT SUM(pret_total)
             FROM comenzi_produse_furnizori
            WHERE EXTRACT(YEAR FROM data_ora_comanda) = 2023),
        2
    ) AS pondere_procent
FROM comenzi_produse_furnizori cpf
JOIN furnizori f ON f.id_furnizor = cpf.id_furnizor
WHERE EXTRACT(YEAR FROM cpf.data_ora_comanda) = 2023
GROUP BY f.id_furnizor, f.den_furn
ORDER BY pondere_procent DESC;
