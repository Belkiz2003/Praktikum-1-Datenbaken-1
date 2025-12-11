-- *** AUFGABE 2: SQL-ANFRAGEN 1 bis 5 ***

-- 1. Finden Sie alle Studenten (MatrNr ausgeben), die die Vorlesung Ethik hören.
SELECT s.MatrNr
FROM Studenten s
JOIN hoeren h ON s.MatrNr = h.MatrNr
JOIN Vorlesungen v ON h.VorlNr = v.VorlNr 
WHERE v.Titel = 'Ethik';

-- kürzere und vermutlich schnellere alternative zu 1:
SELECT matrnr 
FROM hoeren 
JOIN vorlesungen ON vorlesungen.vorlnr = hoeren.vorlnr 
WHERE vorlesungen.titel = 'Ethik';

-- 2. Welche Studenten haben schon mal mit 'Schopenhauer' gemeinsam eine Vorlesung gehört?
SELECT DISTINCT s.Name
FROM Studenten s
JOIN hoeren h ON s.MatrNr = h.MatrNr
WHERE h.VorlNr IN (
-- Unterabfragen:
	SELECT h2.VorlNr
	From hoeren h2
	JOIN Studenten s2 ON h2.MatrNr = s2.MatrNr
	WHERE s2.Name = 'Schopenhauer'
)
AND s.Name <> 'Schopenhauer'; -- Schopenhauer soll aus dem ergebnis ausgeschlossen werden

-- 3. Welche Studenten hören ALLE Vorlesungen, die Schopenhauer hört?
SELECT s.Name
FROM Studenten s
WHERE NOT EXISTS (
-- Suche eine Vorlesung, die Schopenhauer hört
SELECT h_scho.VorlNr
FROM hoeren h_scho 
JOIN Studenten s_scho ON h_scho.MatrNr = s_scho.MatrNr
WHERE s_scho.Name = 'Schopenhauer'
-- und welche studenten die gleiche Vorlesung wie Schopenhauer hört
AND NOT EXISTS (
	SELECT h. VorlNr
	FROM hoeren h
	WHERE h.MatrNr = s.MatrNr
	AND h.VorlNr = h_scho.VorlNr
)
);

-- 4. Welche Vorlesungen (VorlNr) haben mindestens zwei andere Vorlesungen als Voraussetzung?
SELECT Nachfolger AS VorlNr
FROM voraussetzen
GROUP BY Nachfolger HAVING COUNT(*) >= 2;

-- 5. Liste aller Vorlesungen und Anzahl der Prüfungen (absteigend sortiert)
SELECT v.VorlNr, v.Titel, COUNT(p.MatrNr) AS Anzahl_Pruefungen
FROM Vorlesungen v
LEFT JOIN pruefen p ON v.VorlNr = p.VorlNr
GROUP BY v.VorlNr, v.Titel
ORDER BY Anzahl_Pruefungen DESC;


-- 6. Finden Sie den/die Professor(en) (Name ausgeben) mit den meisten Assistenten.

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

-- 7. Welche Studierenden hören alle Vorlesungen?

SELECT studenten.name,studenten.matrnr
FROM studenten 
JOIN hoeren ON hoeren.matrnr=studenten.matrnr -- Join um den studenten mit seinen gehörten Vorlesungen zu verknüpfen. Ist nur für den Namen notwendig.
GROUP BY studenten.name,studenten.matrnr

HAVING count(*) = (  -- Anzahl aller Vorlesungen vergleichen mit der Anzahl der Vorlesungen, welche vom jeweiligen Studenten gehört werden
	SELECT count(*)  -- Anzahl der Vorlesungen zählen
	FROM vorlesungen
);

-- 8. Wie oft wurde eine Prüfung mit der Note 1 oder 2 bewertet?

SELECT count(*) FROM pruefen WHERE note <=2 AND note >=1; -- Kommentare nötig?

-- 9. Erstellen Sie eine Übersicht, in der die MatrNr und der Name der Studierenden zusammen mit der
-- von ihnen erreichten Durchschnittsnote sowie dem dazugehörigen Varianz-Wert angeben werden.

SELECT name,inf.matrnr,inf.avg,inf.var --endgültiger select 

FROM (
	SELECT matrnr, AVG(note), (MAX(note)-MIN(note)) as var -- Alle Werte erfassen
	FROM pruefen 
	GROUP BY matrnr -- auf studis gruppieren
) as inf -- benennen zur identifizierung

JOIN studenten ON studenten.matrnr=inf.matrnr; -- Join um die matrikelnummern mit Namen zu versehen

-- 10. Gibt es Namen von Personen, die in mindestens zwei verschiedenen Tabellen auftreten?

SELECT 
CASE 
	WHEN EXISTS (      -- Falls welche gefunden wird 1, sonst 0 zurückgegeben, gleicht TRUE / FALSE
		SELECT a.name, p.name, s.name 
		FROM assistenten as a,professoren as p,studenten as s                   -- Hier werden namen rausgesucht
		WHERE a.name = p.name OR a.name = s.name OR p.name = s.name
	) 
	THEN 1
	ELSE 0
END


-- 11. Erstellen Sie eine Übersicht, welche Vorlesung (VorlNr genügt) welche anderen Vorlesungen direkt
-- oder indirekt als Voraussetzung hat

SELECT * FROM 

(
SELECT DISTINCT v1.vorgaenger,v2.nachfolger as zielmodul 
FROM voraussetzen as v1                                            -- Alle indirekten Vorgänger
RIGHT JOIN voraussetzen as v2 ON v1.nachfolger=v2.vorgaenger 

UNION     -- Zusammenfassung beider

SELECT DISTINCT v2.vorgaenger,v2.nachfolger as zielmodul 
FROM voraussetzen as v1                                            -- Alle direkten Vorgänger
RIGHT JOIN voraussetzen as v2 ON v1.nachfolger=v2.vorgaenger
)

WHERE vorgaenger IS NOT NULL  -- Null ausfiltern
ORDER BY zielmodul -- Sortieren (deutlich bessere übersicht)

-- Indirekt nur bis zur zweiten Ebene, wahrscheinlich rekursive Lösung geforderdert?