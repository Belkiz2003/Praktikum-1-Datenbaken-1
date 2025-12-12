-- *** AUFGABE 3: SQL-Optimierung ***

-- * Abfrage aus 2, die mittels Index optimiert werden soll --> Abfrage 6

-- Abfrage vor der Optimierung
-- -6. Finden Sie den/die Professor(en) (Name ausgeben) mit den meisten Assistenten.

EXPLAIN ANALYZE
-- ### START (Copy & Paste aus Aufgabe 2)###
SELECT professoren.name --, -- <--- Falls gewünscht auskommentieren: zeigt dann auch noch die Anzahl der Assistenten an
--count(boss) as assistenten -- <--- Falls gewünscht auskommentieren: zeigt dann auch noch die MenAnzahlge der Assistenten an
FROM assistenten 
JOIN professoren ON professoren.persnr=assistenten.boss 
GROUP BY professoren.name 
HAVING count(boss) = ( -- Dieser Teil findet die größte Anzahl an Assistenten, um die dann mit allen Professoren zu vergleichen.
	SELECT count(boss) as assistenten -- Diese Query alleine würde schon ausreichen um !DEN! Professor mit den meisten Assistenten zu ermitteln,
	FROM assistenten                  -- aber es ist nach allen gefragt, muss dieser wert noch weiter mit allen abgeglichen werden.
	JOIN professoren ON professoren.persnr=assistenten.boss 
	GROUP BY professoren.name ORDER BY assistenten DESC LIMIT 1 --
);
-- ### ENDE (Copy & Paste aus Aufgabe 2)###


-- Optimierung
-- -Temporäre Indexe erstellen
CREATE INDEX profpersnr_indx ON professoren (name);
CREATE INDEX assboss_indx ON assistenten (boss);    -- Wichtiger Index, weil Fremdschlüssel von PostgreSQL nativ nicht mit einem Index optimiert werden

-- Optimierung testen
-- -Abfrage nach Indexerzeugung testen
EXPLAIN ANALYZE
-- ### START (Copy & Paste aus Aufgabe 2)###
SELECT professoren.name --, -- <--- Falls gewünscht auskommentieren: zeigt dann auch noch die Anzahl der Assistenten an
--count(boss) as assistenten -- <--- Falls gewünscht auskommentieren: zeigt dann auch noch die MenAnzahlge der Assistenten an
FROM assistenten 
JOIN professoren ON professoren.persnr=assistenten.boss 
GROUP BY professoren.name 
HAVING count(boss) = ( -- Dieser Teil findet die größte Anzahl an Assistenten, um die dann mit allen Professoren zu vergleichen.
	SELECT count(boss) as assistenten -- Diese Query alleine würde schon ausreichen um !DEN! Professor mit den meisten Assistenten zu ermitteln,
	FROM assistenten                  -- aber es ist nach allen gefragt, muss dieser wert noch weiter mit allen abgeglichen werden.
	JOIN professoren ON professoren.persnr=assistenten.boss 
	GROUP BY professoren.name ORDER BY assistenten DESC LIMIT 1 --
);
-- ### ENDE (Copy & Paste aus Aufgabe 2)###


-- Optimierung aufheben
-- -Temporäre Indexe wieder löschen
DROP INDEX profpersnr_indx;
DROP INDEX assboss_indx;