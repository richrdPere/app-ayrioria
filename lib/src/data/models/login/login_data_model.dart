import 'package:app_aryoria/src/data/models/usuario_model.dart';
import 'package:app_aryoria/src/domain/entity/session_entity.dart';

class LoginDataModel {
  final String token;
  final Usuario usuario;

  LoginDataModel({required this.token, required this.usuario});

  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      token: json["token"],
      usuario: Usuario.fromJson(json["usuario"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {"token": token, "usuario": usuario.toJson()};
  }

  SessionEntity toEntity() {
    return SessionEntity(token: token, usuario: usuario.toEntity());
  }
}
