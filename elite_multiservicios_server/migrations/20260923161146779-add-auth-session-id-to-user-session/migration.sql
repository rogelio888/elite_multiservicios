BEGIN;

--
-- ACTION ALTER TABLE
--
DROP INDEX "user_session_token_hash_idx";
ALTER TABLE "user_session" ADD COLUMN "authSessionId" text;
ALTER TABLE "user_session" ADD COLUMN "reconcileAttempts" bigint NOT NULL DEFAULT 0;
ALTER TABLE "user_session" ALTER COLUMN "sessionTokenHash" DROP NOT NULL;
CREATE INDEX "user_session_auth_id_idx" ON "user_session" USING btree ("authSessionId");

--
-- MIGRATION VERSION FOR elite_multiservicios
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('elite_multiservicios', '20260923161146779-add-auth-session-id-to-user-session', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260923161146779-add-auth-session-id-to-user-session', "timestamp" = now();

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
