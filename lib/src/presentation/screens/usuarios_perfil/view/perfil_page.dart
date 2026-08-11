import 'package:app_aryoria/src/data/models/usuario-perfil/foto_perfil_update_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Bloc
import 'package:app_aryoria/src/presentation/screens/usuarios_perfil/bloc/usuario_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/usuarios_perfil/bloc/usuario_event.dart';
import 'package:app_aryoria/src/presentation/screens/usuarios_perfil/bloc/usuario_state.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';

// View
import 'perfil_content.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _loadPerfil();
    });
  }

  // ==========================================================
  // CARGAR PERFIL
  // ==========================================================
  void _loadPerfil() {
    context.read<UsuarioBloc>().add(const GetPerfilUsuarioEvent());
  }

  // ==========================================================
  // REFRESH
  // ==========================================================
  Future<void> _onRefresh() async {
    final bloc = context.read<UsuarioBloc>();

    final completed = bloc.stream.firstWhere(
      (state) =>
          state.perfilResponse != null && state.perfilResponse is! Loading,
    );

    bloc.add(const GetPerfilUsuarioEvent());

    await completed;
  }

  // ==========================================================
  // EDITAR PERFIL
  // ==========================================================
  Future<void> _onEditarPerfil() async {
    final result = await context.pushNamed('editar_perfil');

    if (!mounted) return;

    if (result == true) {
      _loadPerfil();
    }
  }

  // ==========================================================
  // CAMBIAR CONTRASEÑA
  // ==========================================================
  Future<void> _onCambiarPassword() async {
    final result = await context.pushNamed('cambiar_password');

    if (!mounted) return;

    if (result == true) {
      _showSuccess('Contraseña actualizada correctamente.');
    }
  }

  // ==========================================================
  // MENSAJES
  // ==========================================================
  void _showSuccess(String message) {
    if (!mounted) return;

    final colors = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: colors.primary),
      );
  }

  void _showError(String message) {
    if (!mounted) return;

    final colors = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: colors.error),
      );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ======================================================
        // CARGA DE PERFIL
        // ======================================================
        BlocListener<UsuarioBloc, UsuarioState>(
          listenWhen: (previous, current) {
            return previous.perfilResponse != current.perfilResponse;
          },
          listener: (context, state) {
            final response = state.perfilResponse;

            if (response is ErrorData<ApiResponse<PerfilUsuarioData>>) {
              _showError(response.displayMessage);
            }
          },
        ),

        // ======================================================
        // UPDATE PERFIL
        // ======================================================
        BlocListener<UsuarioBloc, UsuarioState>(
          listenWhen: (previous, current) {
            return previous.actionResponse != current.actionResponse;
          },
          listener: (context, state) {
            final response = state.actionResponse;

            if (response == null || response is Loading) {
              return;
            }

            if (response is Success<ApiResponse<PerfilUsuarioData>>) {
              final dynamic api = response.data;

              String message = 'Perfil actualizado correctamente.';

              if (api is ApiResponse && api.message.trim().isNotEmpty) {
                message = api.message;
              }

              _showSuccess(message);
            }

            if (response is ErrorData<ApiResponse<PerfilUsuarioData>>) {
              _showError(response.displayMessage);
            }

            context.read<UsuarioBloc>().add(
              const ClearUsuarioActionResponseEvent(),
            );
          },
        ),

        // ======================================================
        // UPDATE FOTO
        // ======================================================
        BlocListener<UsuarioBloc, UsuarioState>(
          listenWhen: (previous, current) {
            return previous.fotoResponse != current.fotoResponse;
          },
          listener: (context, state) {
            final response = state.fotoResponse;

            if (response == null || response is Loading) {
              return;
            }

            if (response is Success<ApiResponse<FotoPerfilUpdateData>>) {
              final dynamic api = response.data;

              String message = 'Foto de perfil actualizada correctamente.';

              if (api is ApiResponse && api.message.trim().isNotEmpty) {
                message = api.message;
              }

              _showSuccess(message);
            }

            if (response is ErrorData<ApiResponse<FotoPerfilUpdateData>>) {
              _showError(response.displayMessage);
            }

            context.read<UsuarioBloc>().add(
              const ClearUsuarioFotoResponseEvent(),
            );
          },
        ),
      ],

      child: PerfilContent(
        onRefresh: _onRefresh,
        onRetry: _loadPerfil,
        onEditarPerfil: _onEditarPerfil,
        onCambiarPassword: _onCambiarPassword,
      ),
    );
  }
}
