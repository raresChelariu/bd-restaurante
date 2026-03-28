-- Restaurante3.14: Calculati ponderea fiecarui furnizor in totalul aprovizionarilor din 2023.

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
