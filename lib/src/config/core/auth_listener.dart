import 'dart:async';
import 'dart:convert';

import 'package:app_aryoria/injection.dart';

import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/common/api_response.dart';

import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:app_aryoria/src/data/models/login/login_data_model.dart';
import 'package:app_aryoria/src/domain/repositories/auth_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

import 'package:app_aryoria/src/presentation/screens/auth/login/bloc/login_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/auth/login/bloc/login_state.dart';

import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthListener extends StatefulWidget {
  final Widget child;

  const AuthListener({super.key, required this.child});

  @override
  State<AuthListener> createState() => _AuthListenerState();
}

class _AuthListenerState extends State<AuthListener>
    with WidgetsBindingObserver {
  Timer? _tokenTimer;

  final AuthRepository _authRepository = locator<AuthRepository>();

  bool _handlingExpiredToken = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkStoredToken();

      _startTokenExpirationWatcher();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _tokenTimer?.cancel();

    super.dispose();
  }

  /// Se ejecuta cuando la aplicación vuelve
  /// desde segundo plano.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkStoredToken();
    }
  }

  /// ------------------------------------------------------------
  /// MONITOR DEL TOKEN
  /// ------------------------------------------------------------
  void _startTokenExpirationWatcher() {
    _tokenTimer?.cancel();

    _tokenTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _checkStoredToken();
    });
  }

  /// ------------------------------------------------------------
  /// VERIFICAR TOKEN ALMACENADO
  /// ------------------------------------------------------------
  Future<void> _checkStoredToken() async {
    if (_handlingExpiredToken) return;

    final token = await _authRepository.getToken();

    /// No existe sesión almacenada.
    if (token == null || token.trim().isEmpty) {
      return;
    }

    final expired = _isTokenExpired(token);

    if (expired) {
      await _handleExpiredToken();
    }
  }

  /// ------------------------------------------------------------
  /// COMPROBAR EXPIRACIÓN JWT
  /// ------------------------------------------------------------
  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');

      if (parts.length != 3) {
        debugPrint('Token JWT inválido');
        return true;
      }

      final payload = parts[1];

      final normalizedPayload = base64Url.normalize(payload);

      final decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));

      final Map<String, dynamic> payloadMap = jsonDecode(decodedPayload);

      final exp = payloadMap['exp'];

      if (exp == null) {
        /// Si tu JWT no contiene exp,
        /// no podemos determinar expiración localmente.
        return false;
      }

      final expirationDate = DateTime.fromMillisecondsSinceEpoch(
        (exp as num).toInt() * 1000,
      );

      final now = DateTime.now();

      return now.isAfter(expirationDate);
    } catch (e) {
      debugPrint('Error verificando expiración del token: $e');

      /// Si el token está corrupto,
      /// es más seguro cerrar la sesión.
      return true;
    }
  }

  /// ------------------------------------------------------------
  /// TOKEN EXPIRADO
  /// ------------------------------------------------------------
  Future<void> _handleExpiredToken() async {
    if (_handlingExpiredToken) return;

    _handlingExpiredToken = true;

    try {
      debugPrint('Token expirado');

      /// 1. Eliminar token / sesión local.
      await _authRepository.logout();

      if (!mounted) return;

      /// 2. Actualizar estado global.
      context.read<SessionBloc>().logout();

      /// NO navegamos manualmente.
      /// GoRouter hará redirect automáticamente
      /// porque isAuthenticated será false.
    } catch (e) {
      debugPrint('Error cerrando sesión expirada: $e');

      if (!mounted) return;

      context.read<SessionBloc>().logout();
    } finally {
      _handlingExpiredToken = false;
    }
  }

  /// ------------------------------------------------------------
  /// BUILD
  /// ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// ========================================================
        /// LOGIN
        /// ========================================================
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.response != current.response ||
              previous.isLoggedOut != current.isLoggedOut,

          listener: (context, state) {
            /// LOGIN EXITOSO
            if (state.response is Success<AuthResponse>) {
              final auth = (state.response as Success<AuthResponse>).data;

              // 1. Actualizar sesión
              context.read<SessionBloc>().updateSession(auth);

              // 2. Verificar token
              _checkStoredToken();

              // 3. Si todavía NO existe una empresa activa,
              // cargar las empresas disponibles del usuario.
              if (auth.data.empresa == null) {
                context.read<EmpresaBloc>().add(
                  const GetEmpresasEvent(page: 1, limit: 10),
                );
              }
            }
            // if (state.response is Success<AuthResponse>) {
            //   final auth = (state.response as Success<AuthResponse>).data;

            //   context.read<SessionBloc>().updateSession(auth);

            //   /// Verificamos inmediatamente el nuevo token.
            //   _checkStoredToken();

            //   // Próximamente:
            //   // EmpresaBloc.add(...)
            //   // SocketBloc.add(...)
            //   // ConfigBloc.add(...)
            //   // NotificationBloc.add(...)
            // }

            /// LOGOUT
            if (state.isLoggedOut) {
              debugPrint('Usuario deslogueado');
              context.read<SessionBloc>().logout();
              context.read<EmpresaBloc>().add(const EmpresaResetEvent());

              // SocketBloc.add(...)
              // EmpresaBloc.add(ClearEmpresa())
              // HomeBloc.add(ClearHome())
            }
          },
        ),

        /// ========================================================
        /// EMPRESA
        /// ========================================================
        BlocListener<EmpresaBloc, EmpresaState>(
          listenWhen: (previous, current) =>
              previous.selectResponse != current.selectResponse,

          listener: (context, state) {
            final response = state.selectResponse;

            if (response is Success<ApiResponse<LoginDataModel>>) {
              final apiResponse = response.data;
              final loginData = apiResponse.data;

              if (loginData == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No se pudieron obtener los datos de la nueva sesión.',
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );

                return;
              }

              // CONVERTIR A AuthResponse
              final authResponse = AuthResponse(
                success: apiResponse.success,
                message: apiResponse.message,
                data: loginData,
              );

              context.read<SessionBloc>().updateSession(authResponse);

              /// Por si el backend devuelve un token nuevo
              /// al seleccionar empresa.
              _checkStoredToken();
            }
          },
        ),
      ],

      child: widget.child,
    );
  }
}

// import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
// import 'package:app_aryoria/src/data/models/login/auth_response.dart';
// import 'package:app_aryoria/src/domain/utils/Resource.dart';
// import 'package:app_aryoria/src/presentation/screens/auth/login/bloc/login_bloc.dart';
// import 'package:app_aryoria/src/presentation/screens/auth/login/bloc/login_state.dart';
// import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
// import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AuthListener extends StatefulWidget {
//   final Widget child;

//   const AuthListener({super.key, required this.child});

//   @override
//   State<AuthListener> createState() => _AuthListenerState();
// }

// class _AuthListenerState extends State<AuthListener> {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         /// LOGIN
//         BlocListener<LoginBloc, LoginState>(
//           listenWhen: (previous, current) =>
//               previous.response != current.response ||
//               previous.isLoggedOut != current.isLoggedOut,

//           listener: (context, state) {
//             /// LOGIN EXITOSO
//             if (state.response is Success<AuthResponse>) {
//               final auth = (state.response as Success<AuthResponse>).data;

//               context.read<SessionBloc>().updateSession(auth);

//               // Próximamente:
//               // EmpresaBloc.add(...)
//               // SocketBloc.add(...)
//               // ConfigBloc.add(...)
//               // NotificationBloc.add(...)
//             }

//             /// LOGOUT
//             if (state.isLoggedOut) {
//               debugPrint("Usuario deslogueado");
//               context.read<SessionBloc>().logout();

//               // SocketBloc.add(...)
//               // EmpresaBloc.add(ClearEmpresa())
//               // HomeBloc.add(ClearHome())
//             }
//           },
//         ),

//         /// EMPRESA
//         BlocListener<EmpresaBloc, EmpresaState>(
//           listenWhen: (p, c) => p.selectResponse != c.selectResponse,
//           listener: (context, state) {
//             final response = state.selectResponse;

//             if (response is Success<AuthResponse>) {
//               context.read<SessionBloc>().updateSession(response.data);
//             }
//           },
//         ),
//       ],

//       child: widget.child,
//     );
//   }
// }
