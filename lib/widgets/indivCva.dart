// ignore_for_file: file_names

import 'package:ati/widgets/cardCva.dart';
import 'package:flutter/material.dart';

class IndividualCVA extends StatelessWidget {
  final Map datos;
  const IndividualCVA({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    final anio = datos['garantia'].toString().split(' ');
    return Center(
      child: SizedBox(
        width: 400,
        child: CardCVA(
          imagen: datos['imagen'].toString(),
          descripcion: datos['descripcion'].toString(),
          existencia: datos['ExsTotal'].toString(),
          garantia: anio[0].toString(),
          precio: datos['precio'].toString(),
          precioDesc: datos['PrecioDescuento'].toString(),
          moneda: datos['moneda'].toString(),
          monedaDesc: datos['MonedaPrecioDescuento'].toString(),
          cCva: datos['clave'].toString(),
          np: datos['codigo_fabricante'].toString(),
        ),
      ),
    );
  }
}
