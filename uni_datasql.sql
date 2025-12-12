BEGIN; -- Start der Transaktion ; DB merkt sich alles bis zum COMMIT und führt dann alles als eine Transaktion aus

INSERT INTO Studenten(MatrNr, Name, Semester) 
VALUES (24002, 'Xenokrates', 18); 
 
INSERT INTO Studenten(MatrNr, Name, Semester) 
VALUES (25403, 'Jonas', 12); 
 
INSERT INTO Studenten(MatrNr, Name, Semester) 
VALUES (26120, 'Fichte', 10); 

INSERT INTO Studenten(MatrNr, Name, Semester) 
VALUES (26830, 'Aristoxenos', 8); 
 
INSERT INTO Studenten(MatrNr, Name, Semester) 
VALUES (27550, 'Schopenhauer', 6); 

INSERT INTO Studenten(MatrNr, Name, Semester) 
VALUES (28106, 'Carnap', 3); 
 
INSERT INTO Studenten(MatrNr, Name, Semester) 
VALUES (29120, 'Theophrastos', 2); 
 
INSERT INTO Studenten(MatrNr, Name, Semester) 
VALUES (29555, 'Feuerbach', 2); 
 


INSERT INTO Professoren(PersNr, Name, Raum) 
VALUES (2125, 'Sokrates', 226); 

INSERT INTO Professoren(PersNr, Name, Raum) 
VALUES (2126, 'Russel', 232);  
 
INSERT INTO Professoren(PersNr, Name, Raum) 
VALUES (2127, 'Kopernikus', 310); 
 
INSERT INTO Professoren(PersNr, Name, Raum) 
VALUES (2133, 'Popper', 052); 
 
INSERT INTO Professoren(PersNr, Name, Raum) 
VALUES (2134, 'Augustinus', 309); 
 
INSERT INTO Professoren(PersNr, Name, Raum) 
VALUES (2136, 'Curie', 036); 
 
INSERT INTO Professoren(PersNr, Name, Raum) 
VALUES (2137, 'Kant', 007); 
 
 
 
INSERT INTO Assistenten(PersNr, Name, Fachgebiet, Boss) 
VALUES (3002, 'Platon', 'Ideenlehre', 2125); 
 
INSERT INTO Assistenten(PersNr, Name, Fachgebiet, Boss) 
VALUES (3003, 'Aristoteles', 'Syllogistik', 2125); 
 
INSERT INTO Assistenten(PersNr, Name, Fachgebiet, Boss) 
VALUES (3004, 'Wittgenstein', 'Sprachtheorie', 2126); 
 
INSERT INTO Assistenten(PersNr, Name, Fachgebiet, Boss) 
VALUES (3005, 'Rhetikus', 'Planetenbewegung', 2127); 
 
INSERT INTO Assistenten(PersNr, Name, Fachgebiet, Boss) 
VALUES (3006, 'Newton', 'Keplersche Gesetze', 2127); 
 
INSERT INTO Assistenten(PersNr, Name, Fachgebiet, Boss) 
VALUES (3007, 'Spinoza', 'Gott und Natur', 2134); 


 
INSERT INTO Vorlesungen(VorlNr, Titel, SWS, gelesenVon) 
VALUES (5001, 'Grundzuege', 4, 2137);

INSERT INTO Vorlesungen(VorlNr, Titel, SWS, gelesenVon) 
VALUES (5041, 'Ethik', 4, 2125);
 
INSERT INTO Vorlesungen(VorlNr, Titel, SWS, gelesenVon) 
VALUES (5043, 'Erkenntnistheorie', 3, 2126);
 
INSERT INTO Vorlesungen(VorlNr, Titel, SWS, gelesenVon) 
VALUES (5049, 'Maeeutik', 2, 2125);
 
INSERT INTO Vorlesungen(VorlNr, Titel, SWS, gelesenVon) 
VALUES (4052, 'Logik', 4, 2125);
 
INSERT INTO Vorlesungen(VorlNr, Titel, SWS, gelesenVon) 
VALUES (5052, 'Wissenschaftstheorie', 3, 2126); 
 
INSERT INTO Vorlesungen(VorlNr, Titel, SWS, gelesenVon) 
VALUES (5216, 'Bioethik', 2, 2126); 
 
INSERT INTO Vorlesungen(VorlNr, Titel, SWS, gelesenVon) 
VALUES (5259, 'Der Wiener Kreis', 2, 2133); 
 
INSERT INTO Vorlesungen(VorlNr, Titel, SWS, gelesenVon) 
VALUES (5022, 'Glaube und Wissen', 2, 2134); 
 
INSERT INTO Vorlesungen(VorlNr, Titel, SWS, gelesenVon) 
VALUES (4630, 'Die 3 Kritiken', 4, 2137); 



-- Datensätze vervollständigen (Problem der Zirkulären Referenzen)
UPDATE Professoren SET VVorl = 5001 WHERE PersNr = 2125; -- Sokrates
UPDATE Professoren SET VVorl = 5041 WHERE PersNr = 2126; -- Russel
UPDATE Professoren SET VVorl = 5043 WHERE PersNr = 2127; -- Kopernikus
UPDATE Professoren SET VVorl = 5049 WHERE PersNr = 2133; -- Popper
UPDATE Professoren SET VVorl = 5052 WHERE PersNr = 2134; -- Augustinus
UPDATE Professoren SET VVorl = 5022 WHERE PersNr = 2136; -- Curie
UPDATE Professoren SET VVorl = 4630 WHERE PersNr = 2137; -- Kant


 
 
INSERT INTO hoeren(MatrNr, VorlNr) 
VALUES (26120, 5001); 
 
INSERT INTO hoeren(MatrNr, VorlNr) 
VALUES (27550, 5001); 
 
INSERT INTO hoeren(MatrNr, VorlNr) 
VALUES (27550, 4052); 
 
INSERT INTO hoeren(MatrNr, VorlNr) 
VALUES (28106, 5041); 
 
INSERT INTO hoeren(MatrNr, VorlNr) 
VALUES (28106, 5052); 
 
INSERT INTO hoeren(MatrNr, VorlNr) 
VALUES (28106, 5216); 
 
INSERT INTO hoeren(MatrNr, VorlNr) 
VALUES (28106, 5259); 
 
INSERT INTO hoeren(MatrNr, VorlNr) 
VALUES (29120, 5001); 

INSERT INTO hoeren(MatrNr, VorlNr) 
VALUES (29120, 5041); 

INSERT INTO hoeren(MatrNr, VorlNr) 
VALUES (29120, 5049); 

INSERT INTO hoeren(MatrNr, VorlNr) 
VALUES (29555, 5022); 

INSERT INTO hoeren(MatrNr, VorlNr) 
VALUES (25403, 5022);  
 
INSERT INTO hoeren(MatrNr, VorlNr) 
VALUES (29555, 5001);  
 
 
 
INSERT INTO voraussetzen(Vorgaenger, Nachfolger) 
VALUES (5001, 5041); 
 
INSERT INTO voraussetzen(Vorgaenger, Nachfolger) 
VALUES (5001, 5043); 
 
INSERT INTO voraussetzen(Vorgaenger, Nachfolger) 
VALUES (5001, 5049); 
 
INSERT INTO voraussetzen(Vorgaenger, Nachfolger) 
VALUES (5041, 5216);  

INSERT INTO voraussetzen(Vorgaenger, Nachfolger) 
VALUES (5043, 5052);  

INSERT INTO voraussetzen(Vorgaenger, Nachfolger) 
VALUES (5041, 5052); 
 
INSERT INTO voraussetzen(Vorgaenger, Nachfolger) 
VALUES (5052, 5259); 
 


INSERT INTO pruefen(MatrNr, VorlNr, PersNr, Note) 
VALUES (28106, 5001, 2126, 1.0);

INSERT INTO pruefen(MatrNr, VorlNr, PersNr, Note) 
VALUES (25403, 5041, 2125, 2.0);

INSERT INTO pruefen(MatrNr, VorlNr, PersNr, Note) 
VALUES (27550, 4630, 2137, 2.0);

COMMIT -- Ende der Transaktion ; Die Befehle zwischen BEGIN und COMMIT werden zwischengespeichert und als eine Transaktion in der Datenbank ausgeführt