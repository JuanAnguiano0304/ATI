// ignore_for_file: file_names

import 'package:ati/widgets/cardCva.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ListaCva extends StatefulWidget {
  final List datos;
  const ListaCva({super.key, required this.datos});

  @override
  State<ListaCva> createState() => _ListaCvaState();
}

class _ListaCvaState extends State<ListaCva> {
  List grid = [];
  List datos = [];
  final _controller = ScrollController();
  List<List> chunks = [];
  int chunkSize = 24;
  int pag = 0;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        pag += 1;
        if (pag < chunks.length) {
          grid.addAll(chunks[pag]);
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    datos = widget.datos;
    datos.sort((a, b) => int.parse(b['ExsTotal']) - int.parse(a['ExsTotal']));
    if (pag == 0) {
      for (var i = 0; i < datos.length; i += chunkSize) {
        chunks.add(datos.sublist(
            i, i + chunkSize > datos.length ? datos.length : i + chunkSize));
      }
      grid.addAll(chunks[pag]);
    }
    return Expanded(
      child: AlignedGridView.count(
        shrinkWrap: true,
        crossAxisCount: MediaQuery.of(context).size.width >= 1420
            ? 4
            : MediaQuery.of(context).size.width >= 1063 &&
                    MediaQuery.of(context).size.width < 1420
                ? 3
                : MediaQuery.of(context).size.width < 633
                    ? 1
                    : 2,
        mainAxisSpacing: MediaQuery.of(context).size.width >= 1420
            ? 4
            : MediaQuery.of(context).size.width >= 1063 &&
                    MediaQuery.of(context).size.width < 1420
                ? 3
                : MediaQuery.of(context).size.width < 633
                    ? 1
                    : 2,
        crossAxisSpacing: MediaQuery.of(context).size.width >= 1420
            ? 4
            : MediaQuery.of(context).size.width >= 1063 &&
                    MediaQuery.of(context).size.width < 1420
                ? 3
                : MediaQuery.of(context).size.width < 633
                    ? 1
                    : 2,
        controller: _controller,
        itemCount: grid.length,
        itemBuilder: (context, index) {
          final anio = grid[index]['garantia'].toString().split(' ');
          return CardCVA(
              imagen: grid[index]['imagen'].toString(),
              descripcion: grid[index]['descripcion'].toString(),
              existencia: grid[index]['ExsTotal'].toString(),
              garantia: anio[0].toString(),
              precio: grid[index]['precio'].toString(),
              precioDesc: grid[index]['PrecioDescuento'].toString(),
              moneda: grid[index]['moneda'].toString(),
              monedaDesc: grid[index]['MonedaPrecioDescuento'].toString(),
              cCva: grid[index]['clave'].toString(),
              np: grid[index]['codigo_fabricante'].toString());
        },
      ),
    );
  }
}
