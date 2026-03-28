-- Restaurante3.2: Care sunt angajatii care s-au ocupat de comenzi ale clientului XYZ
--                 pe parcursul anului 2023?
-- Inlocuiti 'XYZ' cu numele efectiv al clientului (campul `nume` din tabelul `clienti`).

-- Interogare pentru a gasi numele clientilor
-- select distinct cl.nume from clienti cl;

SELECT DISTINCT
    a.id_angajat,
    a.nume_angajat,
    a.prenume_angajat
FROM comenzi c
JOIN clienti cl  ON c.id_client      = cl.id_client
JOIN mese m      ON c.id_masa        = m.id_masa
JOIN angajati a  ON a.id_restaurant  = m.id_restaurant
JOIN ture t      ON t.id_angajat     = a.id_angajat
                AND c.data_ora_comanda BETWEEN t.data_ora_inceput_tura
                                            AND t.ora_ora_sfarsit_tura
WHERE cl.nume = 'Stanescu'
  AND EXTRACT(YEAR FROM c.data_ora_comanda) = 2023
ORDER BY a.nume_angajat, a.prenume_angajat;
