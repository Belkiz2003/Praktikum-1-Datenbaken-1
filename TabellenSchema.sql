-- Tabellen aus dem Arbeitsblatt 
CREATE TABLE Professoren (
	PersNr INTEGER PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	Raum VARCHAR(20),
	VVorl INTEGER
);
CREATE TABLE Vorlesungen (
	VorlNr INTEGER PRIMARY KEY,
	Titel VARCHAR(255) NOT NULL,
	SWS INTEGER CHECK (SWS > 0),
	gelesenVon INTEGER NOT NULL REFERENCES Professoren(PersNr)
);

CREATE TABLE Studenten (
	MatrNr INTEGER PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	Semester INTEGER DEFAULT 1 CHECK (Semester > 0)
);

CREATE TABLE Assistenten (
	PersNr INTEGER PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	Fachgebiet VARCHAR(255),
	Boss INTEGER REFERENCES Professoren(PersNr)
);

CREATE TABLE hoeren (
	MatrNr INTEGER REFERENCES Studenten(MatrNr) ON DELETE CASCADE,
	VorlNr INTEGER REFERENCES Vorlesungen(VorlNr) ON DELETE CASCADE,
	PRIMARY KEY (MatrNr, VorlNr)
);

CREATE TABLE voraussetzen (
	Vorgaenger INTEGER REFERENCES Vorlesungen(VorlNr),
	Nachfolger INTEGER REFERENCES Vorlesungen(VorlNr),
	PRIMARY KEY (Vorgaenger, Nachfolger)
);

CREATE TABLE pruefen (
	MatrNr INTEGER REFERENCES Studenten(MatrNr),
	VorlNr INTEGER REFERENCES Vorlesungen(VorlNR),
	PersNr INTEGER REFERENCES Professoren(PersNr),
	Note DECIMAL(3,1) CHECK (Note BETWEEN 1.0 AND 5.0),
	PRIMARY KEY (MatrNr, VorlNr)
);

-- Zirkuläre Fremdschlüssel
ALTER TABLE Professoren
ADD CONSTRAINT fk_prof_vvorl
FOREIGN KEY (VVorl) REFERENCES Vorlesungen(VorlNr)
DEFERRABLE INITIALLY DEFERRED;
