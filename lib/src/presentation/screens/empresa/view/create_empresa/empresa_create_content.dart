import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';

class EmpresaCreateContent extends StatefulWidget {
  const EmpresaCreateContent({super.key});

  @override
  State<EmpresaCreateContent> createState() => _EmpresaCreateContentState();
}

class _EmpresaCreateContentState extends State<EmpresaCreateContent> {
  final _formKey = GlobalKey<FormState>();

  final razonSocialCtrl = TextEditingController();
  final nombreComercialCtrl = TextEditingController();
  final rucCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final direccionFiscalCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();

  String tipoEmpresa = "PRIVADA";

  final tiposEmpresa = const [
    "PRIVADA",
    "PUBLICA",
    "ONG",
    "INDEPENDIENTE",
    "OTRA",
  ];

  @override
  void dispose() {
    razonSocialCtrl.dispose();
    nombreComercialCtrl.dispose();
    rucCtrl.dispose();
    emailCtrl.dispose();
    direccionFiscalCtrl.dispose();
    telefonoCtrl.dispose();
    super.dispose();
  }

  void _crearEmpresa() {
    if (!_formKey.currentState!.validate()) return;

    // Obtener usuario de la sesión
    final sessionState = context.read<SessionBloc>().state;
    final usuario = sessionState.user;

    if (usuario == null) return;

    final request = EmpresaRequest(
      idUsuario: usuario.data.usuario.idUsuario,
      razonSocial: razonSocialCtrl.text.trim(),
      nombreComercial: nombreComercialCtrl.text.trim(),
      ruc: rucCtrl.text.trim(),
      tipoEmpresa: tipoEmpresa,
      direccionFiscal: direccionFiscalCtrl.text.trim(),
      telefono: telefonoCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      paginaWeb: "",
      logoUrl: "",
    );

    context.read<EmpresaBloc>().add(CreateEmpresaEvent(request));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F7FA),
        elevation: 0,
        foregroundColor: Colors.black,
        // title: const Text(
        //   "Crear empresa",
        //   style: TextStyle(fontWeight: FontWeight.bold),
        // ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Registra tu primera empresa",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  "Completa los datos principales para comenzar a usar Ayroria.",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 28),

                _buildTipoEmpresaDropdown(),

                const SizedBox(height: 16),

                _buildInput(
                  controller: razonSocialCtrl,
                  label: "Razón social",
                  icon: Icons.apartment_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "La razón social es obligatoria";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                _buildInput(
                  controller: nombreComercialCtrl,
                  label: "Nombre comercial",
                  icon: Icons.business_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "El nombre comercial es obligatorio";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                _buildInput(
                  controller: rucCtrl,
                  label: "RUC",
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "El RUC es obligatorio";
                    }

                    if (value.trim().length != 11) {
                      return "El RUC debe tener 11 dígitos";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                _buildInput(
                  controller: emailCtrl,
                  label: "Email",
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "El email es obligatorio";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                _buildInput(
                  controller: telefonoCtrl,
                  label: "Teléfono",
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "El teléfono es obligatorio";
                    }

                    if (value.trim().length < 6) {
                      return "Ingrese un teléfono válido";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildInput(
                  controller: direccionFiscalCtrl,
                  label: "Dirección fiscal",
                  icon: Icons.location_on_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "La dirección fiscal es obligatoria";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _crearEmpresa,
                    icon: const Icon(Icons.add_business),
                    label: const Text(
                      "Crear empresa",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2563EB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipoEmpresaDropdown() {
    return DropdownButtonFormField<String>(
      value: tipoEmpresa,

      items: tiposEmpresa.map((tipo) {
        return DropdownMenuItem<String>(value: tipo, child: Text(tipo));
      }).toList(),

      onChanged: (value) {
        if (value == null) return;

        setState(() {
          tipoEmpresa = value;
        });
      },

      validator: (value) {
        if (value == null || value.isEmpty) {
          return "El tipo de empresa es obligatorio";
        }

        return null;
      },

      decoration: InputDecoration(
        labelText: "Tipo de empresa",
        prefixIcon: const Icon(Icons.category_outlined),
        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xff2563EB), width: 1.4),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLength: maxLength,

      decoration: InputDecoration(
        counterText: "",
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xff2563EB), width: 1.4),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}
