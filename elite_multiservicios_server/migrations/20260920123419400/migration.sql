BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "crm_contract_budget_item" (
    "id" bigserial PRIMARY KEY,
    "contractId" bigint NOT NULL,
    "description" text NOT NULL,
    "quantity" double precision NOT NULL,
    "unit" text NOT NULL,
    "unitPrice" double precision NOT NULL,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "crm_contract_budget_item_contract_idx" ON "crm_contract_budget_item" USING btree ("contractId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "crm_customer" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "legalName" text NOT NULL,
    "tradeName" text NOT NULL,
    "taxId" text NOT NULL,
    "segment" text NOT NULL,
    "status" text NOT NULL DEFAULT 'Activo'::text,
    "activeServices" json NOT NULL,
    "contactPerson" text NOT NULL,
    "phone" text NOT NULL,
    "email" text NOT NULL,
    "opportunityId" bigint,
    "startDate" timestamp without time zone,
    "notes" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_customer_code_idx" ON "crm_customer" USING btree ("code");
CREATE INDEX "crm_customer_tax_id_idx" ON "crm_customer" USING btree ("taxId");
CREATE INDEX "crm_customer_status_idx" ON "crm_customer" USING btree ("status");
CREATE INDEX "crm_customer_segment_idx" ON "crm_customer" USING btree ("segment");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "crm_customer_branch" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "customerId" bigint NOT NULL,
    "name" text NOT NULL,
    "address" text NOT NULL,
    "localContact" text NOT NULL,
    "localPhone" text NOT NULL,
    "isHeadquarters" boolean NOT NULL DEFAULT false,
    "notes" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "crm_customer_branch_customer_idx" ON "crm_customer_branch" USING btree ("customerId");
CREATE INDEX "crm_customer_branch_code_idx" ON "crm_customer_branch" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "crm_customer_contract" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "customerId" bigint NOT NULL,
    "branchId" bigint,
    "title" text NOT NULL,
    "contractType" text NOT NULL,
    "serviceCategory" text NOT NULL,
    "totalAmount" double precision NOT NULL,
    "recurringMonthlyAmount" double precision NOT NULL DEFAULT 0.0,
    "oneTimeAmount" double precision NOT NULL DEFAULT 0.0,
    "paymentTerms" text NOT NULL,
    "executionTime" text NOT NULL,
    "advancePercentage" bigint NOT NULL DEFAULT 0,
    "status" text NOT NULL DEFAULT 'Vigente'::text,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone,
    "actualEndDate" timestamp without time zone,
    "originType" text NOT NULL DEFAULT 'Venta Nueva'::text,
    "serviceScope" text,
    "completionNotes" text,
    "satisfactionRating" bigint,
    "completedBy" text,
    "notes" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "crm_customer_contract_customer_idx" ON "crm_customer_contract" USING btree ("customerId");
CREATE INDEX "crm_customer_contract_branch_idx" ON "crm_customer_contract" USING btree ("branchId");
CREATE INDEX "crm_customer_contract_status_idx" ON "crm_customer_contract" USING btree ("status");
CREATE INDEX "crm_customer_contract_code_idx" ON "crm_customer_contract" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "crm_opportunity" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "title" text NOT NULL,
    "clientName" text NOT NULL,
    "contactPerson" text NOT NULL,
    "phone" text NOT NULL,
    "serviceType" text NOT NULL,
    "amount" double precision NOT NULL,
    "stage" text NOT NULL DEFAULT 'Calificación'::text,
    "probability" bigint NOT NULL DEFAULT 20,
    "owner" text NOT NULL,
    "closingDate" text NOT NULL,
    "notes" text,
    "contractType" text NOT NULL DEFAULT 'Recurrente Mensual'::text,
    "executionTime" text NOT NULL DEFAULT '12 meses'::text,
    "paymentTerms" text NOT NULL DEFAULT 'Facturación mensual a 30 días'::text,
    "advancePercentage" bigint NOT NULL DEFAULT 0,
    "contactRole" text NOT NULL DEFAULT 'Administrador'::text,
    "businessSegment" text NOT NULL DEFAULT 'Corporativo B2B'::text,
    "siteName" text,
    "siteAddress" text,
    "siteCity" text NOT NULL DEFAULT 'Santa Cruz'::text,
    "siteContactName" text,
    "siteContactPhone" text,
    "siteAccessRequirements" text,
    "isSiteHeadquarters" boolean NOT NULL DEFAULT true,
    "legalBusinessName" text,
    "taxId" text,
    "legalRepresentative" text,
    "billingEmail" text,
    "serviceStartDate" text,
    "advancePaid" double precision NOT NULL DEFAULT 0.0,
    "wonNotes" text,
    "leadId" bigint,
    "customerId" bigint,
    "branchId" bigint,
    "branchName" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_opportunity_code_idx" ON "crm_opportunity" USING btree ("code");
CREATE INDEX "crm_opportunity_stage_idx" ON "crm_opportunity" USING btree ("stage");
CREATE INDEX "crm_opportunity_customer_idx" ON "crm_opportunity" USING btree ("customerId");
CREATE INDEX "crm_opportunity_lead_idx" ON "crm_opportunity" USING btree ("leadId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "crm_quote_item" (
    "id" bigserial PRIMARY KEY,
    "opportunityId" bigint NOT NULL,
    "category" text NOT NULL,
    "concept" text NOT NULL,
    "unitType" text NOT NULL,
    "quantity" double precision NOT NULL,
    "unitPrice" double precision NOT NULL,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "crm_quote_item_opportunity_idx" ON "crm_quote_item" USING btree ("opportunityId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "crm_task" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "title" text NOT NULL,
    "taskType" text NOT NULL,
    "clientName" text NOT NULL,
    "contactPerson" text NOT NULL,
    "phone" text NOT NULL,
    "scheduledAt" timestamp without time zone NOT NULL,
    "scheduledTimeText" text NOT NULL,
    "priority" text NOT NULL DEFAULT 'Media'::text,
    "status" text NOT NULL DEFAULT 'Pendiente'::text,
    "callContext" text,
    "notes" text,
    "leadId" bigint,
    "opportunityId" bigint,
    "customerId" bigint,
    "contractId" bigint,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_task_code_idx" ON "crm_task" USING btree ("code");
CREATE INDEX "crm_task_scheduled_idx" ON "crm_task" USING btree ("scheduledAt");
CREATE INDEX "crm_task_status_idx" ON "crm_task" USING btree ("status");
CREATE INDEX "crm_task_type_idx" ON "crm_task" USING btree ("taskType");
CREATE INDEX "crm_task_customer_idx" ON "crm_task" USING btree ("customerId");
CREATE INDEX "crm_task_opportunity_idx" ON "crm_task" USING btree ("opportunityId");
CREATE INDEX "crm_task_lead_idx" ON "crm_task" USING btree ("leadId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "crm_contract_budget_item"
    ADD CONSTRAINT "crm_contract_budget_item_fk_0"
    FOREIGN KEY("contractId")
    REFERENCES "crm_customer_contract"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "crm_customer_branch"
    ADD CONSTRAINT "crm_customer_branch_fk_0"
    FOREIGN KEY("customerId")
    REFERENCES "crm_customer"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "crm_customer_contract"
    ADD CONSTRAINT "crm_customer_contract_fk_0"
    FOREIGN KEY("customerId")
    REFERENCES "crm_customer"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "crm_customer_contract"
    ADD CONSTRAINT "crm_customer_contract_fk_1"
    FOREIGN KEY("branchId")
    REFERENCES "crm_customer_branch"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "crm_quote_item"
    ADD CONSTRAINT "crm_quote_item_fk_0"
    FOREIGN KEY("opportunityId")
    REFERENCES "crm_opportunity"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260920123419400', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260920123419400', "timestamp" = now();

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
