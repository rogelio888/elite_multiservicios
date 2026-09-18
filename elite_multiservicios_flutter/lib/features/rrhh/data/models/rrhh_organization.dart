import 'package:flutter/material.dart';

/// Área o departamento de la empresa (ej. Operaciones, Marketing, Ventas, RRHH, Administración)
class RrhhArea {
  final String id;
  final String code;
  final String name;
  final String description;
  final String leader;
  final String type; // 'OFICINA', 'CAMPO', 'MIXTO'
  final int activeEmployeesCount;
  final Color color;
  final IconData icon;

  const RrhhArea({
    required this.id,
    this.code = 'ADM',
    required this.name,
    required this.description,
    this.leader = 'Jefatura Operativa',
    this.type = 'OFICINA',
    this.activeEmployeesCount = 0,
    this.color = const Color(0xFF2563EB),
    this.icon = Icons.apartment_outlined,
  });

  RrhhArea copyWith({
    String? id,
    String? code,
    String? name,
    String? description,
    String? leader,
    String? type,
    int? activeEmployeesCount,
    Color? color,
    IconData? icon,
  }) {
    return RrhhArea(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      leader: leader ?? this.leader,
      type: type ?? this.type,
      activeEmployeesCount: activeEmployeesCount ?? this.activeEmployeesCount,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}

/// Cargo o puesto de trabajo dentro de una área específica
class RrhhPosition {
  final String id;
  final String code;
  final String title;
  final String areaId;
  final String areaName;
  final String employeeType; // 'OFICINA' o 'CAMPO'
  final double baseSalary;
  final double minSalary;
  final double maxSalary;
  final String level; // 'OPERATIVO', 'SUPERVISIÓN', 'JEFATURA', 'EJECUTIVO'
  final String requiredExperience;
  final bool requiresSpecialty;
  final bool isActive;

  const RrhhPosition({
    required this.id,
    this.code = 'CAR-001',
    required this.title,
    required this.areaId,
    required this.areaName,
    this.employeeType = 'CAMPO',
    this.baseSalary = 3000.0,
    this.minSalary = 2800.0,
    this.maxSalary = 4500.0,
    this.level = 'OPERATIVO',
    this.requiredExperience = '1 año en puestos similares',
    this.requiresSpecialty = false,
    this.isActive = true,
  });

  RrhhPosition copyWith({
    String? id,
    String? code,
    String? title,
    String? areaId,
    String? areaName,
    String? employeeType,
    double? baseSalary,
    double? minSalary,
    double? maxSalary,
    String? level,
    String? requiredExperience,
    bool? requiresSpecialty,
    bool? isActive,
  }) {
    return RrhhPosition(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      areaId: areaId ?? this.areaId,
      areaName: areaName ?? this.areaName,
      employeeType: employeeType ?? this.employeeType,
      baseSalary: baseSalary ?? this.baseSalary,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      level: level ?? this.level,
      requiredExperience: requiredExperience ?? this.requiredExperience,
      requiresSpecialty: requiresSpecialty ?? this.requiresSpecialty,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Especialidad técnica u operativa (Limpieza, Jardinería, Mantenimiento, Seguridad)
class RrhhSpecialty {
  final String id;
  final String code;
  final String name;
  final String description;
  final String category;
  final bool requiresCertification;
  final List<String> requiredToolsOrCertifications;

  const RrhhSpecialty({
    required this.id,
    this.code = 'ESP-001',
    required this.name,
    required this.description,
    this.category = 'OPERATIVO',
    this.requiresCertification = false,
    this.requiredToolsOrCertifications = const [],
  });
}
