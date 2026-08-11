import 'package:equatable/equatable.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/password_update_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/foto_perfil_update_data.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class UsuarioState extends Equatable {
  // ==========================================================
  // DATA
  // ==========================================================

  final PerfilUsuarioData? perfil;

  // ==========================================================
  // RESPUESTAS
  // ==========================================================

  /// GET perfil.
  final Resource<ApiResponse<PerfilUsuarioData>>? perfilResponse;

  /// PUT perfil.
  final Resource<ApiResponse<PerfilUsuarioData>>? actionResponse;

  /// PATCH password.
  final Resource<ApiResponse<PasswordUpdateData>>? passwordResponse;

  /// PATCH foto.
  final Resource<ApiResponse<FotoPerfilUpdateData>>? fotoResponse;

  // ==========================================================
  // CONSTRUCTOR
  // ==========================================================
  const UsuarioState({
    this.perfil,
    this.perfilResponse,
    this.actionResponse,
    this.passwordResponse,
    this.fotoResponse,
  });

  // ==========================================================
  // HELPERS
  // ==========================================================

  bool get hasPerfil => perfil != null;

  bool get isLoadingPerfil =>
      perfilResponse is Loading<ApiResponse<PerfilUsuarioData>>;

  bool get isUpdatingPerfil =>
      actionResponse is Loading<ApiResponse<PerfilUsuarioData>>;

  bool get isUpdatingPassword =>
      passwordResponse is Loading<ApiResponse<PasswordUpdateData>>;

  bool get isUpdatingFoto =>
      fotoResponse is Loading<ApiResponse<FotoPerfilUpdateData>>;

  // ==========================================================
  // COPY WITH
  // ==========================================================
  UsuarioState copyWith({
    PerfilUsuarioData? perfil,
    Resource<ApiResponse<PerfilUsuarioData>>? perfilResponse,
    Resource<ApiResponse<PerfilUsuarioData>>? actionResponse,
    Resource<ApiResponse<PasswordUpdateData>>? passwordResponse,
    Resource<ApiResponse<FotoPerfilUpdateData>>? fotoResponse,
    bool clearPerfil = false,
    bool clearPerfilResponse = false,
    bool clearActionResponse = false,
    bool clearPasswordResponse = false,
    bool clearFotoResponse = false,
  }) {
    return UsuarioState(
      perfil: clearPerfil ? null : perfil ?? this.perfil,

      perfilResponse: clearPerfilResponse
          ? null
          : perfilResponse ?? this.perfilResponse,

      actionResponse: clearActionResponse
          ? null
          : actionResponse ?? this.actionResponse,

      passwordResponse: clearPasswordResponse
          ? null
          : passwordResponse ?? this.passwordResponse,

      fotoResponse: clearFotoResponse
          ? null
          : fotoResponse ?? this.fotoResponse,
    );
  }

  // ==========================================================
  // EQUATABLE
  // ==========================================================
  @override
  List<Object?> get props => [
    perfil,
    perfilResponse,
    actionResponse,
    passwordResponse,
    fotoResponse,
  ];
}
