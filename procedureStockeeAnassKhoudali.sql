create PROCEDURE createall
AS
BEGIN

IF OBJECT_ID(N'dbo.type_utilisateur', N'U') IS NULL BEGIN  
CREATE TABLE type_utilisateur (
    id_type_utilisateur INT,
    nom VARCHAR(20),
    PRIMARY KEY (id_type_utilisateur)
);
END;

IF OBJECT_ID(N'dbo.etat_commande', N'U') IS NULL BEGIN  
CREATE TABLE etat_commande (
    id_etat_commande  INT,
    nom VARCHAR(15),
    PRIMARY KEY (id_etat_commande)
);
END;

IF OBJECT_ID(N'dbo.utilisateur', N'U') IS NULL BEGIN  
CREATE TABLE utilisateur (
    id_utilisateur INT,
    id_type_utilisateur INT,
    email VARCHAR(320),
    password VARCHAR(20),
    PRIMARY KEY (id_utilisateur)
);
ALTER TABLE utilisateur
ADD CONSTRAINT fk_id_type_utilisateur
FOREIGN KEY(id_type_utilisateur)
REFERENCES type_utilisateur(id_type_utilisateur);
END;

IF OBJECT_ID(N'dbo.commande', N'U') IS NULL BEGIN  
CREATE TABLE commande (
    id_commande INT,
    id_utilisateur INT,
    id_etat_commande INT,
    date DATE,
    PRIMARY KEY(id_commande)
);

ALTER TABLE commande
ADD CONSTRAINT fk_id_utilisateur
FOREIGN KEY(id_utilisateur)
REFERENCES utilisateur(id_utilisateur);

ALTER TABLE commande
ADD CONSTRAINT fk_id_etat_commande
FOREIGN KEY(id_etat_commande)
REFERENCES etat_commande(id_etat_commande);
END;

IF OBJECT_ID(N'dbo.categorie', N'U') IS NULL BEGIN  
CREATE TABLE categorie (
   id_categorie INT PRIMARY KEY,
   nom VARCHAR(50)
);
END;

IF OBJECT_ID(N'dbo.produit', N'U') IS NULL BEGIN  
CREATE TABLE produit (
   id_produit INT,
   qtestock INT,
   nom VARCHAR(30),
   prix INT,
   PRIMARY KEY (id_produit),
   id_categorie INT,
   FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie)
);
END;

IF OBJECT_ID(N'dbo.commande_produit', N'U') IS NULL BEGIN  
CREATE TABLE commande_produit (
    id_commande INT,
    id_produit INT,
    quantite INT,
    PRIMARY KEY (id_commande, id_produit)
);
ALTER TABLE commande_produit
ADD CONSTRAINT fk_id_commande
FOREIGN KEY(id_commande)
REFERENCES commande(id_commande);

ALTER TABLE commande_produit
ADD CONSTRAINT fk_id_produit
FOREIGN KEY(id_produit)
REFERENCES produit(id_produit);
END;



IF OBJECT_ID(N'dbo.avis', N'U') IS NULL BEGIN  
CREATE TABLE avis (
   id_utilisateur INT,
   id_produit INT,
   nombre_etoiles INT CHECK (nombre_etoiles between 1 and 5),
  PRiMARY KEY (id_utilisateur, id_produit),
  FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur),
  FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
);
END;

DECLARE @triggercode AS VARCHAR(max)

SET @triggercode='CREATE TRIGGER trigger_commande_produit
ON commande_produit
INSTEAD OF INSERT
AS

DECLARE @QTE AS INT
DECLARE @QTESTOCK AS INT
SET @QTE = (SELECT quantite from inserted)
SET @QTESTOCK = (SELECT qtestock FROM PRODUIT WHERE id_produit= (SELECT id_produit from inserted))

IF @QTE<=@QTESTOCK
	BEGIN

	INSERT INTO commande_produit 
	SELECT * FROM inserted

	UPDATE Produit
	SET qtestock=qtestock-@QTE
	WHERE id_produit=(SELECT id_produit from inserted)
	END
'
EXEC(@triggercode);

INSERT INTO type_utilisateur VALUES (1,'admin'),
									(2,'moderateur'),
									(3,'Client'),
									(4,'Gestionnaire');

INSERT INTO utilisateur VALUES (1,3,'user1@gmail.com','mdp1'),
								(2,3,'user2@gmail.com','mdp1'),
								(3,2,'mod@gmail.com','mdp1'),
								(4,1,'admin@gmail.com','mdp1'),
								(5,4,'gestion@gmail.com','mdp1');

INSERT INTO categorie VALUES (1,'Telephone'),
							 (2,'Laptop'),
					   		 (3,'TV'),
							 (4,'Ordinateur'),
							 (5,'Accessoire');

INSERT INTO produit VALUES (1,23,'Iphone 13',1200,1),
							 (2,34,'Television HP',599,3),
					   		 (3,12,'ASUS ROG',1399,2),
							 (4,5,'Lenevo computer',1199,4),
							 (5,9,'Ecouteurs Samsung',60,5);

INSERT INTO etat_commande VALUES (1,'en cours'),
								 (2,'livreé'),
								 (3,'annulé'),
								 (4,'bloqué'),
								 (5,'en attente');

INSERT INTO commande VALUES (1,1,1,'10-11-2021'),
							(2,2,1,'11-07-2021'),
							(3,2,2,'09-04-2021'),
							(4,1,2,'02-12-2021'),
							(5,3,3,'12-01-2021');

INSERT INTO commande_produit VALUES (1,2,11);
INSERT INTO commande_produit VALUES (2,5,2);
INSERT INTO commande_produit VALUES (1,3,1);
INSERT INTO commande_produit VALUES (3,4,4);
INSERT INTO commande_produit VALUES (4,1,7);

INSERT INTO avis VALUES (1,1,4),
						(1,4,1),
						(2,5,5),
						(3,4,2),
						(4,2,3);
							

END