import 'dart:typed_data';

import 'package:ati/admin/link_off.dart';
import 'package:ati/screens/buscadorLinks_screen.dart';
import 'package:ati/screens/view_link/user_register.dart';
import 'package:ati/utils/marcas.dart';
import 'package:ati/utils/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> with AutomaticKeepAliveClientMixin {
  final _globalKey = GlobalKey<FormState>();
  final _globalKey1 = GlobalKey<FormState>();
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _nombreMarca = TextEditingController();

  List<User> _user = [];
  List<Marca> _marca = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        title: const Text('Administrar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            elevation: 2.0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () async {
                        await _registerUser().whenComplete(() {
                          setState(() {});
                        });
                      },
                      child: media.width < 600
                          ? Row(
                              children: const [
                                Icon(Icons.add),
                                Text('usuario')
                              ],
                            )
                          : const Text('Registrar usuario'),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () async {
                        await _register();
                      },
                      child: media.width < 600
                          ? Row(
                              children: const [Icon(Icons.add), Text('marca')],
                            )
                          : const Text('Agregar marca'),
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
                    child: Tooltip(
                      message: 'Links desactivados',
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LinkOff(),
                          ));
                        },
                        child: media.width < 600
                            ? const Icon(Icons.link)
                            : const Text('Ver links desactivados'),
                      ),
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
                    child: Tooltip(
                      message: 'Páginas buscador',
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BuscadorLinks(),
                                ));
                          },
                          child: media.width < 600
                              ? const Icon(Icons.travel_explore)
                              : const Text('Páginas buscador')),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: ((media.height / 2) - 49),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Lista de Usuarios',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: User.getUser(''),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _user = snapshot.data!;
                        return ListView.builder(
                          itemCount: _user.length,
                          itemBuilder: (context, index) {
                            User p = _user[index];
                            return ListTile(
                              leading: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(248, 3, 243, 35),
                                ),
                                onPressed: () {
                                  _update(p);
                                },
                              ),
                              title: Text("${p.nombre}"),
                              subtitle: Text("${p.email}"),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 255, 0, 0),
                                ),
                                onPressed: () => _deleteusuario(p.id),
                              ),
                            );
                          },
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: ((media.height / 2) - 49),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Lista de Marcas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: Marca.getMarca(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _marca = snapshot.data!;
                        return ListView.builder(
                          itemCount: _marca.length,
                          itemBuilder: (context, index) {
                            Marca p = _marca[index];
                            return ListTile(
                              leading: IconButton(
                                  onPressed: () {
                                    _updateMarca(p);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(248, 3, 243, 35),
                                  )),
                              title: Text("${p.nombre}"),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 255, 0, 0),
                                ),
                                onPressed: () => _deletemarca(p.id),
                              ),
                            );
                          },
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _deletemarca(int id) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Estas seguro de eliminar esta marca?'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar')),
            ElevatedButton(
                onPressed: () async {
                  try {
                    await Marca.destroy(id).then((value) {
                      Navigator.pop(context);
                      setState(() {});
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
          ],
        );
      },
    );
  }

  Future _deleteusuario(int id) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Estas seguro de eliminar este usuario?'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar')),
            ElevatedButton(
                onPressed: () async {
                  try {
                    User.deleteUser(id).whenComplete(() {
                      setState(() {});
                    });
                    setState(() {});
                  } catch (e) {
                    const ScaffoldMessenger(
                      child: Center(
                        child: Text('Permisos Insuficientes'),
                      ),
                    );
                  }
                },
                child: const Text('Eliminar')),
          ],
        );
      },
    );
  }

  Future _registerUser() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar Usuario'),
          actions: [UserRegister()],
        );
      },
    );
  }

  Future _update(User p) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Actualizar'),
          content: Form(
            key: _globalKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nombre,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    hintText: p.nombre,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo requerido';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    hintText: p.email,
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo requerido';
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  if (_globalKey.currentState!.validate()) {
                    User.update(p.id, _nombre.value.text, _email.value.text)
                        .whenComplete(() {
                      _nombre.clear();
                      _email.clear();
                      setState(() {
                        Navigator.pop(context);
                      });
                    });
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            )
          ],
        );
      },
    );
  }

  void refresh() {
    setState(() {});
  }

  Future _register() {
    Uint8List? imagen;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Registrar marca'),
              content: Form(
                key: _globalKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 400,
                        height: 400,
                        child: imagen == null
                            ? const Icon(Icons.image_search)
                            : Image.memory(
                                imagen!,
                                fit: BoxFit.fill,
                              ),
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png', 'jpeg'],
                          );
                          if (result != null) {
                            imagen = result.files.first.bytes!;
                            setState(() {});
                          }
                        },
                        child: const Text('Subir Imagen'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _nombre,
                      decoration: const InputDecoration(
                        labelText: 'Marca',
                        hintText: 'Marca',
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
                          return 'Campo requerido';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        if (_globalKey.currentState!.validate() &&
                            imagen != null) {
                          Marca.register(_nombre.value.text, imagen)
                              .whenComplete(() {
                            _nombre.clear();
                            Navigator.pop(context);
                            refresh();
                          });
                        }
                      },
                      child: const Text('Guardar')),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        refresh();
                      },
                      child: const Text('Cancelar')),
                )
              ],
            );
          },
        );
      },
    );
  }

  Future _updateMarca(Marca p) {
    Uint8List? imagen;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Actualizar marca'),
              content: Form(
                key: _globalKey1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 400,
                        height: 400,
                        child: imagen == null
                            ? CachedNetworkImage(
                                imageUrl: p.direccion,
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.image_not_supported),
                              )
                            : Image.memory(
                                imagen!,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png', 'jpeg'],
                          );
                          if (result != null) {
                            imagen = result.files.first.bytes!;
                            setState(() {});
                          }
                        },
                        child: const Text('Subir Imagen'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _nombreMarca,
                        decoration: InputDecoration(
                          labelText: 'Marca',
                          hintText: p.nombre,
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo requerido';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      if (_globalKey1.currentState!.validate()) {
                        Marca.update(p.id, _nombreMarca.value.text, imagen)
                            .whenComplete(() {
                          _nombreMarca.clear();
                          Navigator.pop(context);
                          refresh();
                        });
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
