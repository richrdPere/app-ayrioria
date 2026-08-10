import 'package:equatable/equatable.dart';

// Models
import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_query_params.dart';

abstract class CategoriaEvent extends Equatable {
  const CategoriaEvent();

  @override
  List<Object?> get props => [];
}

// ==========================================================
// 1. CREAR CATEGORÍA
// ==========================================================
class CreateCategoriaEvent extends CategoriaEvent {
  final CategoriaRequest request;

  const CreateCategoriaEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

// ==========================================================
// 2. LISTAR CATEGORÍAS PAGINADAS
// ==========================================================
class GetCategoriasEvent extends CategoriaEvent {
  final int idEmpresa;
  final CategoriasParams queryParams;
  final bool refresh;

  const GetCategoriasEvent({
    required this.idEmpresa,
    required this.queryParams,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [idEmpresa, queryParams, refresh];
}

// ==========================================================
// 3. OBTENER CATEGORÍA POR ID
// ==========================================================
class GetCategoriaByIdEvent extends CategoriaEvent {
  final int idCategoria;
  final int idEmpresa;

  const GetCategoriaByIdEvent({
    required this.idCategoria,
    required this.idEmpresa,
  });

  @override
  List<Object?> get props => [idCategoria, idEmpresa];
}

// ==========================================================
// 4. OBTENER CATEGORÍAS POR TIPO
// ==========================================================
class GetCategoriasByTipoEvent extends CategoriaEvent {
  final String tipo;
  final int idEmpresa;

  const GetCategoriasByTipoEvent({required this.tipo, required this.idEmpresa});

  @override
  List<Object?> get props => [tipo, idEmpresa];
}

// ==========================================================
// 5. ACTUALIZAR CATEGORÍA
// ==========================================================
class UpdateCategoriaEvent extends CategoriaEvent {
  final int idCategoria;
  final int idEmpresa;
  final CategoriaRequest request;

  const UpdateCategoriaEvent({
    required this.idCategoria,
    required this.idEmpresa,
    required this.request,
  });

  @override
  List<Object?> get props => [idCategoria, idEmpresa, request];
}

// ==========================================================
// 6. ELIMINAR CATEGORÍA
// ==========================================================
class DeleteCategoriaEvent extends CategoriaEvent {
  final int idCategoria;
  final int idEmpresa;

  const DeleteCategoriaEvent({
    required this.idCategoria,
    required this.idEmpresa,
  });

  @override
  List<Object?> get props => [idCategoria, idEmpresa];
}

// ==========================================================
// 7. LIMPIAR RESPUESTA DE ACCIÓN
// ==========================================================
class ClearCategoriaActionResponseEvent extends CategoriaEvent {
  const ClearCategoriaActionResponseEvent();
}

// ==========================================================
// 8. LIMPIAR CATEGORÍA SELECCIONADA
// ==========================================================
class ClearCategoriaSelectedEvent extends CategoriaEvent {
  const ClearCategoriaSelectedEvent();
}

// ==========================================================
// 9. RESET GENERAL
// ==========================================================
class ResetCategoriaStateEvent extends CategoriaEvent {
  const ResetCategoriaStateEvent();
}
