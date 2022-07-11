
use boutique;

CREATE TABLE Client(
	IDCLIENT INT PRIMARY KEY,
	NOM VARCHAR(255) NOT NULL,
	PRENOM VARCHAR(255) NOT NULL,
	DATENAISSANCE DATE,
	VILLE VARCHAR(255) NOT NULL
);

CREATE TABLE Commande(
	IDCOMMANDE INT PRIMARY KEY,
	NOMAGENT VARCHAR(255) NOT NULL,
	DATECOMMANDE DATE,
	QUANTITE INT NOT NULL,
	PRIXUNITAIRE INT NOT NULL ,
	VILLECOMMANDE  VARCHAR(255) NOT NULL,
);

CREATE TABLE Livraison(
	IDLIVRAISON INT PRIMARY KEY,
	DATELIVRAISON DATE NOT NULL,
	VILLELIVRAISON  VARCHAR(255) NOT NULL,
);

CREATE TABLE Paiement(
	IDCLIENT INT,
	IDCOMMANDE INT,
	IDLIVRAISON INT,
	PRIXTOTAL INT,
	CONSTRAINT FK_L_V FOREIGN KEY (IDCLIENT) REFERENCES Client(IDCLIENT),
	CONSTRAINT FK_L_P FOREIGN KEY (IDCOMMANDE) REFERENCES Commande(IDCOMMANDE),
	CONSTRAINT FK_L_C FOREIGN KEY (IDLIVRAISON) REFERENCES Livraison(IDLIVRAISON)
);

INSERT INTO Client 
VALUES 
(1,'Pierre','Jef','1978-01-01','Ottawa'),
(2,'Champlain','Nickolas','1984-01-01','Gatineau'),
(3,'Martin','Jean','1985-02-01','Paris'),
(4,'Michel','Roux','1990-03-01','Montreal'),
(5,'Morel','David','2000-11-01','Madrid'),
(6,'Sophie','Dumont','2001-12-01','Ottawa'),
(7,'Marie','Leblanc','1998-04-01','Ottawa'),
(8,'Sally','Roussel','2001-05-01','Toronto');

INSERT INTO Commande 
VALUES 
(1,'Pierre','2022-03-01','3','100','Ottawa'),
(2,'Pierre','2022-02-01','4','150','Gatineau'),
(3,'Pierre','2022-01-01','2','120','Montreal'),
(4,'Pierre','2021-12-01','8','140','Toronto'),
(5,'Pierre','2022-03-14','2','160','Madrid'),
(6,'Pierre','2022-03-10','5','180','Paris'),
(7,'Pierre','2022-03-10','4','170','Ottawa'),
(8,'Pierre','2022-02-01','5','160','Ottawa'),
(9,'Pierre','2022-02-25','2','180','Ottawa');

INSERT INTO Livraison 
VALUES 
(1,'2022-03-01','Ottawa'),
(2,'2022-02-01','Gatineau'),
(3,'2022-01-01','Montreal'),
(4,'2021-12-01','Toronto'),
(5,'2022-03-14','Madrid'),
(6,'2022-03-10','Paris'),
(7,'2022-03-10','Ottawa'),
(8,'2022-02-01','Ottawa'),
(9,'2022-02-25','Ottawa'); 

INSERT INTO Paiement 
VALUES 
(1,1,1,0), 
(1,7,7,0), 
(6,8,8,0), 
(7,9,9,0), 
(2,2,2,0), 
(4,3,3,0), 
(3,6,6,0), 
(4,3,3,0), 
(8,4,4,0), 
(5,5,5,0);

-- Question 1
SELECT nom, prenom, datenaissance, ville
FROM Client
WHERE ville = 'Ottawa';

-- Question 2
SELECT nom, prenom, datenaissance, FLOOR(DATEDIFF(DAY, datenaissance, GETDATE() ) / 365) AS Age, ville
FROM Client
WHERE FLOOR(DATEDIFF(DAY, datenaissance, GETDATE() ) / 365) > 30;

-- Question 3
SELECT clt.idclient, cmd.idcommande, l.idlivraison, clt.ville 'ville du client', cmd.villecommande, l.villelivraison
FROM client clt
INNER JOIN commande cmd ON clt.VILLE = cmd.villecommande
INNER JOIN livraison L ON L.villelivraison = cmd.villecommande;

-- Question 3 methode vue dans le cours
SELECT clt.idclient, cmd.idcommande, l.idlivraison, clt.ville 'ville du client', cmd.villecommande, l.villelivraison
FROM client clt
FULL OUTER JOIN Paiement p on p.idclient = clt.idclient
FULL OUTER JOIN Commande cmd on p.idcommande = cmd.idcommande
FULL OUTER JOIN livraison l on p.idlivraison = l.idlivraison
WHERE clt.ville = cmd.villecommande AND clt.ville = l.villelivraison;

-- Question 4
SELECT clt.idclient, cmd.idcommande, l.idlivraison, clt.ville 'ville du client', cmd.villecommande, l.villelivraison
FROM client clt
INNER JOIN Paiement p on p.idclient = clt.idclient
INNER JOIN Commande cmd on p.idcommande = cmd.idcommande
INNER JOIN livraison l on p.idlivraison = l.idlivraison
WHERE clt.ville = cmd.villecommande AND clt.ville = l.villelivraison;


-- Question 5
SELECT YEAR(datecommande) AS 'Année', COUNT(*) AS 'Nombre des commandes'
FROM Commande
GROUP BY YEAR(datecommande);

-- Question 6
SELECT nomagent, SUM(quantite*prixunitaire) AS 'Chiffre affaires'
FROM commande 
GROUP BY nomagent;

-- Question 7
SELECT cmd.idcommande, clt.nom, clt.prenom, l.datelivraison, cmd.villecommande, cmd.nomagent, cmd.datecommande
FROM client clt
INNER JOIN Paiement p on p.idclient = clt.idclient
INNER JOIN Commande cmd on p.idcommande = cmd.idcommande
INNER JOIN livraison l on p.idlivraison = l.idlivraison
WHERE cmd.datecommande between '2022-03-01' and '2022-03-31';

-- Question 8
update commande 
set quantite += 2
where nomagent='Sophie';

-- Question 9
update Paiement 
set prixtotal =(
select (c.prixunitaire*c.quantite) AS 'prix total'
FROM Commande c
inner join Paiement p On p.idcommande = c.idcommande
);

-- Question 10
SELECT clt.ville, SUM(cmd.prixunitaire*cmd.quantite) AS 'chiffre d’affaires des client'
FROM client clt
INNER JOIN Paiement p on p.idclient = clt.idclient
INNER JOIN commande cmd on cmd.idcommande = p.idcommande
GROUP BY clt.ville;

-- Question 10 2eme solution
SELECT clt.ville, SUM(cmd.prixunitaire*cmd.quantite) AS 'chiffre d’affaires des client'
FROM commande cmd
INNER JOIN Paiement p on cmd.idcommande = p.idcommande
INNER JOIN client clt on p.idclient = clt.idclient
GROUP BY clt.ville;

-- Question 10 2eme solution
SELECT DISTINCT clt.ville, SUM(cmd.prixunitaire*cmd.quantite)
FROM client clt, Commande cmd
WHERE EXISTS (
SELECT SUM(cmd.prixunitaire*cmd.quantite)
FROM Commande cmd
inner join 
WHERE cmd.idcommande = Paiement.idcommande 
);






SELECT clt.ville, SUM(p.PRIXTOTAL) AS 'chiffre d’affaires des client'
FROM client clt
INNER JOIN Paiement p on clt.IDCLIENT = p.IDCLIENT
GROUP BY clt.ville;