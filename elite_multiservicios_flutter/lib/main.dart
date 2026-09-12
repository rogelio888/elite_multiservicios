import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/security/presentation/login_screen.dart';
import 'features/security/presentation/recovery/force_password_change_screen.dart';
import 'features/security/presentation/recovery/mfa_verification_screen.dart';
import 'features/security/presentation/security_shell_screen.dart';
import 'features/security/services/auth_service.dart';

/// Cliente global fuertemente tipado para comunicación RPC con Serverpod.
Client client = Client('http://localhost:8080/')
  ..connectivityMonitor = FlutterConnectivityMonitor()
  ..authSessionManager = FlutterAuthSessionManager();
late String serverUrl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  serverUrl = await getServerUrl();

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  // Inicialización obligatoria de credenciales y tokens JWT antes de resolver la vista
  await client.auth.initialize();

  runApp(const EliteMultiserviciosApp());
}

class EliteMultiserviciosApp extends StatefulWidget {
  const EliteMultiserviciosApp({super.key});

  @override
  State<EliteMultiserviciosApp> createState() => _EliteMultiserviciosAppState();
}

class _EliteMultiserviciosAppState extends State<EliteMultiserviciosApp> {
  ThemeMode _themeMode = ThemeMode.system;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _authService.addListener(_onAuthChanged);
    client.auth.authInfoListenable.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthChanged);
    _authService.dispose();
    client.auth.authInfoListenable.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    setState(() {});
  }

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    final isSignedIn = client.auth.isAuthenticated;

    return MaterialApp(
      title: 'Elite Multiservicios — Sistema Empresarial',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: !isSignedIn
          ? LoginScreen(
              authService: _authService,
              isDarkMode: isDark,
              onToggleTheme: _toggleTheme,
            )
          : FutureBuilder<AppUser>(
              future: client.user.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    _authService.isCheckingMfa) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return SecurityShellScreen(
                    isDarkMode: isDark,
                    onToggleTheme: _toggleTheme,
                  );
                }
                final user = snapshot.data!;

                // 1. Cambio obligatorio de contraseña
                if (user.mustChangePassword) {
                  return ForcePasswordChangeScreen(
                    authService: _authService,
                    onPasswordChanged: () => setState(() {}),
                  );
                }

                // 2. MFA pendiente
                if (_authService.isMfaPending &&
                    _authService.currentMfaChallenge != null) {
                  final challenge = _authService.currentMfaChallenge!;
                  return MfaVerificationScreen(
                    authService: _authService,
                    challengeId: challenge.challengeId,
                    emailHint: challenge.emailHint,
                    rememberMe: _authService.currentRememberMe,
                    onMfaSuccess: () {
                      _authService.clearMfaPending();
                      setState(() {});
                    },
                  );
                }

                // 3. Dashboard
                return SecurityShellScreen(
                  isDarkMode: isDark,
                  onToggleTheme: _toggleTheme,
                );
              },
            ),
    );
  }
}
