import 'package:flutter/material.dart';

class Forbidden403View extends StatelessWidget {
  final String currentRole;
  final List<String> requiredRoles;
  final String moduleName;

  const Forbidden403View({
    super.key,
    required this.currentRole,
    required this.requiredRoles,
    required this.moduleName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background glow effect simulation
            Positioned(
              top: -30,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.2),
                      blurRadius: 40,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.2),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.security,
                      color: Colors.redAccent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade900.withValues(alpha: 0.3),
                      border: Border.all(
                        color: Colors.red.shade900.withValues(alpha: 0.5),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'HTTP 403: ACCESO RESTRINGIDO',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 10,
                        fontFamily: 'monospace',
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Privilegios Insuficientes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: 'El módulo '),
                        TextSpan(
                          text: '"$moduleName"',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ' requiere nivel de autorización contable avanzado. Tu rol actual no cuenta con los permisos necesarios.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                      border: Border.all(color: const Color(0xFF334155)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Rol Activo:',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                            Text(
                              currentRole,
                              style: const TextStyle(
                                color: Colors.amberAccent,
                                fontSize: 12,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Roles Permitidos:',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                            Text(
                              requiredRoles.join(' / '),
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Protocolo:',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.lock,
                                  color: Colors.white54,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'RBAC_PROTECTED',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Volver al Tablero',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
