-- *** AUFGABE 3: SQL-Optimierung von Michael Haselhoff ***

-- * Abfrage aus Aufgabe 2, die mittels Index optimiert werden soll --> Abfrage 6

-- 1. MESSUNG VOR DER OPTIMIERUNG
-- Abfrage 6: Professor(en) mit den meisten Assistenten.

EXPLAIN ANALYZE
-- ### START (Optimierte Abfrage aus Aufgabe 2) ###
SELECT p.Name, COUNT(a.Boss) AS Anzahl_Assistenten
FROM Assistenten a
JOIN Professoren p ON p.PersNr = a.Boss
GROUP BY p.PersNr, p.Name 
HAVING COUNT(a.Boss) = (
    -- Unterabfrage: Findet die höchste Anzahl an Assistenten
    SELECT COUNT(*)
    FROM assistenten
    GROUP BY Boss 
    ORDER BY COUNT(*) DESC 
    LIMIT 1 
);
-- ### ENDE ###


-- 2. OPTIMIERUNG DURCHFÜHREN
-- Temporäre Indexe erstellen
CREATE INDEX profpersnr_indx ON professoren (name);
CREATE INDEX assboss_indx ON assistenten (boss);    -- Wichtiger Index! Fremdschlüssel werden in PostgreSQL nicht automatisch indiziert.


-- 3. MESSUNG NACH DER OPTIMIERUNG
-- Dieselbe Abfrage noch einmal ausführen, um den Unterschied zu sehen.

EXPLAIN ANALYZE
-- ### START (Gleiche Abfrage wie oben) ###
SELECT p.Name, COUNT(a.Boss) AS Anzahl_Assistenten
FROM Assistenten a
JOIN Professoren p ON p.PersNr = a.Boss
GROUP BY p.PersNr, p.Name 
HAVING COUNT(a.Boss) = (
    -- Unterabfrage: Findet die höchste Anzahl an Assistenten
    SELECT COUNT(*)
    FROM assistenten
    GROUP BY Boss 
    ORDER BY COUNT(*) DESC 
    LIMIT 1 
);
-- ### ENDE ###


-- 4. AUFRÄUMEN
-- Temporäre Indexe wieder löschen, um den Ursprungszustand herzustellen.
DROP INDEX profpersnr_indx;
DROP INDEX assboss_indx;


-- 5. VOR- und NACHHER -VERGLEICH
-- -Vorher:
-- --Planning-Time:  ca. 0,49  ms
-- --Execution-Time: ca. 0,289 ms

-- -Nachher:
-- --Planning-Time:  ca. 0,369 ms
-- --Execution-Time: ca. 0,180 ms
