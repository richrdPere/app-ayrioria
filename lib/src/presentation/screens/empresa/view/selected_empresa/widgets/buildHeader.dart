import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//==============================================================
// HEADER
//==============================================================
Widget buildHeader(BuildContext context) {
  final session = context.watch<SessionBloc>().state;
  final persona = session.user?.data.usuario.persona;

  final primerNombre =
      (persona?.nombres ?? '').trim().split(' ').firstOrNull ?? 'Usuario';

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xff2563EB), Color(0xff1D4ED8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white.withOpacity(.20),
              child: const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 30,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "¡Hola, $primerNombre!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Bienvenido nuevamente",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.85),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        const Text(
          "Selecciona una empresa",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "La empresa que elijas definirá toda la información con la que trabajarás: categorías, movimientos, reportes y configuraciones.",
          style: TextStyle(
            color: Colors.white.withOpacity(.90),
            fontSize: 15,
            height: 1.45,
          ),
        ),

        const SizedBox(height: 18),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            children: [
              Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Podrás cambiar de empresa en cualquier momento desde Configuración.",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
