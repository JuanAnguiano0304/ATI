// ignore_for_file: use_build_context_synchronously, file_names

import 'package:ati/models/comparativos.dart';
import 'package:ati/widgets/fpdf.dart';
import 'package:flutter/material.dart';

class CardComparativos extends StatelessWidget {
  final String nombre;
  final String mejor;
  final String id;
  final String comparador;
  const CardComparativos(
      {super.key,
      required this.nombre,
      required this.mejor,
      required this.id,
      required this.comparador});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
          tooltip: 'Descargar en PDF',
          onPressed: () async {
            List<Map> datos =
                await ComparativoModelo.comparativoPdf(comparador, id);
            FPDF().pdf(context, false, nombre, mejor,
                ComparativoModelo().columnas[comparador], datos);
          },
          icon: const Icon(
            Icons.picture_as_pdf,
            color: Colors.red,
          ),
        ),
        title: Text(nombre),
        subtitle: Text(comparador.toUpperCase()),
        trailing: IconButton(
          tooltip: 'Subir a Drive y descargar',
          onPressed: () async {
            List<Map> datos =
                await ComparativoModelo.comparativoPdf(comparador, id);
            FPDF().pdf(context, true, nombre, mejor,
                ComparativoModelo().columnas[comparador], datos);
          },
          icon: const Icon(
            Icons.add_to_drive_outlined,
            color: Colors.lightGreen,
          ),
        ),
      ),
    );
  }
}
