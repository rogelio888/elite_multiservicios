import 'dart:ui';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/security/presentation/login_screen.dart';
import 'features/security/presentation/recovery/force_password_change_screen.dart';
import 'features/security/presentation/recovery/mfa_verification_screen.dart';
import 'features/security/presentation/security_shell_screen.dart';
import 'features/security/services/auth_service.dart';

/// URL del backend. Configurable por --dart-define.
/// En desarrollo, default es localhost.
/// En producción, se pasa: --dart-define=SERVER_URL=https://elite-backend.onrender.com/
const String _serverUrl = String.fromEnvironment(
  'SERVER_URL',
  defaultValue: 'http://localhost:8080/',
);

/// Cliente global fuertemente tipado para comunicación RPC con Serverpod.
Client client = Client(_serverUrl)
  ..connectivityMonitor = FlutterConnectivityMonitor()
  ..authSessionManager = FlutterAuthSessionManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  Future<_UserAuthState>? _authStateFuture;
  bool _lastSignedIn = false;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _authService.addListener(_onAuthChanged);
    client.auth.authInfoListenable.addListener(_onAuthChanged);
    _lastSignedIn = client.auth.isAuthenticated;
    if (_lastSignedIn) {
      _authStateFuture = _resolveAuthState();
    }
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthChanged);
    _authService.dispose();
    client.auth.authInfoListenable.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    final currentSignedIn = client.auth.isAuthenticated;
    if (currentSignedIn != _lastSignedIn || (currentSignedIn && _authStateFuture == null)) {
      _lastSignedIn = currentSignedIn;
      if (currentSignedIn) {
        _authStateFuture = _resolveAuthState();
      } else {
        _authStateFuture = null;
      }
    }
    setState(() {});
  }

  void _refreshAuthState() {
    setState(() {
      if (client.auth.isAuthenticated) {
        _authStateFuture = _resolveAuthState();
      } else {
        _authStateFuture = null;
      }
    });
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
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.unknown,
        },
      ),
      locale: const Locale('es', 'ES'),
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('es'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _buildRootWidget(context, isDark, isSignedIn),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => _buildRootWidget(context, isDark, isSignedIn),
        );
      },
    );
  }

  Future<_UserAuthState> _resolveAuthState() async {
    final user = await client.user.getCurrentUser();
    if (!user.mfaEnabled) {
      return _UserAuthState(user: user, isMfaVerified: true);
    }

    final isVerified = await _authService.isCurrentSessionMfaVerified();
    if (isVerified) {
      return _UserAuthState(user: user, isMfaVerified: true);
    }

    // La sesión activa NO tiene MFA verificado. Recuperar o emitir challenge.
    MfaChallengeResponse? challenge = _authService.currentMfaChallenge;
    try {
      challenge ??= await _authService.checkMfaRequired(
        rememberMe: _authService.currentRememberMe,
        notify: false,
      );
    } catch (_) {
      // Tolerar errores de red durante la comprobación de MFA
    }

    return _UserAuthState(
      user: user,
      isMfaVerified: false,
      mfaChallenge: challenge,
    );
  }

  Widget _buildRootWidget(BuildContext context, bool isDark, bool isSignedIn) {
    if (!isSignedIn) {
      return LoginScreen(
        authService: _authService,
        isDarkMode: isDark,
        onToggleTheme: _toggleTheme,
        onLoginSuccess: _refreshAuthState,
      );
    }
    _authStateFuture ??= _resolveAuthState();
    return FutureBuilder<_UserAuthState>(
      future: _authStateFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          // Si no se puede validar la sesión, jamás dar acceso: retornar a LoginScreen
          return LoginScreen(
            authService: _authService,
            isDarkMode: isDark,
            onToggleTheme: _toggleTheme,
            onLoginSuccess: _refreshAuthState,
          );
        }
        final authState = snapshot.data!;
        final user = authState.user;

        // 1. PRIMERO: Si el usuario requiere MFA y la sesión NO está verificada
        if (user.mfaEnabled && !authState.isMfaVerified) {
          final challenge =
              authState.mfaChallenge ?? _authService.currentMfaChallenge;
          if (challenge != null) {
            return MfaVerificationScreen(
              authService: _authService,
              challengeId: challenge.challengeId,
              emailHint: challenge.emailHint,
              rememberMe: _authService.currentRememberMe,
              onMfaSuccess: () {
                _authService.markSessionMfaVerified();
                _refreshAuthState();
              },
            );
          }
        }

        // 2. DESPUÉS: ¿Cambio obligatorio de contraseña?
        if (user.mustChangePassword) {
          return ForcePasswordChangeScreen(
            authService: _authService,
            onPasswordChanged: _refreshAuthState,
          );
        }

        // 3. Dashboard
        return SecurityShellScreen(
          isDarkMode: isDark,
          onToggleTheme: _toggleTheme,
        );
      },
    );
  }
}

class _UserAuthState {
  final AppUser user;
  final bool isMfaVerified;
  final MfaChallengeResponse? mfaChallenge;

  const _UserAuthState({
    required this.user,
    required this.isMfaVerified,
    this.mfaChallenge,
  });
}
