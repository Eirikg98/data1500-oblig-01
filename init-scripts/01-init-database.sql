-- ============================================================================
-- DATA1500 - Oblig 1: Arbeidskrav I våren 2026
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- Opprett grunnleggende tabeller

-- =========================
-- TABELL: Stasjon
-- =========================
CREATE TABLE stasjon (
                         stasjon_id SERIAL PRIMARY KEY,
                         navn VARCHAR(50) NOT NULL,
                         adresse VARCHAR(255) NOT NULL,
                         kapasitet INTEGER NOT NULL CHECK (kapasitet > 0)
);

CREATE TABLE kunde (
                       kunde_id SERIAL PRIMARY KEY,
                       mobilnummer VARCHAR(15) NOT NULL UNIQUE,
                       epost VARCHAR(255) NOT NULL UNIQUE,
                       fornavn VARCHAR(50) NOT NULL,
                       etternavn VARCHAR(50) NOT NULL
);

CREATE TABLE laas (
                      laas_id SERIAL PRIMARY KEY,
                      stasjon_id INTEGER NOT NULL REFERENCES stasjon(stasjon_id) ON DELETE CASCADE
);

CREATE TABLE sykkel (
                        sykkel_id SERIAL PRIMARY KEY,
                        tatt_i_bruk_dato DATE NOT NULL,
                        laas_id INTEGER REFERENCES laas(laas_id) ON DELETE SET NULL,
                        CONSTRAINT uq_sykkel_laas UNIQUE (laas_id)
);

CREATE TABLE utleie (
                        utleie_id SERIAL PRIMARY KEY,
                        kunde_id INTEGER NOT NULL REFERENCES kunde(kunde_id) ON DELETE CASCADE,
                        sykkel_id INTEGER NOT NULL REFERENCES sykkel(sykkel_id) ON DELETE CASCADE,
                        utlevert_tid TIMESTAMP NOT NULL,
                        innlevert_tid TIMESTAMP,
                        beloep NUMERIC(8,2),
                        CHECK (innlevert_tid IS NULL OR innlevert_tid >= utlevert_tid),
                        CHECK (beloep IS NULL OR beloep >= 0)
);

-- Hindrer dobbelt aktiv utleie for samme sykkel
CREATE UNIQUE INDEX uq_utleie_aktiv_sykkel
    ON utleie (sykkel_id)
    WHERE innlevert_tid IS NULL;

SELECT 'Database initialisert!' AS status;

-- Sett inn testdata
    --“Jeg brukte AI som støtte til å komme på en måte å generere testdata effektivt i PostgreSQL (f.eks. generate_series), og tilpasset det til skjemaet mitt.”
-- =========================
-- TESTDATA: Stasjon
-- =========================

INSERT INTO stasjon (navn, adresse, kapasitet) VALUES
                                                   ('Sentrum', 'Karl Johans gate 1', 20),
                                                   ('Majorstuen', 'Bogstadveien 50', 20),
                                                   ('Grunerlokka', 'Thorvald Meyers gate 15', 20),
                                                   ('Blindern', 'Problemveien 7', 20),
                                                   ('Bjorvika', 'Dronning Eufemias gate 15', 20);



---- =========================
-- TESTDATA: Kunde
-- =========================

INSERT INTO kunde (mobilnummer, epost, fornavn, etternavn) VALUES
                                                               ('90856229', 'ola@test.no', 'Ola', 'Nordmann'),
                                                               ('99562651', 'kari@test.no', 'Kari', 'Hansen'),
                                                               ('48226605', 'per@test.no', 'Per', 'Johansen'),
                                                               ('93984106', 'anne@test.no', 'Anne', 'Larsen'),
                                                               ('94191260', 'lars@test.no', 'Lars', 'Berg');




INSERT INTO laas (stasjon_id)
SELECT s.stasjon_id
FROM stasjon s,
    generate_series(1,20);

-- =========================
-- TESTDATA: Sykkel (100)
-- =========================

-- 80 sykler plassert på låser
-- =========================
-- TESTDATA: Sykkel (100)
-- =========================

-- 80 sykler plassert på låser (låser 1–80)
INSERT INTO sykkel (tatt_i_bruk_dato, laas_id)
SELECT
    DATE '2023-01-01' + (gs % 700),
    gs
FROM generate_series(1,80) gs;

-- 20 sykler som er ute (ingen lås)
INSERT INTO sykkel (tatt_i_bruk_dato, laas_id)
SELECT
    DATE '2023-01-01' + (gs % 700),
    NULL
FROM generate_series(81,100) gs;

-- =========================
-- TESTDATA: Utleie (50)
-- =========================
--
INSERT INTO utleie (kunde_id, sykkel_id, utlevert_tid, innlevert_tid, beloep)
SELECT
    (gs % 5) + 1,               -- 5 kunder
    gs,                         -- bruker sykkel 1–50
    NOW() - (gs || ' days')::interval,
    NOW() - ((gs - 1) || ' days')::interval,
    100 + (gs * 5)
FROM generate_series(1,50) gs;


CREATE ROLE kunde_rolle;
CREATE USER kunde_1 WITH PASSWORD 'passord455';
GRANT kunde_rolle TO kunde_1;

GRANT SELECT ON stasjon TO kunde_rolle;
GRANT SELECT ON laas TO kunde_rolle;
GRANT SELECT ON sykkel TO kunde_rolle;

GRANT SELECT, INSERT, UPDATE ON utleie TO kunde_rolle;


CREATE VIEW mine_utleier AS
SELECT *
FROM utleie
WHERE kunde_id = 1;

REVOKE SELECT ON utleie FROM kunde_role;
GRANT SELECT ON mine_utleier TO kunde_role;





--
--
--
--
--
--
--
--
--
--
--
-- Vis at initialisering er fullført (kan se i loggen fra "docker-compose log"
SELECT 'Database initialisert!' as status;
