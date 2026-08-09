import 'package:app_aryoria/src/data/models/empresa/empresa_request.dart';

abstract class EmpresaEvent {
  const EmpresaEvent();
}

/// 1. CREAR EMPRESA
class CreateEmpresaEvent extends EmpresaEvent {
  final EmpresaRequest request;

  const CreateEmpresaEvent(this.request);
}

/// 2. OBTENER EMPRESAS
class GetEmpresasEvent extends EmpresaEvent {
  final int page;
  final int limit;
  final String search;

  const GetEmpresasEvent({this.page = 1, this.limit = 10, this.search = ''});
}

/// 3. OBTENER EMPRESA POR ID
class GetEmpresaByIdEvent extends EmpresaEvent {
  final int idEmpresa;

  const GetEmpresaByIdEvent(this.idEmpresa);
}

/// 4. ACTUALIZAR EMPRESA
class UpdateEmpresaEvent extends EmpresaEvent {
  final int idEmpresa;
  final EmpresaRequest request;

  const UpdateEmpresaEvent({required this.idEmpresa, required this.request});
}

/// 5. ELIMINAR EMPRESA
class DeleteEmpresaEvent extends EmpresaEvent {
  final int idEmpresa;

  const DeleteEmpresaEvent(this.idEmpresa);
}

/// 6. SELECCIONAR EMPRESA
class SelectEmpresaEvent extends EmpresaEvent {
  final int idEmpresa;

  const SelectEmpresaEvent(this.idEmpresa);
}

/// 7. RESET
class EmpresaResetEvent extends EmpresaEvent {
  const EmpresaResetEvent();
}
