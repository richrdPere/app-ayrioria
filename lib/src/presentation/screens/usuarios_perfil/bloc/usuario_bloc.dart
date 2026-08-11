import 'package:flutter_bloc/flutter_bloc.dart';

// Use Cases
import 'package:app_aryoria/src/domain/use_cases/index_uses_cases.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/password_update_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/foto_perfil_update_data.dart';

// Bloc
import 'usuario_event.dart';
import 'usuario_state.dart';

class UsuarioBloc extends Bloc<UsuarioEvent, UsuarioState> {
  final UsuariosUsesCases usuariosUsesCases;

  UsuarioBloc(this.usuariosUsesCases) : super(const UsuarioState()) {
    on<GetPerfilUsuarioEvent>(_onGetPerfilUsuario);

    on<UpdatePerfilUsuarioEvent>(_onUpdatePerfilUsuario);

    on<UpdatePasswordUsuarioEvent>(_onUpdatePasswordUsuario);

    on<UpdateFotoUsuarioEvent>(_onUpdateFotoUsuario);

    on<ClearUsuarioActionResponseEvent>(_onClearActionResponse);

    on<ClearUsuarioPasswordResponseEvent>(_onClearPasswordResponse);

    on<ClearUsuarioFotoResponseEvent>(_onClearFotoResponse);

    on<ClearPerfilUsuarioEvent>(_onClearPerfil);
  }

  // ==========================================================
  // 1.- OBTENER PERFIL
  // ==========================================================
  Future<void> _onGetPerfilUsuario(
    GetPerfilUsuarioEvent event,
    Emitter<UsuarioState> emit,
  ) async {
    emit(
      state.copyWith(
        perfilResponse: const Loading<ApiResponse<PerfilUsuarioData>>(),
        clearActionResponse: true,
        clearPasswordResponse: true,
        clearFotoResponse: true,
      ),
    );

    final response = await usuariosUsesCases.getPerfilUsuario.run();

    if (response is Success<ApiResponse<PerfilUsuarioData>>) {
      final perfil = response.data.data;

      emit(state.copyWith(perfilResponse: response, perfil: perfil));

      return;
    }

    emit(state.copyWith(perfilResponse: response));
  }

  // ==========================================================
  // 2.- ACTUALIZAR PERFIL
  // ==========================================================
  Future<void> _onUpdatePerfilUsuario(
    UpdatePerfilUsuarioEvent event,
    Emitter<UsuarioState> emit,
  ) async {
    emit(
      state.copyWith(
        actionResponse: const Loading<ApiResponse<PerfilUsuarioData>>(),
      ),
    );

    final response = await usuariosUsesCases.updatePerfilUsuario.run(
      request: event.request,
    );

    if (response is Success<ApiResponse<PerfilUsuarioData>>) {
      final perfilActualizado = response.data.data;

      emit(
        state.copyWith(
          actionResponse: response,

          // Actualizamos también el perfil visible
          // para no hacer GET nuevamente.
          perfil: perfilActualizado ?? state.perfil,
        ),
      );

      return;
    }

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // 3.- ACTUALIZAR CONTRASEÑA
  // ==========================================================

  Future<void> _onUpdatePasswordUsuario(
    UpdatePasswordUsuarioEvent event,
    Emitter<UsuarioState> emit,
  ) async {
    emit(
      state.copyWith(
        passwordResponse: const Loading<ApiResponse<PasswordUpdateData>>(),
      ),
    );

    final response = await usuariosUsesCases.updatePasswordUsuario.run(
      request: event.request,
    );

    emit(state.copyWith(passwordResponse: response));
  }

  // ==========================================================
  // 4.- ACTUALIZAR FOTO
  // ==========================================================
  Future<void> _onUpdateFotoUsuario(
    UpdateFotoUsuarioEvent event,
    Emitter<UsuarioState> emit,
  ) async {
    emit(
      state.copyWith(
        fotoResponse: const Loading<ApiResponse<FotoPerfilUpdateData>>(),
      ),
    );

    final response = await usuariosUsesCases.updateFotoUsuario.run(
      filePath: event.filePath,
    );

    if (response is Success<ApiResponse<FotoPerfilUpdateData>>) {
      final fotoData = response.data.data;

      if (fotoData != null && state.perfil != null) {
        final perfilActual = state.perfil!;

        // ====================================================
        // RECONSTRUIR PERSONA CON NUEVA FOTO
        // ====================================================
        final personaActualizada = PerfilPersona(
          idPersona: perfilActual.persona.idPersona,
          nombres: perfilActual.persona.nombres,
          apellidos: perfilActual.persona.apellidos,
          email: perfilActual.persona.email,
          tipoDocumento: perfilActual.persona.tipoDocumento,
          numeroDocumento: perfilActual.persona.numeroDocumento,
          fechaNacimiento: perfilActual.persona.fechaNacimiento,
          celular: perfilActual.persona.celular,
          direccion: perfilActual.persona.direccion,
          fotoUrl: fotoData.fotoUrl,
          genero: perfilActual.persona.genero,
          estado: perfilActual.persona.estado,
        );

        final perfilActualizado = PerfilUsuarioData(
          usuario: perfilActual.usuario,
          persona: personaActualizada,
          roles: perfilActual.roles,
        );

        emit(state.copyWith(fotoResponse: response, perfil: perfilActualizado));
        return;
      }
    }

    emit(state.copyWith(fotoResponse: response));
  }

  // ==========================================================
  // 5.- LIMPIAR ACTION RESPONSE
  // ==========================================================
  void _onClearActionResponse(
    ClearUsuarioActionResponseEvent event,
    Emitter<UsuarioState> emit,
  ) {
    emit(state.copyWith(clearActionResponse: true));
  }

  // ==========================================================
  // 6.- LIMPIAR PASSWORD RESPONSE
  // ==========================================================
  void _onClearPasswordResponse(
    ClearUsuarioPasswordResponseEvent event,
    Emitter<UsuarioState> emit,
  ) {
    emit(state.copyWith(clearPasswordResponse: true));
  }

  // ==========================================================
  // 7.- LIMPIAR FOTO RESPONSE
  // ==========================================================
  void _onClearFotoResponse(
    ClearUsuarioFotoResponseEvent event,
    Emitter<UsuarioState> emit,
  ) {
    emit(state.copyWith(clearFotoResponse: true));
  }

  // ==========================================================
  // 8.- LIMPIAR PERFIL
  // ==========================================================
  void _onClearPerfil(
    ClearPerfilUsuarioEvent event,
    Emitter<UsuarioState> emit,
  ) {
    emit(const UsuarioState());
  }
}
