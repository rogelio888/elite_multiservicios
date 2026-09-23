import re
import sys

file_path = "lib/features/security/presentation/security_shell_screen.dart"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# 1. Imports
if "import '../../accounting/" not in content:
    content = content.replace(
        "import 'views/server_metrics_view.dart';",
        "import 'views/server_metrics_view.dart';\nimport '../../accounting/presentation/screens/accounting_dashboard_screen.dart';\nimport '../../accounting/presentation/screens/accounting_invoices_screen.dart';\nimport '../../accounting/presentation/screens/accounting_expenses_screen.dart';"
    )

# 2. _tabSlugs
if "'accounting-dashboard'" not in content:
    content = content.replace(
        "'rrhh-reportes',",
        "'rrhh-reportes',\n    'accounting-dashboard',\n    'accounting-invoices',\n    'accounting-expenses',"
    )

# 3. _indexFromRouteOrHash
if "case 'accounting-dashboard':" not in content:
    content = content.replace(
        "case 'bitacora-rrhh':\n        return 15;",
        "case 'bitacora-rrhh':\n        return 15;\n      case 'accounting-dashboard':\n      case 'contabilidad':\n        return 16;\n      case 'accounting-invoices':\n      case 'facturas':\n        return 17;\n      case 'accounting-expenses':\n      case 'gastos':\n        return 18;"
    )

# 4. State variable
if "bool _isAccountingExpanded" not in content:
    content = content.replace(
        "bool _isRrhhExpanded = true;",
        "bool _isRrhhExpanded = true;\n  bool _isAccountingExpanded = true;"
    )

# 5. initIndex ranges
content = content.replace(
    "if (initialIndex >= 10 && initialIndex <= 15) {\n      _isRrhhExpanded = true;\n    }",
    "if (initialIndex >= 10 && initialIndex <= 15) {\n      _isRrhhExpanded = true;\n    } else if (initialIndex >= 16 && initialIndex <= 18) {\n      _isAccountingExpanded = true;\n    }"
)

# 6. listenBrowserHashChange
content = content.replace(
    "if (newIndex >= 10 && newIndex <= 15) _isRrhhExpanded = true;",
    "if (newIndex >= 10 && newIndex <= 15) _isRrhhExpanded = true;\n            if (newIndex >= 16 && newIndex <= 18) _isAccountingExpanded = true;"
)

# 7. _onTabSelected
content = content.replace(
    "if (index >= 10 && index <= 15) {\n          _isRrhhExpanded = true;\n        }",
    "if (index >= 10 && index <= 15) {\n          _isRrhhExpanded = true;\n        } else if (index >= 16 && index <= 18) {\n          _isAccountingExpanded = true;\n        }"
)

# 8. _titles
if "'Contabilidad: Dashboard'" not in content:
    content = content.replace(
        "'RRHH: Centro de Reportes & Métricas',",
        "'RRHH: Centro de Reportes & Métricas',\n    'Contabilidad: Dashboard',\n    'Contabilidad: Facturación',\n    'Contabilidad: Egresos',"
    )

# 9. switch (currentView)
if "case 16:" not in content:
    content = content.replace(
        "case 15:\n        currentView = const RrhhReportsView();\n        break;",
        "case 15:\n        currentView = const RrhhReportsView();\n        break;\n      case 16:\n        currentView = const AccountingDashboardScreen();\n        break;\n      case 17:\n        currentView = const AccountingInvoicesScreen();\n        break;\n      case 18:\n        currentView = const AccountingExpensesScreen();\n        break;"
    )

# 10. Items array
if "isAnyAccountingActive" not in content:
    content = content.replace(
        "Widget currentView;",
        """final isAnyAccountingActive = _selectedIndex >= 16 && _selectedIndex <= 18;
    final accountingItems = [
      (
        icon: Icons.account_balance_wallet_outlined,
        selectedIcon: Icons.account_balance_wallet,
        label: 'Dashboard',
        badge: null,
        index: 16,
      ),
      (
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long,
        label: 'Facturación',
        badge: null,
        index: 17,
      ),
      (
        icon: Icons.money_off_outlined,
        selectedIcon: Icons.money_off,
        label: 'Egresos',
        badge: null,
        index: 18,
      ),
    ];

    Widget currentView;"""
    )

# 11. _buildSidebarContent signature
content = content.replace(
    "required bool isAnyRrhhActive,",
    "required bool isAnyRrhhActive,\n    required List<({IconData icon, IconData selectedIcon, String label, String? badge, int index})> accountingItems,\n    required bool isAnyAccountingActive,"
)

# 12. _buildSidebarContent calls
content = content.replace(
    "isAnyRrhhActive: isAnyRrhhActive,\n                    ),",
    "isAnyRrhhActive: isAnyRrhhActive,\n                      accountingItems: accountingItems,\n                      isAnyAccountingActive: isAnyAccountingActive,\n                    ),"
)

# 13. Accordion UI. We need to append the Accounting accordion at the end of the ListView in _buildSidebarContent.
accordion_code = """
                // 8. Acordeón Colapsable "Contabilidad"
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const Key('nav_accordion_accounting'),
                    onTap: () {
                      setState(() {
                        _isAccountingExpanded = !_isAccountingExpanded;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: (isAnyAccountingActive && !_isAccountingExpanded)
                            ? (isDark
                                  ? const Color(0xFF1E1B4B)
                                  : const Color(0xFFEEF2FF))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: (isAnyAccountingActive && !_isAccountingExpanded)
                            ? const Border(
                                left: BorderSide(
                                  color: Color(0xFF6366F1),
                                  width: 2.5,
                                ),
                              )
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: collapsed
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.monetization_on_outlined,
                            color: isAnyAccountingActive
                                ? (isDark
                                      ? const Color(0xFF818CF8)
                                      : const Color(0xFF4F46E5))
                                : (isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B)),
                            size: 18,
                          ),
                          if (!collapsed) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Contabilidad',
                                      style: GoogleFonts.inter(
                                        color: isAnyAccountingActive
                                            ? (isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A))
                                            : (isDark
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF64748B)),
                                        fontWeight: isAnyAccountingActive
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedRotation(
                              turns: _isAccountingExpanded ? 0.5 : 0.0,
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOutCubic,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: isDark
                                    ? const Color(0xFF64748B)
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                if (_isAccountingExpanded)
                  Padding(
                    padding: EdgeInsets.only(
                      left: collapsed ? 0 : 10,
                      top: 2,
                    ),
                    child: Container(
                      decoration: collapsed
                          ? null
                          : BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                              ),
                            ),
                      padding: EdgeInsets.only(
                        left: collapsed ? 0 : 6,
                      ),
                      child: Column(
                        children: accountingItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: _buildNavItem(
                              icon: item.icon,
                              selectedIcon: item.selectedIcon,
                              label: item.label,
                              index: item.index,
                              badge: item.badge,
                              isSubItem: true,
                              isDrawer: isDrawer,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                const SizedBox(height: 6),
"""

# Try to find the end of the RRHH block to append this
# In the list view children, we can append it just before the closing ] of the ListView.
if "nav_accordion_accounting" not in content:
    # Since it's hard to find the end of ListView, let's find the specific text of the last RRHH expanded block
    content = content.replace(
        """                      ),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),""",
        f"""                      ),
                    ),
                  ),
                const SizedBox(height: 6),
{accordion_code}
                const SizedBox(height: 16),
              ],
            ),
          ),"""
    )
    
    # If the exact match above didn't work because of spacing, let's try a regex
    content = re.sub(
        r'const SizedBox\(height: \d+\),\s+\]\,\s+\),\s+\),',
        f'const SizedBox(height: 6),\n{accordion_code}\nconst SizedBox(height: 16),\n              ],\n            ),\n          ),',
        content,
        count=1
    )

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Patch applied")
