import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:equatable/equatable.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_paginado.dart';

class SubcategoriaState extends Equatable {
  // 1.- Paginado
  final Resource<ApiResponse<SubcategoriaPaginated>>? paginatedResponse;

  // 2.- Por categoría
  final Resource<ApiResponse<List<SubcategoriaData>>>? byCategoriaResponse;

  // 3.- Por tipo
  final Resource<ApiResponse<List<SubcategoriaData>>>? byTipoResponse;

  // 4.- Detalle
  final Resource<ApiResponse<SubcategoriaData>>? detailResponse;

  // 5.- Crear / actualizar / cambiar estado
  final Resource<ApiResponse<SubcategoriaData>>? actionResponse;

  // 6.- Eliminar
  final Resource<ApiResponse<void>>? deleteResponse;

  const SubcategoriaState({
    this.paginatedResponse,
    this.byCategoriaResponse,
    this.byTipoResponse,
    this.detailResponse,
    this.actionResponse,
    this.deleteResponse,
  });

  SubcategoriaState copyWith({
    Resource<ApiResponse<SubcategoriaPaginated>>? paginatedResponse,
    Resource<ApiResponse<List<SubcategoriaData>>>? byCategoriaResponse,
    Resource<ApiResponse<List<SubcategoriaData>>>? byTipoResponse,
    Resource<ApiResponse<SubcategoriaData>>? detailResponse,
    Resource<ApiResponse<SubcategoriaData>>? actionResponse,
    Resource<ApiResponse<void>>? deleteResponse,

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
