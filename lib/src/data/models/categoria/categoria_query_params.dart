import 'package:equatable/equatable.dart';

class CategoriasParams extends Equatable {
  final int page;
  final int limit;

  final String? tipo;
  final bool? estado;
  final String? search;

  const CategoriasParams({
    this.page = 1,
    this.limit = 10,
    this.tipo,
    this.estado,
    this.search,
  });

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {'page': page, 'limit': limit};

    final String? tipoValue = tipo?.trim();

    if (tipoValue != null && tipoValue.isNotEmpty) {
      params['tipo'] = tipoValue.toUpperCase();
    }

    if (estado != null) {
      params['estado'] = estado;
    }

    final String? searchValue = search?.trim();

    if (searchValue != null && searchValue.isNotEmpty) {
      params['search'] = searchValue;
    }

    return params;
  }

  CategoriasParams copyWith({
    int? page,
    int? limit,
    String? tipo,
    bool? estado,
    String? search,

    bool clearTipo = false,
    bool clearEstado = false,
    bool clearSearch = false,
  }) {
    return CategoriasParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      tipo: clearTipo ? null : tipo ?? this.tipo,
      estado: clearEstado ? null : estado ?? this.estado,
      search: clearSearch ? null : search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [page, limit, tipo, estado, search];
}
