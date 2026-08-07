import 'package:equatable/equatable.dart';

// Models
import 'package:app_aryoria/src/data/models/sub_categoria/create_sub_categoria_req.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/update_sub_categoria_req.dart';

abstract class SubcategoriaEvent extends Equatable {
  const SubcategoriaEvent();

  @override
  List<Object?> get props => [];
}

// *****************************************************************************
// 1.- Obtener subcategorias paginadas
// *****************************************************************************
class GetSubcategoriasPaginatedEvent extends SubcategoriaEvent {
  final int idEmpresa;
  final Map<String, dynamic> queryParams;

  const GetSubcategoriasPaginatedEvent({
    required this.idEmpresa,
    required this.queryParams,
  });

  @override
  List<Object?> get props => [idEmpresa, queryParams];
}

// *****************************************************************************
// 2.- Refrescar subcategorias paginadas
// *****************************************************************************
class RefreshSubcategoriasEvent extends SubcategoriaEvent {
  final int idEmpresa;
  final Map<String, dynamic> queryParams;

  const RefreshSubcategoriasEvent({
    required this.idEmpresa,
    required this.queryParams,
  });

  @override
  List<Object?> get props => [idEmpresa, queryParams];
}

// *****************************************************************************
// 3.- Obtener subcategorias por categoria
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
// 4.- Obtener subcategorias por tipo
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
// 5.- Obtener subcategoria por ID
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
// 6.- Crear subcategoria
// *****************************************************************************
class CreateSubcategoriaEvent extends SubcategoriaEvent {
  final int idEmpresa;
  final CreateSubcategoriaRequest request;

  const CreateSubcategoriaEvent({
    required this.idEmpresa,
    required this.request,
  });

  @override
  List<Object?> get props => [idEmpresa, request];
}

// *****************************************************************************
// 7.- Actualizar subcategoria
// *****************************************************************************
class UpdateSubcategoriaEvent extends SubcategoriaEvent {
  final int idEmpresa;
  final int idSubcategoria;
  final UpdateSubcategoriaRequest request;

  const UpdateSubcategoriaEvent({
    required this.idEmpresa,
    required this.idSubcategoria,
    required this.request,
  });

  @override
  List<Object?> get props => [idEmpresa, idSubcategoria, request];
}

// *****************************************************************************
// 8.- Cambiar estado de subcategoria
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
// 9.- Eliminar subcategoria
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
// 10.- Limpiar respuesta de acciones
// *****************************************************************************
class ClearSubcategoriaActionResponseEvent extends SubcategoriaEvent {
  const ClearSubcategoriaActionResponseEvent();
}

// *****************************************************************************
// 11.- Limpiar detalle seleccionado
// *****************************************************************************
class ClearSubcategoriaDetailEvent extends SubcategoriaEvent {
  const ClearSubcategoriaDetailEvent();
}

// *****************************************************************************
// 12.- Limpiar listas auxiliares
// *****************************************************************************
class ClearSubcategoriaAuxiliaryListsEvent extends SubcategoriaEvent {
  const ClearSubcategoriaAuxiliaryListsEvent();
}
