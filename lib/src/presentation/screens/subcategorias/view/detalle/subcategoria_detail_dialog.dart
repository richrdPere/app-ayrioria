import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_state.dart';

class SubcategoriaDetailDialog extends StatelessWidget {
  final int idEmpresa;
  final int idSubcategoria;

  const SubcategoriaDetailDialog({
    super.key,
    required this.idEmpresa,
    required this.idSubcategoria,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // =========================================================
      // APP BAR
      // =========================================================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: 'Cerrar',
          onPressed: () {
            context.read<SubcategoriaBloc>().add(
              const ClearSubcategoriaDetailEvent(),
            );

            Navigator.pop(context);
          },
          icon: const Icon(Icons.close_rounded),
        ),
        title: const Text('Detalle de subcategoría'),
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: BlocBuilder<SubcategoriaBloc, SubcategoriaState>(
        buildWhen: (previous, current) =>
            previous.detailResponse != current.detailResponse,
        builder: (context, state) {
          final response = state.detailResponse;

          // =====================================================
          // LOADING
          // =====================================================
          if (response is Loading<ApiResponse<SubcategoriaData>>) {
            return const Center(child: CircularProgressIndicator());
          }

          // =====================================================
          // ERROR
          // =====================================================
          if (response is ErrorData<ApiResponse<SubcategoriaData>>) {
            return _buildError(context, response.displayMessage);
          }

          // =====================================================
          // SUCCESS
          // =====================================================
          if (response is Success<ApiResponse<SubcategoriaData>>) {
            final apiResponse = response.data;

            final subcategoria = apiResponse.data;

            if (subcategoria == null) {
              return _buildError(
                context,
                'No se encontró información de la subcategoría.',
              );
            }

            return _buildContent(context, subcategoria);
          }

          return const SizedBox();
        },
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent(BuildContext context, SubcategoriaData subcategoria) {
    final categoria = subcategoria.categoria;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===================================================
            // CABECERA
            // ===================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.account_tree_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subcategoria.nombre,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          categoria?.nombre ?? 'Sin categoría',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ===================================================
            // INFORMACIÓN GENERAL
            // ===================================================
            _buildSectionTitle('Información general'),

            const SizedBox(height: 12),

            _buildInfoCard(
              context,
              children: [
                _buildInfoRow(
                  icon: Icons.category_outlined,
                  title: 'Categoría',
                  value: categoria?.nombre ?? 'No disponible',
                ),

                const Divider(),

                _buildInfoRow(
                  icon: Icons.swap_vert_rounded,
                  title: 'Tipo',
                  value: categoria?.tipo ?? 'No disponible',
                ),

                const Divider(),

                _buildInfoRow(
                  icon: Icons.sort_rounded,
                  title: 'Orden',
                  value: subcategoria.orden.toString(),
                ),

                const Divider(),

                _buildInfoRow(
                  icon: Icons.account_tree_outlined,
                  title: 'Naturaleza',
                  value: subcategoria.naturaleza ?? 'No definida',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ===================================================
            // DESCRIPCIÓN
            // ===================================================
            _buildSectionTitle('Descripción'),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                subcategoria.descripcion?.trim().isNotEmpty == true
                    ? subcategoria.descripcion!
                    : 'Sin descripción.',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),

            const SizedBox(height: 24),

            // ===================================================
            // CONFIGURACIÓN
            // ===================================================
            _buildSectionTitle('Configuración'),

            const SizedBox(height: 12),

            _buildInfoCard(
              context,
              children: [
                _buildStatusRow(
                  title: 'Estado',
                  active: subcategoria.estado,
                  activeText: 'Activa',
                  inactiveText: 'Inactiva',
                ),

                const Divider(),

                _buildStatusRow(
                  title: 'Predeterminada',
                  active: subcategoria.esPredeterminada,
                  activeText: 'Sí',
                  inactiveText: 'No',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ===================================================
            // INFORMACIÓN DE CATEGORÍA
            // ===================================================
            if (categoria != null) ...[
              _buildSectionTitle('Categoría asociada'),

              const SizedBox(height: 12),

              _buildInfoCard(
                context,
                children: [
                  _buildInfoRow(
                    icon: Icons.label_outline,
                    title: 'Nombre',
                    value: categoria.nombre,
                  ),

                  const Divider(),

                  _buildInfoRow(
                    icon: Icons.swap_horiz_rounded,
                    title: 'Tipo',
                    value: categoria.tipo,
                  ),

                  if (categoria.descripcion != null) ...[
                    const Divider(),

                    _buildInfoRow(
                      icon: Icons.notes_rounded,
                      title: 'Descripción',
                      value: categoria.descripcion!,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 58,
              color: Theme.of(context).colorScheme.error,
            ),

            const SizedBox(height: 14),

            Text(message, textAlign: TextAlign.center),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: () {
                context.read<SubcategoriaBloc>().add(
                  GetSubcategoriaByIdEvent(
                    idEmpresa: idEmpresa,
                    idSubcategoria: idSubcategoria,
                  ),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // WIDGETS AUXILIARES
  // ============================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 21),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow({
    required String title,
    required bool active,
    required String activeText,
    required String inactiveText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: active
                  ? Colors.green.withValues(alpha: 0.12)
                  : Colors.red.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  active ? Icons.check_circle_outline : Icons.cancel_outlined,
                  size: 16,
                  color: active ? Colors.green : Colors.red,
                ),

                const SizedBox(width: 6),

                Text(
                  active ? activeText : inactiveText,
                  style: TextStyle(
                    color: active ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
