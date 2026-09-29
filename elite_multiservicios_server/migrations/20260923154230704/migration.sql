BEGIN;

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
    "executedExpenses" double precision NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounting_payroll_est" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "baseSalary" double precision NOT NULL,
    "bonuses" double precision NOT NULL,
    "estimatedTotal" double precision NOT NULL,
    "month" bigint NOT NULL,
    "year" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounting_petty_cash" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "balance" double precision NOT NULL,
    "maxLimit" double precision NOT NULL,
    "custodianId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounting_petty_cash_txn" (
    "id" bigserial PRIMARY KEY,
    "pettyCashId" bigint NOT NULL,
    "amount" double precision NOT NULL,
    "type" text NOT NULL,
    "description" text NOT NULL,
    "date" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "crm_catalog_item" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "category" text NOT NULL,
    "serviceLineId" bigint NOT NULL,
    "concept" text NOT NULL,
    "calculationType" text NOT NULL,
    "unitType" text NOT NULL,
    "basePrice" double precision NOT NULL,
    "minQuantity" double precision NOT NULL DEFAULT 1.0,
    "version" bigint NOT NULL DEFAULT 1,
    "metadata" text,
    "description" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_catalog_item_code_unique_idx" ON "crm_catalog_item" USING btree ("code");
CREATE UNIQUE INDEX "crm_catalog_item_concept_service_line_unique_idx" ON "crm_catalog_item" USING btree ("serviceLineId", "concept");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "crm_catalog_item_scope" (
    "id" bigserial PRIMARY KEY,
    "catalogItemId" bigint NOT NULL,
    "sectorId" bigint NOT NULL,
    "serviceLineId" bigint,
    "priceOverride" double precision,
    "minQuantityOverride" double precision,
    "metadataOverride" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_catalog_scope_unique_idx" ON "crm_catalog_item_scope" USING btree ("catalogItemId", "sectorId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "crm_contract_budget_item" ADD COLUMN "catalogItemId" bigint;
CREATE INDEX "crm_contract_budget_item_catalog_item_idx" ON "crm_contract_budget_item" USING btree ("catalogItemId");
--
-- ACTION ALTER TABLE
--
ALTER TABLE "crm_customer_contract" ADD COLUMN "serviceFrequency" text NOT NULL DEFAULT 'Lunes a Viernes'::text;
ALTER TABLE "crm_customer_contract" ADD COLUMN "scheduleHours" text;
ALTER TABLE "crm_customer_contract" ADD COLUMN "billingCycleDay" bigint DEFAULT 5;
ALTER TABLE "crm_customer_contract" ADD COLUMN "specificRequirements" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "crm_lead" ADD COLUMN "origin" text NOT NULL DEFAULT 'Google Maps'::text;
ALTER TABLE "crm_lead" ADD COLUMN "requestedService" text;
CREATE INDEX "crm_lead_origin_idx" ON "crm_lead" USING btree ("origin");
--
-- ACTION ALTER TABLE
--
ALTER TABLE "crm_opportunity" ADD COLUMN "serviceFrequency" text NOT NULL DEFAULT 'Lunes a Viernes'::text;
ALTER TABLE "crm_opportunity" ADD COLUMN "scheduleHours" text;
ALTER TABLE "crm_opportunity" ADD COLUMN "billingCycleDay" bigint DEFAULT 5;
ALTER TABLE "crm_opportunity" ADD COLUMN "specificRequirements" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "crm_quote_item" ADD COLUMN "catalogItemId" bigint;
ALTER TABLE "crm_quote_item" ADD COLUMN "catalogVersion" bigint;
ALTER TABLE "crm_quote_item" ADD COLUMN "calculationType" text NOT NULL DEFAULT 'PER_UNIT'::text;
ALTER TABLE "crm_quote_item" ADD COLUMN "metadata" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "crm_sector" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "name" text NOT NULL,
    "description" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_sector_code_unique_idx" ON "crm_sector" USING btree ("code");
CREATE UNIQUE INDEX "crm_sector_name_unique_idx" ON "crm_sector" USING btree ("name");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "crm_service_line" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "name" text NOT NULL,
    "category" text NOT NULL,
    "description" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_service_line_code_unique_idx" ON "crm_service_line" USING btree ("code");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "crm_catalog_item"
    ADD CONSTRAINT "crm_catalog_item_fk_0"
    FOREIGN KEY("serviceLineId")
    REFERENCES "crm_service_line"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "crm_catalog_item_scope"
    ADD CONSTRAINT "crm_catalog_item_scope_fk_0"
    FOREIGN KEY("catalogItemId")
    REFERENCES "crm_catalog_item"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "crm_catalog_item_scope"
    ADD CONSTRAINT "crm_catalog_item_scope_fk_1"
    FOREIGN KEY("sectorId")
    REFERENCES "crm_sector"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "crm_catalog_item_scope"
    ADD CONSTRAINT "crm_catalog_item_scope_fk_2"
    FOREIGN KEY("serviceLineId")
    REFERENCES "crm_service_line"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260923154230704', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260923154230704', "timestamp" = now();

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
