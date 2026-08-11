class PasswordUpdateRequest {
  final String passwordActual;
  final String passwordNuevo;

  const PasswordUpdateRequest({
    required this.passwordActual,
    required this.passwordNuevo,
  });

  Map<String, dynamic> toJson() {
    return {'password_actual': passwordActual, 'password_nuevo': passwordNuevo};
  }
}
