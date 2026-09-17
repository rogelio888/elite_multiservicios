BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "crm_lead" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "company" text NOT NULL,
    "companyUrl" text,
    "sector" text NOT NULL,
    "advisor" text NOT NULL,
    "advisorUserId" bigint,
    "address" text NOT NULL,
    "phone" text NOT NULL,
    "emailOrWeb" text,
    "status" text NOT NULL DEFAULT 'Prospectado'::text,
    "temperature" text NOT NULL DEFAULT 'Templado'::text,
    "contactPerson" text NOT NULL,
    "notes" text,
    "estimatedValue" double precision NOT NULL DEFAULT 0.0,
    "isPromoted" boolean NOT NULL DEFAULT false,
    "promotedOpportunityId" bigint,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_lead_code_idx" ON "crm_lead" USING btree ("code");
CREATE INDEX "crm_lead_status_idx" ON "crm_lead" USING btree ("status");
CREATE INDEX "crm_lead_sector_idx" ON "crm_lead" USING btree ("sector");
CREATE INDEX "crm_lead_temperature_idx" ON "crm_lead" USING btree ("temperature");


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260917155532754', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260917155532754', "timestamp" = now();

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
