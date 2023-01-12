-- utilisateurs
DROP TRIGGER IF EXISTS before_delete_utilisateurs_arc;
DELIMITER //
CREATE TRIGGER before_delete_utilisateurs_arc BEFORE DELETE
	on utilisateurs_arc FOR EACH ROW
BEGIN
	DELETE FROM sos_immo_sauv.utilisateurs_arc
		WHERE ut_uuid = old.ut_uuid;
END;
//
DELIMITER ;

-- habilitations_arc
DROP TRIGGER IF EXISTS before_delete_habilitations_arc;
DELIMITER //
CREATE TRIGGER before_delete_habilitations_arc BEFORE DELETE
	on habilitations_arc FOR EACH ROW
BEGIN
	DELETE FROM sos_immo_sauv.habilitations_arc
		  WHERE hab_uuid = old.hab_uuid;		
END;
//
DELIMITER ;

-- incidents_arc
DROP TRIGGER IF EXISTS before_delete_incidents_arc;
DELIMITER //
CREATE TRIGGER before_delete_incidents_arc BEFORE DELETE
	on incidents_arc FOR EACH ROW
BEGIN
	DELETE FROM sos_immo_sauv.incidents_arc
		  WHERE inc_id = old.inc_id;		
END;
//
DELIMITER ;

-- journaux_arc
DROP TRIGGER IF EXISTS before_delete_journaux_arc;
DELIMITER //
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

