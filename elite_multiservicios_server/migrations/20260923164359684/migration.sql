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
    "month" bigint NOT NULL,
    "year" bigint NOT NULL,
    "projectedIncome" double precision NOT NULL,
    "executedIncome" double precision NOT NULL,
    "projectedExpenses" double precision NOT NULL,
    "executedExpenses" double precision NOT NULL,
    "estimatedBalance" double precision NOT NULL
);

--
-- ACTION DROP TABLE
--
DROP TABLE "accounting_petty_cash_txn" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounting_petty_cash_txn" (
    "id" bigserial PRIMARY KEY,
    "pettyCashId" bigint NOT NULL,
    "amount" double precision NOT NULL,
    "type" text NOT NULL,
    "description" text NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "hasInvoice" boolean NOT NULL,
    "isFixedPayment" boolean NOT NULL,
    "fiscalCredit" double precision,
    "fiscalDebit" double precision
);


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260923164359684', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260923164359684', "timestamp" = now();

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
