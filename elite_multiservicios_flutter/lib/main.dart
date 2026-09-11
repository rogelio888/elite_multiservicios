import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/security/presentation/login_screen.dart';
import 'features/security/presentation/security_shell_screen.dart';

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

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
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
      home: isSignedIn
          ? SecurityShellScreen(
              isDarkMode: isDark,
              onToggleTheme: _toggleTheme,
            )
          : LoginScreen(
              isDarkMode: isDark,
              onToggleTheme: _toggleTheme,
            ),
    );
  }
}
