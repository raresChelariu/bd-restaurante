-- ============================================================
-- RESTAURANTE3 - Script de creare tabele PostgreSQL
-- Generat pe baza diagramei ER din documentul Restaurante3.pdf
-- ============================================================

-- Ordinea de creare respectă dependențele între tabele
-- (tabelele referite sunt create înaintea celor care le referă)

-- ============================================================
-- 1. TABELE INDEPENDENTE (fără FK)
-- ============================================================

CREATE TABLE localitati (
    id_localitate   NUMERIC(6)    PRIMARY KEY,
    nume_localitate VARCHAR(70),
    judet           VARCHAR(30)
);

CREATE TABLE clienti (
    id_client   NUMERIC(7)      PRIMARY KEY,
    nume        VARCHAR(40),
    prenume     VARCHAR(40),
    telefon     VARCHAR(20),
    e_mail      VARCHAR(1000)
);

CREATE TABLE produse (
    id_produs        NUMERIC(5)   PRIMARY KEY,
    den_produs       VARCHAR(70),
    categorie_produs VARCHAR(90)
);

-- ============================================================
-- 2. TABELE CU FK SPRE TABELE INDEPENDENTE
-- ============================================================

CREATE TABLE restaurante (
    id_restaurant       NUMERIC(5)   PRIMARY KEY,
    den_rest            VARCHAR(90),
    adresa_rest         VARCHAR,
    id_localitate       NUMERIC(5),
    locuri_restaurant   INT,
    CONSTRAINT fk_restaurante_localitati
        FOREIGN KEY (id_localitate) REFERENCES localitati (id_localitate)
);

CREATE TABLE furnizori (
    id_furnizor     NUMERIC(5)   PRIMARY KEY,
    den_furn        VARCHAR(70),
    tip_furn        VARCHAR(90),
    adresa_furn     VARCHAR,
    id_localitate   NUMERIC(5),
    CONSTRAINT fk_furnizori_localitati
        FOREIGN KEY (id_localitate) REFERENCES localitati (id_localitate)
);

CREATE TABLE bauturi (
    id_bautura              NUMERIC(6)    PRIMARY KEY,
    denumire_in_meniu       VARCHAR(44),
    data_adaugarii_in_meniu DATE,
    tip_bautura             VARCHAR(35),
    alcoolica               FLOAT,
    id_produs               NUMERIC(6),
    cantitate_portie        NUMERIC,
    pret_unitar             NUMERIC(10, 2),
    CONSTRAINT fk_bauturi_produse
        FOREIGN KEY (id_produs) REFERENCES produse (id_produs)
);

CREATE TABLE meniuri_mancare (
    id_sortiment_mancare    NUMERIC(6)    PRIMARY KEY,
    denumire_in_meniu       VARCHAR(45),
    data_adaugarii_in_meniu DATE,
    tip_mancare             VARCHAR(50),
    id_produs               NUMERIC(6),
    gramaj_portie           NUMERIC,
    pret_unitar             NUMERIC,
    CONSTRAINT fk_meniuri_mancare_produse
        FOREIGN KEY (id_produs) REFERENCES produse (id_produs)
);

-- ============================================================
-- 3. MESE (FK spre restaurante)
-- ============================================================

CREATE TABLE mese (
    id_masa         NUMERIC(5)   PRIMARY KEY,
    id_restaurant   NUMERIC(5),
    masa_nr         INT2,
    observatii      VARCHAR(100),
    CONSTRAINT fk_mese_restaurante
        FOREIGN KEY (id_restaurant) REFERENCES restaurante (id_restaurant)
);

-- ============================================================
-- 4. ANGAJAȚI ȘI SUBTIPURI
-- ============================================================

CREATE TABLE angajati (
    id_angajat       NUMERIC(15)   PRIMARY KEY,
    nume_angajat     VARCHAR(50),
    prenume_angajat  VARCHAR(50),
    cnp_angajat      CHAR(13),
    data_nasterii    DATE,
    data_angajarii   DATE,
    id_restaurant    NUMERIC(15),
    salariu          NUMERIC(15),
    CONSTRAINT fk_angajati_restaurante
        FOREIGN KEY (id_restaurant) REFERENCES restaurante (id_restaurant)
);

CREATE TABLE manageri (
    id_manager      NUMERIC(5)   PRIMARY KEY,
    id_restaurant   NUMERIC(5),
    data_numirii    DATE,
    CONSTRAINT fk_manageri_angajati
        FOREIGN KEY (id_manager) REFERENCES angajati (id_angajat),
    CONSTRAINT fk_manageri_restaurante
        FOREIGN KEY (id_restaurant) REFERENCES restaurante (id_restaurant)
);

CREATE TABLE chelneri (
    id_chelner               NUMERIC(5)    PRIMARY KEY,
    punctaj_ultima_evaluare  NUMERIC(3, 2),
    data_ultimei_evaluari    DATE,
    CONSTRAINT fk_chelneri_angajati
        FOREIGN KEY (id_chelner) REFERENCES angajati (id_angajat)
);

CREATE TABLE bucatari (
    id_bucatar                  NUMERIC(5)      PRIMARY KEY,
    specializari                VARCHAR(1000),
    data_ultimei_specializari   DATE,
    CONSTRAINT fk_bucatari_angajati
        FOREIGN KEY (id_bucatar) REFERENCES angajati (id_angajat)
);

CREATE TABLE ture (
    id_angajat              NUMERIC(5),
    data_ora_inceput_tura   TIMESTAMP,
    ora_ora_sfarsit_tura    TIMESTAMP,
    observatii              VARCHAR(500),
    CONSTRAINT pk_ture
        PRIMARY KEY (id_angajat, data_ora_inceput_tura),
    CONSTRAINT fk_ture_angajati
        FOREIGN KEY (id_angajat) REFERENCES angajati (id_angajat)
);

-- ============================================================
-- 5. COMENZI ȘI DETALII COMENZI
-- ============================================================

CREATE TABLE comenzi (
    id_comanda          NUMERIC(12)   PRIMARY KEY,
    data_ora_comanda    TIMESTAMP,
    id_client           NUMERIC(5),
    id_masa             NUMERIC(5),
    observatii          VARCHAR(100),
    CONSTRAINT fk_comenzi_clienti
        FOREIGN KEY (id_client) REFERENCES clienti (id_client),
    CONSTRAINT fk_comenzi_mese
        FOREIGN KEY (id_masa) REFERENCES mese (id_masa)
);

CREATE TABLE com_bauturi (
    id_comanda              NUMERIC(12),
    id_bautura              NUMERIC(6),
    cantitate_comandata     NUMERIC(5),
    pret_unitar             NUMERIC(10, 2),
    CONSTRAINT pk_com_bauturi
        PRIMARY KEY (id_comanda, id_bautura),
    CONSTRAINT fk_com_bauturi_comenzi
        FOREIGN KEY (id_comanda) REFERENCES comenzi (id_comanda),
    CONSTRAINT fk_com_bauturi_bauturi
        FOREIGN KEY (id_bautura) REFERENCES bauturi (id_bautura)
);

CREATE TABLE com_mancare (
    id_comanda              NUMERIC(12),
    id_sortiment_mancare    NUMERIC(5),
    id_portie_comandata     NUMERIC(5),
    pret_unitar             NUMERIC(10, 2),
    CONSTRAINT pk_com_mancare
        PRIMARY KEY (id_comanda, id_sortiment_mancare),
    CONSTRAINT fk_com_mancare_comenzi
        FOREIGN KEY (id_comanda) REFERENCES comenzi (id_comanda),
    CONSTRAINT fk_com_mancare_meniuri
        FOREIGN KEY (id_sortiment_mancare) REFERENCES meniuri_mancare (id_sortiment_mancare)
);

CREATE TABLE bonuri_fiscale (
    id_bon_f        NUMERIC(10)   PRIMARY KEY,
    nr_bon_f        VARCHAR(20),
    data_ora_bon_f  TIMESTAMP,
    id_comanda      NUMERIC(10),
    suma_bon_f      NUMERIC(10, 2),
    cod_locatie     VARCHAR(20),
    id_client       NUMERIC(7),
    CONSTRAINT fk_bonuri_comenzi
        FOREIGN KEY (id_comanda) REFERENCES comenzi (id_comanda),
    CONSTRAINT fk_bonuri_clienti
        FOREIGN KEY (id_client) REFERENCES clienti (id_client)
);

-- ============================================================
-- 6. REZERVĂRI
-- ============================================================

CREATE TABLE rezervari (
    id_rezervare        NUMERIC(10)   PRIMARY KEY,
    data_ora_rezervare  TIMESTAMP,
    id_client           NUMERIC(5),
    data_ora_sosire     TIMESTAMP,
    data_ora_plecare    TIMESTAMP,
    CONSTRAINT fk_rezervari_clienti
        FOREIGN KEY (id_client) REFERENCES clienti (id_client)
);

CREATE TABLE rezervari_mese (
    id_rezervare    NUMERIC(10),
    id_masa         NUMERIC(5),
    observatii      VARCHAR(100),
    CONSTRAINT pk_rezervari_mese
        PRIMARY KEY (id_rezervare, id_masa),
    CONSTRAINT fk_rezervari_mese_rezervari
        FOREIGN KEY (id_rezervare) REFERENCES rezervari (id_rezervare),
    CONSTRAINT fk_rezervari_mese_mese
        FOREIGN KEY (id_masa) REFERENCES mese (id_masa)
);

CREATE TABLE rezervari_restaurante (
    id_rezervare    NUMERIC(10),
    id_restaurant   NUMERIC(5),
    observatii      VARCHAR(1000),
    CONSTRAINT pk_rezervari_restaurante
        PRIMARY KEY (id_rezervare, id_restaurant),
    CONSTRAINT fk_rez_rest_rezervari
        FOREIGN KEY (id_rezervare) REFERENCES rezervari (id_rezervare),
    CONSTRAINT fk_rez_rest_restaurante
        FOREIGN KEY (id_restaurant) REFERENCES restaurante (id_restaurant)
);

-- ============================================================
-- 7. APROVIZIONĂRI DE LA FURNIZORI
-- ============================================================

CREATE TABLE comenzi_produse_furnizori (
    id_comanda_furnizor NUMERIC(10)   PRIMARY KEY,
    data_ora_comanda    TIMESTAMP,
    id_restaurant       NUMERIC(5),
    id_furnizor         NUMERIC(5),
    id_produs           NUMERIC(6),
    cantitate           NUMERIC,
    pret_total          NUMERIC,
    CONSTRAINT fk_cpf_restaurante
        FOREIGN KEY (id_restaurant) REFERENCES restaurante (id_restaurant),
    CONSTRAINT fk_cpf_furnizori
        FOREIGN KEY (id_furnizor) REFERENCES furnizori (id_furnizor),
    CONSTRAINT fk_cpf_produse
        FOREIGN KEY (id_produs) REFERENCES produse (id_produs)
);