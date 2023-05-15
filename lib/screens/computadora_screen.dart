// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:ati/models/pc_mod.dart';
import 'package:ati/widgets/fpdf.dart';
import 'package:ati/widgets/funcionalidad.dart';
import 'package:ati/widgets/msgScaffold.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class Computadora extends StatefulWidget {
  const Computadora({super.key});

  @override
  State<Computadora> createState() => _ComputadoraState();
}

class _ComputadoraState extends State<Computadora> {
  final formComputadora = GlobalKey<FormState>();
  List<Map<String, String>> compPC = [];
  List<DataRow> row = [];
  String? titulo;
  String? mejor;
  String busq = '';
  int db = 0;
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formComputadora,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        width: 700,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Escriba un titulo';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            titulo = newValue;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Nombre de la Comparativa',
                            labelText: 'Nombre de la Comparativa',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      onPressed: () {
                        compPC.add(PcModelo().toJson());
                        row.add(Funcionalidades().filas(i, compPC));
                        setState(() {
                          i++;
                        });
                      },
                      icon: const Icon(Icons.add),
                      tooltip: 'Agregar fila nueva',
                    ),
                    IconButton(
                      onPressed: () => _showMyDialog(),
                      icon: const Icon(Icons.add_box),
                      tooltip: 'Agregar fila con un producto',
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                    ),
                    IconButton(
                      tooltip: 'Subir a Drive',
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      onPressed: () => guardar(true),
                      icon: const Icon(
                        Icons.add_to_drive,
                        color: Colors.green,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Descargar en PDF',
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      onPressed: () => guardar(false),
                      icon: const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  width: 700,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Debe poner el desktop que sea superior';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      mejor = newValue;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Desktop superior',
                      labelText: 'Desktop superior',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: tablaComputadora())
          ],
        ),
      ),
    );
  }

  void guardar(bool drive) async {
    if (formComputadora.currentState!.validate() && compPC.length > 1) {
      formComputadora.currentState!.save();
      if (db == 0) {
        String guardar = await PcModelo.guardar(compPC, titulo!, mejor!);
        db = 1;
        if (guardar == 'Completado') {
          // ignore: use_build_context_synchronously
          FPDF().pdf(
              context, drive, titulo!, mejor!, PcModelo().columnas, compPC);
        } else {
          db = 0;
          // ignore: use_build_context_synchronously
          MsgScaffold().mensaje(context, guardar, Colors.red, null);
        }
      } else {
        FPDF()
            .pdf(context, drive, titulo!, mejor!, PcModelo().columnas, compPC);
      }
    }
  }

  Widget tablaComputadora() {
    return DataTable2(
        columnSpacing: 16,
        dataRowHeight: 180,
        minWidth: 3400,
        border: TableBorder.all(),
        columns: PcModelo().columnas.map((e) {
          return DataColumn2(
              label: Text(
            e,
            softWrap: true,
          ));
        }).toList(),
        rows: row);
  }

  void refresh() {
    setState(() {});
  }

  Future<void> _showMyDialog() async {
    busq = '';
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Productos'),
              content: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 230,
                        child: TextField(
                          onChanged: (value) {
                            busq = value;
                          },
                          onSubmitted: (value) {
                            setState(() {});
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
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: const Icon(Icons.search))
                    ],
                  ),
                  FutureBuilder(
                    future: PcModelo.listaPc(busq),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState.name == 'waiting') {
                        return SizedBox(
                          height: (MediaQuery.of(context).size.height - 197),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Ocurrio un error'),
                          );
                        } else {
                          if (snapshot.data == 'Error' ||
                              snapshot.data == 'Sin datos') {
                            return SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height - 197),
                                child: Center(child: Text(snapshot.data)));
                          } else {
                            var datos = snapshot.data;
                            return Expanded(
                              child: SizedBox(
                                width: 280,
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        compPC.add(datos[index]);
                                        row.add(
                                            Funcionalidades().filas(i, compPC));
                                        Navigator.pop(context);
                                        i++;
                                        refresh();
                                      },
                                      child: Card(
                                        child: ListTile(
                                          leading: const Icon(Icons.computer),
                                          title: Text(datos[index]['marca'] +
                                              ' ' +
                                              datos[index]['modelo']),
                                          subtitle:
                                              Text('NP: ' + datos[index]['np']),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
