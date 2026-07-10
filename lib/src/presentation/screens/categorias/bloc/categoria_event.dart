import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';

abstract class CategoriaEvent {
  const CategoriaEvent();
}

class CreateCategoriaEvent extends CategoriaEvent {
  final CategoriaRequest request;

  const CreateCategoriaEvent({required this.request});
}

class GetCategoriasEvent extends CategoriaEvent {
  final int page;
  final int limit;
  final int idEmpresa;
  final String search;

  const GetCategoriasEvent({
    this.page = 1,
    this.limit = 10,
    required this.idEmpresa,
    this.search = '',
  });
}

class GetCategoriaByIdEvent extends CategoriaEvent {
  final int idCategoria;

  const GetCategoriaByIdEvent({required this.idCategoria});
}

class GetCategoriasByTipoEvent extends CategoriaEvent {
  final String tipo;
  final int page;
  final int limit;
  final String search;

  const GetCategoriasByTipoEvent({
    required this.tipo,
    this.page = 1,
    this.limit = 10,
    this.search = '',
  });
}

class UpdateCategoriaEvent extends CategoriaEvent {
  final int idCategoria;
  final CategoriaRequest request;

  const UpdateCategoriaEvent({
    required this.idCategoria,
    required this.request,
  });
}

class DeleteCategoriaEvent extends CategoriaEvent {
  final int idCategoria;

  const DeleteCategoriaEvent({required this.idCategoria});
}

class ResetCategoriaStateEvent extends CategoriaEvent {
  const ResetCategoriaStateEvent();
}
