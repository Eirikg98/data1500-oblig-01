# Besvarelse - Refleksjon og Analyse

**Student:** [Ditt navn]

**Studentnummer:** [Ditt studentnummer]

**Dato:** [Innleveringsdato]

---

## Del 1: Datamodellering

### Oppgave 1.1: Entiteter og attributter

**Identifiserte entiteter:**
stasjon
kunde
laas
sykkel
utleie

[Skriv ditt svar her - list opp alle entitetene du har identifisert]

**Attributter for hver entitet:**

    STASJON {
    SERIAL stasjon_id PK
    VARCHAR(50) navn "NOT NULL"
    VARCHAR(255) adresse "NOT NULL"
    INTEGER kapasitet "NOT NULL, CHECK > 0"
    }

    KUNDE {
        SERIAL kunde_id PK
        VARCHAR(15) mobilnummer "NOT NULL, UNIQUE"
        VARCHAR(255) epost "NOT NULL, UNIQUE"
        VARCHAR(50) fornavn "NOT NULL"
        VARCHAR(50) etternavn "NOT NULL"
    }

    LAAS {
        SERIAL laas_id PK
        INTEGER stasjon_id "NOT NULL, FK"
    }

    SYKKEL {
        SERIAL sykkel_id PK
        DATE tatt_i_bruk_dato "NOT NULL"
        INTEGER laas_id "FK, UNIQUE, NULL ved utleie"
    }

    UTLEIE {
        SERIAL utleie_id PK
        INTEGER kunde_id "NOT NULL, FK"
        INTEGER sykkel_id "NOT NULL, FK"
        TIMESTAMP utlevert_tid "NOT NULL"
        TIMESTAMP innlevert_tid "NULL mulig"
        NUMERIC_8_2 beloep "SQL: NUMERIC(8,2), CHECK >= 0"
    }

    STASJON ||--o{ LAAS : har en
    LAAS o|--o| SYKKEL : inneholder
    KUNDE ||--o{ UTLEIE : gjør
    SYKKEL ||--o{ UTLEIE : eksisterer i



### Oppgave 1.2: Datatyper og `CHECK`-constraints

**Valgte datatyper og begrunnelser:**
INTEGER
- Brukes på felt som representerer heltall.
- Brukes for primærnøkler (f.eks. stasjon_id, kunde_id, sykkel_id) fordi disse er numeriske identifikatorer.
- Brukes for fremmednøkler, siden de må ha samme datatype som primærnøkkelen de refererer til.
- Brukes for kapasitet, siden dette er et antall (heltall) og ikke kan være desimaltall.


VARCHAR
- Jeg har brukt varchar på felt som inneholder tekst, for eksempel navn, adresse og e-post.
- Tok også et valg om å bruke det på mobilnummer, selv om det består av tall, fordi det ikke brukes i beregninger.
- Mobilnummer kan inneholde landskode f.eks. +47 eller starte med 0, og derfor har jeg ikke valgt datatypen INTEGER.
- VARCHAR gir også mulighet til å sette en maksimal lengde på feltet.
- Jeg har brukt varchar(50) på navn, siden lite sannsynlig at det overstiger 100 tegn.
- Jeg har brukt varchar(255) på adresse som gir godt egnet kapasitet. 
- jeg har brukt not null på felter som er obligatoriske for at en rad skal være gyldig. Det skal hindre at viktige verdier mangler (f.eks. kunde på en utleie eller navn på en stasjon).
- Jeg har brukt not null på stasjonen sitt navn, adresse og kapasitet. 
- Jeg har brukt not null på kunden sitt mobilnummer, epost, fornavn, etternavn. 
 - Jeg har brukt not null på laas sitt stasjon_id. 
 - Jeg har brukt not null på sykkel sitt tatt_i_bruk_dato. 
 - Jeg har brukt not null på utleie sitt kunde_id, sykkel_id, utlevert_tid.



[Skriv ditt svar her - forklar hvilke datatyper du har valgt for hver attributt og hvorfor]

**`CHECK`-constraints:**
CHECK (kapasitet > 0)
- Sikrer at en stasjon må ha positiv kapasitet. Hindrer at det registreres stasjoner med 0 eller negativt antall plasser.

CHECK (innlevert_tid IS NULL OR innlevert_tid >= utlevert_tid)
- Sikrer at innleveringstidspunktet ikke kan være før utleveringstidspunktet. Tillater at innlevert_tid er NULL så lenge utleien pågår.

CHECK (beloep IS NULL OR beloep >= 0)
- Sikrer at leiebeløpet ikke kan være negativt.Tillater at beløpet er NULL frem til utleien avsluttes.

Generelt om CHECK-constraints
- Brukes for å håndheve forretningsregler direkte i databasen. Hindrer at ugyldige eller logisk feil data blir lagret.
Bidrar til bedre datakvalitet og mer konsistent database.

[Skriv ditt svar her - list opp alle CHECK-constraints du har lagt til og forklar hvorfor de er nødvendige]

**ER-diagram:**

[Legg inn mermaid-kode eller eventuelt en bildefil fra `mermaid.live` her]

---

### Oppgave 1.3: Primærnøkler

**Valgte primærnøkler og begrunnelser:**

STASJON: stasjon_id(primærnøkkel)
- Jeg har valgt stasjon_id (primærnøkkel). Brukes for å identifisere hver stasjon entydig. Valgt SERIAL som surrogatnøkkel for stabil og enkel referanse.

KUNDE: kunde_id (primærnøkkel)
- Identifiserer hver kunde unikt. E-post og mobil er unike, men kan endres, derfor brukes en egen ID.

LAAS: laas_id (primærnøkkel)
- Gir hver lås en unik identifikator og brukes i relasjon til sykkel.

SYKKEL: sykkel_id (primærnøkkel)
- Unik ID for hver sykkel. Valgt som surrogatnøkkel siden det ikke finnes en naturlig nøkkel.

UTLEIE:  utleie_id (primærnøkkel)
- Identifiserer hver utleie unikt. En egen ID gjør relasjoner enklere.



[Skriv ditt svar her - forklar hvilke primærnøkler du har valgt for hver entitet og hvorfor]

**Naturlige vs. surrogatnøkler:**

- Jeg har valgt surrogatnøkler (SERIAL), fordi de er stabile og gjør det lettere å opprette fremmednøkler mellom tabellene.


[Skriv ditt svar her - diskuter om du har brukt naturlige eller surrogatnøkler og hvorfor]

**Oppdatert ER-diagram:**
        
        STASJON {
        SERIAL stasjon_id PK
        VARCHAR(50) navn "NOT NULL"
        VARCHAR(255) adresse "NOT NULL"
        INTEGER kapasitet "NOT NULL, CHECK > 0"
        }

    KUNDE {
        SERIAL kunde_id PK
        VARCHAR(15) mobilnummer "NOT NULL, UNIQUE"
        VARCHAR(255) epost "NOT NULL, UNIQUE"
        VARCHAR(50) fornavn "NOT NULL"
        VARCHAR(50) etternavn "NOT NULL"
    }

    LAAS {
        SERIAL laas_id PK
        INTEGER stasjon_id "NOT NULL, FK"
    }

    SYKKEL {
        SERIAL sykkel_id PK
        DATE tatt_i_bruk_dato "NOT NULL"
        INTEGER laas_id "FK, UNIQUE, NULL ved utleie"
    }

    UTLEIE {
        SERIAL utleie_id PK
        INTEGER kunde_id "NOT NULL, FK"
        INTEGER sykkel_id "NOT NULL, FK"
        TIMESTAMP utlevert_tid "NOT NULL"
        TIMESTAMP innlevert_tid "NULL mulig"
        NUMERIC_8_2 beloep "SQL: NUMERIC(8,2), CHECK >= 0"
    }

    STASJON ||--o{ LAAS : har en
    LAAS o|--o| SYKKEL : inneholder
    KUNDE ||--o{ UTLEIE : gjør
    SYKKEL ||--o{ UTLEIE : eksisterer i

[Legg inn mermaid-kode eller eventuelt en bildefil fra `mermaid.live` her]

---

### Oppgave 1.4: Forhold og fremmednøkler

**Identifiserte forhold og kardinalitet:**
Jeg har identifisert følgende forhold mellom entitetene i databasen:

Stasjon – Lås
Kardinalitet: 1 til mange (1:N)
Én stasjon kan ha flere låser, og hver lås tilhører én stasjon.
Dette implementeres med fremmednøkkelen laas.stasjon_id.

Lås – Sykkel
Kardinalitet: 0..1 til 0..1 (valgfri én-til-én)
En lås kan være tom eller inneholde én sykkel.
En sykkel kan stå i én lås eller være utleid (da er laas_id NULL).
Dette implementeres med sykkel.laas_id som fremmednøkkel og UNIQUE-constraint.

Kunde – Utleie
Kardinalitet: 1 til mange (1:N)
En kunde kan ha flere utleier, men hver utleie tilhører én kunde.
Implementeres med utleie.kunde_id som fremmednøkkel.

Sykkel – Utleie
Kardinalitet: 1 til mange (1:N)
En sykkel kan bli leid ut flere ganger over tid, men hver utleie gjelder én sykkel.
Implementeres med utleie.sykkel_id som fremmednøkkel.
[Skriv ditt svar her - list opp alle forholdene mellom entitetene og angi kardinalitet]

**Fremmednøkler:**
Jeg har brukt fremmednøkler for å koble tabellene sammen og sikre at relasjonene i databasen fungerer riktig.
- laas sin stasjon_id peker til stasjon sin stasjon_id. Dette gjør at hver lås alltid er knyttet til en bestemt stasjon.
- sykkel sin laas_id peker til laas sin laas_id.
- Dette viser hvilken lås sykkelen står i. Feltet kan være NULL når sykkelen er utleid. I tillegg er det satt UNIQUE på laas_id slik at én lås ikke kan ha flere sykler.
- utleie sin kunde_id refererer til kunde sin kunde_id. Dette viser hvilken kunde som har leid sykkelen.
- utleie sin sykkel_id refererer til sykkel.sykkel_id. Dette viser hvilken sykkel som er leid ut.

Fremmednøklene sørger for at det ikke går an å registrere for eksempel en utleie med en kunde eller sykkel som ikke finnes i systemet.

[Skriv ditt svar her - list opp alle fremmednøklene og forklar hvordan de implementerer forholdene]

**Oppdatert ER-diagram:**
erDiagram

    STASJON {
        SERIAL stasjon_id PK
        VARCHAR(50) navn "NOT NULL"
        VARCHAR(255) adresse "NOT NULL"
        INTEGER kapasitet "NOT NULL, CHECK > 0"
    }

    KUNDE {
        SERIAL kunde_id PK
        VARCHAR(15) mobilnummer "NOT NULL, UNIQUE"
        VARCHAR(255) epost "NOT NULL, UNIQUE"
        VARCHAR(50) fornavn "NOT NULL"
        VARCHAR(50) etternavn "NOT NULL"
    }

    LAAS {
        SERIAL laas_id PK
        INTEGER stasjon_id "NOT NULL, FK"
    }

    SYKKEL {
        SERIAL sykkel_id PK
        DATE tatt_i_bruk_dato "NOT NULL"
        INTEGER laas_id "FK, UNIQUE, NULL ved utleie"
    }

    UTLEIE {
        SERIAL utleie_id PK
        INTEGER kunde_id "NOT NULL, FK"
        INTEGER sykkel_id "NOT NULL, FK"
        TIMESTAMP utlevert_tid "NOT NULL"
        TIMESTAMP innlevert_tid "NULL mulig"
        NUMERIC_8_2 beloep "SQL: NUMERIC(8,2), CHECK >= 0"
    }

    STASJON ||--o{ LAAS : har en
    LAAS o|--o| SYKKEL : inneholder
    KUNDE ||--o{ UTLEIE : gjør
    SYKKEL ||--o{ UTLEIE : eksisterer i

[Legg inn mermaid-kode eller eventuelt en bildefil fra `mermaid.live` her]

---

### Oppgave 1.5: Normalisering

**Vurdering av 1. normalform (1NF):**
- Datamodellen min er på 1NF fordi alle tabellene har en primærnøkkel som identifiserer hver rad entydig. I tillegg inneholder hver kolonne kun en verdi per felt, for eksempel ett mobilnummer per kunde og en dato per sykkel. Det finnes ingen repeterende grupper eller lister i én kolonne. Dette betyr at strukturen oppfyller kravene til første normalform. 

[Skriv ditt svar her - forklar om datamodellen din tilfredsstiller 1NF og hvorfor]

**Vurdering av 2. normalform (2NF):**
- Datamodellen min er i 2NF fordi alle tabellene har én enkel primærnøkkel, for eksempel kunde_id eller sykkel_id. Det betyr at ingen av tabellene har sammensatte nøkler, og dermed kan det ikke oppstå delvise avhengigheter. Alle de andre feltene i hver tabell henger sammen med hele primærnøkkelen. For eksempel i kunde-tabellen hører mobilnummer, e-post og navn direkte til kunde_id.
[Skriv ditt svar her - forklar om datamodellen din tilfredsstiller 2NF og hvorfor]
 
**Vurdering av 3. normalform (3NF):**
- Jeg mener modellen min også er i 3NF fordi informasjonen er delt opp i egne tabeller, og ingen ikke-nøkkelattributter avhenger av andre ikke-nøkkelattributter. For eksempel ligger informasjon om stasjon kun i stasjon-tabellen, og ikke i laas eller sykkel. På samme måte ligger kundeinformasjon kun i kunde, mens utleie bare peker til kunden via kunde_id. Dette gjør at vi unngår unødvendig duplisering av data og reduserer risikoen for inkonsistens.

[Skriv ditt svar her - forklar om datamodellen din tilfredsstiller 3NF og hvorfor]

**Eventuelle justeringer:**

[Skriv ditt svar her - hvis modellen ikke var på 3NF, forklar hvilke justeringer du har gjort]

---

## Del 2: Database-implementering

### Oppgave 2.1: SQL-skript for database-initialisering

**Plassering av SQL-skript:**

[Bekreft at du har lagt SQL-skriptet i `init-scripts/01-init-database.sql`]
Jeg kan bekrefte at lagt SQL-scriptet i`init-scripts/01-init-database.sql`]
**Antall testdata:**

- Kunder: 5
- Sykler: 100
- Sykkelstasjoner: 5
- Låser: 20
- Utleier: 50

---

### Oppgave 2.2: Kjøre initialiseringsskriptet

**Dokumentasjon av vellykket kjøring:**

[Skriv ditt svar her - f.eks. skjermbilder eller output fra terminalen som viser at databasen ble opprettet uten feil]

**Spørring mot systemkatalogen:**

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

**Resultat:**

```
Jeg kjørte initialiseringsskriptet via Docker, og det ble gjennomført uten noen feilmeldinger. Databasen og alle tabellene ble opprettet slik de skulle.

oblig01=# SELECT table_name 
oblig01-# FROM information_schema.tables 
oblig01-# WHERE table_schema = 'public' 
oblig01-#   AND table_type = 'BASE TABLE'
oblig01-# ORDER BY table_name;
 table_name 
------------
 kunde
 laas
 stasjon
 sykkel
 utleie
(5 rows)


```

---

## Del 3: Tilgangskontroll

### Oppgave 3.1: Roller og brukere

**SQL for å opprette rolle:**

```sql
[CREATE ROLE kunde_rolle;]
```

**SQL for å opprette bruker:**

```sql
[CREATE USER kunde_1 WITH PASSWORD 'passord455';]
```

**SQL for å tildele rettigheter:**

```sql
[GRANT kunde_rolle TO kunde_1;

GRANT SELECT ON stasjon TO kunde_rolle;
GRANT SELECT ON laas TO kunde_rolle;
GRANT SELECT ON sykkel TO kunde_rolle;

GRANT SELECT, INSERT, UPDATE ON utleie TO kunde_rolle;]
```

---

### Oppgave 3.2: Begrenset visning for kunder

**SQL for VIEW:**

```sql
[Skriv din SQL-kode for VIEW her]

CREATE VIEW eirik_utleier AS
SELECT *
FROM utleie
WHERE kunde_id = 1;

REVOKE SELECT ON utleie FROM kunde_role;
GRANT SELECT ON eirik_utleier TO kunde_role;
```

**Ulempe med VIEW vs. POLICIES:**


[Skriv ditt svar her - diskuter minst én ulempe med å bruke VIEW for autorisasjon sammenlignet med POLICIES]
- En ulempe med å bruke VIEW i stedet for POLICIES er at sikkerheten avhenger av at man setter rettighetene helt riktig. Hvis en bruker ved en feil får tilgang direkte til tabellen, kan de omgå viewet og hente ut alle radene derfra. Da gir ikke viewet egentlig den beskyttelsen man ønsker.
  Med policies blir tilgangskontrollen håndhevet direkte av databasen på radnivå. Det betyr at selv om brukeren prøver å skrive en egen spørring, vil databasen fortsatt bare gi tilgang til de radene brukeren har lov til å se. Dette gjør det til en mer sikker løsning.
## Del 4: Analyse og Refleksjon

### Oppgave 4.1: Lagringskapasitet

**Gitte tall for utleierate:**

- Høysesong (mai-september): 20000 utleier/måned
- Mellomsesong (mars, april, oktober, november): 5000 utleier/måned
- Lavsesong (desember-februar): 500 utleier/måned

**Totalt antall utleier per år:**

- Høysessong 5*20_000= 100_000 utleiere i høysesong   
- Mellomsesong 4*5000=20_000 utleiere i mellomsesong 
- Lavsesong 3*500= 1500 utleiere i lavsesong 

Totalt utleiere per år: 121_500 

[Skriv din utregning her]


**Estimat for lagringskapasitet:**

Total bytes for hver enkelt datatype i utleie: 

Utleie: 

int 4 bytes * 3 = 12 bytes 

timestamps 8*2=16 bytes 

numeric (8,2)=antar 12 bytes

Totalt antall bytes for datatypene: 

40 bytes. 




[Skriv din utregning her - vis hvordan du har beregnet lagringskapasiteten for hver tabell]

**Totalt for første år:**

[40 bytes * 121_500= 4860000 bytes]

---

### Oppgave 4.2: Flat fil vs. relasjonsdatabase

**Analyse av CSV-filen (`data/utleier.csv`):**

**Problem 1: Redundans**

[I CSV-filen kan vi se at dataene gir redundans der gjentakelse av Ole Hansen og Kari Olsen 3 ganger der fornavn, etternavn, mobilnummer og epost er det samme. Dette tar opp unødvendig lagringskapasitet og kan føre til risiko for inkonsistens der dataen ikke oppdateres likt overalt.  ]

**Problem 2: Inkonsistens**

[Vi ser i CSV-filen at flere rader inneholder samme kundeinformasjon, for eksempel navn, mobilnummer og e-post. Dette betyr at de samme dataene lagres flere ganger. Hvis en kunde endrer navn eller mobilnummer, må denne informasjonen oppdateres i alle radene der kunden forekommer. Dersom én eller flere rader ikke blir oppdatert, vil vi få ulike verdier for samme kunde. Dette fører til inkonsistente data i datasettet. ]

**Problem 3: Oppdateringsanomalier**

[en flat CSV-fil kan det oppstå problemer fordi samme informasjon ligger i flere rader. Hvis en kunde for eksempel endrer mobilnummer, må det oppdateres overalt. Hvis vi glemmer én rad, får vi ulike verdier for samme person.
Det kan også være vanskelig å legge inn en ny kunde uten at det finnes en utleie, siden hver rad i filen representerer en utleie. I tillegg kan vi miste viktig informasjon hvis vi sletter en rad som inneholder den eneste registreringen av en kunde eller stasjon.]

**Fordeler med en indeks:**

[En indeks gjør det raskere å finne bestemte rader i en tabell. Uten indeks må databasen gå gjennom hele tabellen for å finne det vi leter etter. Med en indeks kan den hoppe direkte til riktig rad.]

**Case 1: Indeks passer i RAM**

[Skriv ditt svar her - forklar hvordan indeksen fungerer når den passer i minnet]

**Case 2: Indeks passer ikke i RAM**

[Skriv ditt svar her - forklar hvordan flettesortering kan brukes]

**Datastrukturer i DBMS:**

[Skriv ditt svar her - diskuter B+-tre og hash-indekser]

---

### Oppgave 4.3: Datastrukturer for logging

**Foreslått datastruktur:**

[Skriv ditt svar her - f.eks. heap-fil, LSM-tree, eller annen egnet datastruktur]

**Begrunnelse:**

**Skrive-operasjoner:**

[Skriv ditt svar her - forklar hvorfor datastrukturen er egnet for mange skrive-operasjoner]

**Lese-operasjoner:**

[Skriv ditt svar her - forklar hvordan datastrukturen håndterer sjeldne lese-operasjoner]

---

### Oppgave 4.4: Validering i flerlags-systemer

**Hvor bør validering gjøres:**

[Skriv ditt svar her - argumenter for validering i ett eller flere lag]

**Validering i nettleseren:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Validering i applikasjonslaget:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Validering i databasen:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Konklusjon:**

[Skriv ditt svar her - oppsummer hvor validering bør gjøres og hvorfor]

---

### Oppgave 4.5: Refleksjon over læringsutbytte

**Hva har du lært så langt i emnet:**


[I emnet databaser har jeg fått en mye bedre forståelse for hvordan en database bygges opp fra bunnen av. Jeg har lært å modellere et system ved hjelp av ER-diagram, og hvordan man går fra en idé eller problemstilling til en konkret struktur med tabeller, attributter og relasjoner.
Jeg har også fått en bedre forståelse for begreper som primærnøkler og fremmednøkler, og hvordan disse brukes for å koble tabeller sammen og sikre referanseintegritet. Kardinalitet og forhold mellom entiteter var noe jeg syntes var litt vanskelig i starten, men gjennom oppgavene har jeg blitt tryggere på å definere én-til-mange og én-til-én-forhold riktig.
Videre har jeg lært om normalisering (1NF, 2NF og 3NF), og hvorfor det er viktig for å unngå redundans og inkonsistente data. Jeg ser nå tydelig forskjellen mellom en flat struktur (som CSV) og en relasjonsdatabase, og hvorfor en godt strukturert database er mer robust.
I tillegg har jeg fått mer praktisk erfaring med SQL, både når det gjelder å opprette tabeller med riktige constraints, bruke JOIN, GROUP BY og ulike spørringer, samt å jobbe med tilgangskontroll gjennom roller og views. Det har gjort at jeg føler meg mer komfortabel med hvordan databaser faktisk fungerer i praksis, ikke bare i teori.]

**Hvordan har denne oppgaven bidratt til å oppnå læringsmålene:**

[Jeg føler at denne oppgaven virkelig har hjulpet meg med å nå læringsmålene i emnet. Gjennom arbeidet har vi brukt Docker til å sette opp databasen og faktisk kjørt SQL-skript i praksis, noe som gjorde det mer konkret enn bare teori. Vi har opprettet tabeller, definert nøkler og constraints, og testet ulike SQL-spørringer for å hente ut data.
I tillegg har vi brukt ER-diagram for å planlegge strukturen før vi implementerte den. Det gjorde det lettere å forstå hvordan tabellene henger sammen, og hvorfor det er viktig å tenke gjennom relasjoner og normalisering før man begynner å kode. Oppgaven har derfor gitt meg både teknisk erfaring og en bedre helhetsforståelse av databasedesign.]

Se oversikt over læringsmålene i en PDF-fil i Canvas https://oslomet.instructure.com/courses/33293/files/folder/Plan%20v%C3%A5ren%202026?preview=4370886

**Hva var mest utfordrende:**

[Noe jeg syntes var spesielt utfordrende var kardinalitet og det å definere riktige relasjoner mellom entitetene. I starten var det vanskelig å vite om noe skulle være én-til-mange eller én-til-én, og hvordan det faktisk påvirker databasedesignet. Jeg syntes også det var utfordrende å legge inn testdata på en god måte, spesielt når jeg måtte sørge for at fremmednøkler stemte og at dataene ikke brøt constraints. Etter hvert som jeg jobbet mer med det, ble det lettere å se sammenhengen.
Gjennom denne oppgaven føler jeg at jeg har fått en bedre forståelse av både databasedesign og praktisk bruk av SQL.]

**Hva har du lært om databasedesign:**

[Skriv din refleksjon her - reflekter over prosessen med å designe en database fra bunnen av]

---

## Del 5: SQL-spørringer og Automatisk Testing

**Plassering av SQL-spørringer:**

[ Jeg har lagt til SQL-spørringer i `test-scripts/queries.sql`]


**Eventuelle feil og rettelser:**

[Skriv ditt svar her - hvis noen tester feilet, forklar hva som var feil og hvordan du rettet det]

---

## Del 6: Bonusoppgaver (Valgfri)

### Oppgave 6.1: Trigger for lagerbeholdning

**SQL for trigger:**

```sql
[Skriv din SQL-kode for trigger her, hvis du har løst denne oppgaven]
```

**Forklaring:**

[Skriv ditt svar her - forklar hvordan triggeren fungerer]

**Testing:**

[Skriv ditt svar her - vis hvordan du har testet at triggeren fungerer som forventet]

---

### Oppgave 6.2: Presentasjon

**Lenke til presentasjon:**

[Legg inn lenke til video eller presentasjonsfiler her, hvis du har løst denne oppgaven]

**Hovedpunkter i presentasjonen:**

[Skriv ditt svar her - oppsummer de viktigste punktene du dekket i presentasjonen]

---

**Slutt på besvarelse**
