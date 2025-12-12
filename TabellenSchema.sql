-- *** AUFGABE 1: DDL - ERSTELLEN DES TABELLENSCHEMAS von Belkiz Güldür ***

-- Tabelle: Professoren
-- Erklärung: Die Spalte VVorl verweist eigentlich auf die Vorlesungstabelle.
-- Ich habe hier bewusst das 'NOT NULL' weggelassen. 
-- Grund: Da Vorlesungen auch Professoren brauchen (Zirkelbezug), lege ich erst die Professoren ...
-- ...ohne Vorlesung an und trage die Spalte mit Verknüpfung später einfach mit einem ALTER TABLE nach (in der Tabellenstruktur).
-- ...ohne Vorlesung an und trage die Spalte mit Verknüpfung später einfach mit einem UPDATE nach (beim Füllen der Tabellen mittels INSERT INTO und UPDATE).
CREATE TABLE Professoren (
	PersNr INTEGER PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	Raum VARCHAR(20)--,
	--VVorl INTEGER REFERENCES Vorlesungen(VorlNr)   -- Wird mittels ALTER TABLE nachträglich ergänzt
);

-- Tabelle: Vorlesungen
-- Erklärung: 'gelesenVon' ist der Fremdschlüssel zum Professor.
-- Mit CHECK (SWS > 0) stelle ich sicher, dass keine negativen Semesterwochenstunden eingetragen werden können.
CREATE TABLE Vorlesungen (
	VorlNr INTEGER PRIMARY KEY,
	Titel VARCHAR(255) NOT NULL,
	SWS INTEGER CHECK (SWS > 0),
	gelesenVon INTEGER NOT NULL REFERENCES Professoren(PersNr)
);

-- Tabelle Professoren anpassen/vervollständigen
-- Spalte VVorl anlegen, die eine Spalte von Vorlesungen referenziert
ALTER TABLE Professoren ADD VVorl INTEGER REFERENCES Vorlesungen(VorlNr);


-- Tabelle: Studenten
-- Erklärung: Ich habe als Standardwert (DEFAULT) für das Semester die 1 gesetzt, weil neue Studenten meistens im ersten Semester starten.
-- Der CHECK verhindert auch hier, dass negative Semesterzahlen eingegeben werden.
CREATE TABLE Studenten (
	MatrNr INTEGER PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	Semester INTEGER DEFAULT 1 CHECK (Semester > 0)
);

-- Tabelle: Assistenten
-- Erklärung: Jeder Assistent braucht einen Boss, das muss zwingend ein Professor sein (Fremdschlüssel).
CREATE TABLE Assistenten (
	PersNr INTEGER PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	Fachgebiet VARCHAR(255),
	Boss INTEGER REFERENCES Professoren(PersNr)
);

-- Tabelle: hoeren
-- Erklärung: Das ist die Verknüpfungstabelle zwischen Studenten und Vorlesungen.
-- ON DELETE CASCADE habe ich eingebaut, damit der Eintrag hier automatisch mitgelöscht wird, 
-- wenn der Student oder die Vorlesung gelöscht wird. So entstehen keine Datenleichen.
CREATE TABLE hoeren (
	MatrNr INTEGER REFERENCES Studenten(MatrNr) ON DELETE CASCADE,
	VorlNr INTEGER REFERENCES Vorlesungen(VorlNr) ON DELETE CASCADE,
	PRIMARY KEY (MatrNr, VorlNr)
);

-- Tabelle: voraussetzen
-- Erklärung: Hier wird gespeichert, welche Vorlesung (Vorgänger) für eine andere (Nachfolger) nötig ist.
-- Beide Spalten verweisen logischerweise auf die Vorlesungstabelle.
CREATE TABLE voraussetzen (
	Vorgaenger INTEGER REFERENCES Vorlesungen(VorlNr),
	Nachfolger INTEGER REFERENCES Vorlesungen(VorlNr),
	PRIMARY KEY (Vorgaenger, Nachfolger)
);

-- Tabelle: pruefen
-- Erklärung: Hier werden die Noten gespeichert.
-- Ich nutze DECIMAL(3,1), damit Noten wie 1.3 oder 5.0 reinpassen (insgesamt 3 Stellen, davon 1 Nachkomma).
-- Mit dem CHECK sorge ich dafür, dass die Noten im gültigen Bereich zwischen 1.0 und 5.0 liegen.
CREATE TABLE pruefen (
	MatrNr INTEGER REFERENCES Studenten(MatrNr),
	VorlNr INTEGER REFERENCES Vorlesungen(VorlNr),
	PersNr INTEGER REFERENCES Professoren(PersNr),
	Note DECIMAL(3,1) CHECK (Note BETWEEN 1.0 AND 5.0),
	PRIMARY KEY (MatrNr, VorlNr)
);