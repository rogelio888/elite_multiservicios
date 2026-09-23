BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- Class AppPermission as table app_permission
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
-- Class AppRole as table app_role
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
-- Class AppUser as table app_user
--
CREATE TABLE "app_user" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "fullName" text NOT NULL,
    "userInfoId" bigint,
    "isActive" boolean NOT NULL,
    "isDeleted" boolean NOT NULL,
    "mustChangePassword" boolean NOT NULL DEFAULT true,
    "failedLoginAttempts" bigint NOT NULL DEFAULT 0,
    "lastFailedLoginAt" timestamp without time zone,
    "lockedUntil" timestamp without time zone,
    "mfaEnabled" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "app_user_email_idx" ON "app_user" USING btree ("email");

--
-- Class AuditLog as table audit_log
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
CREATE INDEX "audit_log_result_idx" ON "audit_log" USING btree ("result");

--
-- Class CrmCatalogItem as table crm_catalog_item
--
CREATE TABLE "crm_catalog_item" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "category" text NOT NULL,
    "serviceLineId" bigint NOT NULL,
    "concept" text NOT NULL,
    "calculationType" text NOT NULL,
    "unitType" text NOT NULL,
    "basePrice" double precision NOT NULL,
    "minQuantity" double precision NOT NULL DEFAULT 1.0,
    "version" bigint NOT NULL DEFAULT 1,
    "metadata" text,
    "description" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_catalog_item_code_unique_idx" ON "crm_catalog_item" USING btree ("code");
CREATE UNIQUE INDEX "crm_catalog_item_concept_service_line_unique_idx" ON "crm_catalog_item" USING btree ("serviceLineId", "concept");

--
-- Class CrmCatalogItemScope as table crm_catalog_item_scope
--
CREATE TABLE "crm_catalog_item_scope" (
    "id" bigserial PRIMARY KEY,
    "catalogItemId" bigint NOT NULL,
    "sectorId" bigint NOT NULL,
    "serviceLineId" bigint,
    "priceOverride" double precision,
    "minQuantityOverride" double precision,
    "metadataOverride" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_catalog_scope_unique_idx" ON "crm_catalog_item_scope" USING btree ("catalogItemId", "sectorId");

--
-- Class CrmContractBudgetItem as table crm_contract_budget_item
--
CREATE TABLE "crm_contract_budget_item" (
    "id" bigserial PRIMARY KEY,
    "contractId" bigint NOT NULL,
    "catalogItemId" bigint,
    "description" text NOT NULL,
    "quantity" double precision NOT NULL,
    "unit" text NOT NULL,
    "unitPrice" double precision NOT NULL,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "crm_contract_budget_item_contract_idx" ON "crm_contract_budget_item" USING btree ("contractId");
CREATE INDEX "crm_contract_budget_item_catalog_item_idx" ON "crm_contract_budget_item" USING btree ("catalogItemId");

--
-- Class CrmCustomer as table crm_customer
--
CREATE TABLE "crm_customer" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "legalName" text NOT NULL,
    "tradeName" text NOT NULL,
    "taxId" text NOT NULL,
    "segment" text NOT NULL,
    "status" text NOT NULL DEFAULT 'Activo'::text,
    "activeServices" json NOT NULL,
    "contactPerson" text NOT NULL,
    "phone" text NOT NULL,
    "email" text NOT NULL,
    "opportunityId" bigint,
    "startDate" timestamp without time zone,
    "notes" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_customer_code_idx" ON "crm_customer" USING btree ("code");
CREATE INDEX "crm_customer_tax_id_idx" ON "crm_customer" USING btree ("taxId");
CREATE INDEX "crm_customer_status_idx" ON "crm_customer" USING btree ("status");
CREATE INDEX "crm_customer_segment_idx" ON "crm_customer" USING btree ("segment");

--
-- Class CrmCustomerBranch as table crm_customer_branch
--
CREATE TABLE "crm_customer_branch" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "customerId" bigint NOT NULL,
    "name" text NOT NULL,
    "address" text NOT NULL,
    "localContact" text NOT NULL,
    "localPhone" text NOT NULL,
    "isHeadquarters" boolean NOT NULL DEFAULT false,
    "notes" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "crm_customer_branch_customer_idx" ON "crm_customer_branch" USING btree ("customerId");
CREATE INDEX "crm_customer_branch_code_idx" ON "crm_customer_branch" USING btree ("code");

--
-- Class CrmCustomerContract as table crm_customer_contract
--
CREATE TABLE "crm_customer_contract" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "customerId" bigint NOT NULL,
    "branchId" bigint,
    "title" text NOT NULL,
    "contractType" text NOT NULL,
    "serviceCategory" text NOT NULL,
    "serviceFrequency" text NOT NULL DEFAULT 'Lunes a Viernes'::text,
    "scheduleHours" text,
    "billingCycleDay" bigint DEFAULT 5,
    "specificRequirements" text,
    "totalAmount" double precision NOT NULL,
    "recurringMonthlyAmount" double precision NOT NULL DEFAULT 0.0,
    "oneTimeAmount" double precision NOT NULL DEFAULT 0.0,
    "paymentTerms" text NOT NULL,
    "executionTime" text NOT NULL,
    "advancePercentage" bigint NOT NULL DEFAULT 0,
    "status" text NOT NULL DEFAULT 'Vigente'::text,
    "startDate" timestamp without time zone NOT NULL,
    "endDate" timestamp without time zone,
    "actualEndDate" timestamp without time zone,
    "originType" text NOT NULL DEFAULT 'Venta Nueva'::text,
    "serviceScope" text,
    "completionNotes" text,
    "satisfactionRating" bigint,
    "completedBy" text,
    "notes" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "crm_customer_contract_customer_idx" ON "crm_customer_contract" USING btree ("customerId");
CREATE INDEX "crm_customer_contract_branch_idx" ON "crm_customer_contract" USING btree ("branchId");
CREATE INDEX "crm_customer_contract_status_idx" ON "crm_customer_contract" USING btree ("status");
CREATE INDEX "crm_customer_contract_code_idx" ON "crm_customer_contract" USING btree ("code");

--
-- Class CrmLead as table crm_lead
--
CREATE TABLE "crm_lead" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "company" text NOT NULL,
    "origin" text NOT NULL DEFAULT 'Google Maps'::text,
    "requestedService" text,
    "companyUrl" text,
    "sector" text NOT NULL,
    "advisor" text NOT NULL,
    "advisorUserId" bigint,
    "address" text NOT NULL,
    "phone" text NOT NULL,
    "emailOrWeb" text,
    "status" text NOT NULL DEFAULT 'Prospectado'::text,
    "temperature" text NOT NULL DEFAULT 'Templado'::text,
    "contactPerson" text NOT NULL,
    "notes" text,
    "estimatedValue" double precision NOT NULL DEFAULT 0.0,
    "isPromoted" boolean NOT NULL DEFAULT false,
    "promotedOpportunityId" bigint,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_lead_code_idx" ON "crm_lead" USING btree ("code");
CREATE INDEX "crm_lead_origin_idx" ON "crm_lead" USING btree ("origin");
CREATE INDEX "crm_lead_status_idx" ON "crm_lead" USING btree ("status");
CREATE INDEX "crm_lead_sector_idx" ON "crm_lead" USING btree ("sector");
CREATE INDEX "crm_lead_temperature_idx" ON "crm_lead" USING btree ("temperature");

--
-- Class CrmOpportunity as table crm_opportunity
--
CREATE TABLE "crm_opportunity" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "title" text NOT NULL,
    "clientName" text NOT NULL,
    "contactPerson" text NOT NULL,
    "phone" text NOT NULL,
    "serviceType" text NOT NULL,
    "amount" double precision NOT NULL,
    "stage" text NOT NULL,
    "probability" bigint NOT NULL DEFAULT 20,
    "owner" text NOT NULL,
    "closingDate" text NOT NULL,
    "notes" text,
    "contractType" text NOT NULL DEFAULT 'Recurrente Mensual'::text,
    "serviceFrequency" text NOT NULL DEFAULT 'Lunes a Viernes'::text,
    "scheduleHours" text,
    "billingCycleDay" bigint DEFAULT 5,
    "specificRequirements" text,
    "executionTime" text NOT NULL DEFAULT '12 meses'::text,
    "paymentTerms" text NOT NULL,
    "advancePercentage" bigint NOT NULL DEFAULT 0,
    "contactRole" text NOT NULL DEFAULT 'Administrador'::text,
    "businessSegment" text NOT NULL DEFAULT 'Corporativo B2B'::text,
    "siteName" text,
    "siteAddress" text,
    "siteCity" text NOT NULL DEFAULT 'Santa Cruz'::text,
    "siteContactName" text,
    "siteContactPhone" text,
    "siteAccessRequirements" text,
    "isSiteHeadquarters" boolean NOT NULL DEFAULT true,
    "legalBusinessName" text,
    "taxId" text,
    "legalRepresentative" text,
    "billingEmail" text,
    "serviceStartDate" text,
    "advancePaid" double precision NOT NULL DEFAULT 0.0,
    "wonNotes" text,
    "leadId" bigint,
    "customerId" bigint,
    "branchId" bigint,
    "branchName" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_opportunity_code_idx" ON "crm_opportunity" USING btree ("code");
CREATE INDEX "crm_opportunity_stage_idx" ON "crm_opportunity" USING btree ("stage");
CREATE INDEX "crm_opportunity_customer_idx" ON "crm_opportunity" USING btree ("customerId");
CREATE INDEX "crm_opportunity_lead_idx" ON "crm_opportunity" USING btree ("leadId");

--
-- Class CrmQuoteItem as table crm_quote_item
--
CREATE TABLE "crm_quote_item" (
    "id" bigserial PRIMARY KEY,
    "opportunityId" bigint NOT NULL,
    "catalogItemId" bigint,
    "catalogVersion" bigint,
    "category" text NOT NULL,
    "concept" text NOT NULL,
    "calculationType" text NOT NULL DEFAULT 'PER_UNIT'::text,
    "unitType" text NOT NULL,
    "quantity" double precision NOT NULL,
    "unitPrice" double precision NOT NULL,
    "metadata" text,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "crm_quote_item_opportunity_idx" ON "crm_quote_item" USING btree ("opportunityId");

--
-- Class CrmSector as table crm_sector
--
CREATE TABLE "crm_sector" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "name" text NOT NULL,
    "description" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_sector_code_unique_idx" ON "crm_sector" USING btree ("code");
CREATE UNIQUE INDEX "crm_sector_name_unique_idx" ON "crm_sector" USING btree ("name");

--
-- Class CrmServiceLine as table crm_service_line
--
CREATE TABLE "crm_service_line" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "name" text NOT NULL,
    "category" text NOT NULL,
    "description" text,
    "isActive" boolean NOT NULL DEFAULT true,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "deletedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_service_line_code_unique_idx" ON "crm_service_line" USING btree ("code");

--
-- Class CrmTask as table crm_task
--
CREATE TABLE "crm_task" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "title" text NOT NULL,
    "taskType" text NOT NULL,
    "clientName" text NOT NULL,
    "contactPerson" text NOT NULL,
    "phone" text NOT NULL,
    "scheduledAt" timestamp without time zone NOT NULL,
    "scheduledTimeText" text NOT NULL,
    "priority" text NOT NULL DEFAULT 'Media'::text,
    "status" text NOT NULL DEFAULT 'Pendiente'::text,
    "callContext" text,
    "notes" text,
    "leadId" bigint,
    "opportunityId" bigint,
    "customerId" bigint,
    "contractId" bigint,
    "isDeleted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "crm_task_code_idx" ON "crm_task" USING btree ("code");
CREATE INDEX "crm_task_scheduled_idx" ON "crm_task" USING btree ("scheduledAt");
CREATE INDEX "crm_task_status_idx" ON "crm_task" USING btree ("status");
CREATE INDEX "crm_task_type_idx" ON "crm_task" USING btree ("taskType");
CREATE INDEX "crm_task_customer_idx" ON "crm_task" USING btree ("customerId");
CREATE INDEX "crm_task_opportunity_idx" ON "crm_task" USING btree ("opportunityId");
CREATE INDEX "crm_task_lead_idx" ON "crm_task" USING btree ("leadId");

--
-- Class MfaChallenge as table mfa_challenge
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
-- Class RolePermission as table role_permission
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
-- Class RrhhArea as table rrhh_area
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
-- Class RrhhPosition as table rrhh_position
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
-- Class RrhhSpecialty as table rrhh_specialty
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
-- Class TrustedDevice as table trusted_device
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
-- Class UserRole as table user_role
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
-- Class UserSession as table user_session
--
CREATE TABLE "user_session" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "sessionTokenHash" text NOT NULL,
    "ipAddress" text,
    "deviceInfo" text,
    "isRevoked" boolean NOT NULL,
    "mfaVerified" boolean NOT NULL DEFAULT false,
    "revokedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "lastActivityAt" timestamp without time zone NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_session_token_hash_idx" ON "user_session" USING btree ("sessionTokenHash");
CREATE INDEX "user_session_user_idx" ON "user_session" USING btree ("userId");
CREATE INDEX "user_session_expires_idx" ON "user_session" USING btree ("expiresAt");

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Class AnonymousAccount as table serverpod_auth_idp_anonymous_account
--
CREATE TABLE "serverpod_auth_idp_anonymous_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- Class AppleAccount as table serverpod_auth_idp_apple_account
--
CREATE TABLE "serverpod_auth_idp_apple_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userIdentifier" text NOT NULL,
    "refreshToken" text NOT NULL,
    "refreshTokenRequestedWithBundleIdentifier" boolean NOT NULL,
    "lastRefreshedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text,
    "isEmailVerified" boolean,
    "isPrivateEmail" boolean,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_apple_account_identifier" ON "serverpod_auth_idp_apple_account" USING btree ("userIdentifier");

--
-- Class EmailAccount as table serverpod_auth_idp_email_account
--
CREATE TABLE "serverpod_auth_idp_email_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_email" ON "serverpod_auth_idp_email_account" USING btree ("email");

--
-- Class EmailAccountPasswordResetRequest as table serverpod_auth_idp_email_account_password_reset_request
--
CREATE TABLE "serverpod_auth_idp_email_account_password_reset_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "emailAccountId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "challengeId" uuid NOT NULL,
    "setPasswordChallengeId" uuid
);

--
-- Class EmailAccountRequest as table serverpod_auth_idp_email_account_request
--
CREATE TABLE "serverpod_auth_idp_email_account_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" text NOT NULL,
    "challengeId" uuid NOT NULL,
    "createAccountChallengeId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_request_email" ON "serverpod_auth_idp_email_account_request" USING btree ("email");

--
-- Class FacebookAccount as table serverpod_auth_idp_facebook_account
--
CREATE TABLE "serverpod_auth_idp_facebook_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "fullName" text,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_facebook_account_user_identifier" ON "serverpod_auth_idp_facebook_account" USING btree ("userIdentifier");

--
-- Class FirebaseAccount as table serverpod_auth_idp_firebase_account
--
CREATE TABLE "serverpod_auth_idp_firebase_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text,
    "phone" text,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_firebase_account_user_identifier" ON "serverpod_auth_idp_firebase_account" USING btree ("userIdentifier");

--
-- Class GitHubAccount as table serverpod_auth_idp_github_account
--
CREATE TABLE "serverpod_auth_idp_github_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_github_account_user_identifier" ON "serverpod_auth_idp_github_account" USING btree ("userIdentifier");

--
-- Class GoogleAccount as table serverpod_auth_idp_google_account
--
CREATE TABLE "serverpod_auth_idp_google_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_google_account_user_identifier" ON "serverpod_auth_idp_google_account" USING btree ("userIdentifier");

--
-- Class MicrosoftAccount as table serverpod_auth_idp_microsoft_account
--
CREATE TABLE "serverpod_auth_idp_microsoft_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_microsoft_account_user_identifier" ON "serverpod_auth_idp_microsoft_account" USING btree ("userIdentifier");

--
-- Class PasskeyAccount as table serverpod_auth_idp_passkey_account
--
CREATE TABLE "serverpod_auth_idp_passkey_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "keyId" bytea NOT NULL,
    "keyIdBase64" text NOT NULL,
    "clientDataJSON" bytea NOT NULL,
    "attestationObject" bytea NOT NULL,
    "originalChallenge" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_passkey_account_key_id_base64" ON "serverpod_auth_idp_passkey_account" USING btree ("keyIdBase64");

--
-- Class PasskeyChallenge as table serverpod_auth_idp_passkey_challenge
--
CREATE TABLE "serverpod_auth_idp_passkey_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "challenge" bytea NOT NULL
);

--
-- Class RateLimitedRequestAttempt as table serverpod_auth_idp_rate_limited_request_attempt
--
CREATE TABLE "serverpod_auth_idp_rate_limited_request_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "domain" text NOT NULL,
    "source" text NOT NULL,
    "nonce" text NOT NULL,
    "ipAddress" text,
    "attemptedAt" timestamp without time zone NOT NULL,
    "extraData" json
);

-- Indexes
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_composite" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("domain", "source", "nonce", "attemptedAt");

--
-- Class SecretChallenge as table serverpod_auth_idp_secret_challenge
--
CREATE TABLE "serverpod_auth_idp_secret_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "challengeCodeHash" text NOT NULL
);

--
-- Class RefreshToken as table serverpod_auth_core_jwt_refresh_token
--
CREATE TABLE "serverpod_auth_core_jwt_refresh_token" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "extraClaims" text,
    "method" text NOT NULL,
    "fixedSecret" bytea NOT NULL,
    "rotatingSecretHash" text NOT NULL,
    "lastUpdatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "serverpod_auth_core_jwt_refresh_token_last_updated_at" ON "serverpod_auth_core_jwt_refresh_token" USING btree ("lastUpdatedAt");

--
-- Class UserProfile as table serverpod_auth_core_profile
--
CREATE TABLE "serverpod_auth_core_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "imageId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_profile_user_profile_email_auth_user_id" ON "serverpod_auth_core_profile" USING btree ("authUserId");

--
-- Class UserProfileImage as table serverpod_auth_core_profile_image
--
CREATE TABLE "serverpod_auth_core_profile_image" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userProfileId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "url" text NOT NULL
);

--
-- Class ServerSideSession as table serverpod_auth_core_session
--
CREATE TABLE "serverpod_auth_core_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUsedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone,
    "expireAfterUnusedFor" bigint,
    "sessionKeyHash" bytea NOT NULL,
    "sessionKeySalt" bytea NOT NULL,
    "method" text NOT NULL
);

--
-- Class AuthUser as table serverpod_auth_core_user
--
CREATE TABLE "serverpod_auth_core_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

--
-- Foreign relations for "audit_log" table
--
ALTER TABLE ONLY "audit_log"
    ADD CONSTRAINT "audit_log_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "crm_catalog_item" table
--
ALTER TABLE ONLY "crm_catalog_item"
    ADD CONSTRAINT "crm_catalog_item_fk_0"
    FOREIGN KEY("serviceLineId")
    REFERENCES "crm_service_line"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "crm_catalog_item_scope" table
--
ALTER TABLE ONLY "crm_catalog_item_scope"
    ADD CONSTRAINT "crm_catalog_item_scope_fk_0"
    FOREIGN KEY("catalogItemId")
    REFERENCES "crm_catalog_item"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "crm_catalog_item_scope"
    ADD CONSTRAINT "crm_catalog_item_scope_fk_1"
    FOREIGN KEY("sectorId")
    REFERENCES "crm_sector"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "crm_catalog_item_scope"
    ADD CONSTRAINT "crm_catalog_item_scope_fk_2"
    FOREIGN KEY("serviceLineId")
    REFERENCES "crm_service_line"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "crm_contract_budget_item" table
--
ALTER TABLE ONLY "crm_contract_budget_item"
    ADD CONSTRAINT "crm_contract_budget_item_fk_0"
    FOREIGN KEY("contractId")
    REFERENCES "crm_customer_contract"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "crm_customer_branch" table
--
ALTER TABLE ONLY "crm_customer_branch"
    ADD CONSTRAINT "crm_customer_branch_fk_0"
    FOREIGN KEY("customerId")
    REFERENCES "crm_customer"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "crm_customer_contract" table
--
ALTER TABLE ONLY "crm_customer_contract"
    ADD CONSTRAINT "crm_customer_contract_fk_0"
    FOREIGN KEY("customerId")
    REFERENCES "crm_customer"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "crm_customer_contract"
    ADD CONSTRAINT "crm_customer_contract_fk_1"
    FOREIGN KEY("branchId")
    REFERENCES "crm_customer_branch"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "crm_quote_item" table
--
ALTER TABLE ONLY "crm_quote_item"
    ADD CONSTRAINT "crm_quote_item_fk_0"
    FOREIGN KEY("opportunityId")
    REFERENCES "crm_opportunity"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "mfa_challenge" table
--
ALTER TABLE ONLY "mfa_challenge"
    ADD CONSTRAINT "mfa_challenge_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "role_permission" table
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
-- Foreign relations for "rrhh_position" table
--
ALTER TABLE ONLY "rrhh_position"
    ADD CONSTRAINT "rrhh_position_fk_0"
    FOREIGN KEY("areaId")
    REFERENCES "rrhh_area"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "trusted_device" table
--
ALTER TABLE ONLY "trusted_device"
    ADD CONSTRAINT "trusted_device_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "user_role" table
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
-- Foreign relations for "user_session" table
--
ALTER TABLE ONLY "user_session"
    ADD CONSTRAINT "user_session_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "app_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_anonymous_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_anonymous_account"
    ADD CONSTRAINT "serverpod_auth_idp_anonymous_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_apple_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_apple_account"
    ADD CONSTRAINT "serverpod_auth_idp_apple_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_password_reset_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_0"
    FOREIGN KEY("emailAccountId")
    REFERENCES "serverpod_auth_idp_email_account"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_1"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_2"
    FOREIGN KEY("setPasswordChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_0"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_1"
    FOREIGN KEY("createAccountChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_facebook_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_facebook_account"
    ADD CONSTRAINT "serverpod_auth_idp_facebook_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_firebase_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_firebase_account"
    ADD CONSTRAINT "serverpod_auth_idp_firebase_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_github_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_github_account"
    ADD CONSTRAINT "serverpod_auth_idp_github_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_google_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_google_account"
    ADD CONSTRAINT "serverpod_auth_idp_google_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_microsoft_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_microsoft_account"
    ADD CONSTRAINT "serverpod_auth_idp_microsoft_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_passkey_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_passkey_account"
    ADD CONSTRAINT "serverpod_auth_idp_passkey_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_jwt_refresh_token" table
--
ALTER TABLE ONLY "serverpod_auth_core_jwt_refresh_token"
    ADD CONSTRAINT "serverpod_auth_core_jwt_refresh_token_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_profile" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_1"
    FOREIGN KEY("imageId")
    REFERENCES "serverpod_auth_core_profile_image"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_profile_image" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile_image"
    ADD CONSTRAINT "serverpod_auth_core_profile_image_fk_0"
    FOREIGN KEY("userProfileId")
    REFERENCES "serverpod_auth_core_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_session" table
--
ALTER TABLE ONLY "serverpod_auth_core_session"
    ADD CONSTRAINT "serverpod_auth_core_session_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
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
