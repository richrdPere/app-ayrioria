import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_paginated.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_request.dart';
import 'package:app_aryoria/src/data/models/login/login_data_model.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

abstract class EmpresaRepository {
  /// 1.- Crear empresa
  Future<Resource<ApiResponse<EmpresaData>>> createEmpresa(
    EmpresaRequest request,
  );

  /// 2.- Obtener empresas del usuario autenticado
  Future<Resource<ApiResponse<EmpresaPaginated>>> getEmpresas({
    int page = 1,
    int limit = 10,
    String search = '',
  });

  /// 3.- Obtener empresa por Id
  Future<Resource<ApiResponse<EmpresaData>>> getEmpresaById(int idEmpresa);

  /// 4.- Actualizar empresa
  Future<Resource<ApiResponse<EmpresaData>>> updateEmpresa({
    required int idEmpresa,
    required EmpresaRequest request,
  });

  /// 5.- Eliminar empresa
  Future<Resource<ApiResponse<void>>> deleteEmpresa(int idEmpresa);

  /// 6.-Seleccionar empresa
  Future<Resource<ApiResponse<LoginDataModel>>> selectEmpresa(int idEmpresa);
}
