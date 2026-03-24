-- ============================================================
-- Script de creare a tabelelor pentru baza de date "Restaurante"
-- ============================================================
--
-- Termeni noi introduși în acest fișier sunt definiți în dictionar.md.
--
-- Cum se rulează:
--   psql -U postgres -d numele_bazei_de_date -f create_tables.sql
-- ============================================================


-- Tabelul RESTAURANTE
-- Stochează informații de bază despre fiecare restaurant.
CREATE TABLE restaurante (
    id_restaurant INT      PRIMARY KEY,
    nume          VARCHAR(100) NOT NULL,
    oras          VARCHAR(100) NOT NULL,
    adresa        VARCHAR(200),
    telefon       VARCHAR(20)
);


-- Tabelul MESE
-- Fiecare masă fizică dintr-un restaurant.
-- O masă nu poate exista fără restaurant → FOREIGN KEY pe id_restaurant.
CREATE TABLE mese (
    id_masa       INT PRIMARY KEY,
    id_restaurant INT    NOT NULL,
    numar_masa    INT    NOT NULL,  -- numărul mesei în cadrul restaurantului
    capacitate    INT    NOT NULL,  -- câte persoane pot sta la masă
    FOREIGN KEY (id_restaurant) REFERENCES restaurante(id_restaurant)
);


-- Tabelul ANGAJATI
-- Angajații unui restaurant.
-- Câmpul id_manager este o cheie străină care indică tot spre acest tabel
-- (un angajat poate fi managerul altui angajat → relație ierarhică / recursivă).
CREATE TABLE angajati (
    id_angajat    INT       PRIMARY KEY,
    nume          VARCHAR(100) NOT NULL,
    prenume       VARCHAR(100) NOT NULL,
    data_angajare DATE         NOT NULL,
    functie       VARCHAR(100),
    id_manager    INT,           -- NULL dacă angajatul nu are manager (ex: director general)
    id_restaurant INT           NOT NULL,
    FOREIGN KEY (id_manager)    REFERENCES angajati(id_angajat),
    FOREIGN KEY (id_restaurant) REFERENCES restaurante(id_restaurant)
);


-- Tabelul CLIENTI
-- Clienții care fac comenzi sau rezervări.
CREATE TABLE clienti (
    id_client INT       PRIMARY KEY,
    nume      VARCHAR(100) NOT NULL,
    prenume   VARCHAR(100) NOT NULL,
    email     VARCHAR(150),
    telefon   VARCHAR(20)
);


-- Tabelul PRODUSE
-- Mâncărurile și băuturile oferite de restaurante.
-- Câmpul "tip" acceptă DOAR valorile 'mancare' sau 'bautura' (constrângere CHECK).
CREATE TABLE produse (
    id_produs     INT        PRIMARY KEY,
    nume          VARCHAR(100)  NOT NULL,
    tip           VARCHAR(10)   NOT NULL CHECK (tip IN ('mancare', 'bautura')),
    pret          NUMERIC(10,2) NOT NULL,
    id_restaurant INT           NOT NULL,
    FOREIGN KEY (id_restaurant) REFERENCES restaurante(id_restaurant)
);


-- Tabelul COMENZI
-- O comandă este plasată de un client, preluată de un angajat,
-- la un anumit restaurant, la o dată și oră anume.
CREATE TABLE comenzi (
    id_comanda    INT    PRIMARY KEY,
    id_client     INT       NOT NULL,
    id_angajat    INT       NOT NULL,
    id_restaurant INT       NOT NULL,
    data_comanda  TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id_client)     REFERENCES clienti(id_client),
    FOREIGN KEY (id_angajat)    REFERENCES angajati(id_angajat),
    FOREIGN KEY (id_restaurant) REFERENCES restaurante(id_restaurant)
);


-- Tabelul DETALII_COMENZI
-- Produsele incluse în fiecare comandă (ce s-a comandat și la ce preț).
-- Cheia primară este COMPUSĂ din id_comanda + id_produs:
--   același produs poate apărea o singură dată per comandă.
CREATE TABLE detalii_comenzi (
    id_comanda  INT           NOT NULL,
    id_produs   INT           NOT NULL,
    cantitate   INT           NOT NULL DEFAULT 1,
    pret_unitar NUMERIC(10,2) NOT NULL,  -- prețul la momentul comenzii (poate diferi de prețul curent)
    PRIMARY KEY (id_comanda, id_produs),
    FOREIGN KEY (id_comanda) REFERENCES comenzi(id_comanda),
    FOREIGN KEY (id_produs)  REFERENCES produse(id_produs)
);


-- Tabelul REZERVARI
-- O rezervare este făcută de un client și poate acoperi
-- restaurante întregi, mese individuale, sau ambele (rezervare mixtă).
CREATE TABLE rezervari (
    id_rezervare   INT    PRIMARY KEY,
    id_client      INT       NOT NULL,
    data_rezervare TIMESTAMP NOT NULL,
    numar_persoane INT       NOT NULL,
    FOREIGN KEY (id_client) REFERENCES clienti(id_client)
);


-- Tabelul REZERVARI_RESTAURANTE
-- Leagă o rezervare de un restaurant întreg
-- (clientul a rezervat întregul spațiu al restaurantului).
CREATE TABLE rezervari_restaurante (
    id_rezervare  INT NOT NULL,
    id_restaurant INT NOT NULL,
    PRIMARY KEY (id_rezervare, id_restaurant),
    FOREIGN KEY (id_rezervare)  REFERENCES rezervari(id_rezervare),
    FOREIGN KEY (id_restaurant) REFERENCES restaurante(id_restaurant)
);


-- Tabelul REZERVARI_MESE
-- Leagă o rezervare de una sau mai multe mese individuale.
CREATE TABLE rezervari_mese (
    id_rezervare INT NOT NULL,
    id_masa      INT NOT NULL,
    PRIMARY KEY (id_rezervare, id_masa),
    FOREIGN KEY (id_rezervare) REFERENCES rezervari(id_rezervare),
    FOREIGN KEY (id_masa)      REFERENCES mese(id_masa)
);


-- Tabelul FURNIZORI
-- Companiile care aprovizionează restaurantele cu produse.
CREATE TABLE furnizori (
    id_furnizor INT       PRIMARY KEY,
    nume        VARCHAR(150) NOT NULL,
    contact     VARCHAR(150),
    oras        VARCHAR(100)
);


-- Tabelul APROVIZIONARI
-- Înregistrează fiecare achiziție de produse de la un furnizor:
-- ce produs, de la cine, când, câtă cantitate și la ce preț.
CREATE TABLE aprovizionari (
    id_aprovizionare   INT        PRIMARY KEY,
    id_furnizor        INT           NOT NULL,
    id_produs          INT           NOT NULL,
    data_aprovizionare DATE          NOT NULL,
    cantitate          INT           NOT NULL,
    pret_unitar        NUMERIC(10,2) NOT NULL,
    FOREIGN KEY (id_furnizor) REFERENCES furnizori(id_furnizor),
    FOREIGN KEY (id_produs)   REFERENCES produse(id_produs)
);
