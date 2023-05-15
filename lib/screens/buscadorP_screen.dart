// ignore_for_file: file_names

import 'package:ati/models/cvaApi.dart';
import 'package:ati/widgets/funcionalidad.dart';
import 'package:ati/widgets/indivCva.dart';
import 'package:ati/widgets/listacva.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class BuscadorProveedor extends StatefulWidget {
  const BuscadorProveedor({super.key});

  @override
  State<BuscadorProveedor> createState() => _BuscadorProveedorState();
}

class _BuscadorProveedorState extends State<BuscadorProveedor>
    with AutomaticKeepAliveClientMixin {
  String np = '';
  String select = 'codigo';
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 450,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Buscar en CVA',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged: (value) {
                      np = value;
                    },
                    onSubmitted: (value) {
                      np = value;
                      setState(() {});
                    },
                  ),
                ),
              ),
              Flexible(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    value: select,
                    items: Funcionalidades().busqCVA().map((e) {
                      return DropdownMenuItem(
                        value: e[1],
                        child: Text(e[0]),
                      );
                    }).toList(),
                    onChanged: (value) {
                      select = value.toString();
                      setState(() {});
                    },
                    buttonStyleData: ButtonStyleData(
                      width: 190,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.search_rounded)),
              const IconButton(
                tooltip:
                    'Advertencia: Algunos precios suelen ser diferentes al de la página. (Esto es un problema de parte de CVA)',
                onPressed: null,
                icon: Icon(
                  Icons.error,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: ApiCva.cva(np, select),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState.name == 'waiting') {
                return SizedBox(
                  height: (MediaQuery.of(context).size.height - 144),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data != 'Sin búsqueda' &&
                      snapshot.data != 'No Existe' &&
                      snapshot.data !=
                          'Ocurrio un problema con el tiempo de respuesta') {
                    if (select == 'codigo' || select == 'clave') {
                      return IndividualCVA(
                        datos: snapshot.data,
                      );
                    } else {
                      return ListaCva(
                        datos: snapshot.data,
                      );
                    }
                  } else {
                    return SizedBox(
                      height: (MediaQuery.of(context).size.height - 144),
                      child: Center(
                        child: Text(
                          snapshot.data,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                } else {
                  return SizedBox(
                    height: (MediaQuery.of(context).size.height - 143),
                    child: const Center(
                      child: Text('Ocurrio un Error'),
                    ),
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }
}
