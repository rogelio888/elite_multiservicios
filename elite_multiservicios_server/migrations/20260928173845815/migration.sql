BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "accounting_budget" CASCADE;

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
    "executedExpenses" double precision NOT NULL,
    "estimatedBalance" double precision NOT NULL
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "accounting_expense" DROP COLUMN "dueDate";
ALTER TABLE "accounting_expense" DROP COLUMN "currency";
ALTER TABLE "accounting_expense" DROP COLUMN "originalAmount";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "accounting_payroll_est" DROP COLUMN "isProcessed";
--
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_applicant" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "fullName" text NOT NULL,
    "identityCard" text NOT NULL,
    "phone" text NOT NULL,
    "email" text,
    "address" text,
    "birthDate" timestamp without time zone,
    "emergencyContact" text,
    "emergencyPhone" text,
    "targetArea" text,
    "areaId" bigint,
    "targetPosition" text,
    "positionId" bigint,
    "targetType" text NOT NULL,
    "specialty" text,
    "specialtyId" bigint,
    "education" text,
    "experienceSummary" text,
    "skills" text,
    "referencePerson" text,
    "referencePhone" text,
    "applicationDate" timestamp without time zone NOT NULL,
    "status" text NOT NULL DEFAULT 'NUEVO'::text,
    "interviewNotes" text,
    "expectedSalary" double precision DEFAULT 0.0,
    "hasCvAttached" boolean NOT NULL DEFAULT true,
    "hasIdentityCardCopy" boolean NOT NULL DEFAULT true,
    "cvUrl" text,
    "discardReason" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "rrhh_applicant_code_unique_idx" ON "rrhh_applicant" USING btree ("code");
CREATE INDEX "rrhh_applicant_ci_idx" ON "rrhh_applicant" USING btree ("identityCard");
CREATE INDEX "rrhh_applicant_status_idx" ON "rrhh_applicant" USING btree ("status");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_area" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "name" text NOT NULL,
    "description" text,
    "colorTag" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "rrhh_area_code_unique_idx" ON "rrhh_area" USING btree ("code");
CREATE UNIQUE INDEX "rrhh_area_name_unique_idx" ON "rrhh_area" USING btree ("name");

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
    "agreedSalary" double precision,
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
    "bankName" text,
    "accountType" text,
    "accountNumber" text,
    "afpName" text,
    "afpNumber" text,
    "healthInsurance" text,
    "fullAddress" text,
    "maritalStatus" text,
    "childrenCount" bigint,
    "emergencyContactName" text,
    "emergencyContactPhone" text,
    "emergencyContactRelation" text,
    "workdayType" text,
    "contractStartDate" timestamp without time zone,
    "contractSignedPdfUrl" text,
    "bonuses" json,
    "deductions" json,
    "shiftId" text,
    "baseLocation" text,
    "supervisorEmployeeId" text,
    "documentChecklist" json,
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
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "rrhh_emp_doc_emp_type_idx" ON "rrhh_employee_document" USING btree ("employeeId", "documentType");

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
CREATE TABLE "rrhh_position" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "areaId" bigint NOT NULL,
    "name" text NOT NULL,
    "workplaceType" text NOT NULL,
    "suggestedSalary" double precision DEFAULT 0.0,
    "description" text,
    "requirements" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "rrhh_position_code_unique_idx" ON "rrhh_position" USING btree ("code");
CREATE UNIQUE INDEX "rrhh_position_area_name_unique_idx" ON "rrhh_position" USING btree ("areaId", "name");

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
-- ACTION CREATE TABLE
--
CREATE TABLE "rrhh_specialty" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "name" text NOT NULL,
    "description" text,
    "colorTag" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "rrhh_specialty_code_unique_idx" ON "rrhh_specialty" USING btree ("code");
CREATE UNIQUE INDEX "rrhh_specialty_name_unique_idx" ON "rrhh_specialty" USING btree ("name");

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
-- ACTION ALTER TABLE
--
DROP INDEX "user_session_token_hash_idx";
ALTER TABLE "user_session" ADD COLUMN "authSessionId" text;
ALTER TABLE "user_session" ADD COLUMN "reconcileAttempts" bigint NOT NULL DEFAULT 0;
ALTER TABLE "user_session" ALTER COLUMN "sessionTokenHash" DROP NOT NULL;
CREATE INDEX "user_session_auth_id_idx" ON "user_session" USING btree ("authSessionId");
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "rrhh_applicant"
    ADD CONSTRAINT "rrhh_applicant_fk_0"
    FOREIGN KEY("areaId")
    REFERENCES "rrhh_area"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rrhh_applicant"
    ADD CONSTRAINT "rrhh_applicant_fk_1"
    FOREIGN KEY("positionId")
    REFERENCES "rrhh_position"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "rrhh_applicant"
    ADD CONSTRAINT "rrhh_applicant_fk_2"
    FOREIGN KEY("specialtyId")
    REFERENCES "rrhh_specialty"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

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
ALTER TABLE ONLY "rrhh_position"
    ADD CONSTRAINT "rrhh_position_fk_0"
    FOREIGN KEY("areaId")
    REFERENCES "rrhh_area"("id")
    ON DELETE CASCADE
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
ALTER TABLE ONLY "rrhh_timeline_event"
    ADD CONSTRAINT "rrhh_timeline_event_fk_0"
    FOREIGN KEY("employeeId")
    REFERENCES "rrhh_employee"("id")
    ON DELETE CASCADE
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
    VALUES ('elite_multiservicios', '20260928173845815', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260928173845815', "timestamp" = now();

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
