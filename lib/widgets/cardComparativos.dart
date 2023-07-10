// ignore_for_file: use_build_context_synchronously, file_names

import 'package:ati/models/comparativos.dart';
import 'package:ati/widgets/fpdf.dart';
import 'package:flutter/material.dart';

class CardComparativos extends StatefulWidget {
  final String nombre;
  final String id;
  final String comparador;
  final Function onDelete;

  const CardComparativos({
    Key? key,
    required this.nombre,
    required this.id,
    required this.comparador,
    required this.onDelete,
  }) : super(key: key);

  @override
  _CardComparativosState createState() => _CardComparativosState();
}

class _CardComparativosState extends State<CardComparativos> {
  bool showCard = true;

  @override
  Widget build(BuildContext context) {
    if (!showCard) {
      return SizedBox.shrink();
    }

    return Card(
      child: ListTile(
        leading: IconButton(
          tooltip: 'Descargar en PDF',
          onPressed: () async {
            List<Map> datos = await ComparativoModelo.comparativoPdf(
              widget.comparador,
              widget.id,
            );
            FPDF().pdf(
              context,
              false,
              widget.nombre,
              '',
              ComparativoModelo().columnas[widget.comparador],
              datos,
            );
          },
          icon: const Icon(
            Icons.picture_as_pdf,
            color: Colors.red,
          ),
        ),
        title: Text(widget.nombre),
        subtitle: Text(widget.comparador.toUpperCase()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Eliminar',
              onPressed: () {
                setState(() {
                  showCard = false;
                });
                widget.onDelete();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.grey,
              ),
            ),
            IconButton(
              tooltip: 'Subir a Drive y descargar',
              onPressed: () async {
                List<Map> datos = await ComparativoModelo.comparativoPdf(
                  widget.comparador,
                  widget.id,
                );
                FPDF().pdf(
                  context,
                  true,
                  widget.nombre,
                  '',
                  ComparativoModelo().columnas[widget.comparador],
                  datos,
                );
              },
              icon: const Icon(
                Icons.add_to_drive_outlined,
                color: Colors.lightGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
