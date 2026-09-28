BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounting_fixed_asset" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "category" text NOT NULL,
    "purchaseValue" double precision NOT NULL,
    "purchaseDate" timestamp without time zone NOT NULL,
    "usefulLifeMonths" bigint NOT NULL,
    "accumulatedDepreciation" double precision NOT NULL,
    "isFullyDepreciated" boolean NOT NULL,
    "lastDepreciationDate" timestamp without time zone
);


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260928152726496', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260928152726496', "timestamp" = now();

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
