// ignore_for_file: use_build_context_synchronously

import 'package:ati/widgets/funcionalidad.dart';
import 'package:ati/widgets/msgScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

class BuscadorLinks extends StatefulWidget {
  const BuscadorLinks({super.key});

  @override
  State<BuscadorLinks> createState() => _BuscadorLinksState();
}

class _BuscadorLinksState extends State<BuscadorLinks> {
  String busq = '';
  final form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: GradientColors.seaBlue,
            ),
          ),
        ),
        title: const Text('Links buscador general'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Flexible(
                  child: SizedBox(
                    width: 400,
                    child: TextField(
                      onSubmitted: (value) {
                        busq = value;
                        setState(() {});
                      },
                      onChanged: (value) {
                        busq = value;
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
                ),
                IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.search)),
                IconButton(
                    tooltip: 'Agregar link',
                    onPressed: () =>
                        _showMyDialog('Agregar Link', '', '', '', 'Si'),
                    icon: const Icon(Icons.add))
              ],
            ),
          ),
          FutureBuilder(
            future: Funcionalidades.links(busq),
            builder: (context, snapshot) {
              if (snapshot.connectionState.name == 'waiting') {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Sin registros'),
                  );
                } else {
                  var datos = snapshot.data;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: datos!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(datos[index]['titulo']),
                            subtitle: Text(datos[index]['link']),
                            leading: Icon(
                              Icons.check_box,
                              color: datos[index]['activo'] == 'Si'
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            trailing: IconButton(
                              onPressed: () => _showMyDialog(
                                  'Actualizar',
                                  datos[index]['titulo'],
                                  datos[index]['link'],
                                  datos[index]['id'],
                                  datos[index]['activo']),
                              icon: const Icon(
                                Icons.settings_applications,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        );
                      },
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

  void refresh() {
    setState(() {});
  }

  Future<void> _showMyDialog(String titulo, String nombre, String link,
      String id, String activo) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    if (form.currentState!.validate()) {
                      form.currentState!.save();
                      String resp =
                          await Funcionalidades.gact(id, nombre, link, activo);
                      refresh();
                      Navigator.pop(context);
                      MsgScaffold().mensaje(context, resp, Colors.green, null);
                    }
                  },
                  child: const Text('Guardar'),
                )
              ],
              title: Text(titulo),
              content: Form(
                key: form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: nombre,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingrese un titulo';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        nombre = newValue!;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Titulo',
                        labelText: 'Titulo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 200,
                      child: TextFormField(
                        initialValue: link,
                        onSaved: (newValue) {
                          link = newValue!;
                        },
                        minLines: null,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: 'Link',
                          labelText: 'Link',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            borderSide: BorderSide(
                              color: Colors.redAccent,
                              width: 3,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingrese un link';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Activo'),
                        value: activo,
                        items: const [
                          DropdownMenuItem(
                            child: Text('Si'),
                            value: 'Si',
                          ),
                          DropdownMenuItem(
                            child: Text('No'),
                            value: 'No',
                          ),
                        ],
                        onChanged: (value) {
                          activo = value!;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
