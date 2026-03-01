-- ============================================================================
-- TEST-SKRIPT FOR OBLIG 1
-- ============================================================================

-- Kjør med: docker-compose exec postgres psql -h -U admin -d data1500_db -f test-scripts/queries.sql
--5.1
select * from sykkel
--5.2
select etternavn, fornavn, mobilnummer from kunde order by etternavn;
--5.3
select * from sykkel where tatt_i_bruk_dato > '2023-04-01';
--5.4
select COUNT (*) from sykkel;
--5.5
SELECT
    k.kunde_id,
    k.fornavn,
    k.etternavn,
    COUNT(u.utleie_id) AS antall_utleier -- Gjør om opptellingen til utleier antall.
FROM kunde k
         LEFT JOIN utleie u
                   ON u.kunde_id = k.kunde_id
GROUP BY k.kunde_id, k.fornavn, k.etternavn
ORDER BY k.etternavn, k.fornavn;
-- En test med en SQL-spørring mot metadata i PostgreSQL (kan slettes fra din script)
select nspname as schema_name from pg_catalog.pg_namespace;

--5.6
SELECT
    k.kunde_id,
    k.fornavn,
    k.etternavn,
    k.mobilnummer
FROM kunde k
         LEFT JOIN utleie u
                   ON u.kunde_id = k.kunde_id
WHERE u.utleie_id IS NULL
ORDER BY k.etternavn, k.fornavn;

--5.7
SELECT
    s.sykkel_id,
    s.tatt_i_bruk_dato,
    s.laas_id
FROM sykkel s
         LEFT JOIN utleie u
                   ON u.sykkel_id = s.sykkel_id
WHERE u.utleie_id IS NULL
ORDER BY s.sykkel_id;

--5.8

