-- Restaurante3.8: Care este cel mai mare numar de rezervari pentru o luna calendaristica?

SELECT count(*) nr_rezervari FROM rezervari
group by 
    EXTRACT(YEAR  FROM data_ora_rezervare),
    EXTRACT(MONTH FROM data_ora_rezervare)
ORDER BY
    nr_rezervari DESC
LIMIT 1;
