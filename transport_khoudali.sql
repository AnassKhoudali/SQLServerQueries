
use Transport_khoudali;


CREATE TABLE typeCamion(
ID_typeCamion INT NOT NULL PRIMARY KEY,
Marque NVARCHAR(50),
PoidsMax INT DEFAULT 0 NOT NULL  CHECK (poidsmax >= 0),
VolumeMax INT DEFAULT 0 NOT NULL  CHECK (VolumeMax >= 0)
);

CREATE TABLE Camion(
ID_Camion INT NOT NULL PRIMARY KEY,
DateMiseEnCirculation DATE NOT NULL,
MTRICULE NVARCHAR(50) NOT NULL,
ID_typeCamion INT NOT NULL,
FOREIGN KEY(ID_typeCamion)  REFERENCES typeCamion
);

CREATE TABLE Ville(
ID_Ville INT NOT NULL PRIMARY KEY,
NomVille NVARCHAR(50),
);

CREATE TABLE Conducteur(
ID_Conducteur INT NOT NULL PRIMARY KEY,
Nom NVARCHAR(50) NOT NULL,
Prenom NVARCHAR(50) NOT NULL,
Age INT, 
ID_Ville INT,
FOREIGN KEY(ID_Ville)  REFERENCES Ville
);

CREATE TABLE Livraison(
ID_Livraison INT NOT NULL PRIMARY KEY,
DateLivraison DATE,
ID_Ville INT,
ID_Conducteur INT,
ID_Camion INT,
FOREIGN KEY(ID_Ville)  REFERENCES Ville,
FOREIGN KEY(ID_Camion)  REFERENCES Camion,
FOREIGN KEY(ID_Conducteur)  REFERENCES Conducteur
);

--Insertion des données
INSERT INTO typeCamion(ID_typeCamion, Marque, PoidsMax, VolumeMax)
values(1, 'Mercedes', 26000, 80);
INSERT INTO typeCamion(ID_typeCamion, Marque, PoidsMax, VolumeMax)
values(2, 'Scania', 25000, 90);
INSERT INTO typeCamion(ID_typeCamion, Marque, PoidsMax, VolumeMax)
values(3, 'Volvo', 21000, 100);
INSERT INTO typeCamion(ID_typeCamion, Marque, PoidsMax, VolumeMax)
values(4, 'DAF', 25000, 80);
INSERT INTO typeCamion(ID_typeCamion, Marque, PoidsMax, VolumeMax)
values(5, 'Man', 28000, 90);

-- camion 
INSERT INTO Camion(ID_Camion, DateMiseEnCirculation, ID_typeCamion, MTRICULE)
values(1, '2020-01-01', 1, 'CK09');
INSERT INTO Camion(ID_Camion, DateMiseEnCirculation, ID_typeCamion, MTRICULE)
values(2, '2021-01-02', 1, 'CK20');
INSERT INTO Camion(ID_Camion, DateMiseEnCirculation, ID_typeCamion, MTRICULE)
values(3, '2020-11-03', 2, 'CK60');
INSERT INTO Camion(ID_Camion, DateMiseEnCirculation, ID_typeCamion, MTRICULE)
values(4, '2020-07-04', 3, 'CK25');
INSERT INTO Camion(ID_Camion, DateMiseEnCirculation, ID_typeCamion, MTRICULE)
values(5, '2021-09-05', 4, 'CK13');

--ville
INSERT INTO Ville(ID_Ville, NomVille)
values(1, 'Ottawa');
INSERT INTO Ville(ID_Ville, NomVille)
values(2, 'Tronto');
INSERT INTO Ville(ID_Ville, NomVille)
values(3, 'Montréal');
INSERT INTO Ville(ID_Ville, NomVille)
values(4, 'Québec');
INSERT INTO Ville(ID_Ville, NomVille)
values(5, 'Vancouver');

--conducteur
INSERT INTO Conducteur(ID_conducteur, Nom, Prenom, Age, ID_Ville)
values(1, 'Alexi', 'Borno', 45, 1);
INSERT INTO Conducteur(ID_conducteur, Nom, Prenom, Age, ID_Ville)
values(2, 'Fred', 'Mexi', 50, 2);
INSERT INTO Conducteur(ID_conducteur, Nom, Prenom, Age, ID_Ville)
values(3, 'Ali', 'Darki', 35, 4);
INSERT INTO Conducteur(ID_conducteur, Nom, Prenom, Age, ID_Ville)
values(4, 'Sophie', 'Bernard', 30, 5);
INSERT INTO Conducteur(ID_conducteur, Nom, Prenom, Age, ID_Ville)
values(5, 'Slim', 'Weld haj', 40, 5);

--livraison
INSERT INTO livraison(ID_livraison, DateLivraison, ID_Ville, ID_Conducteur, ID_Camion)
values(1, '2022-02-10', 1, 1, 1);
INSERT INTO livraison(ID_livraison, DateLivraison, ID_Ville, ID_Conducteur, ID_Camion)
values(2, '2022-02-11', 2, 3, 2);
INSERT INTO livraison(ID_livraison, DateLivraison, ID_Ville, ID_Conducteur, ID_Camion)
values(3, '2022-02-12', 3, 4, 3);
INSERT INTO livraison(ID_livraison, DateLivraison, ID_Ville, ID_Conducteur, ID_Camion)
values(4, '2022-02-13', 4, 5, 3);
INSERT INTO livraison(ID_livraison, DateLivraison, ID_Ville, ID_Conducteur, ID_Camion)
values(5, '2021-02-14', 4, 1, 5);
INSERT INTO livraison(ID_livraison, DateLivraison, ID_Ville, ID_Conducteur, ID_Camion)
values(6, '2021-03-14', 5, 2, 1);
INSERT INTO livraison(ID_livraison, DateLivraison, ID_Ville, ID_Conducteur, ID_Camion)
values(7, '2021-05-14', 5, 1, 2);
INSERT INTO livraison(ID_livraison, DateLivraison, ID_Ville, ID_Conducteur, ID_Camion)
values(8, '2021-09-14', 2, 5, 4);
INSERT INTO livraison(ID_livraison, DateLivraison, ID_Ville, ID_Conducteur, ID_Camion)
values(9, '2021-11-14', 2, 2, 5);
INSERT INTO livraison(ID_livraison, DateLivraison, ID_Ville, ID_Conducteur, ID_Camion)
values(10, '2021-12-14', 1, 3, 2);

-- Requêtes

-- 1
SELECT * 
FROM Camion
WHERE DateMiseEnCirculation > '2021-01-01';

-- 2
SELECT * 
FROM Livraison
WHERE ID_Camion = 5;

-- 3
SELECT c.nom, c.prenom, c.age, c.id_ville
FROM Conducteur c
inner join ville on c.ID_Ville = Ville.ID_Ville
where ville.NomVille = 'Vancouver';

-- 4
SELECT* 
FROM conducteur
Where ID_Conducteur in (
SELECT ID_Conducteur
FROM Livraison
);

--5
SELECT l.*, cr.nom, cn.datemiseEnCirculation, tc.marque
FROM typeCamion tc
inner join camion cn on tc.ID_typeCamion = cn.ID_typeCamion
inner join Livraison l on cn.id_camion = l.ID_Camion
inner join Conducteur cr on cr.ID_Conducteur = l.ID_Conducteur;

-- 6
SELECT Ville.NomVille, (count(Livraison.ID_Ville)) as 'Nombre de livraisons effectuées'
FROM Livraison
INNER JOIN Ville on Ville.ID_Ville = Livraison.ID_Ville
GROUP BY NomVille;

-- 8
SELECT Conducteur.Nom, (count(Livraison.ID_Conducteur)) as 'Nombre de livraisons effectuées'
FROM Livraison
INNER JOIN Conducteur on Conducteur.ID_Conducteur = Livraison.ID_Conducteur
GROUP BY Conducteur.Nom;

-- 9
SELECT *
FROM Camion
where Mtricule like '%0';

--10 
SELECT  Camion.*, tc.Marque, tc.Poidsmax
FROM Camion
INNER JOIN typeCamion tc on tc.ID_typeCamion = Camion.ID_typeCamion
WHERE tc.PoidsMax > 25000;

--11
SELECT l.*, v.nomville
FROM Livraison l 
INNER JOIN Ville v on v.ID_Ville = l.ID_Ville
WHERE v.NomVille = 'Québec';

--12
SELECT l.*, c.nom
FROM Livraison l 
INNER JOIN Conducteur c on c.ID_Conducteur = l.ID_Conducteur
WHERE c.Nom = 'Slim';

--13
SELECT cr.Nom, cr.Prenom, cr.Age
FROM Conducteur cr 
INNER JOIN Livraison l on cr.ID_Conducteur = l.ID_Conducteur
INNER JOIN Camion cn on cn.ID_Camion = l.ID_Camion
INNER JOIN typeCamion tc on tc.ID_typeCamion = cn.ID_typeCamion
WHERE tc.Marque = 'Mercedes';