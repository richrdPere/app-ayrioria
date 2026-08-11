class PasswordUpdateData {
  final int idUsuario;

  const PasswordUpdateData({required this.idUsuario});

  factory PasswordUpdateData.fromJson(Map<String, dynamic> json) {
    return PasswordUpdateData(idUsuario: _toInt(json['id_usuario']));
  }

  Map<String, dynamic> toJson() {
    return {'id_usuario': idUsuario};
  }

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
