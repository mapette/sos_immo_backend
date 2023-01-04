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
         ut_date_deb, ut_date_exp, ut_mdp, old.ut_mdp_exp)
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

-- show triggers;
--	presta_supp = current_timestamp()

