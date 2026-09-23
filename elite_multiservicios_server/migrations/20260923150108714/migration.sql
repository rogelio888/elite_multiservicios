BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_assignment" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "employeeId" bigint NOT NULL,
    "employeeCode" text NOT NULL,
    "employeeName" text NOT NULL,
    "assignmentType" text NOT NULL,
    "officeAreaId" bigint,
    "officeAreaName" text,
    "officeRole" text,
    "customerId" bigint,
    "customerCompanyName" text,
    "workplaceBranch" text,
    "contractedServiceName" text,
    "supervisorName" text NOT NULL,
    "supervisorEmployeeId" bigint,
    "scheduleId" bigint NOT NULL,
    "scheduleName" text NOT NULL,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone,
    "status" text NOT NULL DEFAULT 'ACTIVA'::text,
    "rotationNumber" bigint NOT NULL DEFAULT 0,
    "originDescription" text,
    "rotationReason" text,
    "notes" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "rrhh_assignment_code_unique_idx" ON "rrhh_assignment" USING btree ("code");
CREATE INDEX "rrhh_assignment_employee_status_idx" ON "rrhh_assignment" USING btree ("employeeId", "status");
CREATE INDEX "rrhh_assignment_type_idx" ON "rrhh_assignment" USING btree ("assignmentType");
CREATE INDEX "rrhh_assignment_status_idx" ON "rrhh_assignment" USING btree ("status");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_schedule" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "name" text NOT NULL,
    "targetType" text NOT NULL DEFAULT 'AMBOS'::text,
    "startTime" text NOT NULL,
    "endTime" text NOT NULL,
    "workDays" json NOT NULL,
    "toleranceMinutes" bigint NOT NULL DEFAULT 10,
    "isNightShift" boolean NOT NULL DEFAULT false,
    "description" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "rrhh_schedule_code_unique_idx" ON "rrhh_schedule" USING btree ("code");
CREATE INDEX "rrhh_schedule_type_idx" ON "rrhh_schedule" USING btree ("targetType");
CREATE INDEX "rrhh_schedule_active_idx" ON "rrhh_schedule" USING btree ("isActive");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "rrhh_assignment"
    ADD CONSTRAINT "rrhh_assignment_fk_0"
    FOREIGN KEY("employeeId")
    REFERENCES "rrhh_employee"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rrhh_assignment"
    ADD CONSTRAINT "rrhh_assignment_fk_1"
    FOREIGN KEY("officeAreaId")
    REFERENCES "rrhh_area"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rrhh_assignment"
    ADD CONSTRAINT "rrhh_assignment_fk_2"
    FOREIGN KEY("supervisorEmployeeId")
    REFERENCES "rrhh_employee"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rrhh_assignment"
    ADD CONSTRAINT "rrhh_assignment_fk_3"
    FOREIGN KEY("scheduleId")
    REFERENCES "rrhh_schedule"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260923150108714', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260923150108714', "timestamp" = now();

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
