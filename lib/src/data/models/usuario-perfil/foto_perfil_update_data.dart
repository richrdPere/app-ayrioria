class FotoPerfilUpdateData {
  final int idUsuario;
  final int idPersona;
  final String fotoUrl;

  const FotoPerfilUpdateData({
    required this.idUsuario,
    required this.idPersona,
    required this.fotoUrl,
  });

  factory FotoPerfilUpdateData.fromJson(Map<String, dynamic> json) {
    return FotoPerfilUpdateData(
      idUsuario: _toInt(json['id_usuario']),
      idPersona: _toInt(json['id_persona']),
      fotoUrl: json['foto_url']?.toString().trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': idUsuario,
      'id_persona': idPersona,
      'foto_url': fotoUrl,
    };
  }

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
