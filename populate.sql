-- ============================================================
-- Script de populare cu date realiste (România)
-- ============================================================
-- Rulează DUPĂ create_tables.sql.
-- Ordinea INSERT-urilor respectă dependențele dintre tabele:
-- tabelele referite (cu FK) sunt populate înaintea celor care le referă.
-- ============================================================


-- ============================================================
-- 1. LOCALITATI
-- ============================================================
INSERT INTO localitati (id_localitate, nume_localitate, judet) VALUES
    (1, 'București',   'Ilfov'),
    (2, 'Cluj-Napoca', 'Cluj'),
    (3, 'Iași',        'Iași');


-- ============================================================
-- 2. CLIENTI
-- ============================================================
INSERT INTO clienti (id_client, nume, prenume, telefon, e_mail) VALUES
    (1, 'Stanescu',  'Mihai',     '0722-111-222', 'mihai.stanescu@gmail.com'),
    (2, 'Radu',      'Ana Maria', '0744-333-444', 'ana.radu@yahoo.com'),
    (3, 'Georgescu', 'Alexandru', '0766-555-666', 'alex.georgescu@gmail.com'),
    (4, 'Petrescu',  'Ioana',     '0788-777-888', 'ioana.petrescu@hotmail.com'),
    (5, 'Marin',     'Bogdan',    '0755-999-000', 'bogdan.marin@gmail.com');


-- ============================================================
-- 3. PRODUSE (materii prime / ingrediente de baza)
-- ============================================================
-- Acestea sunt ingredientele care stau la baza bautuilor si
-- mancarii din meniu, si care sunt aprovizionate de la furnizori.
INSERT INTO produse (id_produs, den_produs, categorie_produs) VALUES
    (1,  'Carne de porc',             'Carne'),
    (2,  'Varza alba',                'Legume'),
    (3,  'Lapte acru',                'Lactate'),
    (4,  'Struguri Feteasca Neagra',  'Fructe/Vinificatie'),
    (5,  'Hamei si malt',             'Ingrediente bere'),
    (6,  'Apa minerala',              'Bauturi nealcoolice'),
    (7,  'Sfecla rosie',              'Legume'),
    (8,  'Faina alba',                'Cereale'),
    (9,  'Branza de vaci',            'Lactate'),
    (10, 'Struguri Feteasca Regala',  'Fructe/Vinificatie'),
    (11, 'Prune',                     'Fructe'),
    (12, 'Boabe de cafea',            'Bauturi calde'),
    (13, 'Pui intreg',                'Carne'),
    (14, 'Oua',                       'Produse lactate');


-- ============================================================
-- 4. RESTAURANTE (FK → localitati)
-- ============================================================
INSERT INTO restaurante (id_restaurant, den_rest, adresa_rest, id_localitate, locuri_restaurant) VALUES
    (1, 'La Mama',        'Str. Epictet 1, Sector 1',      1, 60),
    (2, 'Caru cu Bere',   'Str. Stavropoleos 5, Sector 3', 1, 120),
    (3, 'Vatra',          'Str. Memorandumului 12',         2, 40);


-- ============================================================
-- 5. FURNIZORI (FK → localitati)
-- ============================================================
INSERT INTO furnizori (id_furnizor, den_furn, tip_furn, adresa_furn, id_localitate) VALUES
    (1, 'Lactate Dorna SRL',      'Produse lactate',    'Str. Dornei 5',        3),
    (2, 'Bauturi Maramures SRL',  'Bauturi alcoolice',  'Bd. Unirii 12',        2),
    (3, 'Agricola Bacau SA',      'Carne si legume',    'Str. Marasesti 8',     1),
    (4, 'Panificatie Buftea SRL', 'Produse de panif.',  'Sos. Bucuresti-Ploi.', 1);


-- ============================================================
-- 6. BAUTURI (FK → produse)
-- ============================================================
-- Bautura din meniu este derivata dintr-un produs de baza (ingredient principal).
INSERT INTO bauturi (id_bautura, denumire_in_meniu, data_adaugarii_in_meniu, tip_bautura, alcoolica, id_produs, cantitate_portie, pret_unitar) VALUES
    (1, 'Vin Feteasca Neagra (250ml)', '2020-01-10', 'vin rosu',    13.5,  4, 250,  35.00),
    (2, 'Bere Ursus (500ml)',          '2020-01-10', 'bere',         5.0,  5, 500,  15.00),
    (3, 'Apa minerala Borsec (500ml)', '2020-01-10', 'apa minerala', 0.0,  6, 500,   8.00),
    (4, 'Vin Feteasca Regala (250ml)', '2020-03-01', 'vin alb',     12.0, 10, 250,  40.00),
    (5, 'Palinca de prune (50ml)',     '2020-06-01', 'rachiu',      45.0, 11,  50,  30.00),
    (6, 'Cafea espresso',             '2020-01-10', 'cafea',        0.0, 12,  30,  12.00),
    (7, 'Tuica Cluj (50ml)',          '2021-03-01', 'rachiu',      40.0, 11,  50,  20.00),
    (8, 'Vin de Tarnave (250ml)',     '2021-03-01', 'vin alb',     11.5, 10, 250,  38.00);


-- ============================================================
-- 7. MENIURI_MANCARE (FK → produse)
-- ============================================================
INSERT INTO meniuri_mancare (id_sortiment_mancare, denumire_in_meniu, data_adaugarii_in_meniu, tip_mancare, id_produs, gramaj_portie, pret_unitar) VALUES
    (1,  'Mici cu mustar',           '2019-03-01', 'gratar',      1, 200, 32.00),
    (2,  'Sarmale cu mamaliga',      '2019-03-01', 'traditionala',2, 350, 38.00),
    (3,  'Ciorba de burta',          '2019-03-01', 'ciorba',      3, 400, 25.00),
    (4,  'Tochitura moldoveneasca',  '2019-05-01', 'traditionala',1, 300, 45.00),
    (5,  'Salata de boeuf',          '2019-04-01', 'salata',      9, 250, 22.00),
    (6,  'Pastrama de oaie',         '2019-06-01', 'gratar',     13, 300, 55.00),
    (7,  'Cozonac cu nuca',          '2020-12-01', 'desert',      8, 200, 18.00),
    (8,  'Placinta cu branza',       '2020-01-10', 'patiserie',   9, 250, 20.00),
    (9,  'Ciorba ardeleneasca',      '2021-01-05', 'ciorba',      1, 400, 28.00),
    (10, 'Varza cu carne',           '2021-01-05', 'traditionala',2, 400, 35.00),
    (11, 'Langos cu smantana',       '2021-03-01', 'patiserie',   8, 200, 22.00),
    (12, 'Papanasi cu smantana',     '2021-03-01', 'desert',     14, 200, 25.00);


-- ============================================================
-- 8. MESE (FK → restaurante)
-- ============================================================
INSERT INTO mese (id_masa, id_restaurant, masa_nr, observatii) VALUES
    -- La Mama (id_restaurant=1)
    (1, 1, 1, 'Langa fereastra'),
    (2, 1, 2, 'Terasa interioara'),
    (3, 1, 3, 'Rezervata fumatori'),
    -- Caru cu Bere (id_restaurant=2)
    (4, 2, 1, 'Sala principala'),
    (5, 2, 2, 'Etaj, vedere la hol'),
    -- Vatra (id_restaurant=3)
    (6, 3, 1, 'Langa semineu'),
    (7, 3, 2, 'Terasa'),
    (8, 3, 3, 'Cabinet privat');


-- ============================================================
-- 9. ANGAJATI (FK → restaurante)
-- ============================================================
-- Angajați din ani diferiți → necesari pentru exercițiul 3.1
-- CNP-urile sunt fictive, create doar în scop educațional.
INSERT INTO angajati (id_angajat, nume_angajat, prenume_angajat, cnp_angajat, data_nasterii, data_angajarii, id_restaurant, salariu) VALUES
    -- La Mama (id_restaurant=1)
    (1,  'Popescu',    'Ion',      '1800510400001', '1980-05-10', '2019-05-15', 1, 6500),
    (2,  'Ionescu',    'Maria',    '2850320400002', '1985-03-20', '2020-03-10', 1, 5000),
    (3,  'Dumitrescu', 'Andrei',   '1950615400003', '1995-06-15', '2021-06-01', 1, 3500),
    (4,  'Constantin', 'Elena',    '2980920400004', '1998-09-20', '2022-09-15', 1, 3500),
    (5,  'Popa',       'Gheorghe', '1780228400005', '1978-02-28', '2023-02-20', 1, 5500),
    -- Caru cu Bere (id_restaurant=2)
    (6,  'Moldovan',   'Cristina', '2820410400006', '1982-04-10', '2020-04-01', 2, 7000),
    (7,  'Stanescu',   'Radu',     '1960825400007', '1996-08-25', '2021-08-15', 2, 3500),
    (8,  'Florescu',   'Ioana',    '2991105400008', '1999-11-05', '2022-11-01', 2, 3500),
    -- Vatra (id_restaurant=3)
    (9,  'Vasile',     'Dumitru',  '1751130400009', '1975-11-30', '2019-11-20', 3, 6000),
    (10, 'Dinu',       'Mihaela',  '6000715400010', '2000-07-15', '2023-07-10', 3, 3000);
-- Ani de angajare: 2019, 2020, 2021, 2022, 2023


-- ============================================================
-- 10. MANAGERI (FK → angajati, restaurante)
-- ============================================================
-- Un manager este și angajat: id_manager = id_angajat din tabelul angajati.
INSERT INTO manageri (id_manager, id_restaurant, data_numirii) VALUES
    (1, 1, '2019-05-15'),  -- Popescu Ion → manager La Mama
    (6, 2, '2020-04-01'),  -- Moldovan Cristina → manager Caru cu Bere
    (9, 3, '2019-11-20');  -- Vasile Dumitru → manager Vatra


-- ============================================================
-- 11. CHELNERI (FK → angajati)
-- ============================================================
-- Un chelner este și angajat: id_chelner = id_angajat.
INSERT INTO chelneri (id_chelner, punctaj_ultima_evaluare, data_ultimei_evaluari) VALUES
    (3,  9.50, '2024-01-15'),  -- Dumitrescu Andrei
    (4,  8.80, '2024-01-15'),  -- Constantin Elena
    (7,  9.20, '2024-01-15'),  -- Stanescu Radu
    (8,  8.50, '2024-01-15'),  -- Florescu Ioana
    (10, 7.90, '2024-01-15');  -- Dinu Mihaela


-- ============================================================
-- 12. BUCATARI (FK → angajati)
-- ============================================================
INSERT INTO bucatari (id_bucatar, specializari, data_ultimei_specializari) VALUES
    (2, 'Bucatarie traditionala romaneasca', '2022-03-10'),  -- Ionescu Maria
    (5, 'Grill si preparate la gratar',      '2023-05-20');  -- Popa Gheorghe


-- ============================================================
-- 13. TURE (FK → angajati)
-- ============================================================
-- O tura = un interval de lucru al unui angajat.
-- Prin TURE putem afla ce chelner a servit o comanda:
-- chelnerul era de tura la restaurant in momentul comenzii.
-- Necesar pentru exercitiul 3.2.
INSERT INTO ture (id_angajat, data_ora_inceput_tura, ora_ora_sfarsit_tura, observatii) VALUES
    -- Andrei Dumitrescu (chelner, La Mama)
    (3, '2021-03-15 11:00:00', '2021-03-15 23:00:00', NULL),
    (3, '2021-06-20 18:00:00', '2021-06-20 23:00:00', NULL),
    (3, '2023-01-10 18:00:00', '2023-01-10 23:00:00', NULL),
    (3, '2023-02-14 18:00:00', '2023-02-14 23:00:00', NULL),  -- acoperă comanda 5 (Mihai)
    (3, '2023-08-22 18:00:00', '2023-08-22 23:00:00', NULL),  -- acoperă comanda 12 (Mihai)
    (3, '2024-03-08 19:00:00', '2024-03-08 23:00:00', NULL),
    -- Elena Constantin (chelner, La Mama)
    (4, '2022-04-10 10:00:00', '2022-04-10 18:00:00', NULL),
    (4, '2023-01-20 11:00:00', '2023-01-20 16:00:00', NULL),
    (4, '2023-05-20 10:00:00', '2023-05-20 18:00:00', NULL),  -- acoperă comanda 6 (Mihai)
    -- Radu Stanescu (chelner, Caru cu Bere)
    (7, '2022-09-05 19:00:00', '2022-09-05 23:00:00', NULL),
    (7, '2023-01-25 19:00:00', '2023-01-25 23:00:00', NULL),
    (7, '2023-07-08 20:00:00', '2023-07-08 23:00:00', NULL),
    (7, '2024-04-12 18:00:00', '2024-04-12 23:00:00', NULL),
    -- Ioana Florescu (chelner, Caru cu Bere)
    (8, '2023-04-15 18:00:00', '2023-04-15 23:00:00', NULL),
    (8, '2023-11-15 17:00:00', '2023-11-15 23:00:00', NULL),
    -- Mihaela Dinu (chelner, Vatra)
    (10, '2023-03-15 18:00:00', '2023-03-15 23:00:00', NULL),
    (10, '2023-09-10 10:00:00', '2023-09-10 18:00:00', NULL),
    (10, '2024-01-20 10:00:00', '2024-01-20 18:00:00', NULL);


-- ============================================================
-- 14. COMENZI (FK → clienti, mese)
-- ============================================================
-- Comanda se plasează la o masă; restaurantul se deduce prin masă.
-- Chelnerul care a servit se deduce prin ture (vezi ex. 3.2).
INSERT INTO comenzi (id_comanda, data_ora_comanda, id_client, id_masa, observatii) VALUES
    (1,  '2021-03-15 12:30:00', 2, 1, NULL),  -- Ana Maria    @ La Mama (masa 1), 2021
    (2,  '2021-06-20 19:00:00', 3, 2, NULL),  -- Alexandru    @ La Mama (masa 2), 2021
    (3,  '2022-04-10 13:45:00', 4, 3, NULL),  -- Ioana        @ La Mama (masa 3), 2022
    (4,  '2022-09-05 20:00:00', 2, 4, NULL),  -- Ana Maria    @ Caru (masa 4),    2022
    (5,  '2023-02-14 19:30:00', 1, 1, NULL),  -- MIHAI/XYZ    @ La Mama (masa 1), 2023
    (6,  '2023-05-20 12:00:00', 1, 2, NULL),  -- MIHAI/XYZ    @ La Mama (masa 2), 2023
    (7,  '2023-07-08 21:00:00', 2, 4, NULL),  -- Ana Maria    @ Caru (masa 4),    2023
    (8,  '2023-11-15 18:30:00', 3, 5, NULL),  -- Alexandru    @ Caru (masa 5),    2023
    (9,  '2024-01-20 13:00:00', 5, 6, NULL),  -- Bogdan       @ Vatra (masa 6),   2024
    (10, '2024-03-08 20:00:00', 4, 1, NULL),  -- Ioana        @ La Mama (masa 1), 2024
    (11, '2024-04-12 19:00:00', 2, 4, NULL),  -- Ana Maria    @ Caru (masa 4),    2024
    (12, '2023-08-22 20:30:00', 1, 3, NULL),  -- MIHAI/XYZ    @ La Mama (masa 3), 2023
    (13, '2023-01-10 19:00:00', 3, 1, NULL),  -- Alexandru    @ La Mama (masa 1), 2023
    (14, '2023-01-20 12:30:00', 4, 2, NULL),  -- Ioana        @ La Mama (masa 2), 2023
    (15, '2023-01-25 20:00:00', 2, 4, NULL),  -- Ana Maria    @ Caru (masa 4),    2023
    (16, '2023-04-15 19:30:00', 5, 5, NULL),  -- Bogdan       @ Caru (masa 5),    2023
    (17, '2023-09-10 13:00:00', 2, 7, NULL),  -- Ana Maria    @ Vatra (masa 7),   2023
    (18, '2023-03-15 19:00:00', 3, 8, NULL);  -- Alexandru    @ Vatra (masa 8),   2023
-- Exercitiul 3.2: Mihai (id_client=1) a comandat in 2023: comenzile 5, 6, 12
--   Turile arata ca: Andrei a servit comenzile 5 si 12, Elena a servit comanda 6.


-- ============================================================
-- 15. COM_BAUTURI (FK → comenzi, bauturi)
-- ============================================================
-- Bauturi comandate in fiecare comanda.
-- id_bautura 1=Vin Feteasca Neagra, 2=Bere Ursus, 3=Apa minerala,
--            4=Vin Feteasca Regala, 5=Palinca, 6=Cafea, 7=Tuica, 8=Vin Tarnave
INSERT INTO com_bauturi (id_comanda, id_bautura, cantitate_comandata, pret_unitar) VALUES
    -- Comanda 1: bautura
    (1,  2, 2, 15.00),   -- Bere Ursus x2
    -- Comanda 3: bautura
    (3,  1, 1, 35.00),   -- Vin Feteasca Neagra x1
    -- Comanda 4: bautura
    (4,  5, 1, 30.00),   -- Palinca x1
    -- Comanda 5: bautura (Mihai)
    (5,  3, 2,  8.00),   -- Apa minerala x2
    -- Comanda 7: bautura
    (7,  5, 2, 30.00),   -- Palinca x2
    (7,  6, 1, 12.00),   -- Cafea x1
    -- Comanda 8: bautura
    (8,  4, 1, 40.00),   -- Vin Feteasca Regala x1
    -- Comanda 10: bautura
    (10, 2, 2, 15.00),   -- Bere Ursus x2
    -- Comanda 11: bautura
    (11, 4, 2, 40.00),   -- Vin Feteasca Regala x2
    -- Comanda 12: bautura (Mihai)
    (12, 1, 2, 35.00),   -- Vin Feteasca Neagra x2
    (12, 2, 1, 15.00),   -- Bere Ursus x1
    -- Comanda 13: bautura
    (13, 1, 1, 35.00),   -- Vin Feteasca Neagra x1
    -- Comanda 15: bautura
    (15, 6, 1, 12.00),   -- Cafea x1
    -- Comanda 16: bautura
    (16, 4, 1, 40.00),   -- Vin Feteasca Regala x1
    (16, 5, 1, 30.00),   -- Palinca x1
    -- Comanda 17: bautura
    (17, 1, 1, 35.00),   -- Vin Feteasca Neagra x1
    -- Comanda 18: bautura
    (18, 7, 1, 20.00);   -- Tuica Cluj x1


-- ============================================================
-- 16. COM_MANCARE (FK → comenzi, meniuri_mancare)
-- ============================================================
-- id_portie_comandata = numarul de portii comandate
-- id_sortiment_mancare: 1=Mici, 2=Sarmale, 3=Ciorba burta,
--   4=Tochitura, 5=Salata boeuf, 6=Pastrama, 7=Cozonac,
--   8=Placinta, 9=Ciorba ardel, 10=Varza, 11=Langos, 12=Papanasi
INSERT INTO com_mancare (id_comanda, id_sortiment_mancare, id_portie_comandata, pret_unitar) VALUES
    -- Comanda 1: mancare (+ bautura → ambele tipuri)
    (1,  1, 2, 32.00),   -- Mici x2
    -- Comanda 2: mancare (fara bautura)
    (2,  2, 1, 38.00),   -- Sarmale x1
    (2,  3, 1, 25.00),   -- Ciorba de burta x1
    -- Comanda 3: mancare (+ bautura)
    (3,  4, 1, 45.00),   -- Tochitura x1
    -- Comanda 4: mancare (+ bautura)
    (4,  5, 1, 22.00),   -- Salata boeuf x1
    (4,  6, 1, 55.00),   -- Pastrama x1
    -- Comanda 5: mancare (+ bautura) — Mihai
    (5,  1, 2, 32.00),   -- Mici x2
    -- Comanda 6: mancare (fara bautura) — Mihai
    (6,  2, 2, 38.00),   -- Sarmale x2
    (6,  3, 1, 25.00),   -- Ciorba de burta x1
    -- Comanda 7: fara mancare (doar bautura)
    -- Comanda 8: mancare (+ bautura)
    (8,  7, 2, 18.00),   -- Cozonac x2
    -- Comanda 9: mancare (fara bautura)
    (9,  9, 1, 28.00),   -- Ciorba ardeleneasca x1
    (9,  10,1, 35.00),   -- Varza cu carne x1
    -- Comanda 10: mancare (+ bautura)
    (10, 4, 1, 45.00),   -- Tochitura x1
    (10, 1, 2, 32.00),   -- Mici x2
    -- Comanda 11: mancare (+ bautura)
    (11, 6, 1, 55.00),   -- Pastrama x1
    -- Comanda 12: fara mancare (doar bautura) — Mihai
    -- Comanda 13: mancare (+ bautura)
    (13, 4, 1, 45.00),   -- Tochitura x1
    -- Comanda 14: mancare (fara bautura)
    (14, 1, 3, 32.00),   -- Mici x3
    (14, 3, 1, 25.00),   -- Ciorba de burta x1
    -- Comanda 15: mancare (+ bautura)
    (15, 5, 1, 22.00),   -- Salata boeuf x1
    (15, 6, 1, 55.00),   -- Pastrama x1
    -- Comanda 16: mancare (+ bautura)
    (16, 8, 2, 20.00),   -- Placinta cu branza x2
    -- Comanda 17: mancare (+ bautura)
    (17, 9, 2, 28.00),   -- Ciorba ardeleneasca x2
    -- Comanda 18: mancare (+ bautura)
    (18, 11,2, 22.00),   -- Langos x2
    (18, 12,1, 25.00);   -- Papanasi x1
-- Comenzi cu si mancare, si bautura (ex 3.3): 1, 3, 4, 5, 8, 10, 11, 13, 15, 16, 17, 18


-- ============================================================
-- 17. BONURI_FISCALE (FK → comenzi, clienti)
-- ============================================================
-- Un bon fiscal = documentul emis la finalul fiecarei comenzi.
-- suma_bon_f = totalul comenzii (mancare + bautura)
INSERT INTO bonuri_fiscale (id_bon_f, nr_bon_f, data_ora_bon_f, id_comanda, suma_bon_f, cod_locatie, id_client) VALUES
    (1,  'BON-2021-001', '2021-03-15 13:00:00',  1,   94.00, 'LOC-001', 2),
    (2,  'BON-2021-002', '2021-06-20 19:30:00',  2,   63.00, 'LOC-001', 3),
    (3,  'BON-2022-001', '2022-04-10 14:15:00',  3,   80.00, 'LOC-001', 4),
    (4,  'BON-2022-002', '2022-09-05 20:30:00',  4,  107.00, 'LOC-002', 2),
    (5,  'BON-2023-001', '2023-02-14 20:00:00',  5,   80.00, 'LOC-001', 1),
    (6,  'BON-2023-002', '2023-05-20 12:30:00',  6,  101.00, 'LOC-001', 1),
    (7,  'BON-2023-003', '2023-07-08 21:30:00',  7,   72.00, 'LOC-002', 2),
    (8,  'BON-2023-004', '2023-11-15 19:00:00',  8,   76.00, 'LOC-002', 3),
    (9,  'BON-2024-001', '2024-01-20 13:30:00',  9,   63.00, 'LOC-003', 5),
    (10, 'BON-2024-002', '2024-03-08 20:30:00', 10,  139.00, 'LOC-001', 4),
    (11, 'BON-2024-003', '2024-04-12 19:30:00', 11,  135.00, 'LOC-002', 2),
    (12, 'BON-2023-005', '2023-08-22 21:00:00', 12,   85.00, 'LOC-001', 1),
    (13, 'BON-2023-006', '2023-01-10 19:30:00', 13,   80.00, 'LOC-001', 3),
    (14, 'BON-2023-007', '2023-01-20 13:00:00', 14,  121.00, 'LOC-001', 4),
    (15, 'BON-2023-008', '2023-01-25 20:30:00', 15,   89.00, 'LOC-002', 2),
    (16, 'BON-2023-009', '2023-04-15 20:00:00', 16,  110.00, 'LOC-002', 5),
    (17, 'BON-2023-010', '2023-09-10 13:30:00', 17,   91.00, 'LOC-003', 2),
    (18, 'BON-2023-011', '2023-03-15 19:30:00', 18,   89.00, 'LOC-003', 3);


-- ============================================================
-- 18. REZERVARI (FK → clienti)
-- ============================================================
INSERT INTO rezervari (id_rezervare, data_ora_rezervare, id_client, data_ora_sosire, data_ora_plecare) VALUES
    (1,  '2024-01-10 10:00:00', 1, '2024-01-15 18:00:00', '2024-01-15 22:00:00'),
    (2,  '2024-02-05 11:00:00', 2, '2024-02-14 19:30:00', '2024-02-14 21:30:00'),
    (3,  '2024-03-10 09:00:00', 3, '2024-03-20 20:00:00', '2024-03-20 23:00:00'),
    (4,  '2024-03-28 14:00:00', 4, '2024-04-05 12:00:00', '2024-04-05 14:00:00'),
    (5,  '2024-04-25 10:00:00', 5, '2024-05-10 18:30:00', '2024-05-10 23:00:00'),
    (6,  '2024-06-01 12:00:00', 1, '2024-06-15 19:00:00', '2024-06-15 22:00:00'),
    (7,  '2024-07-10 11:00:00', 2, '2024-07-20 20:00:00', '2024-07-20 24:00:00'),
    (8,  '2023-12-20 10:00:00', 3, '2023-12-31 21:00:00', '2024-01-01 02:00:00'),  -- 2023!
    (9,  '2024-01-18 14:00:00', 2, '2024-01-25 19:00:00', '2024-01-25 21:00:00'),
    (10, '2024-01-22 10:00:00', 3, '2024-01-30 20:00:00', '2024-01-30 23:00:00'),
    (11, '2024-02-12 09:00:00', 4, '2024-02-20 12:00:00', '2024-02-20 14:00:00'),
    (12, '2024-03-05 11:00:00', 5, '2024-03-15 18:00:00', '2024-03-15 21:00:00'),
    (13, '2023-06-01 10:00:00', 1, '2023-06-10 19:30:00', '2023-06-10 22:00:00'),
    (14, '2023-06-12 11:00:00', 1, '2023-06-20 20:00:00', '2023-06-20 23:30:00'),
    (15, '2023-07-08 14:00:00', 2, '2023-07-15 12:00:00', '2023-07-15 14:30:00'),
    (16, '2023-07-15 09:00:00', 2, '2023-07-20 19:00:00', '2023-07-20 22:00:00'),
    (17, '2023-08-01 10:00:00', 3, '2023-08-10 20:00:00', '2023-08-10 23:00:00'),
    (18, '2023-08-18 11:00:00', 3, '2023-08-25 12:30:00', '2023-08-25 14:30:00'),
    (19, '2023-09-05 14:00:00', 4, '2023-09-15 19:00:00', '2023-09-15 22:00:00'),
    (20, '2023-10-10 10:00:00', 5, '2023-10-20 12:00:00', '2023-10-20 14:00:00'),
    (21, '2023-10-18 11:00:00', 5, '2023-10-25 19:30:00', '2023-10-25 23:00:00');


-- ============================================================
-- 19. REZERVARI_RESTAURANTE (FK → rezervari, restaurante)
-- ============================================================
-- Rezervare pentru intreg restaurantul (nu doar o masa).
INSERT INTO rezervari_restaurante (id_rezervare, id_restaurant, observatii) VALUES
    (1,  1, 'Eveniment corporate'),            -- r1: "restaurant intreg"
    (3,  2, 'Petrecere aniversara'),           -- r2: "mixta" (are si mese)
    (5,  3, 'Receptie privata'),               -- r3: "restaurant intreg"
    (7,  1, 'Conferinta'),                     -- r1+r2: "mixta"
    (7,  2, NULL),
    (8,  3, 'Revelion'),                       -- r3: 2023
    (14, 1, 'Zi de nastere'),                  -- r1: 2023
    (17, 2, 'Reuniune de clasa'),              -- r2: 2023
    (21, 3, 'Eveniment cultural');             -- r3: 2023


-- ============================================================
-- 20. REZERVARI_MESE (FK → rezervari, mese)
-- ============================================================
INSERT INTO rezervari_mese (id_rezervare, id_masa, observatii) VALUES
    (2,  1, NULL),   -- rez 2: masa 1 (La Mama) → "masa"
    (3,  4, NULL),   -- rez 3: masa 4+5 (Caru)  → "mixta"
    (3,  5, NULL),
    (4,  3, NULL),   -- rez 4: masa 3 (La Mama) → "masa"
    (6,  6, NULL),   -- rez 6: masa 6+7 (Vatra) → "masa"
    (6,  7, NULL),
    (7,  4, NULL),   -- rez 7: masa 4 (Caru)    → "mixta"
    (9,  2, NULL),   -- rez 9: masa 2 (La Mama) → "masa"
    (10, 4, NULL),   -- rez 10: masa 4+5 (Caru)
    (10, 5, NULL),
    (11, 8, NULL),   -- rez 11: masa 8 (Vatra)
    (12, 6, NULL),   -- rez 12: masa 6 (Vatra)
    (13, 1, NULL),
    (15, 3, NULL),
    (16, 1, NULL),
    (18, 8, NULL),
    (19, 7, NULL),
    (20, 3, NULL);


-- ============================================================
-- 21. COMENZI_PRODUSE_FURNIZORI (FK → restaurante, furnizori, produse)
-- ============================================================
-- Achizitii de materii prime de la furnizori catre restaurante.
-- pret_total = cantitate * pret_unitar
INSERT INTO comenzi_produse_furnizori (id_comanda_furnizor, data_ora_comanda, id_restaurant, id_furnizor, id_produs, cantitate, pret_total) VALUES
    -- 2023 (relevante pentru exercitiul 3.14)
    (1,  '2023-01-15 09:00:00', 1, 1,  3,  50,   250.00),  -- Dorna → Lapte acru (ciorba)
    (2,  '2023-02-10 09:00:00', 1, 2,  4, 100,  2200.00),  -- Bauturi Maramures → Struguri FeN
    (3,  '2023-03-05 09:00:00', 1, 3,  1, 200,  3000.00),  -- Agricola → Carne de porc
    (4,  '2023-04-20 09:00:00', 1, 2,  5, 150,  1200.00),  -- Bauturi Maramures → Hamei/malt
    (5,  '2023-05-10 09:00:00', 2, 3, 13,  50,  1650.00),  -- Agricola → Pui intreg
    (6,  '2023-06-15 09:00:00', 1, 1,  2,  80,   960.00),  -- Dorna → Varza alba
    (7,  '2023-07-15 09:00:00', 2, 4,  8,  60,   720.00),  -- Panificatie → Faina alba
    (8,  '2023-08-10 09:00:00', 1, 3,  1,  60,  1680.00),  -- Agricola → Carne de porc
    (9,  '2023-09-20 09:00:00', 2, 4,  8, 100,  1000.00),  -- Panificatie → Faina alba
    (10, '2023-10-15 09:00:00', 2, 2, 11,  50,   900.00),  -- Bauturi Maramures → Prune
    (11, '2023-11-20 09:00:00', 1, 1,  6, 200,   600.00),  -- Dorna → Apa minerala
    -- 2022 (nu intra in calculul pentru 2023)
    (12, '2022-05-10 09:00:00', 2, 3, 13,  40,  1280.00);  -- Agricola → Pui intreg (2022)
-- Total aprovizionari 2023 pe furnizori:
--   Furnizor 1 (Dorna):             250 + 960 + 600 = 1.810 lei
--   Furnizor 2 (Bauturi Maramures): 2200 + 1200 + 900 = 4.300 lei
--   Furnizor 3 (Agricola):          3000 + 1650 + 1680 = 6.330 lei
--   Furnizor 4 (Panificatie):       720 + 1000 = 1.720 lei
--   TOTAL 2023:                     14.160 lei
