import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/data/models/usuario_model.dart';
import 'package:app_aryoria/src/domain/entity/session_entity.dart';

class LoginDataModel {
  final String token;
  final Usuario usuario;
  final EmpresaData? empresa;

  LoginDataModel({required this.token, required this.usuario, this.empresa});

  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      token: json["token"],
      usuario: Usuario.fromJson(json["usuario"]),
      empresa: json["empresa"] != null
          ? EmpresaData.fromJson(json["empresa"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "usuario": usuario.toJson(),
      "empresa": empresa?.toJson(),
    };
  }

  SessionEntity toEntity() {
    return SessionEntity(
      token: token,
      usuario: usuario.toEntity(),
      empresa: empresa?.toEntity(),
    );
  }
}
