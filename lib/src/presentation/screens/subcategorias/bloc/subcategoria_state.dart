import 'package:equatable/equatable.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_paginado.dart';

class SubcategoriaState extends Equatable {
  // *************************************************************************
  // Listado paginado
  // *************************************************************************
  final Resource<SubcategoriaPaginated>? paginatedResponse;

  // *************************************************************************
  // Subcategorias por categoria
  // *************************************************************************
  final Resource<List<SubcategoriaData>>? byCategoriaResponse;

  // *************************************************************************
  // Subcategorias por tipo
  // *************************************************************************
  final Resource<List<SubcategoriaData>>? byTipoResponse;

  // *************************************************************************
  // Detalle
  // *************************************************************************
  final Resource<SubcategoriaData>? detailResponse;

  // *************************************************************************
  // Crear / actualizar / cambiar estado
  // *************************************************************************
  final Resource<SubcategoriaData>? actionResponse;

  // *************************************************************************
  // Eliminar
  // *************************************************************************
  final Resource<String>? deleteResponse;

  const SubcategoriaState({
    this.paginatedResponse,
    this.byCategoriaResponse,
    this.byTipoResponse,
    this.detailResponse,
    this.actionResponse,
    this.deleteResponse,
  });

  SubcategoriaState copyWith({
    Resource<SubcategoriaPaginated>? paginatedResponse,
    Resource<List<SubcategoriaData>>? byCategoriaResponse,
    Resource<List<SubcategoriaData>>? byTipoResponse,
    Resource<SubcategoriaData>? detailResponse,
    Resource<SubcategoriaData>? actionResponse,
    Resource<String>? deleteResponse,

    bool clearPaginatedResponse = false,
    bool clearByCategoriaResponse = false,
    bool clearByTipoResponse = false,
    bool clearDetailResponse = false,
    bool clearActionResponse = false,
    bool clearDeleteResponse = false,
  }) {
    return SubcategoriaState(
      paginatedResponse: clearPaginatedResponse
          ? null
          : paginatedResponse ?? this.paginatedResponse,

      byCategoriaResponse: clearByCategoriaResponse
          ? null
          : byCategoriaResponse ?? this.byCategoriaResponse,

      byTipoResponse: clearByTipoResponse
          ? null
          : byTipoResponse ?? this.byTipoResponse,

      detailResponse: clearDetailResponse
          ? null
          : detailResponse ?? this.detailResponse,

      actionResponse: clearActionResponse
          ? null
          : actionResponse ?? this.actionResponse,

      deleteResponse: clearDeleteResponse
          ? null
          : deleteResponse ?? this.deleteResponse,
    );
  }

  @override
  List<Object?> get props => [
    paginatedResponse,
    byCategoriaResponse,
    byTipoResponse,
    detailResponse,
    actionResponse,
    deleteResponse,
  ];
}
