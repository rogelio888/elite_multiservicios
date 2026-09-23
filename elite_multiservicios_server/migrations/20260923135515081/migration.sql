BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounting_cost_center" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "contractId" bigint,
    "status" text NOT NULL DEFAULT 'Activo'::text,
    "description" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "acc_cost_center_status_idx" ON "accounting_cost_center" USING btree ("status");
CREATE INDEX "acc_cost_center_contract_idx" ON "accounting_cost_center" USING btree ("contractId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounting_expense" (
    "id" bigserial PRIMARY KEY,
    "supplierName" text NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "amount" double precision NOT NULL,
    "costCenterId" bigint,
    "category" text NOT NULL,
    "status" text NOT NULL DEFAULT 'Pending'::text,
    "description" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "acc_expense_cost_center_idx" ON "accounting_expense" USING btree ("costCenterId");
CREATE INDEX "acc_expense_status_idx" ON "accounting_expense" USING btree ("status");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounting_invoice" (
    "id" bigserial PRIMARY KEY,
    "invoiceNumber" text NOT NULL,
    "customerId" bigint NOT NULL,
    "issueDate" timestamp without time zone NOT NULL,
    "dueDate" timestamp without time zone NOT NULL,
    "totalAmount" double precision NOT NULL,
    "status" text NOT NULL DEFAULT 'Pending'::text,
    "notes" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "acc_invoice_number_idx" ON "accounting_invoice" USING btree ("invoiceNumber");
CREATE INDEX "acc_invoice_customer_idx" ON "accounting_invoice" USING btree ("customerId");
CREATE INDEX "acc_invoice_status_idx" ON "accounting_invoice" USING btree ("status");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "accounting_transaction" (
    "id" bigserial PRIMARY KEY,
    "date" timestamp without time zone NOT NULL,
    "amount" double precision NOT NULL,
    "type" text NOT NULL,
    "referenceId" bigint,
    "account" text,
    "notes" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "acc_tx_type_idx" ON "accounting_transaction" USING btree ("type");
CREATE INDEX "acc_tx_reference_idx" ON "accounting_transaction" USING btree ("referenceId");


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260923135515081', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260923135515081', "timestamp" = now();

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
