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
	INSERT INTO sos_immo_sauv.utilisateurs_arc
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
	INSERT INTO sos_immo_sauv.habilitations_arc
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
	INSERT INTO sos_immo_sauv.incidents_arc
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
	INSERT INTO sos_immo_sauv.journaux_arc
 		(jrn_id, jrn_inc, jrn_msg, jrn_date, jrn_imm)
		VALUES
		(old.jrn_id, old.jrn_inc, old.jrn_msg, old.jrn_date, old.jrn_imm);
	DELETE FROM sos_immo_sauv.journaux
		  WHERE jrn_id = old.jrn_id;		
END;
//
DELIMITER ;

-- show triggers;
--	presta_supp = current_timestamp()

