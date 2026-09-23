BEGIN;

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
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "rrhh_position"
    ADD CONSTRAINT "rrhh_position_fk_0"
    FOREIGN KEY("areaId")
    REFERENCES "rrhh_area"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260923131047544', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260923131047544', "timestamp" = now();

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
