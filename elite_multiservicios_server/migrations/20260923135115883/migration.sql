BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_employee" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "fullName" text NOT NULL,
    "birthDate" timestamp without time zone,
    "birthPlace" text NOT NULL,
    "identityCard" text NOT NULL,
    "phone" text NOT NULL,
    "address" text NOT NULL,
    "occupation" text NOT NULL,
    "personalReference" text NOT NULL,
    "referencePhone" text NOT NULL,
    "employeeType" text NOT NULL,
    "area" text NOT NULL,
    "areaId" bigint,
    "position" text NOT NULL,
    "positionId" bigint,
    "specialty" text NOT NULL,
    "specialtyId" bigint,
    "workplace" text NOT NULL,
    "supervisor" text NOT NULL,
    "supervisorId" bigint,
    "realStartDate" timestamp without time zone NOT NULL,
    "fiscalStartDate" timestamp without time zone NOT NULL,
    "agreedSalary" double precision NOT NULL,
    "contractType" text NOT NULL,
    "contractEndDate" timestamp without time zone,
    "observations" text,
    "status" text NOT NULL DEFAULT 'ACTIVO'::text,
    "skills" json,
    "availabilityStatus" text NOT NULL DEFAULT 'DISPONIBLE'::text,
    "paymentModality" text NOT NULL DEFAULT 'MENSUAL'::text,
    "workScheduleType" text NOT NULL DEFAULT 'TIEMPO_COMPLETO_48H'::text,
    "hasCiCopy" boolean NOT NULL DEFAULT true,
    "hasUtilityBill" boolean NOT NULL DEFAULT true,
    "hasHomeSketch" boolean NOT NULL DEFAULT true,
    "hasFelccRecord" boolean NOT NULL DEFAULT true,
    "hasPhoto3x4" boolean NOT NULL DEFAULT true,
    "hasSusInsurance" boolean NOT NULL DEFAULT true,
    "photoUrl" text,
    "corporateEmail" text,
    "temporaryPassword" text,
    "applicantId" bigint,
    "exitDate" timestamp without time zone,
    "exitReason" text,
    "exitObservations" text,
    "exitRegisteredBy" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "rrhh_employee_code_unique_idx" ON "rrhh_employee" USING btree ("code");
CREATE INDEX "rrhh_employee_ci_idx" ON "rrhh_employee" USING btree ("identityCard");
CREATE INDEX "rrhh_employee_status_idx" ON "rrhh_employee" USING btree ("status");
CREATE INDEX "rrhh_employee_type_idx" ON "rrhh_employee" USING btree ("employeeType");
CREATE INDEX "rrhh_employee_availability_idx" ON "rrhh_employee" USING btree ("availabilityStatus");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_employee_document" (
    "id" bigserial PRIMARY KEY,
    "employeeId" bigint NOT NULL,
    "documentType" text NOT NULL,
    "title" text NOT NULL,
    "fileUrl" text NOT NULL,
    "fileName" text NOT NULL,
    "fileSizeBytes" bigint DEFAULT 0,
    "mimeType" text,
    "isVerified" boolean NOT NULL DEFAULT true,
    "verifiedBy" text,
    "verifiedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "rrhh_emp_doc_emp_type_idx" ON "rrhh_employee_document" USING btree ("employeeId", "documentType");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_timeline_event" (
    "id" bigserial PRIMARY KEY,
    "employeeId" bigint NOT NULL,
    "date" timestamp without time zone NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "category" text NOT NULL,
    "registeredBy" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "rrhh_timeline_employee_idx" ON "rrhh_timeline_event" USING btree ("employeeId", "date");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "rrhh_employee"
    ADD CONSTRAINT "rrhh_employee_fk_0"
    FOREIGN KEY("areaId")
    REFERENCES "rrhh_area"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rrhh_employee"
    ADD CONSTRAINT "rrhh_employee_fk_1"
    FOREIGN KEY("positionId")
    REFERENCES "rrhh_position"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rrhh_employee"
    ADD CONSTRAINT "rrhh_employee_fk_2"
    FOREIGN KEY("specialtyId")
    REFERENCES "rrhh_specialty"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rrhh_employee"
    ADD CONSTRAINT "rrhh_employee_fk_3"
    FOREIGN KEY("supervisorId")
    REFERENCES "rrhh_employee"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rrhh_employee"
    ADD CONSTRAINT "rrhh_employee_fk_4"
    FOREIGN KEY("applicantId")
    REFERENCES "rrhh_applicant"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "rrhh_employee_document"
    ADD CONSTRAINT "rrhh_employee_document_fk_0"
    FOREIGN KEY("employeeId")
    REFERENCES "rrhh_employee"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "rrhh_timeline_event"
    ADD CONSTRAINT "rrhh_timeline_event_fk_0"
    FOREIGN KEY("employeeId")
    REFERENCES "rrhh_employee"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260923135115883', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260923135115883', "timestamp" = now();

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
