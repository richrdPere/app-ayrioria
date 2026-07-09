
import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_Data.dart';
import 'package:app_aryoria/src/data/models/usuario_model.dart';

import '../empresa/empresa_data.dart';


class MovimientoData {
  final int idMovimiento;
  final int idEmpresa;
  final int idCategoria;
  final int idUsuario;
  final int idPeriodo;

  final String tipo;
  final String fecha;
  final String descripcion;
  final double monto;

  final String? observacion;
  final String? comprobante;

  final String estado;
  final bool activo;

  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  final EmpresaData? empresa;
  final CategoriaData? categoria;
  final Usuario? usuario;
  final PeriodoContableData? periodoContable;

  const MovimientoData({
    required this.idMovimiento,
    required this.idEmpresa,
    required this.idCategoria,
    required this.idUsuario,
    required this.idPeriodo,
    required this.tipo,
    required this.fecha,
    required this.descripcion,
    required this.monto,
    this.observacion,
    this.comprobante,
    required this.estado,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.empresa,
    this.categoria,
    this.usuario,
    this.periodoContable,
  });

  factory MovimientoData.fromJson(Map<String, dynamic> json) {
    return MovimientoData(
      idMovimiento: json['id_movimiento'],
      idEmpresa: json['id_empresa'],
      idCategoria: json['id_categoria'],
      idUsuario: json['id_usuario'],
      idPeriodo: json['id_periodo'],
      tipo: json['tipo'] ?? '',
      fecha: json['fecha'] ?? '',
      descripcion: json['descripcion'] ?? '',
      monto: double.tryParse(json['monto'].toString()) ?? 0.0,
      observacion: json['observacion'],
      comprobante: json['comprobante'],
      estado: json['estado'] ?? '',
      activo: json['activo'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      empresa: json['empresa'] != null
          ? EmpresaData.fromJson(json['empresa'])
          : null,
      categoria: json['categoria'] != null
          ? CategoriaData.fromJson(json['categoria'])
          : null,
      usuario: json['usuario'] != null
          ? Usuario.fromJson(json['usuario'])
          : null,
      periodoContable: json['periodoContable'] != null
          ? PeriodoContableData.fromJson(json['periodoContable'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_movimiento': idMovimiento,
      'id_empresa': idEmpresa,
      'id_categoria': idCategoria,
      'id_usuario': idUsuario,
      'id_periodo': idPeriodo,
      'tipo': tipo,
      'fecha': fecha,
      'descripcion': descripcion,
      'monto': monto,
      'observacion': observacion,
      'comprobante': comprobante,
      'estado': estado,
      'activo': activo,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'empresa': empresa?.toJson(),
      'categoria': categoria?.toJson(),
      'usuario': usuario?.toJson(),
      'periodoContable': periodoContable?.toJson(),
    };
  }

  MovimientoData copyWith({
    int? idMovimiento,
    int? idEmpresa,
    int? idCategoria,
    int? idUsuario,
    int? idPeriodo,
    String? tipo,
    String? fecha,
    String? descripcion,
    double? monto,
    String? observacion,
    String? comprobante,
    String? estado,
    bool? activo,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    EmpresaData? empresa,
    CategoriaData? categoria,
    Usuario? usuario,
    PeriodoContableData? periodoContable,
  }) {
    return MovimientoData(
      idMovimiento: idMovimiento ?? this.idMovimiento,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idCategoria: idCategoria ?? this.idCategoria,
      idUsuario: idUsuario ?? this.idUsuario,
      idPeriodo: idPeriodo ?? this.idPeriodo,
      tipo: tipo ?? this.tipo,
      fecha: fecha ?? this.fecha,
      descripcion: descripcion ?? this.descripcion,
      monto: monto ?? this.monto,
      observacion: observacion ?? this.observacion,
      comprobante: comprobante ?? this.comprobante,
      estado: estado ?? this.estado,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      empresa: empresa ?? this.empresa,
      categoria: categoria ?? this.categoria,
      usuario: usuario ?? this.usuario,
      periodoContable: periodoContable ?? this.periodoContable,
    );
  }
}
