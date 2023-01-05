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
   `inc_comm` varchar(100) DEFAULT NULL,
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
   `inc_comm` varchar(100) DEFAULT NULL,
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
   -- obligée de retirer la contrainte : foreign key incidents dans un premier temps et incidents_arc ensuite`)
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
   -- obligée de retirer la contrainte : foreign key utilisateurs dans un premier temps et utilisateurs_arc ensuite
)
COMMENT='archive habilitations';
