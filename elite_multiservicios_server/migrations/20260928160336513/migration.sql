BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "accounting_budget" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounting_budget" (
    "id" bigserial PRIMARY KEY,
    "category" text NOT NULL,
    "month" bigint NOT NULL,
    "year" bigint NOT NULL,
    "limitAmount" double precision NOT NULL,
    "consumedAmount" double precision NOT NULL DEFAULT 0.0,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounting_exchange_rate" (
    "id" bigserial PRIMARY KEY,
    "date" timestamp without time zone NOT NULL,
    "currency" text NOT NULL,
    "rateToBob" double precision NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "accounting_expense" ADD COLUMN "dueDate" timestamp without time zone;
ALTER TABLE "accounting_expense" ADD COLUMN "currency" text NOT NULL DEFAULT 'BOB'::text;
ALTER TABLE "accounting_expense" ADD COLUMN "originalAmount" double precision;

--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260928160336513', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260928160336513', "timestamp" = now();

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
