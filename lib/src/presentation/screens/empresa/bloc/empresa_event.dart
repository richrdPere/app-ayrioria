import 'package:app_aryoria/src/data/models/empresa/empresa_request.dart';

abstract class EmpresaEvent {
  const EmpresaEvent();
}

/// Crear empresa
class CreateEmpresaEvent extends EmpresaEvent {
  final EmpresaRequest request;

  const CreateEmpresaEvent(this.request);
}

/// Obtener empresas paginadas
class GetEmpresasEvent extends EmpresaEvent {
  final int page;
  final int limit;
  final String search;

  const GetEmpresasEvent({this.page = 1, this.limit = 10, this.search = ''});
}

/// Obtener empresa por Id
class GetEmpresaByIdEvent extends EmpresaEvent {
  final int idEmpresa;

  const GetEmpresaByIdEvent(this.idEmpresa);
}

/// Actualizar empresa
class UpdateEmpresaEvent extends EmpresaEvent {
  final int idEmpresa;
  final EmpresaRequest request;

  const UpdateEmpresaEvent({required this.idEmpresa, required this.request});
}

/// Eliminar empresa
class DeleteEmpresaEvent extends EmpresaEvent {
  final int idEmpresa;

  const DeleteEmpresaEvent(this.idEmpresa);
}

/// Eliminar empresa
class SelectEmpresaEvent extends EmpresaEvent {
  final int idEmpresa;

  const SelectEmpresaEvent(this.idEmpresa);
}

/// Limpiar estados
class EmpresaResetEvent extends EmpresaEvent {
  const EmpresaResetEvent();
}
