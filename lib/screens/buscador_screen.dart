import 'package:ati/models/buscador.dart';
import 'package:ati/widgets/cardProduct.dart';
import 'package:ati/widgets/msgScaffold.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ati/widgets/funcionalidad.dart';
import 'package:responsive_grid/responsive_grid.dart';

class BuscadorScreen extends StatefulWidget {
  const BuscadorScreen({Key? key}) : super(key: key);

  @override
  State<BuscadorScreen> createState() => _BuscadorScreenState();
}

class _BuscadorScreenState extends State<BuscadorScreen>
    with AutomaticKeepAliveClientMixin {
  int pages = 0;
  int queryOnly = 0;
  final ScrollController _controller = ScrollController();
  String? valueSelected = '*';
  final TextEditingController _txtController = TextEditingController();
  int totPages = -1;
  @override
  bool get wantKeepAlive => true;
  List<Map> paginas = [
    {'titulo': 'Todos', 'link': '*'}
  ];

  void upList() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();
    links();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    width: 600,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextField(
                      onSubmitted: (value) {
                        if (value != "") {
                          queryOnly = 1;
                          pages = 1;
                          if (_controller.hasClients) {
                            upList();
                          }
                          setState(() {});
                        } else {
                          pages = 0;
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Buscar',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      controller: _txtController,
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    dropdownStyleData: const DropdownStyleData(maxHeight: 400),
                    buttonStyleData: ButtonStyleData(
                      width: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    hint: const Text('Proveedores'),
                    items: paginas
                        .map((item) => DropdownMenuItem<String>(
                              value: item['link'],
                              child: Text(
                                item['titulo'].toString(),
                              ),
                            ))
                        .toList(),
                    value: valueSelected,
                    isExpanded: true,
                    onChanged: (value) {
                      queryOnly = 1;
                      pages = 1;
                      valueSelected = value;
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    queryOnly = 1;
                    pages = 1;
                    if (_controller.hasClients) {
                      upList();
                    }
                    setState(() {});
                  },
                  icon: const Icon(Icons.search),
                  iconSize: 30,
                )
              ],
            ),
            FutureBuilder(
                future: Buscador.buscador(
                    _txtController.text, pages, valueSelected),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data![0] == "Sin búsqueda") {
                      return SizedBox(
                        height: (MediaQuery.of(context).size.height - 189),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.search_off),
                              Text('Sin datos'),
                            ],
                          ),
                        ),
                      );
                    } else {
                      totPages = int.parse(snapshot.data![1]);
                      List<Map<String, String>> l = snapshot.data![0];
                      return Expanded(
                        child: SingleChildScrollView(
                          controller: _controller,
                          child: ResponsiveGridRow(
                            children: l.map((e) {
                              return ResponsiveGridCol(
                                lg: 6,
                                sm: 12,
                                xs: 12,
                                child: CardProduct(
                                    titulo: e['titulo'].toString(),
                                    link: e['link'].toString(),
                                    imagen: e['image'].toString(),
                                    pagina: e['tienda'].toString(),
                                    snippet: e['snippet'].toString()),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }
                  } else {
                    return SizedBox(
                      height: (MediaQuery.of(context).size.height - 189),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.search_off),
                                Text('Sin Resultados'),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Tooltip(
                              message:
                                  'En algunos casos, el producto si existe con el proveedor, pero no se muestra en el servicio de búsqueda de Google.\nPronto se actualizará con la información de los proveedores.',
                              child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.question_mark_sharp),
                                  label: const Text('Más Información')),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue[900],
                padding: const EdgeInsets.all(5),
              ),
              onPressed: pages > 1
                  ? () {
                      queryOnly -= 1;
                      pages -= 10;
                      upList();
                      setState(() {});
                    }
                  : null,
              child: const Text(
                "Anterior",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          queryOnly > 0 ? Text(queryOnly.toString()) : const SizedBox(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.blue[900]),
              onPressed: () {
                if (pages > 0) {
                  if ((pages + 10) > totPages || (queryOnly + 1) > 10) {
                    MsgScaffold().mensaje(
                        context, 'Fin de los resultados', Colors.black, null);
                  } else {
                    queryOnly += 1;
                    pages += 10;
                    upList();
                    setState(() {});
                  }
                }
              },
              child: const Text(
                "Siguiente",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void links() async {
    await Funcionalidades.links('').then((value) {
      value.map((e) {
        if (e['activo'] == 'Si') {
          paginas.add(e);
        }
      }).toList();
      setState(() {});
    });
  }
}
