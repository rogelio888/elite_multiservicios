BEGIN;

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
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260923132810894', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260923132810894', "timestamp" = now();

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
