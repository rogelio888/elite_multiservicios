BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_incident" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "employeeId" bigint NOT NULL,
    "employeeCode" text NOT NULL,
    "employeeName" text NOT NULL,
    "incidentType" text NOT NULL,
    "severity" text NOT NULL,
    "incidentDate" timestamp without time zone NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "actionTaken" text NOT NULL,
    "isJustified" boolean NOT NULL DEFAULT false,
    "recordedByUserId" bigint,
    "documentReferenceUrl" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "rrhh_incident_code_unique_idx" ON "rrhh_incident" USING btree ("code");
CREATE INDEX "rrhh_incident_employee_type_idx" ON "rrhh_incident" USING btree ("employeeId", "incidentType");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_leave_request" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "employeeId" bigint NOT NULL,
    "employeeCode" text NOT NULL,
    "employeeName" text NOT NULL,
    "leaveType" text NOT NULL,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone NOT NULL,
    "daysCount" bigint NOT NULL,
    "hoursCount" double precision,
    "reason" text NOT NULL,
    "medicalCertificateNumber" text,
    "attachmentUrl" text,
    "status" text NOT NULL DEFAULT 'PENDIENTE'::text,
    "resolutionNotes" text,
    "resolvedByUserId" bigint,
    "resolvedAt" timestamp without time zone,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "rrhh_leave_code_unique_idx" ON "rrhh_leave_request" USING btree ("code");
CREATE INDEX "rrhh_leave_employee_status_idx" ON "rrhh_leave_request" USING btree ("employeeId", "status");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_movement_history" (
    "id" bigserial PRIMARY KEY,
    "employeeId" bigint NOT NULL,
    "employeeCode" text NOT NULL,
    "employeeName" text NOT NULL,
    "movementType" text NOT NULL,
    "previousValue" text,
    "newValue" text NOT NULL,
    "effectiveDate" timestamp without time zone NOT NULL,
    "reason" text NOT NULL,
    "authorizedBy" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "rrhh_movement_employee_idx" ON "rrhh_movement_history" USING btree ("employeeId", "effectiveDate");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_termination" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "employeeId" bigint NOT NULL,
    "employeeCode" text NOT NULL,
    "employeeName" text NOT NULL,
    "employeeCi" text NOT NULL,
    "contractType" text NOT NULL,
    "entryDate" timestamp without time zone NOT NULL,
    "terminationDate" timestamp without time zone NOT NULL,
    "lastWorkingDay" timestamp without time zone NOT NULL,
    "reason" text NOT NULL,
    "detailedReason" text NOT NULL,
    "yearsOfService" double precision NOT NULL,
    "severanceAmount" double precision,
    "clearanceCompleted" boolean NOT NULL DEFAULT false,
    "isEligibleForRehire" boolean NOT NULL DEFAULT true,
    "processedByUserId" bigint,
    "handoverNotes" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "rrhh_termination_code_unique_idx" ON "rrhh_termination" USING btree ("code");
CREATE INDEX "rrhh_termination_employee_idx" ON "rrhh_termination" USING btree ("employeeId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_vacation" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "employeeId" bigint NOT NULL,
    "employeeCode" text NOT NULL,
    "employeeName" text NOT NULL,
    "periodYear" bigint NOT NULL,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone NOT NULL,
    "daysRequested" bigint NOT NULL,
    "totalAccruedDays" bigint NOT NULL,
    "remainingBalanceDays" bigint NOT NULL,
    "status" text NOT NULL DEFAULT 'SOLICITADA'::text,
    "approvedByUserId" bigint,
    "approvedAt" timestamp without time zone,
    "notes" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "rrhh_vacation_code_unique_idx" ON "rrhh_vacation" USING btree ("code");
CREATE INDEX "rrhh_vacation_employee_idx" ON "rrhh_vacation" USING btree ("employeeId", "periodYear");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "rrhh_incident"
    ADD CONSTRAINT "rrhh_incident_fk_0"
    FOREIGN KEY("employeeId")
    REFERENCES "rrhh_employee"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "rrhh_leave_request"
    ADD CONSTRAINT "rrhh_leave_request_fk_0"
    FOREIGN KEY("employeeId")
    REFERENCES "rrhh_employee"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "rrhh_movement_history"
    ADD CONSTRAINT "rrhh_movement_history_fk_0"
    FOREIGN KEY("employeeId")
    REFERENCES "rrhh_employee"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "rrhh_termination"
    ADD CONSTRAINT "rrhh_termination_fk_0"
    FOREIGN KEY("employeeId")
    REFERENCES "rrhh_employee"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "rrhh_vacation"
    ADD CONSTRAINT "rrhh_vacation_fk_0"
    FOREIGN KEY("employeeId")
    REFERENCES "rrhh_employee"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260923153226709', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260923153226709', "timestamp" = now();

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
