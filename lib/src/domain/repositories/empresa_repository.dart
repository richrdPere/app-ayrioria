import 'package:app_aryoria/src/data/models/empresa/empresa_paginated.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_request.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_response.dart';
import 'package:app_aryoria/src/data/models/common/base_response.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';


abstract class EmpresaRepository {
  /// Crear empresa
  Future<Resource<EmpresaResponse>> createEmpresa(EmpresaRequest request);

  /// Listar empresas del usuario autenticado
  Future<Resource<EmpresaPaginatedResponse>> getEmpresas({
    int page = 1,
    int limit = 10,
    String search = '',
  });

  /// Obtener empresa por Id
  Future<Resource<EmpresaResponse>> getEmpresaById(int idEmpresa);

  /// Actualizar empresa
  Future<Resource<EmpresaResponse>> updateEmpresa({
    required int idEmpresa,
    required EmpresaRequest request,
  });

  /// Eliminar empresa
  Future<Resource<BaseResponse>> deleteEmpresa(int idEmpresa);
}
