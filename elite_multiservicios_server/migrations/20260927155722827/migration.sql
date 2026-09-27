BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "rrhh_employee" ADD COLUMN "bankName" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "accountType" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "accountNumber" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "afpName" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "afpNumber" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "healthInsurance" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "fullAddress" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "maritalStatus" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "childrenCount" bigint;
ALTER TABLE "rrhh_employee" ADD COLUMN "emergencyContactName" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "emergencyContactPhone" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "emergencyContactRelation" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "workdayType" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "contractStartDate" timestamp without time zone;
ALTER TABLE "rrhh_employee" ADD COLUMN "contractSignedPdfUrl" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "bonuses" json;
ALTER TABLE "rrhh_employee" ADD COLUMN "deductions" json;
ALTER TABLE "rrhh_employee" ADD COLUMN "shiftId" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "baseLocation" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "supervisorEmployeeId" text;
ALTER TABLE "rrhh_employee" ADD COLUMN "documentChecklist" json;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "rrhh_employee_document" ADD COLUMN "isDeleted" boolean NOT NULL DEFAULT false;
ALTER TABLE "rrhh_employee_document" ADD COLUMN "deletedAt" timestamp without time zone;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_hiring_dossier" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "applicantId" bigint,
    "applicantCode" text NOT NULL,
    "applicantName" text NOT NULL,
    "employeeId" bigint,
    "convertedEmployeeCode" text,
    "status" text NOT NULL DEFAULT 'abierto'::text,
    "section1Status" text NOT NULL DEFAULT 'pendiente'::text,
    "section2Status" text NOT NULL DEFAULT 'pendiente'::text,
    "section3Status" text NOT NULL DEFAULT 'pendiente'::text,
    "section4Status" text NOT NULL DEFAULT 'pendiente'::text,
    "section5Status" text NOT NULL DEFAULT 'pendiente'::text,
    "section6Status" text NOT NULL DEFAULT 'pendiente'::text,
    "documentChecklist" json,
    "afpName" text,
    "afpNumber" text,
    "healthInsurance" text,
    "section2Notes" text,
    "fullAddress" text,
    "maritalStatus" text,
    "childrenCount" bigint,
    "emergencyContactName" text,
    "emergencyContactPhone" text,
    "emergencyContactRelation" text,
    "contractType" text,
    "workdayType" text,
    "paymentModality" text,
    "baseSalary" double precision,
    "contractStartDate" timestamp without time zone,
    "contractEndDate" timestamp without time zone,
    "bonuses" json,
    "deductions" json,
    "section4Notes" text,
    "areaId" bigint,
    "positionId" bigint,
    "shiftId" text,
    "scheduleId" text,
    "baseLocation" text,
    "supervisorEmployeeId" text,
    "effectiveStartDate" timestamp without time zone,
    "section5Notes" text,
    "closingNotes" text,
    "approvedBy" text,
    "approvedAt" timestamp without time zone,
    "createdBy" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "closedAt" timestamp without time zone,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "rrhh_hiring_dossier_code_unique_idx" ON "rrhh_hiring_dossier" USING btree ("code");
CREATE INDEX "rrhh_hiring_dossier_status_idx" ON "rrhh_hiring_dossier" USING btree ("status");
CREATE INDEX "rrhh_hiring_dossier_applicant_idx" ON "rrhh_hiring_dossier" USING btree ("applicantId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "rrhh_hiring_dossier"
    ADD CONSTRAINT "rrhh_hiring_dossier_fk_0"
    FOREIGN KEY("applicantId")
    REFERENCES "rrhh_applicant"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rrhh_hiring_dossier"
    ADD CONSTRAINT "rrhh_hiring_dossier_fk_1"
    FOREIGN KEY("employeeId")
    REFERENCES "rrhh_employee"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rrhh_hiring_dossier"
    ADD CONSTRAINT "rrhh_hiring_dossier_fk_2"
    FOREIGN KEY("areaId")
    REFERENCES "rrhh_area"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rrhh_hiring_dossier"
    ADD CONSTRAINT "rrhh_hiring_dossier_fk_3"
    FOREIGN KEY("positionId")
    REFERENCES "rrhh_position"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260927155722827', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260927155722827', "timestamp" = now();

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
