BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "app_user" ADD COLUMN "mfaEnabled" boolean NOT NULL DEFAULT false;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "mfa_challenge" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "challengeId" text NOT NULL,
    "codeHash" text NOT NULL,
    "attempts" bigint NOT NULL DEFAULT 0,
    "isUsed" boolean NOT NULL DEFAULT false,
    "expiresAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "mfa_challenge_challenge_id_idx" ON "mfa_challenge" USING btree ("challengeId");
CREATE INDEX "mfa_challenge_user_idx" ON "mfa_challenge" USING btree ("userId");
CREATE INDEX "mfa_challenge_expires_idx" ON "mfa_challenge" USING btree ("expiresAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "trusted_device" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "deviceToken" text NOT NULL,
    "deviceInfo" text,
    "ipAddress" text,
    "expiresAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "trusted_device_token_idx" ON "trusted_device" USING btree ("deviceToken");
CREATE INDEX "trusted_device_user_idx" ON "trusted_device" USING btree ("userId");
CREATE INDEX "trusted_device_expires_idx" ON "trusted_device" USING btree ("expiresAt");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "mfa_challenge"
    ADD CONSTRAINT "mfa_challenge_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "trusted_device"
    ADD CONSTRAINT "trusted_device_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260912173251823-add-mfa-and-trusted-devices', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260912173251823-add-mfa-and-trusted-devices', "timestamp" = now();

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
