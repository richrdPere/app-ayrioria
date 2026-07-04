import 'package:app_aryoria/src/data/models/register/register_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class RegisterState {
  final Resource<RegisterResponse>? response;
  final bool isLoading;

  const RegisterState({
    this.response,
    this.isLoading = false,
  });

  RegisterState copyWith({
    Resource<RegisterResponse>? response,
    bool? isLoading,
  }) {
    return RegisterState(
      response: response ?? this.response,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory RegisterState.initial() {
    return const RegisterState(
      response: null,
      isLoading: false,
    );
  }
}

// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

// // Resource
// import 'package:app_aryoria/src/domain/utils/Resource.dart';

// // Bloc_Form_Item
// import 'package:app_aryoria/src/presentation/shared/utils/BlocFormItem.dart';

// class RegisterState extends Equatable {
//   final BlocFormItem name;
//   final BlocFormItem lastname;
//   final BlocFormItem email;
//   final BlocFormItem phone;
//   final BlocFormItem dni;
//   final BlocFormItem username;
//   final BlocFormItem password;
//   final BlocFormItem confirmPassword;

//   final GlobalKey<FormState>? formKey;
//   final Resource? response;

//   // Constructor
//   const RegisterState({
//     this.name = const BlocFormItem(error: 'Ingrese su nombre completo'),
//     this.lastname = const BlocFormItem(error: 'Ingrese sus apellidos'),
//     this.email = const BlocFormItem(error: 'Ingrese su email'),
//     this.phone = const BlocFormItem(error: 'Ingrese su teléfono'),
//     this.dni = const BlocFormItem(error: 'Ingrese su DNI'),
//     this.username = const BlocFormItem(),
//     this.password = const BlocFormItem(error: 'Ingrese una contraseña'),
//     this.confirmPassword = const BlocFormItem(error: 'Confirme su contraseña'),
//     this.formKey,
//     this.response,
//   });

//   // Metodos
//   // toUser() => UsuarioEntity(
//   //   email: email.value,
//   //   username: dni.value,
//   //   idUsuario: null,
//   //   idPersona: null,
//   //   estado: null,
//   //   persona: null,
//   //   roles: [],
//   // );

//   RegisterState copyWith({
//     BlocFormItem? name,
//     BlocFormItem? lastname,
//     BlocFormItem? email,
//     BlocFormItem? phone,
//     BlocFormItem? dni,
//     BlocFormItem? username,
//     BlocFormItem? password,
//     BlocFormItem? confirmPassword,
//     GlobalKey<FormState>? formKey,
//     Resource? response,
//   }) {
//     return RegisterState(
//       name: name ?? this.name,
//       lastname: lastname ?? this.lastname,
//       email: email ?? this.email,
//       phone: phone ?? this.phone,
//       dni: dni ?? this.dni,
//       username: username ?? this.username,
//       password: password ?? this.password,
//       confirmPassword: confirmPassword ?? this.confirmPassword,
//       formKey: formKey,
//       response: response,
//     );
//   }

//   // Props
//   @override
//   List<Object?> get props => [
//     name,
//     lastname,
//     email,
//     phone,
//     dni,
//     username,
//     password,
//     confirmPassword,
//     response,
//   ];
// }
