import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/common/api_response.dart';

import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:app_aryoria/src/data/models/login/login_data_model.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'empresa_create_content.dart';

class EmpresaCreatePage extends StatelessWidget {
  const EmpresaCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ======================================================
        // 1. CREAR EMPRESA
        // ======================================================
        BlocListener<EmpresaBloc, EmpresaState>(
          listenWhen: (previous, current) =>
              previous.createResponse != current.createResponse,

          listener: (context, state) {
            final response = state.createResponse;

            // --------------------------------------------------
            // EMPRESA CREADA
            // --------------------------------------------------
            if (response is Success<ApiResponse<EmpresaData>>) {
              final apiResponse = response.data;
              final empresa = apiResponse.data;

              // El backend respondió success,
              // pero sin data.
              if (empresa == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'La empresa fue creada, pero el servidor no devolvió sus datos.',
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );

                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    apiResponse.message.isNotEmpty
                        ? apiResponse.message
                        : 'Empresa creada satisfactoriamente',
                  ),
                  backgroundColor: Colors.green,
                ),
              );

              // Una vez creada, la seleccionamos.
              context.read<EmpresaBloc>().add(
                SelectEmpresaEvent(empresa.idEmpresa),
              );
            }

            // --------------------------------------------------
            // ERROR AL CREAR
            // --------------------------------------------------

            if (response is ErrorData<ApiResponse<EmpresaData>>) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response.displayMessage),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
        ),

        // ======================================================
        // 2. SELECCIONAR EMPRESA
        // ======================================================
        BlocListener<EmpresaBloc, EmpresaState>(
          listenWhen: (previous, current) =>
              previous.selectResponse != current.selectResponse,

          listener: (context, state) {
            final response = state.selectResponse;

            // ==========================================================
            // EMPRESA SELECCIONADA
            // ==========================================================

            if (response is Success<ApiResponse<LoginDataModel>>) {
              final apiResponse = response.data;

              final loginData = apiResponse.data;

              debugPrint('SELECT SUCCESS: ${apiResponse.success}');

              debugPrint('SELECT MESSAGE: ${apiResponse.message}');

              debugPrint(
                'EMPRESA RECIBIDA: '
                '${loginData?.empresa?.idEmpresa}',
              );

              // --------------------------------------------------------
              // VALIDAR SESSION DATA
              // --------------------------------------------------------

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

              if (loginData.empresa == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'La empresa fue creada, pero no pudo establecerse como empresa activa.',
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );

                return;
              }

              // --------------------------------------------------------
              // CREAR AuthResponse
              // --------------------------------------------------------

              final authResponse = AuthResponse(
                success: apiResponse.success,

                message: apiResponse.message,

                data: loginData,
              );

              // --------------------------------------------------------
              // ACTUALIZAR SESSION BLOC
              // --------------------------------------------------------

              context.read<SessionBloc>().updateSession(authResponse);

              // --------------------------------------------------------
              // COMPROBAR EL ESTADO REAL
              // --------------------------------------------------------

              final session = context.read<SessionBloc>().state;

              debugPrint(
                'SESSION AUTHENTICATED: '
                '${session.isAuthenticated}',
              );

              debugPrint(
                'SESSION EMPRESA: '
                '${session.empresaActiva?.idEmpresa}',
              );

              // --------------------------------------------------------
              // IMPORTANTE:
              // no necesitamos addPostFrameCallback
              // --------------------------------------------------------

              if (session.isAuthenticated && session.empresaActiva != null) {
                debugPrint('NAVEGANDO A HOME...');

                context.goNamed('home');
              } else {
                debugPrint(
                  'NO SE NAVEGA: '
                  'la sesión todavía no tiene empresa activa.',
                );
              }

              return;
            }

            // ==========================================================
            // ERROR AL SELECCIONAR
            // ==========================================================

            if (response is ErrorData<ApiResponse<LoginDataModel>>) {
              debugPrint(
                'ERROR SELECT EMPRESA: '
                '${response.displayMessage}',
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(response.displayMessage),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
        ),
        // BlocListener<EmpresaBloc, EmpresaState>(
        //   listenWhen: (previous, current) =>
        //       previous.selectResponse != current.selectResponse,

        //   listener: (context, state) {
        //     final response = state.selectResponse;

        //     // --------------------------------------------------
        //     // EMPRESA SELECCIONADA
        //     // --------------------------------------------------
        //     if (response is Success<ApiResponse<LoginDataModel>>) {
        //       final apiResponse = response.data;
        //       final loginData = apiResponse.data;

        //       if (loginData == null) {
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           const SnackBar(
        //             content: Text(
        //               'No se pudieron obtener los datos de la nueva sesión.',
        //             ),
        //             backgroundColor: Colors.redAccent,
        //           ),
        //         );

        //         return;
        //       }

        //       // ================================================
        //       // CONVERTIR A AuthResponse
        //       //
        //       // SessionBloc todavía trabaja con AuthResponse.
        //       // ================================================

        //       final authResponse = AuthResponse(
        //         success: apiResponse.success,
        //         message: apiResponse.message,
        //         data: loginData,
        //       );

        //       // ================================================
        //       // ACTUALIZAR SESIÓN GLOBAL
        //       // ================================================
        //       context.read<SessionBloc>().updateSession(authResponse);

        //       // ================================================
        //       // IR A HOME
        //       // ================================================
        //       WidgetsBinding.instance.addPostFrameCallback((_) {
        //         if (!context.mounted) {
        //           return;
        //         }

        //         context.goNamed('home');
        //       });
        //     }

        //     // --------------------------------------------------
        //     // ERROR AL SELECCIONAR
        //     // --------------------------------------------------
        //     if (response is ErrorData<ApiResponse<LoginDataModel>>) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(
        //           content: Text(response.displayMessage),
        //           backgroundColor: Colors.redAccent,
        //         ),
        //       );
        //     }
        //   },
        // ),
      ],

      child: const EmpresaCreateContent(),
    );
  }
}

// import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
// import 'package:app_aryoria/src/data/models/login/auth_response.dart';
// import 'package:app_aryoria/src/domain/utils/Resource.dart';
// import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
// import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';
// import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// import 'empresa_create_content.dart';

// class EmpresaCreatePage extends StatelessWidget {
//   const EmpresaCreatePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<EmpresaBloc, EmpresaState>(
//       listenWhen: (previous, current) =>
//           previous.createResponse != current.createResponse ||
//           previous.selectResponse != current.selectResponse,

//       listener: (context, state) {
//         // Empresa creada correctamente
//         if (state.createResponse is Success<EmpresaData>) {
//           final response = state.createResponse as Success<EmpresaData>;
//           final empresa = response.data;

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Empresa creada satisfactoriamente"),
//               backgroundColor: Colors.green,
//             ),
//           );

//           context.read<EmpresaBloc>().add(
//             SelectEmpresaEvent(empresa.idEmpresa),
//           );
//         }

//         // Empresa seleccionada correctamente
//         if (state.selectResponse is Success<AuthResponse>) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             context.goNamed('home');
//           });
//         }

//         // Error al crear
//         if (state.createResponse is ErrorData) {
//           final error = state.createResponse as ErrorData;

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(error.displayMessage),
//               backgroundColor: Colors.redAccent,
//             ),
//           );
//         }

//         // Error al seleccionar
//         if (state.selectResponse is ErrorData) {
//           final error = state.selectResponse as ErrorData;

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(error.displayMessage),
//               backgroundColor: Colors.redAccent,
//             ),
//           );
//         }
//       },
//       child: const EmpresaCreateContent(),
//     );
//   }
// }
