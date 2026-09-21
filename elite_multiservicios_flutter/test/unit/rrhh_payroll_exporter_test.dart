import 'package:flutter_test/flutter_test.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/presentation/utils/rrhh_payroll_exporter.dart';
import 'package:elite_multiservicios_flutter/features/rrhh/data/services/rrhh_state_service.dart';

void main() {
  group('RrhhPayrollExporter Tests', () {
    final stateService = RrhhStateService();

    test(
      'Genera planilla XML compatible con Excel con nombre de hoja PSUELDOS',
      () {
        final employees = stateService.allEmployees;
        expect(employees.isNotEmpty, isTrue);

        final xml = RrhhPayrollExporter.generateSpreadsheetXml(
          employees: employees,
          monthName: 'AGOSTO',
          year: 2026,
          companyName: 'ELITE MULTISERVICIOS',
          nit: '4625505019',
          representativeName: 'ROGELIO ARANDIA ARANDIA',
          representativeCi: '4444455 OR',
          legalCity: 'La Paz',
        );

        // Verificaciones clave de la estructura de la foto del usuario
        expect(xml.contains('<Worksheet ss:Name="PSUELDOS">'), isTrue);
        expect(xml.contains('ELITE MULTISERVICIOS'), isTrue);
        expect(xml.contains('NIT: 4625505019'), isTrue);
        expect(xml.contains('PLANILLA DE SUELDOS Y SALARIOS'), isTrue);
        expect(xml.contains('Correspondiente al mes:   AGOSTO   2026'), isTrue);
        expect(xml.contains('(EXPRESADO EN BOLIVIANOS)'), isTrue);

        // Verificación de columnas normativas
        expect(xml.contains('CARNET&#10;DE&#10;IDENTIDAD'), isTrue);
        expect(xml.contains('NOMBRE DEL EMPLEADO'), isTrue);
        expect(xml.contains('SUELDO&#10;BASICO'), isTrue);
        expect(xml.contains('TOTAL&#10;GANADO&#10;(G)'), isTrue);
        expect(xml.contains('RETENCI&#10;ON 12.71&#10;%'), isTrue);
        expect(
          xml.contains('LIQUIDO&#10;PAGAB&#10;LE&#10;(LL)&#10;G-L'),
          isTrue,
        );
        expect(xml.contains('FIRMA DEL&#10;EMPLEADO'), isTrue);

        // Verificación de fórmulas y totales
        expect(xml.contains('TOTAL GENERAL'), isTrue);
        expect(xml.contains('ss:Formula="=SUM('), isTrue);
        expect(xml.contains('ss:Formula="=ROUND(RC[-1]*0.1271,2)"'), isTrue);

        // Verificación del bloque de pie de página oficial
        expect(
          xml.contains('NOMBRE DEL EMPLEADOR O REPRESENTANTE LEGAL'),
          isTrue,
        );
        expect(xml.contains('NO. CARNET DE IDENTIDAD'), isTrue);
        expect(xml.contains('FIRMA'), isTrue);
        expect(xml.contains('ROGELIO ARANDIA ARANDIA'), isTrue);
        expect(xml.contains('4444455 OR'), isTrue);
        expect(xml.contains('La Paz'), isTrue);
      },
    );

    test('Cálculo correcto de la escala de bono de antigüedad boliviano', () {
      final refDate = DateTime(2026, 8, 31);

      // Menos de 2 años -> 0%
      final recentDate = DateTime(2025, 1, 1);
      expect(
        RrhhPayrollExporter.calculateSeniorityBonus(recentDate, refDate),
        equals(0.0),
      );

      // 3 años (2 a 4 años) -> 5% de 7500 = 375
      final date3Years = DateTime(2023, 1, 1);
      expect(
        RrhhPayrollExporter.calculateSeniorityBonus(date3Years, refDate),
        equals(375.0),
      );

      // 6 años (5 a 7 años) -> 11% de 7500 = 825
      final date6Years = DateTime(2020, 1, 1);
      expect(
        RrhhPayrollExporter.calculateSeniorityBonus(date6Years, refDate),
        equals(825.0),
      );
    });
  });
}
