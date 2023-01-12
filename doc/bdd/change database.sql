use sos_immo;
SELECT * FROM utilisateurs;

use sos_immo_test;
SELECT * FROM utilisateurs;
SELECT * FROM incidents;
SELECT * FROM utilisateurs_arc;
SELECT * FROM habilitations;
SELECT * FROM habilitations_arc;

use sos_immo_sauv;
SELECT * FROM incidents;
SELECT * FROM incidents_arc;
SELECT * FROM journaux;
SELECT * FROM journaux_arc;

show triggers;

-- nettoyer archives
DELETE FROM habilitations_arc WHERE hab_uuid != " ";
DELETE FROM utilisateurs_arc WHERE ut_uuid != " ";
DELETE FROM journaux_arc WHERE jrn_id != " ";
DELETE FROM incidents_arc WHERE inc_id != " ";

DROP TRIGGER IF EXISTS after_create_presta;
DROP TRIGGER IF EXISTS after_update_presta;
DROP TRIGGER IF EXISTS after_create_emplacements;
DROP TRIGGER IF EXISTS after_update_emplacements;
DROP TRIGGER IF EXISTS after_create_type_emplacements;
DROP TRIGGER IF EXISTS after_update_type_emplacements;
DROP TRIGGER IF EXISTS after_create_type_incidents;
DROP TRIGGER IF EXISTS after_update_type_incidents;
DROP TRIGGER IF EXISTS after_create_mapping_temp_tinc;
DROP TRIGGER IF EXISTS after_update_mapping_temp_tinc;
DROP TRIGGER IF EXISTS after_create_incidents;
DROP TRIGGER IF EXISTS after_update_incidents;
DROP TRIGGER IF EXISTS before_delete_incidents;
DROP TRIGGER IF EXISTS before_delete_incidents_arc;
DROP TRIGGER IF EXISTS after_create_journaux;
DROP TRIGGER IF EXISTS after_update_journaux;
DROP TRIGGER IF EXISTS before_delete_journaux;
DROP TRIGGER IF EXISTS before_delete_journaux_arc;
DROP TRIGGER IF EXISTS after_create_utilisateurs;
DROP TRIGGER IF EXISTS after_update_utilisateurs;
DROP TRIGGER IF EXISTS before_delete_utilisateurs;
DROP TRIGGER IF EXISTS before_delete_utilisateurs_arc;
DROP TRIGGER IF EXISTS after_create_habilitations;
DROP TRIGGER IF EXISTS after_update_habilitations;
DROP TRIGGER IF EXISTS before_delete_habilitations;
DROP TRIGGER IF EXISTS before_delete_habilitations_arc;




