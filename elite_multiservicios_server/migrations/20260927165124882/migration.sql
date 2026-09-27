BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "rrhh_employee" DROP COLUMN "documentChecklist";
ALTER TABLE "rrhh_employee" ADD COLUMN "documentChecklist" json;
ALTER TABLE "rrhh_employee" ALTER COLUMN "agreedSalary" DROP NOT NULL;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "rrhh_hiring_dossier" DROP COLUMN "documentChecklist";
ALTER TABLE "rrhh_hiring_dossier" ADD COLUMN "documentChecklist" json;

--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260927165124882', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260927165124882', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
