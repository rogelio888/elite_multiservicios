BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounting_kardex_movement" (
    "id" bigserial PRIMARY KEY,
    "itemId" bigint NOT NULL,
    "itemName" text NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "movementType" text NOT NULL,
    "referenceDoc" text NOT NULL,
    "workOrderId" bigint,
    "quantity" double precision NOT NULL,
    "unitCost" double precision NOT NULL,
    "totalCost" double precision NOT NULL,
    "balanceQuantity" double precision NOT NULL,
    "balanceTotalCost" double precision NOT NULL,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "acc_kardex_item_idx" ON "accounting_kardex_movement" USING btree ("itemId");
CREATE INDEX "acc_kardex_date_idx" ON "accounting_kardex_movement" USING btree ("date");
CREATE INDEX "acc_kardex_work_order_idx" ON "accounting_kardex_movement" USING btree ("workOrderId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounting_period_closure" (
    "id" bigserial PRIMARY KEY,
    "periodName" text NOT NULL,
    "periodType" text NOT NULL,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone NOT NULL,
    "status" text NOT NULL DEFAULT 'CLOSED'::text,
    "totalIncome" double precision NOT NULL,
    "totalExpense" double precision NOT NULL,
    "netResult" double precision NOT NULL,
    "closedBy" text,
    "closedAt" timestamp without time zone NOT NULL,
    "closureNotes" text,
    "isLocked" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "acc_closure_dates_idx" ON "accounting_period_closure" USING btree ("startDate", "endDate");
CREATE INDEX "acc_closure_status_idx" ON "accounting_period_closure" USING btree ("status");


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260929004256425', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260929004256425', "timestamp" = now();

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
