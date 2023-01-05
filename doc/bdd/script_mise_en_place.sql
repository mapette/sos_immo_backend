--                         BASE SAUVEGARDE      ----------------------------------------- 	
CREATE SCHEMA IF NOT EXISTS sos_immo_sauv;
use sos_immo_sauv;

DROP TABLE IF EXISTS journaux;
DROP TABLE IF EXISTS journaux_arc;
DROP TABLE IF EXISTS incidents;
DROP TABLE IF EXISTS incidents_arc;
DROP TABLE IF EXISTS emplacements;
DROP TABLE IF EXISTS mapping_inc_emp;
DROP TABLE IF EXISTS types_emp;
DROP TABLE IF EXISTS types_inc;
DROP TABLE IF EXISTS habilitations;
DROP TABLE IF EXISTS habilitations_arc;
DROP TABLE IF EXISTS utilisateurs;
DROP TABLE IF EXISTS utilisateurs_arc;
DROP TABLE IF EXISTS presta;

CREATE TABLE `presta` (
   `presta_id` int NOT NULL AUTO_INCREMENT,
   `presta_nom` varchar(30) NOT NULL,
   `presta_libelle` varchar(50) NOT NULL,
   PRIMARY KEY (`presta_id`)
 ) 
COMMENT='prestataires sous contrat';

CREATE TABLE `utilisateurs` (
  `ut_uuid` varchar(36) NOT NULL,
  `ut_id` varchar(15) NOT NULL,
  `ut_nom` varchar(25) NOT NULL,
  `ut_prenom` varchar(25) NOT NULL, 
  `ut_presta` int DEFAULT NULL, 
  `ut_tel` varchar(20) DEFAULT NULL,
  `ut_mail` varchar(50) NOT NULL,
  `ut_date_deb` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  `ut_date_exp` datetime DEFAULT NULL,
  `ut_mdp` varchar(40) DEFAULT NULL, 
  `ut_mdp_exp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ut_uuid`),
  UNIQUE KEY `ut_id_UNIQUE` (`ut_id`), 
  UNIQUE KEY `ut_mail_UNIQUE` (`ut_mail`),
  KEY `fk_ut_presta_idx` (`ut_presta`), 
  CONSTRAINT `fk_ut_presta` FOREIGN KEY (`ut_presta`) REFERENCES `presta` (`presta_id`)
)
COMMENT='tous les utilisateurs (interne-presta)';

CREATE TABLE `habilitations` (
   `hab_uuid` varchar(36) NOT NULL,
   `hab_ut` varchar(36) NOT NULL,
   `hab_profil` int NOT NULL,
   `hab_date_deb` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `hab_date_exp` datetime DEFAULT NULL,
   PRIMARY KEY (`hab_uuid`),
   KEY `habilitations_ibfk_1` (`hab_ut`),
   CONSTRAINT `habilitations_ibfk_1` FOREIGN KEY (`hab_ut`) REFERENCES `utilisateurs` (`ut_uuid`)
 )
COMMENT='habilitations :  hab_niveau : 0-utilisateur inactivé, 1-usager, 2-technicien, 3-valideur, 4-imm';

CREATE TABLE `types_emp` (
   `temp_id` int NOT NULL AUTO_INCREMENT,
   `temp_nom` varchar(30) NOT NULL,
   PRIMARY KEY (`temp_id`)
 )
COMMENT='type d''emplacements';

CREATE TABLE `types_inc` (
   `tinc_id` int NOT NULL AUTO_INCREMENT,
   `tinc_nom` varchar(50) NOT NULL,
   `tinc_presta` int NOT NULL,
   PRIMARY KEY (`tinc_id`),
   KEY `presta_id` (`tinc_presta`),
   CONSTRAINT `presta_id` FOREIGN KEY (`tinc_presta`) REFERENCES `presta` (`presta_id`)
 )
COMMENT='Types d''incidents - prestataire en charge';

CREATE TABLE `mapping_inc_emp` (
   `mapping_id` int NOT NULL AUTO_INCREMENT,
   `mapping_tinc` int NOT NULL,
   `mapping_temp` int NOT NULL,
   PRIMARY KEY (`mapping_id`),
   KEY `fk_mapping_inc_idx` (`mapping_tinc`),
   KEY `mapping_inc_emp_ibfk_2` (`mapping_temp`),
   CONSTRAINT `mapping_inc_emp_ibfk_1` FOREIGN KEY (`mapping_tinc`) REFERENCES `types_inc` (`tinc_id`),
   CONSTRAINT `mapping_inc_emp_ibfk_2` FOREIGN KEY (`mapping_temp`) REFERENCES `types_emp` (`temp_id`)
 )
COMMENT='tous types d''incidents pouvant survenir dans tous types d''emplacement';

CREATE TABLE `emplacements` (
  `emp_id` INT NOT NULL AUTO_INCREMENT,
  `emp_etage` VARCHAR(10) NOT NULL,
  `emp_nom` VARCHAR(30) NOT NULL,
  `emp_temp` INT NOT NULL,
  PRIMARY KEY (`emp_id`),
FOREIGN KEY (`emp_temp`)
    REFERENCES `sos_immo`.`types_emp` (`temp_id`)  )
COMMENT = 'emplacements, salles, lieux succeptible de faire l\'objet d\'un signalement';

CREATE TABLE `incidents` (
   `inc_id` int NOT NULL AUTO_INCREMENT,
   `inc_emp` int NOT NULL,
   `inc_tinc` int NOT NULL,
   `inc_presta` int NOT NULL,
   `inc_signal_ut` varchar(36) NOT NULL,
   `inc_signal_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `inc_affect_ut` varchar(36) DEFAULT NULL,
   `inc_affect_date` datetime DEFAULT NULL,
   `inc_fin_date` datetime DEFAULT NULL,
   `inc_cloture_date` datetime DEFAULT NULL,
   `inc_note` int DEFAULT NULL,
   `inc_comm` VARCHAR(100) DEFAULT NULL,
   PRIMARY KEY (`inc_id`),
   KEY `inc_signal_ut` (`inc_signal_ut`),
   KEY `incidents_ibfk_5` (`inc_affect_ut`),
   KEY `incidents_ibfk_3_idx` (`inc_presta`),
   KEY `incidents_ibfk_6_idx` (`inc_emp`),
   CONSTRAINT `incidents_ibfk_3` FOREIGN KEY (`inc_presta`) REFERENCES `presta` (`presta_id`),
   CONSTRAINT `incidents_ibfk_4` FOREIGN KEY (`inc_signal_ut`) REFERENCES `utilisateurs` (`ut_uuid`),
   CONSTRAINT `incidents_ibfk_5` FOREIGN KEY (`inc_affect_ut`) REFERENCES `utilisateurs` (`ut_uuid`),
   CONSTRAINT `incidents_ibfk_6` FOREIGN KEY (`inc_emp`) REFERENCES `emplacements` (`emp_id`)
 )
COMMENT='incidents - signalement, affectation, fin d''intervention et clôture';

CREATE TABLE `journaux` (
   `jrn_id` int NOT NULL AUTO_INCREMENT,
   `jrn_inc` int NOT NULL,
   `jrn_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `jrn_msg` varchar(100) DEFAULT NULL,
   `jrn_imm` tinyint DEFAULT '0',
   PRIMARY KEY (`jrn_id`),
   KEY `jrn_inc` (`jrn_inc`),
   CONSTRAINT `journaux_ibfk_arc` FOREIGN KEY (`jrn_inc`) REFERENCES `incidents` (`inc_id`)
 )
COMMENT='lignes des journaux d''interventions';

CREATE TABLE `incidents_arc` (
   `inc_id` int NOT NULL,
   `inc_emp` int NOT NULL,
   `inc_tinc` int NOT NULL,
   `inc_presta` int NOT NULL,
   `inc_signal_ut` varchar(36) NOT NULL,
   `inc_signal_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `inc_affect_ut` varchar(36) DEFAULT NULL,
   `inc_affect_date` datetime DEFAULT NULL,
   `inc_fin_date` datetime DEFAULT NULL,
   `inc_cloture_date` datetime DEFAULT NULL,
   `inc_note` int DEFAULT NULL,
   `inc_comm` VARCHAR(100) DEFAULT NULL,
   `inc_arc` datetime DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`inc_id`)
 )
 COMMENT='archives incidents';
 
CREATE TABLE `journaux_arc` (
   `jrn_id` int NOT NULL,
   `jrn_inc` int NOT NULL,
   `jrn_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `jrn_msg` varchar(100) DEFAULT NULL,
   `jrn_imm` tinyint DEFAULT '0',
   `jrn_arc` datetime DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`jrn_id`)
 )
COMMENT='archive journaux';

CREATE TABLE `utilisateurs_arc` (
  `ut_uuid` varchar(36) NOT NULL,
  `ut_id` varchar(15) NOT NULL,
  `ut_nom` varchar(25) NOT NULL,
  `ut_prenom` varchar(25) NOT NULL, 
  `ut_presta` int DEFAULT NULL, 
  `ut_tel` varchar(20) DEFAULT NULL,
  `ut_mail` varchar(50) NOT NULL,
  `ut_date_deb` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  `ut_date_exp` datetime DEFAULT NULL,
  `ut_mdp` varchar(40) DEFAULT NULL, 
  `ut_mdp_exp` datetime DEFAULT CURRENT_TIMESTAMP,
  `ut_arc` datetime DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`ut_uuid`),
  UNIQUE KEY `ut_id_UNIQUE` (`ut_id`), 
  UNIQUE KEY `ut_mail_UNIQUE` (`ut_mail`),
  KEY `fk_ut_presta_idx` (`ut_presta`), 
  CONSTRAINT `fk_ut_presta_arc` FOREIGN KEY (`ut_presta`) REFERENCES `presta` (`presta_id`)
)
COMMENT='archive utilisateurs';

CREATE TABLE `habilitations_arc` (
   `hab_uuid` varchar(36) NOT NULL,
   `hab_ut` varchar(36) NOT NULL,
   `hab_profil` int NOT NULL,
   `hab_date_deb` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `hab_date_exp` datetime DEFAULT NULL,
   `hab_arc` datetime DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`hab_uuid`)
)
COMMENT='archive habilitations';

--                         BASE TEST      ----------------------------------------- 	
CREATE SCHEMA IF NOT EXISTS sos_immo_test;
use sos_immo_test;

DROP TABLE IF EXISTS journaux;
DROP TABLE IF EXISTS journaux_arc;
DROP TABLE IF EXISTS incidents;
DROP TABLE IF EXISTS incidents_arc;
DROP TABLE IF EXISTS emplacements;
DROP TABLE IF EXISTS mapping_inc_emp;
DROP TABLE IF EXISTS types_emp;
DROP TABLE IF EXISTS types_inc;
DROP TABLE IF EXISTS habilitations;
DROP TABLE IF EXISTS habilitations_arc;
DROP TABLE IF EXISTS utilisateurs;
DROP TABLE IF EXISTS utilisateurs_arc;
DROP TABLE IF EXISTS presta;

CREATE TABLE `presta` (
   `presta_id` int NOT NULL AUTO_INCREMENT,
   `presta_nom` varchar(30) NOT NULL,
   `presta_libelle` varchar(50) NOT NULL,
   PRIMARY KEY (`presta_id`)
 ) 
COMMENT='prestataires sous contrat';

CREATE TABLE `utilisateurs` (
  `ut_uuid` varchar(36) NOT NULL,
  `ut_id` varchar(15) NOT NULL,
  `ut_nom` varchar(25) NOT NULL,
  `ut_prenom` varchar(25) NOT NULL, 
  `ut_presta` int DEFAULT NULL, 
  `ut_tel` varchar(20) DEFAULT NULL,
  `ut_mail` varchar(50) NOT NULL,
  `ut_date_deb` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  `ut_date_exp` datetime DEFAULT NULL,
  `ut_mdp` varchar(40) DEFAULT NULL, 
  `ut_mdp_exp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ut_uuid`),
  UNIQUE KEY `ut_id_UNIQUE` (`ut_id`), 
  UNIQUE KEY `ut_mail_UNIQUE` (`ut_mail`),
  KEY `fk_ut_presta_idx` (`ut_presta`), 
  CONSTRAINT `fk_ut_presta` FOREIGN KEY (`ut_presta`) REFERENCES `presta` (`presta_id`)
)
COMMENT='tous les utilisateurs (interne-presta)';

CREATE TABLE `habilitations` (
   `hab_uuid` varchar(36) NOT NULL,
   `hab_ut` varchar(36) NOT NULL,
   `hab_profil` int NOT NULL,
   `hab_date_deb` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `hab_date_exp` datetime DEFAULT NULL,
   PRIMARY KEY (`hab_uuid`),
   KEY `habilitations_ibfk_1` (`hab_ut`),
   CONSTRAINT `habilitations_ibfk_1` FOREIGN KEY (`hab_ut`) REFERENCES `utilisateurs` (`ut_uuid`)
 )
COMMENT='habilitations :  hab_niveau : 0-utilisateur inactivé, 1-usager, 2-technicien, 3-valideur, 4-imm';

CREATE TABLE `types_emp` (
   `temp_id` int NOT NULL AUTO_INCREMENT,
   `temp_nom` varchar(30) NOT NULL,
   PRIMARY KEY (`temp_id`)
 )
COMMENT='type d''emplacements';

CREATE TABLE `types_inc` (
   `tinc_id` int NOT NULL AUTO_INCREMENT,
   `tinc_nom` varchar(50) NOT NULL,
   `tinc_presta` int NOT NULL,
   PRIMARY KEY (`tinc_id`),
   KEY `presta_id` (`tinc_presta`),
   CONSTRAINT `presta_id` FOREIGN KEY (`tinc_presta`) REFERENCES `presta` (`presta_id`)
 )
COMMENT='Types d''incidents - prestataire en charge';

CREATE TABLE `mapping_inc_emp` (
   `mapping_id` int NOT NULL AUTO_INCREMENT,
   `mapping_tinc` int NOT NULL,
   `mapping_temp` int NOT NULL,
   PRIMARY KEY (`mapping_id`),
   KEY `fk_mapping_inc_idx` (`mapping_tinc`),
   KEY `mapping_inc_emp_ibfk_2` (`mapping_temp`),
   CONSTRAINT `mapping_inc_emp_ibfk_1` FOREIGN KEY (`mapping_tinc`) REFERENCES `types_inc` (`tinc_id`),
   CONSTRAINT `mapping_inc_emp_ibfk_2` FOREIGN KEY (`mapping_temp`) REFERENCES `types_emp` (`temp_id`)
 )
COMMENT='tous types d''incidents pouvant survenir dans tous types d''emplacement';

CREATE TABLE `emplacements` (
  `emp_id` INT NOT NULL AUTO_INCREMENT,
  `emp_etage` VARCHAR(10) NOT NULL,
  `emp_nom` VARCHAR(30) NOT NULL,
  `emp_temp` INT NOT NULL,
  PRIMARY KEY (`emp_id`),
FOREIGN KEY (`emp_temp`)
    REFERENCES `sos_immo`.`types_emp` (`temp_id`)  )
COMMENT = 'emplacements, salles, lieux succeptible de faire l\'objet d\'un signalement';

CREATE TABLE `incidents` (
   `inc_id` int NOT NULL AUTO_INCREMENT,
   `inc_emp` int NOT NULL,
   `inc_tinc` int NOT NULL,
   `inc_presta` int NOT NULL,
   `inc_signal_ut` varchar(36) NOT NULL,
   `inc_signal_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `inc_affect_ut` varchar(36) DEFAULT NULL,
   `inc_affect_date` datetime DEFAULT NULL,
   `inc_fin_date` datetime DEFAULT NULL,
   `inc_cloture_date` datetime DEFAULT NULL,
   `inc_note` int DEFAULT NULL,
   `inc_comm` VARCHAR(100) DEFAULT NULL,
   PRIMARY KEY (`inc_id`),
   KEY `inc_signal_ut` (`inc_signal_ut`),
   KEY `incidents_ibfk_5` (`inc_affect_ut`),
   KEY `incidents_ibfk_3_idx` (`inc_presta`),
   KEY `incidents_ibfk_6_idx` (`inc_emp`),
   CONSTRAINT `incidents_ibfk_3` FOREIGN KEY (`inc_presta`) REFERENCES `presta` (`presta_id`),
   CONSTRAINT `incidents_ibfk_4` FOREIGN KEY (`inc_signal_ut`) REFERENCES `utilisateurs` (`ut_uuid`),
   CONSTRAINT `incidents_ibfk_5` FOREIGN KEY (`inc_affect_ut`) REFERENCES `utilisateurs` (`ut_uuid`),
   CONSTRAINT `incidents_ibfk_6` FOREIGN KEY (`inc_emp`) REFERENCES `emplacements` (`emp_id`)
 )
COMMENT='incidents - signalement, affectation, fin d''intervention et clôture';

CREATE TABLE `journaux` (
   `jrn_id` int NOT NULL AUTO_INCREMENT,
   `jrn_inc` int NOT NULL,
   `jrn_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `jrn_msg` varchar(100) DEFAULT NULL,
   `jrn_imm` tinyint DEFAULT '0',
   PRIMARY KEY (`jrn_id`),
   KEY `jrn_inc` (`jrn_inc`),
   CONSTRAINT `journaux_ibfk_1` FOREIGN KEY (`jrn_inc`) REFERENCES `incidents` (`inc_id`)
 )
COMMENT='lignes des journaux d''interventions';

CREATE TABLE `incidents_arc` (
   `inc_id` int NOT NULL,
   `inc_emp` int NOT NULL,
   `inc_tinc` int NOT NULL,
   `inc_presta` int NOT NULL,
   `inc_signal_ut` varchar(36) NOT NULL,
   `inc_signal_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `inc_affect_ut` varchar(36) DEFAULT NULL,
   `inc_affect_date` datetime DEFAULT NULL,
   `inc_fin_date` datetime DEFAULT NULL,
   `inc_cloture_date` datetime DEFAULT NULL,
   `inc_note` int DEFAULT NULL,
   `inc_comm` VARCHAR(100) DEFAULT NULL,
   `inc_arc` datetime DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`inc_id`)
 )
 COMMENT='archives incidents';
CREATE TABLE `journaux_arc` (
   `jrn_id` int NOT NULL,
   `jrn_inc` int NOT NULL,
   `jrn_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `jrn_msg` varchar(100) DEFAULT NULL,
   `jrn_imm` tinyint DEFAULT '0',
   `jrn_arc` datetime DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`jrn_id`)
 )
COMMENT='archive journaux';
CREATE TABLE `utilisateurs_arc` (
  `ut_uuid` varchar(36) NOT NULL,
  `ut_id` varchar(15) NOT NULL,
  `ut_nom` varchar(25) NOT NULL,
  `ut_prenom` varchar(25) NOT NULL, 
  `ut_presta` int DEFAULT NULL, 
  `ut_tel` varchar(20) DEFAULT NULL,
  `ut_mail` varchar(50) NOT NULL,
  `ut_date_deb` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  `ut_date_exp` datetime DEFAULT NULL,
  `ut_mdp` varchar(40) DEFAULT NULL, 
  `ut_mdp_exp` datetime DEFAULT CURRENT_TIMESTAMP,
  `ut_arc` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ut_uuid`),
  UNIQUE KEY `ut_id_UNIQUE` (`ut_id`), 
  UNIQUE KEY `ut_mail_UNIQUE` (`ut_mail`),
  KEY `fk_ut_presta_idx` (`ut_presta`), 
  CONSTRAINT `fk_ut_presta_arc` FOREIGN KEY (`ut_presta`) REFERENCES `presta` (`presta_id`)
)
COMMENT='archive utilisateurs';
CREATE TABLE `habilitations_arc` (
   `hab_uuid` varchar(36) NOT NULL,
   `hab_ut` varchar(36) NOT NULL,
   `hab_profil` int NOT NULL,
   `hab_date_deb` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
   `hab_date_exp` datetime DEFAULT NULL,
   `hab_arc` datetime DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`hab_uuid`)
)
COMMENT='archive habilitations';

--                            triggers tables sans archive 		-----------------------------------------------------
-- presta
DROP TRIGGER IF EXISTS after_create_presta;
DROP TRIGGER IF EXISTS after_update_presta;
DELIMITER //
CREATE TRIGGER after_create_presta AFTER INSERT
	on presta FOR EACH ROW
BEGIN
 	INSERT INTO sos_immo_sauv.presta
 		(presta_id, presta_nom, presta_libelle)
 	VALUES
		(new.presta_id, new.presta_nom, new.presta_libelle);
END;
//
CREATE TRIGGER after_update_presta AFTER UPDATE
	on presta FOR EACH ROW
BEGIN
	UPDATE sos_immo_sauv.presta
		SET presta_nom = new.presta_nom,
        presta_libelle = new.presta_libelle
        WHERE presta_id = new.presta_id;		
END;
//
DELIMITER ;

-- emplacements
DROP TRIGGER IF EXISTS after_create_emplacements;
DROP TRIGGER IF EXISTS after_update_emplacements;
DELIMITER //
CREATE TRIGGER after_create_emplacements AFTER INSERT
	on emplacements FOR EACH ROW
BEGIN
 	INSERT INTO sos_immo_sauv.emplacements
 		(emp_id, emp_etage, emp_nom, emp_temp)
 	VALUES
		(new.emp_id, new.emp_etage, new.emp_nom, new.emp_temp);
END;
//
CREATE TRIGGER after_update_emplacements AFTER UPDATE
	on emplacements FOR EACH ROW
BEGIN
	UPDATE sos_immo_sauv.emplacements
		SET emp_etage = new.emp_etage,
        emp_nom = new.emp_nom,
        emp_temp = new.emp_temp
        WHERE emp_id = new.emp_id;		
END;
//
DELIMITER ;

-- types_emp
DROP TRIGGER IF EXISTS after_create_type_emplacements;
DROP TRIGGER IF EXISTS after_update_type_emplacements;
DELIMITER //
CREATE TRIGGER after_create_type_emplacements AFTER INSERT
	on types_emp FOR EACH ROW
BEGIN
 	INSERT INTO sos_immo_sauv.types_emp
 		(temp_id, temp_nom)
 	VALUES
		(new.temp_id, new.temp_nom);
END;
//
CREATE TRIGGER after_update_type_emplacements AFTER UPDATE
	on types_emp FOR EACH ROW
BEGIN
	UPDATE sos_immo_sauv.types_emp
		SET temp_nom = new.temp_nom
        WHERE temp_id = new.temp_id;		
END;
//
DELIMITER ;

-- types_inc
DROP TRIGGER IF EXISTS after_create_type_incidents;
DROP TRIGGER IF EXISTS after_update_type_incidents;
DELIMITER //
CREATE TRIGGER after_create_type_incidents AFTER INSERT
	on types_inc FOR EACH ROW
BEGIN
 	INSERT INTO sos_immo_sauv.types_inc
 		(tinc_id, tinc_nom, tinc_presta)
 	VALUES
		(new.tinc_id, new.tinc_nom, new.tinc_presta);
END;
//
CREATE TRIGGER after_update_type_incidents AFTER UPDATE
	on types_inc FOR EACH ROW
BEGIN
	UPDATE sos_immo_sauv.types_inc
		SET tinc_nom = new.tinc_nom,
        tinc_presta = new.tinc_presta
        WHERE tinc_id = new.tinc_id;		
END;
//
DELIMITER ;

-- mapping temp/tinc
DROP TRIGGER IF EXISTS after_create_mapping_temp_tinc;
DROP TRIGGER IF EXISTS after_update_mapping_temp_tinc;
DELIMITER //
CREATE TRIGGER after_create_mapping_temp_tinc AFTER INSERT
	on mapping_inc_emp FOR EACH ROW
BEGIN
 	INSERT INTO sos_immo_sauv.mapping_inc_emp
 		(mapping_id, mapping_tinc, mapping_temp)
 	VALUES
		(new.mapping_id, new.mapping_tinc, new.mapping_temp);
END;
//
CREATE TRIGGER after_update_mapping_temp_tinc AFTER UPDATE
	on mapping_inc_emp FOR EACH ROW
BEGIN
	UPDATE sos_immo_sauv.mapping_inc_emp
		SET mapping_tinc = new.mapping_tinc,
        mapping_temp = new.mapping_temp
        WHERE mapping_id = new.mapping_id;		
END;
//
DELIMITER ;

--                            triggers tables avec archive 		-----------------------------------------------------

-- utilisateurs
DROP TRIGGER IF EXISTS after_create_utilisateurs;
DROP TRIGGER IF EXISTS after_update_utilisateurs;
DROP TRIGGER IF EXISTS before_delete_utilisateurs;
DELIMITER //
CREATE TRIGGER after_create_utilisateurs AFTER INSERT
	on utilisateurs FOR EACH ROW
BEGIN
 	INSERT INTO sos_immo_sauv.utilisateurs
 		(ut_uuid, ut_id, ut_nom, ut_prenom, ut_presta, ut_tel, ut_mail, ut_mdp)
 	VALUES
		(new.ut_uuid, new.ut_id, new.ut_nom, new.ut_prenom, new.ut_presta, new.ut_tel, new.ut_mail, new.ut_mdp);
END;
//
CREATE TRIGGER after_update_utilisateurs AFTER UPDATE
	on utilisateurs FOR EACH ROW
BEGIN
	UPDATE sos_immo_sauv.utilisateurs
		SET ut_id = new.ut_id, ut_nom = new.ut_nom, ut_prenom = new.ut_prenom, 
        ut_presta = new.ut_presta, ut_tel = new.ut_tel, ut_mail = new.ut_mail, 
        ut_date_deb = new.ut_date_deb, ut_date_exp = new.ut_date_exp,
        ut_mdp = new.ut_mdp, ut_mdp_exp = new.ut_mdp_exp
        WHERE ut_uuid = new.ut_uuid;		
END;
//
CREATE TRIGGER before_delete_utilisateurs BEFORE DELETE
	on utilisateurs FOR EACH ROW
BEGIN
	INSERT INTO utilisateurs_arc
 		(ut_uuid, ut_id, ut_nom, ut_prenom, ut_presta, ut_tel, ut_mail, 
         ut_date_deb, ut_date_exp, ut_mdp, ut_mdp_exp)
 	VALUES
		(old.ut_uuid, old.ut_id, old.ut_nom, old.ut_prenom, old.ut_presta, old.ut_tel, old.ut_mail, 
        old.ut_date_deb, old.ut_date_exp, old.ut_mdp, old.ut_mdp_exp);
	DELETE FROM sos_immo_sauv.utilisateurs
		WHERE ut_uuid = old.ut_uuid;
END;
//
DELIMITER ;

-- habilitations
DROP TRIGGER IF EXISTS after_create_habilitations;
DROP TRIGGER IF EXISTS after_update_habilitations;
DROP TRIGGER IF EXISTS before_delete_habilitations;
DELIMITER //
CREATE TRIGGER after_create_habilitations AFTER INSERT
	on habilitations FOR EACH ROW
BEGIN
 	INSERT INTO sos_immo_sauv.habilitations
 		(hab_uuid, hab_ut, hab_profil)
 	VALUES
		(new.hab_uuid, new.hab_ut, new.hab_profil);
END;
//
CREATE TRIGGER after_update_habilitations AFTER UPDATE
	on habilitations FOR EACH ROW
BEGIN
	UPDATE sos_immo_sauv.habilitations
		SET hab_ut = new.hab_ut, hab_profil = new.hab_profil, 
        hab_date_deb = new.hab_date_exp, hab_date_deb = new.hab_date_exp
        WHERE hab_uuid = new.hab_uuid;		
END;
//
CREATE TRIGGER before_delete_habilitations BEFORE DELETE
	on habilitations FOR EACH ROW
BEGIN
	INSERT INTO habilitations_arc
 		(hab_uuid, hab_ut, hab_profil, hab_date_deb, hab_date_exp)
 	VALUES
			(old.hab_uuid, old.hab_ut, old.hab_profil, old.hab_date_deb, old.hab_date_exp);
	DELETE FROM sos_immo_sauv.habilitations
		  WHERE hab_uuid = old.hab_uuid;		
END;
//
DELIMITER ;

-- incidents
DROP TRIGGER IF EXISTS after_create_incidents;
DROP TRIGGER IF EXISTS after_update_incidents;
DROP TRIGGER IF EXISTS before_delete_incidents;
DELIMITER //
CREATE TRIGGER after_create_incidents AFTER INSERT
	on incidents FOR EACH ROW
BEGIN
 	INSERT INTO sos_immo_sauv.incidents
 		(inc_id, inc_emp, inc_tinc, inc_presta, inc_signal_ut)
 	VALUES
		(new.inc_id, new.inc_emp, new.inc_tinc, new.inc_presta, new.inc_signal_ut);
END;
//
CREATE TRIGGER after_update_incidents AFTER UPDATE
	on incidents FOR EACH ROW
BEGIN
	UPDATE sos_immo_sauv.incidents
		SET inc_id = new.inc_id, inc_emp = new.inc_emp, inc_tinc = new.inc_tinc, inc_presta = new.inc_presta, 
        inc_signal_ut = new.inc_signal_ut, inc_signal_date = new.inc_signal_date,
        inc_affect_ut = new.inc_affect_ut, inc_affect_date = new.inc_affect_date,
        inc_fin_date = new.inc_fin_date, inc_cloture_date = new.inc_cloture_date,
        inc_note = new.inc_note, inc_comm = new.inc_comm
        WHERE inc_id = new.inc_id;		
END;
//
CREATE TRIGGER before_delete_incidents BEFORE DELETE
	on incidents FOR EACH ROW
BEGIN
	INSERT INTO incidents_arc
 		(inc_id, inc_emp, inc_tinc, inc_presta, 
        inc_signal_ut, inc_signal_date,
        inc_affect_ut, inc_affect_date,
        inc_fin_date, inc_cloture_date,
        inc_note, inc_comm)
 	VALUES
		(old.inc_id, old.inc_emp, old.inc_tinc, old.inc_presta, 
        old.inc_signal_ut, old.inc_signal_date,
        old.inc_affect_ut, old.inc_affect_date,
        old.inc_fin_date, old.inc_cloture_date,
        old.inc_note, old.inc_comm);
	DELETE FROM sos_immo_sauv.incidents
		  WHERE inc_id = old.inc_id;		
END;
//
DELIMITER ;

-- journaux
DROP TRIGGER IF EXISTS after_create_journaux;
DROP TRIGGER IF EXISTS after_update_journaux;
DROP TRIGGER IF EXISTS before_delete_journaux;
DELIMITER //
CREATE TRIGGER after_create_journaux AFTER INSERT
	on journaux FOR EACH ROW
BEGIN
 	INSERT INTO sos_immo_sauv.journaux
 		(jrn_id, jrn_inc, jrn_msg, jrn_imm)
 	VALUES
		(new.jrn_id, new.jrn_inc, new.jrn_msg, new.jrn_imm);
END;
//
CREATE TRIGGER after_update_journaux AFTER UPDATE
	on journaux FOR EACH ROW
BEGIN
	UPDATE sos_immo_sauv.journaux
		SET jrn_inc = new.jrn_inc, jrn_msg = new.jrn_msg, 
        jrn_date = new.jrn_date, jrn_imm = new.jrn_imm
        WHERE jrn_id = new.jrn_id;		
END;
//
CREATE TRIGGER before_delete_journaux BEFORE DELETE
	on journaux FOR EACH ROW
BEGIN
	INSERT INTO journaux_arc
 		(jrn_id, jrn_inc, jrn_msg, jrn_date, jrn_imm)
 	VALUES
		(old.jrn_id, old.jrn_inc, old.jrn_msg, old.jrn_date, old.jrn_imm);
	DELETE FROM sos_immo_sauv.journaux
		  WHERE jrn_id = old.jrn_id;		
END;
//
DELIMITER ;

--           INSERTIONS MINIMALES                         ---------------------------------------------------------------
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
    ('9c3d2a09-35b7-46d6-a1ae-8d2be5dc6217', 'mario','mario','mario', 1, 01234---56789,'mario@presta.com', '80d945a6945953a704fb109414d7c2a9788f5fec'),
    ('c7f1d496-a72d-44a3-90cf-ebb4128bd0b4','hwilliam','william','henry', 1, 012399999,'wh@presta.com', '73a9a84ffa2adc1543d8b1e57fefb5550507deda');

-- habilitations
INSERT INTO `habilitations` ( `hab_uuid`, `hab_ut`,  `hab_profil`)
 VALUES
	('0eb89d14-83c0-436c-a509-b4bc6c72da89', 'e13efdf7-6512-4641-8857-af929205da61', 1),
	('2a0edddb-ba6e-4366-af2c-9682b9ff6b19', 'cba7c9b1-f0fe-4373-adf5-25201601ae76', 4),
	('50bd2a84-121e-42af-886d-81023e4400aa', '27bc82c-f294-4908-8ba3-d99ff3e260f7', 2),
	('50bd2a84-121e-42af-886d-9999999999aa', '9c3d2a09-35b7-46d6-a1ae-8d2be5dc6217', 2),
    ('6d3e5d4b-7d97-406f-82d7-c545891182ba', 'c7f1d496-a72d-44a3-90cf-ebb4128bd0b4', 3);

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
INSERT INTO `mapping_inc_emp` (`mapping_tinc`,  `mapping_temp`)
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

--  reculer la date d'expiration des mots de passe
UPDATE utilisateurs SET ut_mdp_exp = ADDDATE(ut_mdp_exp, 90) 
WHERE ut_uuid != " ";


