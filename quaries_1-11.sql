-- *** AUFGABE 2: SQL-ANFRAGEN 1 bis 5 von Belkiz Güldür ***

-- 1. Finden Sie alle Studenten (MatrNr ausgeben), die die Vorlesung Ethik hören.
-- Erklärung: Mit einem JOIN verbinde ich die Studenten über die Tabelle hoeren mit den Vorlesungen.
-- Danach Filtere ich das Ergebnis auf den Titel Ethik um herauszufinden wer die Ethik Vorlesung Hört.
SELECT s.MatrNr
FROM Studenten s
JOIN hoeren h ON s.MatrNr = h.MatrNr
JOIN Vorlesungen v ON h.VorlNr = v.VorlNr 
WHERE v.Titel = 'Ethik';

-- kürzere und vermutlich schnellere alternative zu 1 von Tobias Handwerk
-- Erklärung: Hier spare ich mir den Join zur Studenten-Tabelle, da die MatrNr schon in der Tabelle 'hoeren' steht.
SELECT matrnr 
FROM hoeren 
JOIN vorlesungen ON vorlesungen.vorlnr = hoeren.vorlnr 
WHERE vorlesungen.titel = 'Ethik';

-- **1. -ERGEBNIS**
--		matrnr
--1		28106
--2		29120


-- 2. Welche Studenten haben schon mal mit 'Schopenhauer' gemeinsam eine Vorlesung gehört?
-- Erklärung: Die unterabfrage wird dazu genutzt um erstmal alle VorlesungsNr zu fiden die von Schopenhauer gehört werden.
-- Die Hauptabfrage filtert dann die Studenten die eine der Vorlesung hören.
-- DISTINCT verhindert das Studenten mehrfach in der Tabelle gelisted werden wenn sie mehrer vorlesungen mit Schopenhauer hören.
SELECT DISTINCT s.Name
FROM Studenten s
JOIN hoeren h ON s.MatrNr = h.MatrNr
WHERE h.VorlNr IN (
-- Unterabfragen: Liste aller Vorlesungen an denen Schopenhauer Teilnimmt.
	SELECT h2.VorlNr
	From hoeren h2
	JOIN Studenten s2 ON h2.MatrNr = s2.MatrNr
	WHERE s2.Name = 'Schopenhauer'
)
AND s.Name <> 'Schopenhauer'; -- Schopenhauer soll aus dem ergebnis ausgeschlossen werden

-- **2. -ERGEBNIS**
--		name
--	1	Theophrastos
--	2	Fichte
--	3	Feuerbach


-- 3. Welche Studenten hören ALLE Vorlesungen, die Schopenhauer hört?
-- Erklärung: Hier nutze ich eine doppelte Verneinung (NOT EXISTS in NOT EXISTS).
-- Ich suche quasi Studenten, bei denen es KEINE Vorlesung von Schopenhauer gibt, die sie NICHT hören.
-- Das ist die logische Umkehrung von "alle hören".
SELECT s.Name
FROM Studenten s
WHERE NOT EXISTS (
    -- Suche eine Vorlesung, die Schopenhauer hört...
    SELECT h_scho.VorlNr
    FROM hoeren h_scho 
    JOIN Studenten s_scho ON h_scho.MatrNr = s_scho.MatrNr
    WHERE s_scho.Name = 'Schopenhauer'
    -- ... und prüfe, ob der aktuelle Student diese NICHT hört.
    AND NOT EXISTS (
        SELECT h.VorlNr
        FROM hoeren h
        WHERE h.MatrNr = s.MatrNr
        AND h.VorlNr = h_scho.VorlNr
    )
);

-- **3. -ERGEBNIS**
--		name
--	1	Schopenhauer


-- 4. Welche Vorlesungen (VorlNr) haben mindestens zwei andere Vorlesungen als Voraussetzung?
-- Erklärung: Ich gruppiere die Tabelle 'voraussetzen' nach dem Nachfolger (also dem Modul, das Voraussetzungen hat).
-- Mit HAVING filtere ich dann nur die raus, bei denen der Zähler (Anzahl der Vorgänger) 2 oder größer ist.
SELECT Nachfolger AS VorlNr
FROM voraussetzen
GROUP BY Nachfolger 
HAVING COUNT(*) >= 2;

-- **4. -ERGEBNIS**
--		vorlnr
--	1	5052


-- 5. Liste aller Vorlesungen und Anzahl der Prüfungen (absteigend sortiert)
-- Erklärung: Ich habe hier einen LEFT JOIN benutzt. Ein normaler JOIN würde Vorlesungen ohne Prüfungen einfach weglassen.
-- Durch den LEFT JOIN sehe ich auch die Vorlesungen mit 0 Prüfungen in der Liste.
SELECT v.VorlNr, v.Titel, COUNT(p.MatrNr) AS Anzahl_Pruefungen
FROM Vorlesungen v
LEFT JOIN pruefen p ON v.VorlNr = p.VorlNr
GROUP BY v.VorlNr, v.Titel
ORDER BY Anzahl_Pruefungen DESC;

-- **5. -ERGEBNIS**
--		vorlnr	titel					anzahl_pruefungen
--	1	5001	Grundzuege				1
--	2	4630	Die 3 Kritiken			1
--	3	5041	Ethik					1
--	4	5043	Erkenntnistheorie		0
--	5	5216	Bioethik				0
--	6	5022	Glaube und Wissen		0
--	7	5049	Maeeutik				0
--	8	5052	Wissenschaftstheorie	0
--	9	5259	Der Wiener Kreis		0
--	10	4052	Logik					0



-- *** AUFGABE 2: SQL-ANFRAGEN 6 bis 11 von Tobias Handwerk ***

-- 6. Finden Sie den/die Professor(en) (Name ausgeben) mit den meisten Assistenten.
-- Erklärung: Ich gruppiere Professoren nach PersNr und Name und zähle ihre Assistenten.
-- Im HAVING-Teil vergleiche ich diese Anzahl mit dem Maximum, das ich in der Unterabfrage ermittele.
-- Wichtig: Ich gruppiere auch nach der ID, damit Professoren mit gleichem Namen nicht falsch zusammengefasst werden.
SELECT p.Name, COUNT(a.Boss) AS Anzahl_Assistenten
FROM Assistenten a
JOIN Professoren p ON p.PersNr = a.Boss
GROUP BY p.PersNr, p.Name 
HAVING COUNT(a.Boss) = (
    -- Unterabfrage: Findet die höchste Anzahl an Assistenten, die ein einzelner Prof hat.
	SELECT COUNT(*)
	FROM assistenten
	GROUP BY Boss 
    ORDER BY COUNT(*) DESC 
    LIMIT 1 
);

-- **6. -ERGEBNIS**
--		name		anzahl_assistenten
--	1	Sokrates	2
--	2	Kopernikus	2


-- 7. Welche Studierenden hören alle Vorlesungen?

-- Vorbereitung (Daten erweitern):
-- Erklärung: Da in den Standard-Daten niemand alle Vorlesungen hört, füge ich hier eine "Muster-Studentin" (Hermione) ein.
-- Ich lasse sie automatisch alle existierenden Vorlesungen belegen, damit die Abfrage ein Ergebnis liefert.
INSERT INTO Studenten (MatrNr, Name, Semester) VALUES (10001, 'Hermione', 1);

INSERT INTO hoeren (MatrNr, VorlNr)
SELECT 10001, VorlNr FROM Vorlesungen; -- Trick: Ich kopiere alle Vorlesungs-IDs für Hermione in die Tabelle 'hoeren'.


-- Die eigentliche Abfrage:
-- Erklärung: Ich vergleiche hier zwei Zahlen miteinander:
-- Einmal zähle ich, wie viele Vorlesungen ein Student hört.
-- Das vergleiche ich mit der Gesamtzahl aller Vorlesungen aus der Vorlesungstabelle (Unterabfrage).
-- Wenn die Zahlen gleich sind, hört er/sie alles.
SELECT s.Name, s.MatrNr
FROM Studenten s
JOIN hoeren h ON h.MatrNr = s.MatrNr 
GROUP BY s.Name, s.MatrNr
HAVING COUNT(*) = ( 
	SELECT COUNT(*) FROM Vorlesungen
);

-- **7. -ERGEBNIS**
--		name	matrnr
--	1	Hermione	10001


-- Den Test-Datensatz lösche ich am Ende wieder (die Einträge in 'hoeren' verschwinden automatisch durch ON DELETE CASCADE).
DELETE FROM Studenten WHERE MatrNr = 10001;


-- 8. Wie oft wurde eine Prüfung mit der Note 1 oder 2 bewertet?
-- Erklärung: Hier nutze ich einen simplen Filter (WHERE), um nur die Noten 1.0 und 2.0 zu zählen.
SELECT COUNT(*) 
FROM pruefen 
WHERE Note = 1.0 OR Note = 2.0;

-- **8. -ERGEBNIS**
--		count
--	1	3


-- 9. Übersicht: MatrNr, Name, Durchschnittsnote und Varianz
-- Erklärung: Ich nutze AVG für den Durchschnitt. 
-- Für die Varianz nehme ich die Funktion VARIANCE.
-- Varianz = NULL da nur jeweils eine Prüfung geschrieben wurde.
-- ROUND und TRUNC benutze ich nur, damit die Zahlen schöner aussehen.
SELECT s.Name, s.MatrNr, 
       ROUND(AVG(p.Note), 2) AS Durchschnitt, 
       TRUNC(VARIANCE(p.Note), 2) AS Varianz
FROM Pruefen p
JOIN Studenten s ON s.MatrNr = p.MatrNr -- Join um den Namen der Studenten zu ermitteln
GROUP BY s.MatrNr, s.Name;

-- **9. -ERGEBNIS**
--		name			matrnr		durchschnitt	varianz
--	1	Carnap			28106		1.00			NULL
--	2	Jonas			25403		2.00			NULL
--	3	Schopenhauer	27550		2.00			NULL



-- 10. Gibt es Namen von Personen, die in mindestens zwei verschiedenen Tabellen auftreten?
-- Test werte: da es keine werte gibt die mehr als 1 mal auftauschen
INSERT INTO Studenten (MatrNr, Name, Semester) 
VALUES (99999, 'Sokrates', 1);

-- Erklärung: Ich nutze hier UNION ALL, um erstmal alle Namen aus Studenten, Assistenten und Profs in eine lange Liste zu werfen.
-- Dann gruppiere ich die Liste und lasse mir nur die Namen anzeigen, die öfter als 1 mal vorkommen (HAVING count > 1).
-- Das ist schneller und sauberer als alle Tabellen miteinander zu verknüpfen.
SELECT Name
FROM (
    SELECT Name FROM Studenten
    UNION ALL
    SELECT Name FROM Assistenten
    UNION ALL
    SELECT Name FROM Professoren
) AS AlleNamen
GROUP BY Name
HAVING COUNT(*) > 1;

-- **10. -ERGEBNIS**
--		name
--	1	Sokrates

-- Wichtig: Daten im nachinein löschen
DELETE FROM Studenten WHERE MatrNr = 99999;


-- 11. Welche Vorlesung hat welche andere als direkte oder indirekte Voraussetzung?
-- Erklärung: Ich mache einen Self-Join auf die Tabelle voraussetzen (v1 mit v2).
-- v1 zeigt den direkten Vorgänger, v2 zeigt den Vorgänger vom Vorgänger (also indirekt).
-- Hinweis: Diese Query liefert nur bis zur zweiten Ebene (Großvater -> Vater -> Kind).
-- Weitere Ebenen wären mit weiteren JOINs möglich
SELECT v1.Vorgaenger AS Vorlesung, 
       v1.Nachfolger AS Direkter_Nachfolger, 
       v2.Nachfolger AS Indirekter_Nachfolger
FROM voraussetzen v1
LEFT JOIN voraussetzen v2 ON v1.Nachfolger = v2.Vorgaenger
ORDER BY v1.Vorgaenger;

-- **11. -ERGEBNIS**
--		vorlesung		direkter_nachfolger		indirekter_nachfolger
--	1	5001			5041					5052
--	2	5001			5041					5216
--	3	5001			5043					5052
--	4	5001			5049					NULL
--	5	5041			5052					5259
--	6	5041			5216					NULL
--	7	5043			5052					5259
--	8	5052			5259					NULL
