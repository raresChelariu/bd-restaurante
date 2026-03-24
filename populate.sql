-- ============================================================
-- Script de populare cu date realiste (România)
-- ============================================================
--
-- Rulează DUPĂ create_tables.sql.
-- Comanda: psql -U postgres -d numele_bazei_de_date -f populate.sql
--
-- Deoarece coloanele de tip INT nu generează ID-uri automat,
-- le specificăm explicit în fiecare INSERT.
-- ============================================================


-- ============================================================
-- RESTAURANTE
-- ============================================================
INSERT INTO restaurante (id_restaurant, nume, oras, adresa, telefon) VALUES
    (1, 'La Mama',        'București', 'Str. Epictet 1, Sector 1',      '021-312-9797'),
    (2, 'Caru'' cu Bere', 'București', 'Str. Stavropoleos 5, Sector 3', '021-313-7560'),
    (3, 'Vatra',          'Cluj-Napoca','Str. Memorandumului 12',        '0264-598-411');


-- ============================================================
-- MESE (mese fizice din fiecare restaurant)
-- ============================================================
INSERT INTO mese (id_masa, id_restaurant, numar_masa, capacitate) VALUES
    -- La Mama (id_restaurant=1)
    (1, 1, 1, 4),
    (2, 1, 2, 6),
    (3, 1, 3, 2),
    -- Caru' cu Bere (id_restaurant=2)
    (4, 2, 1, 4),
    (5, 2, 2, 8),
    -- Vatra (id_restaurant=3)
    (6, 3, 1, 4),
    (7, 3, 2, 4),
    (8, 3, 3, 2);


-- ============================================================
-- ANGAJATI
-- ============================================================
-- Angajați din ani diferiți → necesari pentru exercițiul 3.1
-- Ierarhie: managerii (id_manager NULL) sunt inserați primii
INSERT INTO angajati (id_angajat, nume, prenume, data_angajare, functie, id_manager, id_restaurant) VALUES
    -- La Mama (id_restaurant=1)
    (1,  'Popescu',    'Ion',      '2019-05-15', 'Manager',      NULL, 1),
    (2,  'Ionescu',    'Maria',    '2020-03-10', 'Sef sala',     1,    1),
    (3,  'Dumitrescu', 'Andrei',   '2021-06-01', 'Ospatar',      2,    1),
    (4,  'Constantin', 'Elena',    '2022-09-15', 'Ospatar',      2,    1),
    (5,  'Popa',       'Gheorghe', '2023-02-20', 'Bucatar sef',  1,    1),
    -- Caru' cu Bere (id_restaurant=2)
    (6,  'Moldovan',   'Cristina', '2020-04-01', 'Manager',      NULL, 2),
    (7,  'Stanescu',   'Radu',     '2021-08-15', 'Ospatar',      6,    2),
    (8,  'Florescu',   'Ioana',    '2022-11-01', 'Ospatar',      6,    2),
    -- Vatra (id_restaurant=3)
    (9,  'Vasile',     'Dumitru',  '2019-11-20', 'Manager',      NULL, 3),
    (10, 'Dinu',       'Mihaela',  '2023-07-10', 'Ospatar',      9,    3);
-- Ani de angajare prezenti: 2019, 2020, 2021, 2022, 2023


-- ============================================================
-- CLIENTI
-- ============================================================
INSERT INTO clienti (id_client, nume, prenume, email, telefon) VALUES
    (1, 'Stanescu',  'Mihai',     'mihai.stanescu@gmail.com',   '0722-111-222'),
    (2, 'Radu',      'Ana Maria', 'ana.radu@yahoo.com',         '0744-333-444'),
    (3, 'Georgescu', 'Alexandru', 'alex.georgescu@gmail.com',   '0766-555-666'),
    (4, 'Petrescu',  'Ioana',     'ioana.petrescu@hotmail.com', '0788-777-888'),
    (5, 'Marin',     'Bogdan',    'bogdan.marin@gmail.com',     '0755-999-000');


-- ============================================================
-- PRODUSE
-- ============================================================
-- La Mama (id_restaurant=1): id_produs 1-7
INSERT INTO produse (id_produs, nume, tip, pret, id_restaurant) VALUES
    (1,  'Mici cu mustar',              'mancare', 32.00, 1),
    (2,  'Sarmale cu mamaliga',         'mancare', 38.00, 1),
    (3,  'Ciorba de burta',             'mancare', 25.00, 1),
    (4,  'Tochitura moldoveneasca',     'mancare', 45.00, 1),
    (5,  'Vin Feteasca Neagra (250ml)', 'bautura', 35.00, 1),
    (6,  'Bere Ursus (500ml)',          'bautura', 15.00, 1),
    (7,  'Apa minerala Borsec',         'bautura',  8.00, 1);

-- Caru' cu Bere (id_restaurant=2): id_produs 8-14
INSERT INTO produse (id_produs, nume, tip, pret, id_restaurant) VALUES
    (8,  'Salata de boeuf',             'mancare', 22.00, 2),
    (9,  'Pastrama de oaie',            'mancare', 55.00, 2),
    (10, 'Cozonac cu nuca',             'mancare', 18.00, 2),
    (11, 'Placinta cu branza',          'mancare', 20.00, 2),
    (12, 'Vin Feteasca Regala (250ml)', 'bautura', 40.00, 2),
    (13, 'Palinca de prune',            'bautura', 30.00, 2),
    (14, 'Cafea espresso',              'bautura', 12.00, 2);

-- Vatra (id_restaurant=3): id_produs 15-21
INSERT INTO produse (id_produs, nume, tip, pret, id_restaurant) VALUES
    (15, 'Ciorba ardeleneasca',         'mancare', 28.00, 3),
    (16, 'Varza cu carne',              'mancare', 35.00, 3),
    (17, 'Langos cu smantana',          'mancare', 22.00, 3),
    (18, 'Vin de Tarnave (250ml)',      'bautura', 38.00, 3),
    (19, 'Tuica Cluj (50ml)',           'bautura', 20.00, 3),
    (20, 'Apa plata Dorna',             'bautura',  7.00, 3),
    (21, 'Papanasi cu smantana',        'mancare', 25.00, 3);


-- ============================================================
-- COMENZI
-- ============================================================
-- Angajatul trebuie să aparțină aceluiași restaurant ca și comanda.
INSERT INTO comenzi (id_comanda, id_client, id_angajat, id_restaurant, data_comanda) VALUES
    (1,  2, 3, 1, '2021-03-15 12:30:00'),  -- Ana Maria  @ La Mama,        2021
    (2,  3, 3, 1, '2021-06-20 19:00:00'),  -- Alexandru  @ La Mama,        2021
    (3,  4, 4, 1, '2022-04-10 13:45:00'),  -- Ioana      @ La Mama,        2022
    (4,  2, 7, 2, '2022-09-05 20:00:00'),  -- Ana Maria  @ Caru cu Bere,   2022
    (5,  1, 3, 1, '2023-02-14 19:30:00'),  -- MIHAI/XYZ  @ La Mama,        2023
    (6,  1, 4, 1, '2023-05-20 12:00:00'),  -- MIHAI/XYZ  @ La Mama,        2023
    (7,  2, 7, 2, '2023-07-08 21:00:00'),  -- Ana Maria  @ Caru cu Bere,   2023
    (8,  3, 8, 2, '2023-11-15 18:30:00'),  -- Alexandru  @ Caru cu Bere,   2023
    (9,  5,10, 3, '2024-01-20 13:00:00'),  -- Bogdan     @ Vatra,          2024
    (10, 4, 3, 1, '2024-03-08 20:00:00'),  -- Ioana      @ La Mama,        2024
    (11, 2, 7, 2, '2024-04-12 19:00:00'),  -- Ana Maria  @ Caru cu Bere,   2024
    (12, 1, 4, 1, '2023-08-22 20:30:00'),  -- MIHAI/XYZ  @ La Mama,        2023
    (13, 3, 3, 1, '2023-01-10 19:00:00'),  -- Alexandru  @ La Mama,        2023
    (14, 4, 4, 1, '2023-01-20 12:30:00'),  -- Ioana      @ La Mama,        2023
    (15, 2, 7, 2, '2023-01-25 20:00:00'),  -- Ana Maria  @ Caru cu Bere,   2023
    (16, 5, 8, 2, '2023-04-15 19:30:00'),  -- Bogdan     @ Caru cu Bere,   2023
    (17, 2,10, 3, '2023-09-10 13:00:00'),  -- Ana Maria  @ Vatra,          2023
    (18, 3,10, 3, '2023-03-15 19:00:00');  -- Alexandru  @ Vatra,          2023
-- Exercițiul 3.2: Mihai (id_client=1) a avut comenzile 5, 6, 12 în 2023
--   → prelucrate de: Andrei Dumitrescu (id_angajat=3) și Elena Constantin (id_angajat=4)


-- ============================================================
-- DETALII_COMENZI
-- ============================================================
-- Cheia primară este compusă din (id_comanda, id_produs) → nu are un ID separat.
INSERT INTO detalii_comenzi (id_comanda, id_produs, cantitate, pret_unitar) VALUES
    -- Comanda 1: mancare + bautura
    (1, 1, 2, 32.00),   -- Mici x2
    (1, 6, 2, 15.00),   -- Bere Ursus x2
    -- Comanda 2: doar mancare
    (2, 2, 1, 38.00),   -- Sarmale x1
    (2, 3, 1, 25.00),   -- Ciorba de burta x1
    -- Comanda 3: mancare + bautura
    (3, 4, 1, 45.00),   -- Tochitura x1
    (3, 5, 1, 35.00),   -- Vin Feteasca Neagra x1
    -- Comanda 4: mancare + bautura
    (4,  8, 1, 22.00),  -- Salata de boeuf x1
    (4,  9, 1, 55.00),  -- Pastrama de oaie x1
    (4, 13, 1, 30.00),  -- Palinca de prune x1
    -- Comanda 5: mancare + bautura (comanda Mihai)
    (5, 1, 2, 32.00),   -- Mici x2
    (5, 7, 2,  8.00),   -- Apa minerala x2
    -- Comanda 6: doar mancare (comanda Mihai)
    (6, 2, 2, 38.00),   -- Sarmale x2
    (6, 3, 1, 25.00),   -- Ciorba de burta x1
    -- Comanda 7: doar bautura
    (7, 13, 2, 30.00),  -- Palinca de prune x2
    (7, 14, 1, 12.00),  -- Cafea x1
    -- Comanda 8: mancare + bautura
    (8, 10, 2, 18.00),  -- Cozonac x2
    (8, 12, 1, 40.00),  -- Vin Feteasca Regala x1
    -- Comanda 9: doar mancare
    (9, 15, 1, 28.00),  -- Ciorba ardeleneasca x1
    (9, 16, 1, 35.00),  -- Varza cu carne x1
    -- Comanda 10: mancare + bautura
    (10, 4, 1, 45.00),  -- Tochitura x1
    (10, 1, 2, 32.00),  -- Mici x2
    (10, 6, 2, 15.00),  -- Bere Ursus x2
    -- Comanda 11: mancare + bautura
    (11,  9, 1, 55.00), -- Pastrama x1
    (11, 12, 2, 40.00), -- Vin Feteasca Regala x2
    -- Comanda 12: doar bautura (comanda Mihai)
    (12, 5, 2, 35.00),  -- Vin Feteasca Neagra x2
    (12, 6, 1, 15.00),  -- Bere Ursus x1
    -- Comanda 13: mancare + bautura
    (13, 4, 1, 45.00),  -- Tochitura x1
    (13, 5, 1, 35.00),  -- Vin Feteasca Neagra x1
    -- Comanda 14: doar mancare
    (14, 1, 3, 32.00),  -- Mici x3
    (14, 3, 1, 25.00),  -- Ciorba de burta x1
    -- Comanda 15: mancare + bautura
    (15,  8, 1, 22.00), -- Salata de boeuf x1
    (15,  9, 1, 55.00), -- Pastrama x1
    (15, 14, 1, 12.00), -- Cafea x1
    -- Comanda 16: mancare + bautura
    (16, 12, 1, 40.00), -- Vin Feteasca Regala x1
    (16, 13, 1, 30.00), -- Palinca x1
    (16, 11, 2, 20.00), -- Placinta cu branza x2
    -- Comanda 17: mancare + bautura
    (17, 15, 2, 28.00), -- Ciorba ardeleneasca x2
    (17, 18, 1, 38.00), -- Vin de Tarnave x1
    -- Comanda 18: mancare + bautura
    (18, 17, 2, 22.00), -- Langos x2
    (18, 21, 1, 25.00), -- Papanasi x1
    (18, 19, 1, 20.00); -- Tuica Cluj x1


-- ============================================================
-- REZERVARI
-- ============================================================
INSERT INTO rezervari (id_rezervare, id_client, data_rezervare, numar_persoane) VALUES
    (1,  1, '2024-01-15 18:00:00', 10),
    (2,  2, '2024-02-14 19:30:00',  4),
    (3,  3, '2024-03-20 20:00:00',  6),
    (4,  4, '2024-04-05 12:00:00',  2),
    (5,  5, '2024-05-10 18:30:00',  8),
    (6,  1, '2024-06-15 19:00:00',  4),
    (7,  2, '2024-07-20 20:00:00', 15),
    (8,  3, '2023-12-31 21:00:00',  8),  -- 2023, nu apare la ex3.4
    (9,  2, '2024-01-25 19:00:00',  4),
    (10, 3, '2024-01-30 20:00:00',  6),
    (11, 4, '2024-02-20 12:00:00',  2),
    (12, 5, '2024-03-15 18:00:00',  4),
    (13, 1, '2023-06-10 19:30:00',  4),
    (14, 1, '2023-06-20 20:00:00',  6),
    (15, 2, '2023-07-15 12:00:00',  2),
    (16, 2, '2023-07-20 19:00:00',  4),
    (17, 3, '2023-08-10 20:00:00',  8),
    (18, 3, '2023-08-25 12:30:00',  2),
    (19, 4, '2023-09-15 19:00:00',  4),
    (20, 5, '2023-10-20 12:00:00',  2),
    (21, 5, '2023-10-25 19:30:00',  6);


-- ============================================================
-- REZERVARI_RESTAURANTE (rezervare pt. întreg restaurantul)
-- ============================================================
INSERT INTO rezervari_restaurante (id_rezervare, id_restaurant) VALUES
    (1,  1),   -- Rezervare 1: întreg La Mama         → tip: "restaurant intreg"
    (3,  2),   -- Rezervare 3: întreg Caru cu Bere    → tip: "mixta" (are și mese)
    (5,  3),   -- Rezervare 5: întreg Vatra            → tip: "restaurant intreg"
    (7,  1),   -- Rezervare 7: La Mama + Caru cu Bere → tip: "mixta"
    (7,  2),
    (8,  3),   -- Rezervare 8: Vatra (2023)
    (14, 1),   -- Rezervare 14: întreg La Mama (2023)
    (17, 2),   -- Rezervare 17: întreg Caru (2023)
    (21, 3);   -- Rezervare 21: întreg Vatra (2023)


-- ============================================================
-- REZERVARI_MESE (rezervare pt. mese individuale)
-- ============================================================
INSERT INTO rezervari_mese (id_rezervare, id_masa) VALUES
    (2,  1),   -- Rezervare 2: masa 1 (La Mama)         → tip: "masa"
    (3,  4),   -- Rezervare 3: masa 4 (Caru)            → tip: "mixta"
    (3,  5),
    (4,  3),   -- Rezervare 4: masa 3 (La Mama)         → tip: "masa"
    (6,  6),   -- Rezervare 6: masa 6+7 (Vatra)         → tip: "masa"
    (6,  7),
    (7,  4),   -- Rezervare 7: masa 4 (Caru)            → tip: "mixta"
    (9,  2),   -- Rezervare 9: masa 2 (La Mama)         → tip: "masa"
    (10, 4),   -- Rezervare 10: masa 4+5 (Caru)
    (10, 5),
    (11, 8),   -- Rezervare 11: masa 8 (Vatra)
    (12, 6),   -- Rezervare 12: masa 6 (Vatra)
    (13, 1),   -- Rezervare 13: masa 1 (La Mama, 2023)
    (15, 3),
    (16, 1),
    (18, 8),
    (19, 7),
    (20, 3);


-- ============================================================
-- FURNIZORI
-- ============================================================
INSERT INTO furnizori (id_furnizor, nume, contact, oras) VALUES
    (1, 'Lactate Dorna SRL',      'contact@dorna.ro',           'Vatra Dornei'),
    (2, 'Bauturi Maramures SRL',  'office@bauturimaramures.ro', 'Baia Mare'),
    (3, 'Agricola Bacau SA',      'aprovizionare@agricola.ro',  'Bacau'),
    (4, 'Panificatie Buftea SRL', 'comenzi@panbuftea.ro',       'Buftea');


-- ============================================================
-- APROVIZIONARI
-- ============================================================
INSERT INTO aprovizionari (id_aprovizionare, id_furnizor, id_produs, data_aprovizionare, cantitate, pret_unitar) VALUES
    -- 2023 (relevante pentru exercițiul 3.14)
    (1,  1, 3,  '2023-01-15', 50,   5.00),  -- Dorna → Ciorba de burta
    (2,  2, 5,  '2023-02-10', 100, 22.00),  -- Bauturi Maramures → Vin Feteasca Neagra
    (3,  3, 1,  '2023-03-05', 200, 15.00),  -- Agricola → Mici
    (4,  2, 6,  '2023-04-20', 150,  8.00),  -- Bauturi Maramures → Bere Ursus
    (5,  3, 9,  '2023-05-10', 50,  33.00),  -- Agricola → Pastrama
    (6,  1, 2,  '2023-06-15', 80,  12.00),  -- Dorna → Sarmale
    (7,  4, 8,  '2023-07-15', 60,  12.00),  -- Panificatie → Salata de boeuf
    (8,  3, 4,  '2023-08-10', 60,  28.00),  -- Agricola → Tochitura
    (9,  4, 10, '2023-09-20', 100, 10.00),  -- Panificatie → Cozonac
    (10, 2, 13, '2023-10-15', 50,  18.00),  -- Bauturi Maramures → Palinca
    (11, 1, 7,  '2023-11-20', 200,  3.00),  -- Dorna → Apa minerala
    -- 2022 (nu intra in calculul pentru 2023)
    (12, 3, 9,  '2022-05-10', 40,  32.00);  -- Agricola → Pastrama (2022)
