import 'package:equatable/equatable.dart';

// Models
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_update_req.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_password_req.dart';

abstract class UsuarioEvent extends Equatable {
  const UsuarioEvent();

  @override
  List<Object?> get props => [];
}

// ==========================================================
// 1.- OBTENER PERFIL
// ==========================================================
class GetPerfilUsuarioEvent extends UsuarioEvent {
  const GetPerfilUsuarioEvent();
}

// ==========================================================
// 2.- ACTUALIZAR PERFIL
// ==========================================================
class UpdatePerfilUsuarioEvent extends UsuarioEvent {
  final PerfilUpdateRequest request;

  const UpdatePerfilUsuarioEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

// ==========================================================
// 3.- ACTUALIZAR CONTRASEÑA
// ==========================================================
class UpdatePasswordUsuarioEvent extends UsuarioEvent {
  final PasswordUpdateRequest request;

  const UpdatePasswordUsuarioEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

// ==========================================================
// 4.- ACTUALIZAR FOTO
// ==========================================================
class UpdateFotoUsuarioEvent extends UsuarioEvent {
  final String filePath;

  const UpdateFotoUsuarioEvent({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

// ==========================================================
// 5.- LIMPIAR RESPUESTA DE ACCIÓN
// ==========================================================
class ClearUsuarioActionResponseEvent extends UsuarioEvent {
  const ClearUsuarioActionResponseEvent();
}

// ==========================================================
// 6.- LIMPIAR RESPUESTA DE PASSWORD
// ==========================================================
class ClearUsuarioPasswordResponseEvent extends UsuarioEvent {
  const ClearUsuarioPasswordResponseEvent();
}

// ==========================================================
// 7.- LIMPIAR RESPUESTA DE FOTO
// ==========================================================
class ClearUsuarioFotoResponseEvent extends UsuarioEvent {
  const ClearUsuarioFotoResponseEvent();
}

// ==========================================================
// 8.- LIMPIAR PERFIL
// ==========================================================
class ClearPerfilUsuarioEvent extends UsuarioEvent {
  const ClearPerfilUsuarioEvent();
}
