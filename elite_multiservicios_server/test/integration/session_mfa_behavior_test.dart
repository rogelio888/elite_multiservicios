import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:elite_multiservicios_server/src/generated/protocol.dart';
import 'package:elite_multiservicios_server/src/authorization/rbac_guard.dart';
import 'package:elite_multiservicios_server/src/exceptions/app_exception.dart';
import 'package:elite_multiservicios_server/src/modules/security/jobs/reconcile_revoked_sessions_job.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'MFA Session Binding & Fail-Closed Behavior Tests',
    testGroupTagsOverride: ['db-integration'],
    rollbackDatabase: RollbackDatabase.disabled,
    (sessionBuilder, endpoints) {
      late AppUser testUser;

      setUp(() async {
        final setupSession =
            (sessionBuilder as dynamic).internalBuild(
                  endpoint: 'setup',
                  method: 'setup',
                )
                as Session;

        final uniqueEmail =
            'mfa_test_${DateTime.now().microsecondsSinceEpoch}@elite.com';
        testUser = await AppUser.db.insertRow(
          setupSession,
          AppUser(
            email: uniqueEmail,
            fullName: 'MFA Test User',
            mfaEnabled: true,
            isActive: true,
            isDeleted: false,
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      });

      test(
        'Path 2.4: Sesión no verificada NO hereda mfaVerified de sesión concurrente verificada del mismo usuario',
        () async {
          final session =
              (sessionBuilder as dynamic).internalBuild(
                    endpoint: 'rbac',
                    method: 'requireMfaVerified',
                  )
                  as Session;

          final now = DateTime.now().toUtc();
          const authIdVerified = '550e8400-e29b-41d4-a716-446655440001';
          const authIdUnverified = '550e8400-e29b-41d4-a716-446655440002';

          // 1. Crear sesión 1 con MFA verificado
          await UserSession.db.insertRow(
            session,
            UserSession(
              userId: testUser.id!,
              authSessionId: authIdVerified,
              isRevoked: false,
              mfaVerified: true,
              reconcileAttempts: 0,
              createdAt: now,
              lastActivityAt: now,
              expiresAt: now.add(const Duration(days: 14)),
            ),
          );

          // 2. Crear sesión 2 concurrente más reciente pero SIN MFA verificado
          await UserSession.db.insertRow(
            session,
            UserSession(
              userId: testUser.id!,
              authSessionId: authIdUnverified,
              isRevoked: false,
              mfaVerified: false,
              reconcileAttempts: 0,
              createdAt: now.add(const Duration(seconds: 1)),
              lastActivityAt: now.add(const Duration(seconds: 1)),
              expiresAt: now.add(const Duration(days: 14)),
            ),
          );

          // 3. Evaluar sesión no verificada: debe ser rechazada con MfaRequiredException
          final unverifiedBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              testUser.id!.toString(),
              {},
              authId: authIdUnverified,
            ),
          );
          final unverifiedSession =
              (unverifiedBuilder as dynamic).internalBuild(
                    endpoint: 'test',
                    method: 'test',
                  )
                  as Session;

          expect(
            () => RbacGuard.requireMfaVerified(unverifiedSession),
            throwsA(isA<MfaRequiredException>()),
          );

          // 4. Evaluar sesión verificada: debe proceder sin excepción
          final verifiedBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              testUser.id!.toString(),
              {},
              authId: authIdVerified,
            ),
          );
          final verifiedSession =
              (verifiedBuilder as dynamic).internalBuild(
                    endpoint: 'test',
                    method: 'test',
                  )
                  as Session;

          expect(
            () => RbacGuard.requireMfaVerified(verifiedSession),
            returnsNormally,
          );
        },
      );

      test(
        'Logout idempotente: múltiples llamadas sucesivas retornan true sin fallar',
        () async {
          const authSessionId = '550e8400-e29b-41d4-a716-446655440003';
          final now = DateTime.now().toUtc();

          final session =
              (sessionBuilder as dynamic).internalBuild(
                    endpoint: 'sessionManagement',
                    method: 'setup',
                  )
                  as Session;

          // Registrar sesión activa
          await UserSession.db.insertRow(
            session,
            UserSession(
              userId: testUser.id!,
              authSessionId: authSessionId,
              isRevoked: false,
              mfaVerified: false,
              reconcileAttempts: 0,
              createdAt: now,
              lastActivityAt: now,
              expiresAt: now.add(const Duration(days: 14)),
            ),
          );

          // Crear sessionBuilder autenticado
          final authedBuilder = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              testUser.id!.toString(),
              {},
              authId: authSessionId,
            ),
          );

          // Primera llamada a logout: debe revocar y retornar true
          final firstResult = await endpoints.sessionManagement.logout(
            authedBuilder,
          );
          expect(firstResult, isTrue);

          // Segunda llamada a logout: sesión ya revocada, debe retornar true (idempotente)
          final secondResult = await endpoints.sessionManagement.logout(
            authedBuilder,
          );
          expect(secondResult, isTrue);

          // Verificar en DB que la sesión quedó revocada
          final updatedSession = await UserSession.db.findFirstRow(
            session,
            where: (t) => t.authSessionId.equals(authSessionId),
          );
          expect(updatedSession?.isRevoked, isTrue);
          expect(updatedSession?.revokedAt, isNotNull);
        },
      );

      test(
        'ReconcileRevokedSessionsJob: procesa sesiones revocadas con authSessionId sin errores',
        () async {
          const authSessionId = '550e8400-e29b-41d4-a716-446655440004';
          final now = DateTime.now().toUtc();

          final session =
              (sessionBuilder as dynamic).internalBuild(
                    endpoint: 'job',
                    method: 'reconcileRevokedSessions',
                  )
                  as Session;

          // Insertar sesión revocada pendiente de reconciliación
          await UserSession.db.insertRow(
            session,
            UserSession(
              userId: testUser.id!,
              authSessionId: authSessionId,
              isRevoked: true,
              revokedAt: now,
              mfaVerified: false,
              reconcileAttempts: 0,
              createdAt: now.subtract(const Duration(hours: 1)),
              lastActivityAt: now.subtract(const Duration(hours: 1)),
              expiresAt: now.add(const Duration(days: 14)),
            ),
          );

          final job = ReconcileRevokedSessionsJob();
          job.initialize(session.server, 'reconcileRevokedSessions');

          await expectLater(job.invoke(session, null), completes);
        },
      );
    },
  );
}
