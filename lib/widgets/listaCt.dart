import 'package:ati/widgets/cardCt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ListaCt extends StatefulWidget {
  final List datos;
  const ListaCt({super.key, required this.datos});

  @override
  State<ListaCt> createState() => _ListaCtState();
}

class _ListaCtState extends State<ListaCt> {
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
    double width = MediaQuery.of(context).size.width;
    if (pag == 0) {
      datos = widget.datos;
      for (var i = 0; i < datos.length; i += chunkSize) {
        chunks.add(datos.sublist(
            i, i + chunkSize > datos.length ? datos.length : i + chunkSize));
      }
      grid.addAll(chunks[pag]);
    }
    return Expanded(
      child: AlignedGridView.count(
        crossAxisCount: width >= 1420
            ? 4
            : width >= 1063 && width < 1420
                ? 3
                : width < 633
                    ? 1
                    : 2,
        mainAxisSpacing: width >= 1420
            ? 4
            : width >= 1063 && width < 1420
                ? 3
                : width < 633
                    ? 1
                    : 2,
        crossAxisSpacing: width >= 1420
            ? 4
            : width >= 1063 && width < 1420
                ? 3
                : width < 633
                    ? 1
                    : 2,
        itemCount: grid.length,
        controller: _controller,
        itemBuilder: (context, index) {
          return CardCt(
            parte: grid[index]['numParte'],
            nombre: grid[index]['nombre'],
            desc: grid[index]['descripcion'],
            precio: grid[index]['precio'],
            imagen: grid[index]['imagen'],
            existencia: grid[index]['exis'].toString(),
            gdl: grid[index]['gdl'],
          );
        },
      ),
    );
  }
}
