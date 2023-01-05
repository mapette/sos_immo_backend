-- utilisateurs
DROP TRIGGER IF EXISTS after_create_utilisateurs_arc;
DROP TRIGGER IF EXISTS after_update_utilisateurs_arc;
DROP TRIGGER IF EXISTS before_delete_utilisateurs_arc;
DELIMITER //
CREATE TRIGGER after_create_utilisateurs_arc AFTER INSERT
	on utilisateurs_arc FOR EACH ROW
BEGIN
 	INSERT INTO sos_immo_sauv.utilisateurs_arc
 		(ut_uuid, ut_id, ut_nom, ut_prenom, ut_presta, ut_tel, ut_mail, ut_mdp)
 	VALUES
		(new.ut_uuid, new.ut_id, new.ut_nom, new.ut_prenom, new.ut_presta, new.ut_tel, new.ut_mail, new.ut_mdp);
END;
//
CREATE TRIGGER after_update_utilisateurs_arc AFTER UPDATE
	on utilisateurs_arc FOR EACH ROW
BEGIN
	UPDATE sos_immo_sauv.utilisateurs_arc
		SET ut_id = new.ut_id, ut_nom = new.ut_nom, ut_prenom = new.ut_prenom, 
        ut_presta = new.ut_presta, ut_tel = new.ut_tel, ut_mail = new.ut_mail, 
        ut_date_deb = new.ut_date_deb, ut_date_exp = new.ut_date_exp,
        ut_mdp = new.ut_mdp, ut_mdp_exp = new.ut_mdp_exp
	WHERE ut_uuid = new.ut_uuid;		
END;
//
CREATE TRIGGER before_delete_utilisateurs_arc BEFORE DELETE
	on utilisateurs_arc FOR EACH ROW
BEGIN
	DELETE FROM sos_immo_sauv.utilisateurs_arc
		WHERE ut_uuid = old.ut_uuid;
END;
//
DELIMITER ;

-- habilitations_arc
DROP TRIGGER IF EXISTS after_create_habilitations_arc;
DROP TRIGGER IF EXISTS after_update_habilitations_arc;
DROP TRIGGER IF EXISTS before_delete_habilitations_arc;
DELIMITER //
CREATE TRIGGER after_create_habilitations_arc AFTER INSERT
	on habilitations_arc FOR EACH ROW
BEGIN
 	INSERT INTO sos_immo_sauv.habilitations_arc
 		(hab_uuid, hab_ut, hab_profil)
 	VALUES
		(new.hab_uuid, new.hab_ut, new.hab_profil);
END;
//
CREATE TRIGGER after_update_habilitations_arc AFTER UPDATE
	on habilitations_arc FOR EACH ROW
BEGIN
	UPDATE sos_immo_sauv.habilitations_arc
		SET hab_ut = new.hab_ut, hab_profil = new.hab_profil, 
        hab_date_deb = new.hab_date_exp, hab_date_deb = new.hab_date_exp
        WHERE hab_uuid = new.hab_uuid;		
END;
//
CREATE TRIGGER before_delete_habilitations_arc BEFORE DELETE
	on habilitations_arc FOR EACH ROW
BEGIN
	DELETE FROM sos_immo_sauv.habilitations_arc
		  WHERE hab_uuid = old.hab_uuid;		
END;
//
DELIMITER ;

-- incidents_arc
DROP TRIGGER IF EXISTS after_create_incidents_arc;
DROP TRIGGER IF EXISTS after_update_incidents_arc;
DROP TRIGGER IF EXISTS before_delete_incidents_arc;
DELIMITER //
CREATE TRIGGER after_create_incidents_arc AFTER INSERT
	on incidents_arc FOR EACH ROW
BEGIN
 	INSERT INTO sos_immo_sauv.incidents_arc
 		(inc_id, inc_emp, inc_tinc, inc_presta, inc_signal_ut)
 	VALUES
		(new.inc_id, new.inc_emp, new.inc_tinc, new.inc_presta, new.inc_signal_ut);
END;
//
CREATE TRIGGER after_update_incidents_arc AFTER UPDATE
	on incidents_arc FOR EACH ROW
BEGIN
	UPDATE sos_immo_sauv.incidents_arc
		SET inc_id = new.inc_id, inc_emp = new.inc_emp, inc_tinc = new.inc_tinc, inc_presta = new.inc_presta, 
        inc_signal_ut = new.inc_signal_ut, inc_signal_date = new.inc_signal_date,
        inc_affect_ut = new.inc_affect_ut, inc_affect_date = new.inc_affect_date,
        inc_fin_date = new.inc_fin_date, inc_cloture_date = new.inc_cloture_date,
        inc_note = new.inc_note, inc_comm = new.inc_comm
        WHERE inc_id = new.inc_id;		
END;
//
CREATE TRIGGER before_delete_incidents_arc BEFORE DELETE
	on incidents FOR EACH ROW
BEGIN
	DELETE FROM sos_immo_sauv.incidents_arc
		  WHERE inc_id = old.inc_id;		
END;
//
DELIMITER ;

-- journaux_arc
DROP TRIGGER IF EXISTS after_create_journaux_arc;
DROP TRIGGER IF EXISTS after_update_journaux_arc;
DROP TRIGGER IF EXISTS before_delete_journaux_arc;
DELIMITER //
CREATE TRIGGER after_create_journaux_arc AFTER INSERT
	on journaux_arc FOR EACH ROW
BEGIN
 	INSERT INTO sos_immo_sauv.journaux_arc
 		(jrn_id, jrn_inc, jrn_msg, jrn_imm)
 	VALUES
		(new.jrn_id, new.jrn_inc, new.jrn_msg, new.jrn_imm);
END;
//
CREATE TRIGGER after_update_journaux_arc AFTER UPDATE
	on journaux_arc FOR EACH ROW
BEGIN
	UPDATE sos_immo_sauv.journaux_arc
		SET jrn_inc = new.jrn_inc, jrn_msg = new.jrn_msg, 
        jrn_date = new.jrn_date, jrn_imm = new.jrn_imm
        WHERE jrn_id = new.jrn_id;		
END;
//
CREATE TRIGGER before_delete_journaux_arc BEFORE DELETE
	on journaux_arc FOR EACH ROW
BEGIN
	DELETE FROM sos_immo_sauv.journaux_arc
		  WHERE jrn_id = old.jrn_id;		
END;
//
DELIMITER ;

-- show triggers;
--	presta_supp = current_timestamp()

