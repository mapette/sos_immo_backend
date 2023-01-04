-- entreprises presta
INSERT INTO `presta` (`presta_nom`,  `presta_libelle`)
 VALUES
	('Eclair','électricité'),
	("Soul'eau",'plomberie'),
	('touver','jardinage'),
	('Toupropre','ménage et entretien'),
	('Vertigo','ascenceurs');

-- utilisateurs internes
INSERT INTO `utilisateurs` ( `ut_uuid`, `ut_id`,  `ut_nom`,  `ut_prenom`,  `ut_tel`,  `ut_mail`, `ut_mdp`)
 VALUES
	('e13efdf7-6512-4641-8857-af929205da61','lsala','salander','lysbeth', 0123456789, 'ls@sg.com', '120b51604eb96584e7eea87d5d2b82baa0cb54ba'),
	('cba7c9b1-f0fe-4373-adf5-25201601ae76','sjoffre','Joffre','Sophie', 0123456789, 'sj@sg.com', 'b7d460e23133cc432953941a31f9b3bd7ee99b2f');

-- utilisateurs presta
INSERT INTO `utilisateurs` ( `ut_uuid`, `ut_id`,  `ut_nom`,  `ut_prenom`,  `ut_presta`, `ut_tel`,  `ut_mail`,  `ut_mdp`)
 VALUES
	('27bc82c-f294-4908-8ba3-d99ff3e260f7','blaurent','Laurent','Bod', 1, 0123456789,'bl@presta.com', '29cadbe82ff701f788785ff51311c424036cf9f6'),
    ('c7f1d496-a72d-44a3-90cf-ebb4128bd0b4','hwilliam','william','henry', 1, 012399999,'wh@presta.com', '73a9a84ffa2adc1543d8b1e57fefb5550507deda');

-- habilitations
INSERT INTO `habilitations` ( `hab_uuid`, `hab_ut`,  `hab_profil`)
 VALUES
	('0eb89d14-83c0-436c-a509-b4bc6c72da89','e13efdf7-6512-4641-8857-af929205da61', 1),
	('2a0edddb-ba6e-4366-af2c-9682b9ff6b19','cba7c9b1-f0fe-4373-adf5-25201601ae76', 4),
	('50bd2a84-121e-42af-886d-81023e4400aa','27bc82c-f294-4908-8ba3-d99ff3e260f7', 2),
    ('6d3e5d4b-7d97-406f-82d7-c545891182ba','c7f1d496-a72d-44a3-90cf-ebb4128bd0b4', 3);

-- type d'incident
INSERT INTO `types_inc` (`tinc_nom`,  `tinc_presta`)
 VALUES
	('remplacement éclairage',1),
	('fuite de robinet',2),
	('WC bouchés',2),
	('distributeur de savon/bouché',4),
	('papier toilette à réapprivisionnr',4),
	('poubelle à vider',4),
	('sol à nettoyer',4),
	('store bloqué',1),
	('vitres à nettoyer',4),
	('autres (espaces verts)',3),
	('autres',4),
	('porte ascenceur bloquée',5),
	('porte bloquée',4);

-- type d'emplacements
INSERT INTO `types_emp` (`temp_nom`)
 VALUES
	('open space'),
	('dégagements'),
	('ascenceurs'),
	('toilettes'),
	('salle de réunions'),
	('escaliers'),
	('espaces verts'),
	('parking'),
	('local technique'),
	('vestiaire');	

-- emplacements, salles, lieux succeptible de faire l'objet d'un signalement 

INSERT INTO emplacements (emp_etage, emp_nom, emp_temp)
VALUES ('0','pallier escaliers',2),
 ('1','salle de réunions',5),
 ('1','pallier escaliers',2),
 ('0','couloir est',2),
 ('0','bureau 1',1);
 
-- mapping types d'incidents/types d'emplacements
INSERT INTO `mapping_inc_emp` ( `mapping_temp`,  `mapping_tinc`)
 VALUES
	(1,1),
    (6,1),
    (7,1),
    (8,1),
	(1,2),
    (7,2),
	(1,5),
    (6,5),
    (7,5),
    (8,5);	











---------- chantiers



-- emplacements, salles, lieux succeptible de faire l'objet d'un signalement 

INSERT INTO emplacements ( emp_etage,  emp_nom, emp_temp)
VALUES (-1,'parkings',0),
 (-2,'parkings',0),
 (0,'grand massif central',0),
 (0,'couloir est',0),
 (0,'bureau 1',0),
 (0,'bureau 2',0),
 (0,'toilettes',0),
 (1,'couloir ouest',0),
 (1,'bureau 1',0),
 (1,'bureau 2',0),
 (1,'toilettes',0),
 (1,'réunions 1',0),
 (0,'vestaires presta',0),
 (2,'local technique',0),
 (0,'Hall d''accueil',0),
 (0,'pallier ascenceurs',0),
 (0,'ascenceurs',0),
 (0,'pallier escaliers',0),
 (1,'réunions',0),
 (1,'pallier ascenceurs',0),
 (1,'ascenceurs',0),
 (1,'pallier escaliers',0),
 (2,'couloir',0),
 (2,'bureau 1',0),
 (2,'bureau 2',0),
 (-1,'vestaires motards',0),
 (2,'toilettes',0),
 (2,'réunions',0),
 (2,'ascenceurs',0),
 (2,'pallier ascenceurs',0),
 (2,'pallier escaliers',0),
 (-1,'pallier escaliers',0),
 (-2,'pallier ascenceurs',0),
 (-1,'ascenceurs',0),
 (-2,'vestaires presta',0),



