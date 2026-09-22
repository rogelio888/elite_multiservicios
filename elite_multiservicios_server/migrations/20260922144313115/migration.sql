BEGIN;

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
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260922144313115', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260922144313115', "timestamp" = now();

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
