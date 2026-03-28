-- Restaurante3.8: Care este cel mai mare numar de rezervari pentru o luna calendaristica?

SELECT MAX(nr_rezervari) AS max_rezervari_pe_luna
FROM (
    SELECT
        EXTRACT(YEAR  FROM data_ora_rezervare)::INT AS an,
        EXTRACT(MONTH FROM data_ora_rezervare)::INT AS luna,
        COUNT(*)                                    AS nr_rezervari
    FROM rezervari
    GROUP BY
        EXTRACT(YEAR  FROM data_ora_rezervare),
        EXTRACT(MONTH FROM data_ora_rezervare)
) AS rezervari_pe_luna;
