import 'package:ati/screens/view_link/register.dart';
import 'package:ati/utils/links.dart';
import 'package:ati/utils/user.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

class LinksScreen extends StatefulWidget {
  String email;
  String marca;
  LinksScreen({super.key, required this.email, required this.marca});

  @override
  State<LinksScreen> createState() => _LinksScreenState();
}

class _LinksScreenState extends State<LinksScreen> {
  String busq = '';
  String? email1;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _link = TextEditingController();
  final TextEditingController _desc1 = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  void _getUser() async {
    try {
      await User.getUser(widget.email.toString()).then((value) {
        email1 = value.first.email;
        setState(() {});
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
        title: Text('Links: ${widget.marca}'),
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: media.width < 600 ? 0 : 150,
          right: media.width < 600 ? 0 : 150,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: 500,
                    child: TextField(
                      onChanged: (value) {
                        busq = value;
                      },
                      decoration: InputDecoration(
                        icon: IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: const Icon(Icons.search),
                        ),
                        hintText: 'Buscar',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      onSubmitted: (value) {
                        busq = value;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                if (email1 == widget.email)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: GradientColors.seaBlue,
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () async {
                          await _register(widget.marca).whenComplete(() {
                            setState(() {});
                          });
                        },
                        child: const Text('Agregar link'),
                      ),
                    ),
                  )
                else
                  const SizedBox()
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: Link.getLinks(busq, 'ON', widget.marca),
                builder: (context, snapshot) {
                  if (snapshot.connectionState.name == 'waiting') {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Ha ocurrido un error'),
                      );
                    } else {
                      var datos = snapshot.data;
                      if (datos!.isEmpty) {
                        return const Center(
                          child: Text('No existen links'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: datos.length,
                          itemBuilder: (context, index) {
                            Link p = datos[index];
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  js.context
                                      .callMethod('open', [datos[index].link]);
                                },
                                leading: email1 == widget.email
                                    ? IconButton(
                                        onPressed: () {
                                          _update(p);
                                        },
                                        icon: const Icon(
                                          Icons.edit_document,
                                          color:
                                              Color.fromARGB(248, 3, 243, 35),
                                        ))
                                    : const Icon(
                                        Icons.link,
                                        color: Colors.blueAccent,
                                      ),
                                title: Text(datos[index].descripcion),
                                subtitle: Text(datos[index].link),
                                trailing: email1 == widget.email
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Color.fromARGB(255, 255, 0, 0),
                                        ),
                                        onPressed: () async {
                                          _delete(p);
                                        },
                                      )
                                    : Icon(
                                        Icons.arrow_outward,
                                        color: Colors.blue[800],
                                      ),
                              ),
                            );
                          },
                        );
                      }
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _delete(Link p) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(children: const [
            Text('Alerta '),
            Icon(
              Icons.warning,
              color: Color.fromARGB(255, 253, 215, 0),
            )
          ]),
          content: const Text('¿Desear eliminar este registro?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: GradientColors.seaBlue,
                    ),
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        try {
                          Link.destroy(p.id!).whenComplete(() {
                            setState(() {
                              Navigator.pop(context);
                            });
                          });
                        } catch (e) {
                          const ScaffoldMessenger(
                            child: Center(
                              child: Text('Permisos Insuficientes'),
                            ),
                          );
                        }
                      },
                      child: const Text('Eliminar')),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: GradientColors.seaBlue,
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future _register(String marca) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar Link'),
          content: Register(marca: marca),
        );
      },
    );
  }

  void _reload() {
    setState(() {});
  }

  Future _update(Link p) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Actualizar'),
              actions: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo requerido';
                          } else {
                            return null;
                          }
                        },
                        controller: _desc1,
                        decoration: InputDecoration(
                            helperMaxLines: 10,
                            labelText: 'Descripción',
                            hintText: p.descripcion,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                                width: 3,
                              ),
                            ),
                            hintMaxLines: 10),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo requerido';
                          } else {
                            return null;
                          }
                        },
                        controller: _link,
                        decoration: InputDecoration(
                          helperMaxLines: 10,
                          labelText: 'Url',
                          hintMaxLines: 10,
                          hintText: p.link,
                          border: const OutlineInputBorder(
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
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: GradientColors.seaBlue,
                              ),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () {
                                try {
                                  if (_formKey.currentState!.validate()) {
                                    Link.update(
                                      p.id!,
                                      _desc1.value.text,
                                      _link.value.text,
                                    ).whenComplete(
                                      () {
                                        _desc1.clear();
                                        _link.clear();
                                        Navigator.pop(context);
                                        _reload();
                                      },
                                    );
                                  }
                                } catch (e) {
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Guardar'),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: GradientColors.seaBlue,
                              ),
                            ),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancelar')),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
