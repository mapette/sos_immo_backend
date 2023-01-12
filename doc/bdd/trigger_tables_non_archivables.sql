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

-- DROP TRIGGER IF EXISTS before_delete_presta;
-- CREATE TRIGGER before_delete_presta BEFORE DELETE
-- 	on presta FOR EACH ROW
-- BEGIN
--  DELETE FROM sos_immo_sauv.presta
-- 		WHERE presta_id = old.presta_id;	
-- END;
-- //
-- DROP TRIGGER IF EXISTS before_delete_emplacements;
-- CREATE TRIGGER before_delete_emplacements BEFORE DELETE
-- 	on emplacements FOR EACH ROW
-- BEGIN
--  DELETE FROM sos_immo_sauv.emplacements
-- 		WHERE emp_id = old.emp_id;	
-- END;
-- //
-- DROP TRIGGER IF EXISTS before_delete_type_emplacements;
-- CREATE TRIGGER before_delete_type_emplacements BEFORE DELETE
-- 	on types_emp FOR EACH ROW
-- BEGIN
--  DELETE FROM sos_immo_sauv.types_emp
-- 		WHERE temp_id = old.temp_id;	
-- END;
-- //
-- DROP TRIGGER IF EXISTS before_delete_type_incidents;
-- CREATE TRIGGER before_delete_type_incidents BEFORE DELETE
-- 	on types_inc FOR EACH ROW
-- BEGIN
--  DELETE FROM sos_immo_sauv.types_inc
-- 		WHERE tinc_id = old.tinc_id;	
-- END;
-- //
-- DROP TRIGGER IF EXISTS before_delete_mapping_temp_tinc;
-- CREATE TRIGGER before_delete_mapping_temp_tinc BEFORE DELETE
-- 	on mapping_inc_emp FOR EACH ROW
-- BEGIN
--  DELETE FROM sos_immo_sauv.mapping_inc_emp
-- 		WHERE mapping_id = old.mapping_id;	
-- END;
-- //



-- show triggers;

-- C:\Program Files\MySQL\MySQL Server 8.0\bin