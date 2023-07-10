import 'package:ati/models/monitor_mod.dart';
import 'package:ati/widgets/fpdf.dart';
import 'package:ati/widgets/funcionalidad.dart';
import 'package:ati/widgets/msgScaffold.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({Key? key}) : super(key: key);

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  final formMonitor = GlobalKey<FormState>();
  String? titulo;
  List<Map<String, String>> compMonitor = [];
  List<DataRow> row = [];
  String busq = '';
  int db = 0;
  int i = 0;

  @override
  Widget build(BuildContext context) {
    // Verificar si hay exactamente dos filas y agregar una tercera vacía
    if (row.length == 2) {
      compMonitor.add(MonitorModelo().toJson());
      row.add(Funcionalidades().filas(i, compMonitor));
      i++;
    }
    return Scaffold(
      body: Form(
          key: formMonitor,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          compMonitor.add(MonitorModelo().toJson());
                          row.add(Funcionalidades().filas(i, compMonitor));
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
                ],
              ),
              Expanded(child: tablaMonitor())
            ],
          )),
    );
  }

  void guardar(bool drive) async {
    if (formMonitor.currentState!.validate() && compMonitor.length > 1) {
      formMonitor.currentState!.save();
      if (db == 0) {
        String guardar = await MonitorModelo.guardar(compMonitor, titulo!);
        db = 1;
        if (guardar == 'Completado') {
          // ignore: use_build_context_synchronously
          FPDF().pdf(context, drive, titulo!, "", MonitorModelo().columnas,
              compMonitor);
        } else {
          db = 0;
          // ignore: use_build_context_synchronously
          MsgScaffold().mensaje(context, guardar, Colors.red, null);
        }
      } else {
        FPDF().pdf(
            context, drive, titulo!, "", MonitorModelo().columnas, compMonitor);
      }
    }
  }

  Widget tablaMonitor() {
    return DataTable2(
      columnSpacing: 20,
      dataRowHeight: 180,
      minWidth: 3900,
      border: TableBorder.all(),
      columns: MonitorModelo().columnas.map((e) {
        return DataColumn2(
            label: Text(
          e,
          softWrap: true,
        ));
      }).toList(),
      rows: row,
    );
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
                    future: MonitorModelo.listamonitor(busq),
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
                                        compMonitor.add(datos[index]);
                                        row.add(Funcionalidades()
                                            .filas(i, compMonitor));
                                        Navigator.pop(context);
                                        i++;
                                        refresh();
                                      },
                                      child: Card(
                                        child: ListTile(
                                          leading: const Icon(Icons.monitor),
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
