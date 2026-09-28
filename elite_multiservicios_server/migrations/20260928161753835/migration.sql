BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "hr_attendance" (
    "id" bigserial PRIMARY KEY,
    "employeeId" bigint NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "checkIn" timestamp without time zone,
    "checkOut" timestamp without time zone,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "hr_attendance_emp_date_idx" ON "hr_attendance" USING btree ("employeeId", "date");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "hr_employee" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "position" text NOT NULL,
    "baseSalary" double precision NOT NULL,
    "joinDate" timestamp without time zone NOT NULL,
    "isActive" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "hr_payroll" (
    "id" bigserial PRIMARY KEY,
    "employeeId" bigint NOT NULL,
    "month" bigint NOT NULL,
    "year" bigint NOT NULL,
    "baseSalary" double precision NOT NULL,
    "bonuses" double precision NOT NULL DEFAULT 0.0,
    "deductions" double precision NOT NULL DEFAULT 0.0,
    "netPay" double precision NOT NULL,
    "isPaid" boolean NOT NULL DEFAULT false,
    "paymentDate" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "hr_payroll_emp_month_year_idx" ON "hr_payroll" USING btree ("employeeId", "month", "year");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ops_inventory_item" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "unit" text NOT NULL,
    "quantityInStock" double precision NOT NULL DEFAULT 0.0,
    "averageCost" double precision NOT NULL DEFAULT 0.0,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ops_inventory_usage" (
    "id" bigserial PRIMARY KEY,
    "workOrderId" bigint NOT NULL,
    "itemId" bigint NOT NULL,
    "quantityUsed" double precision NOT NULL,
    "totalCost" double precision NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ops_service_contract" (
    "id" bigserial PRIMARY KEY,
    "customerId" bigint NOT NULL,
    "serviceType" text NOT NULL,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone,
    "status" text NOT NULL DEFAULT 'Pending'::text,
    "totalAmount" double precision NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ops_work_order" (
    "id" bigserial PRIMARY KEY,
    "contractId" bigint NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "assignedEmployeeId" bigint,
    "status" text NOT NULL DEFAULT 'Pending'::text,
    "notes" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260928161753835', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260928161753835', "timestamp" = now();

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
