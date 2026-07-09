import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';

class MovimientoResponse {
  final bool success;
  final String message;
  final MovimientoData data;

  MovimientoResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MovimientoResponse.fromJson(Map<String, dynamic> json) {
    return MovimientoResponse(
      success: json["success"],
      message: json["message"],
      data: MovimientoData.fromJson(json["data"]),
    );
  }
}
