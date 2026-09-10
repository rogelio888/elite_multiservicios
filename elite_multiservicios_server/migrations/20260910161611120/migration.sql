BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_permission" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "module" text NOT NULL,
    "description" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "app_permission_code_idx" ON "app_permission" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_role" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "isSystemRole" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "app_role_name_idx" ON "app_role" USING btree ("name");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_user" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "fullName" text NOT NULL,
    "userInfoId" bigint,
    "isActive" boolean NOT NULL,
    "isDeleted" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "app_user_email_idx" ON "app_user" USING btree ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "audit_log" (
    "id" bigserial PRIMARY KEY,
    "action" text NOT NULL,
    "userId" bigint,
    "userIdentifier" text,
    "resource" text,
    "ipAddress" text,
    "result" text NOT NULL,
    "metadata" text,
    "timestamp" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "audit_log_timestamp_idx" ON "audit_log" USING btree ("timestamp");
CREATE INDEX "audit_log_action_idx" ON "audit_log" USING btree ("action");
CREATE INDEX "audit_log_user_idx" ON "audit_log" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "role_permission" (
    "id" bigserial PRIMARY KEY,
    "roleId" bigint NOT NULL,
    "permissionId" bigint NOT NULL,
    "assignedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "role_permission_composite_idx" ON "role_permission" USING btree ("roleId", "permissionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_role" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "roleId" bigint NOT NULL,
    "assignedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_role_composite_idx" ON "user_role" USING btree ("userId", "roleId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_session" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "sessionTokenHash" text NOT NULL,
    "ipAddress" text,
    "deviceInfo" text,
    "isRevoked" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "lastActivityAt" timestamp without time zone NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_session_token_hash_idx" ON "user_session" USING btree ("sessionTokenHash");
CREATE INDEX "user_session_user_idx" ON "user_session" USING btree ("userId");
CREATE INDEX "user_session_expires_idx" ON "user_session" USING btree ("expiresAt");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "audit_log"
    ADD CONSTRAINT "audit_log_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "role_permission"
    ADD CONSTRAINT "role_permission_fk_0"
    FOREIGN KEY("roleId")
    REFERENCES "app_role"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "role_permission"
    ADD CONSTRAINT "role_permission_fk_1"
    FOREIGN KEY("permissionId")
    REFERENCES "app_permission"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user_role"
    ADD CONSTRAINT "user_role_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "user_role"
    ADD CONSTRAINT "user_role_fk_1"
    FOREIGN KEY("roleId")
    REFERENCES "app_role"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user_session"
    ADD CONSTRAINT "user_session_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260910161611120', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260910161611120', "timestamp" = now();

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
