import 'periodo_contable_data.dart';

class PeriodoContableResponse {
  final bool success;
  final String message;
  final PeriodoContableData? data;

  const PeriodoContableResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PeriodoContableResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    return PeriodoContableResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: rawData is Map<String, dynamic>
          ? PeriodoContableData.fromJson(rawData)
          : null,
    );
  }
}
