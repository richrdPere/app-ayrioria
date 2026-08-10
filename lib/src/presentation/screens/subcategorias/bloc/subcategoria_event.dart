import 'package:equatable/equatable.dart';

// Models
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_create_req.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_update_req.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_query_params.dart';

abstract class SubcategoriaEvent extends Equatable {
  const SubcategoriaEvent();

  @override
  List<Object?> get props => [];
}

// *****************************************************************************
// 1.- OBTENER SUBCATEGORÍAS PAGINADAS
// *****************************************************************************
class GetSubcategoriasPaginatedEvent extends SubcategoriaEvent {
  final int idEmpresa;
  final SubcategoriasParams queryParams;

  /// Indica que la consulta debe considerarse una recarga del listado.
  final bool refresh;

  const GetSubcategoriasPaginatedEvent({
    required this.idEmpresa,
    required this.queryParams,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [idEmpresa, queryParams, refresh];
}

// *****************************************************************************
// 2.- OBTENER SUBCATEGORÍAS POR CATEGORÍA
// *****************************************************************************
class GetSubcategoriasByCategoriaEvent extends SubcategoriaEvent {
  final int idEmpresa;
  final int idCategoria;

  const GetSubcategoriasByCategoriaEvent({
    required this.idEmpresa,
    required this.idCategoria,
  });

  @override
  List<Object?> get props => [idEmpresa, idCategoria];
}

// *****************************************************************************
// 3.- OBTENER SUBCATEGORÍAS POR TIPO
// *****************************************************************************
class GetSubcategoriasByTipoEvent extends SubcategoriaEvent {
  final int idEmpresa;
  final String tipo;

  const GetSubcategoriasByTipoEvent({
    required this.idEmpresa,
    required this.tipo,
  });

  @override
  List<Object?> get props => [idEmpresa, tipo];
}

// *****************************************************************************
// 4.- OBTENER SUBCATEGORÍA POR ID
// *****************************************************************************
class GetSubcategoriaByIdEvent extends SubcategoriaEvent {
  final int idEmpresa;
  final int idSubcategoria;

  const GetSubcategoriaByIdEvent({
    required this.idEmpresa,
    required this.idSubcategoria,
  });

  @override
  List<Object?> get props => [idEmpresa, idSubcategoria];
}

// *****************************************************************************
// 5.- CREAR SUBCATEGORÍA
// *****************************************************************************
class CreateSubcategoriaEvent extends SubcategoriaEvent {
  final int idEmpresa;
  final SubcategoriaCreateRequest request;

  const CreateSubcategoriaEvent({
    required this.idEmpresa,
    required this.request,
  });

  @override
  List<Object?> get props => [idEmpresa, request];
}

// *****************************************************************************
// 6.- ACTUALIZAR SUBCATEGORÍA
// *****************************************************************************
class UpdateSubcategoriaEvent extends SubcategoriaEvent {
  final int idEmpresa;
  final int idSubcategoria;
  final SubcategoriaUpdateRequest request;

  const UpdateSubcategoriaEvent({
    required this.idEmpresa,
    required this.idSubcategoria,
    required this.request,
  });

  @override
  List<Object?> get props => [idEmpresa, idSubcategoria, request];
}

// *****************************************************************************
// 7.- CAMBIAR ESTADO
// *****************************************************************************
class ChangeSubcategoriaEstadoEvent extends SubcategoriaEvent {
  final int idEmpresa;
  final int idSubcategoria;
  final bool estado;

  const ChangeSubcategoriaEstadoEvent({
    required this.idEmpresa,
    required this.idSubcategoria,
    required this.estado,
  });

  @override
  List<Object?> get props => [idEmpresa, idSubcategoria, estado];
}

// *****************************************************************************
// 8.- ELIMINAR SUBCATEGORÍA
// *****************************************************************************
class DeleteSubcategoriaEvent extends SubcategoriaEvent {
  final int idEmpresa;
  final int idSubcategoria;

  const DeleteSubcategoriaEvent({
    required this.idEmpresa,
    required this.idSubcategoria,
  });

  @override
  List<Object?> get props => [idEmpresa, idSubcategoria];
}

// *****************************************************************************
// 9.- LIMPIAR RESPUESTA DE ACCIÓN
// *****************************************************************************
class ClearSubcategoriaActionResponseEvent extends SubcategoriaEvent {
  const ClearSubcategoriaActionResponseEvent();
}

// *****************************************************************************
// 10.- LIMPIAR DETALLE
// *****************************************************************************
class ClearSubcategoriaDetailEvent extends SubcategoriaEvent {
  const ClearSubcategoriaDetailEvent();
}

// *****************************************************************************
// 11.- LIMPIAR LISTAS AUXILIARES
// *****************************************************************************
class ClearSubcategoriaAuxiliaryListsEvent extends SubcategoriaEvent {
  const ClearSubcategoriaAuxiliaryListsEvent();
}

// *****************************************************************************
// 12.- RESET GENERAL
// *****************************************************************************
class ResetSubcategoriaStateEvent extends SubcategoriaEvent {
  const ResetSubcategoriaStateEvent();
}
