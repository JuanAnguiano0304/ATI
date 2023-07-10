import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:ati/config/theme/app_theme.dart';

void main() {
  runApp(MaterialApp(
    home: RegistroTable(),
  ));
}

class RegistroTable extends StatefulWidget {
  @override
  _RegistroTableState createState() => _RegistroTableState();
}

class _RegistroTableState extends State<RegistroTable> {
  List<Map<String, dynamic>> registros = [];
  ScrollController _scrollController = ScrollController();
  double scrollOffset = 0.0;

  int nextId = 1;

  Map<int, Color> rowColors =
      {}; // Mapa para almacenar los colores de las filas

  @override
  void initState() {
    super.initState();
    obtenerRegistros();
    obtenerColoresFilas();
  }

  Future<void> obtenerRegistros() async {
    final url =
        'http://localhost:3000/api/registros'; // URL del endpoint en el backend
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        registros = List<Map<String, dynamic>>.from(data);
      });
    } else {
      print('Error al obtener los registros');
    }
  }

  Future<void> obtenerColoresFilas() async {
    final url = 'http://localhost:3000/api/rows/colors';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        rowColors = Map<int, Color>.from(
            data.map((key, value) => MapEntry(int.parse(key), Color(value))));
      });
    } else {
      print('Error al obtener los colores de las filas');
    }
  }

  void agregarRegistro(Map<String, dynamic> registro) async {
    registro['id'] = nextId;
    registro['marcaTemporal'] =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    try {
      final nuevoRegistro = await guardarRegistro(registro);
      setState(() {
        registros.add(nuevoRegistro);
        nextId++;
      });
      await obtenerRegistros();
    } catch (e) {
      print('Error al guardar el registro: $e');
    }
  }

  Future<Map<String, dynamic>> guardarRegistro(
      Map<String, dynamic> registro) async {
    final url = 'http://localhost:3000/api/registros';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registro),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error al guardar el registro');
    }
  }

  void scrollTo(double offset) {
    _scrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight() {
    setState(() {
      scrollOffset += 100.0;
      scrollTo(scrollOffset);
    });
  }

  void scrollLeft() {
    setState(() {
      scrollOffset -= 100.0;
      if (scrollOffset < 0.0) {
        scrollOffset = 0.0;
      }
      scrollTo(scrollOffset);
    });
  }

  void marcarFila(int id, Color color) {
    setState(() {
      rowColors[id] = color;
    });

    guardarColorFila(
        id, color); // Agregar llamada para guardar el color en el backend
  }

  void guardarColorFila(int id, Color color) async {
    final url = 'http://localhost:3000/api/rows';
    final body = {
      'id': id,
      'color': color.value, // Usar color.value en lugar de color.value.toInt()
    }; // Convertir color.value a String

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 201) {
      print('Error al guardar el color de la fila');
    }
  }

  Color getColorForRow(int id) {
    return rowColors[id] ?? Colors.transparent;
  }

  String getEstatusForRow(int id) {
    final registro = registros.firstWhere((element) => element['id'] == id);
    return registro['estatus'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme().theme(),
        home: Scaffold(
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: scrollLeft,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: scrollRight,
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    child: DataTable(
                      border: TableBorder.all(),
                      columnSpacing: 20.0,
                      showCheckboxColumn: false,
                      dataRowHeight: 40.0,
                      headingRowHeight: 50.0,
                      columns: [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Marca temporal')),
                        DataColumn(label: Text('Nombre de la licitación')),
                        DataColumn(label: Text('Dependencia que licita')),
                        DataColumn(label: Text('Dependencia usuaria')),
                        DataColumn(label: Text('Fecha de publicación')),
                        DataColumn(label: Text('Donde se publicó')),
                        DataColumn(label: Text('Fecha de envío de preguntas')),
                        DataColumn(
                            label: Text('Hora límite envío de preguntas')),
                        DataColumn(label: Text('Cómo se entregan')),
                        DataColumn(label: Text('Domicilio y/o correo')),
                        DataColumn(label: Text('Fecha junta de aclaraciones')),
                        DataColumn(label: Text('Hora registro JA')),
                        DataColumn(label: Text('Hora JA')),
                        DataColumn(label: Text('La junta es obligatoria?')),
                        DataColumn(label: Text('Domicilio JA')),
                        DataColumn(label: Text('Es presencial o digital')),
                        DataColumn(label: Text('Domicilio')),
                        DataColumn(label: Text('Fecha de presentación')),
                        DataColumn(
                            label: Text('Hora de registro para presentación')),
                        DataColumn(label: Text('Hora de apertura')),
                        DataColumn(label: Text('Partidas')),
                        DataColumn(label: Text('Requiere preventa')),
                        DataColumn(label: Text('Link carpeta')),
                        DataColumn(label: Text('Estatus')),
                      ],
                      rows: registros.map((registro) {
                        final id = registro['id'];
                        final color = getColorForRow(id);
                        final estatus = getEstatusForRow(id);
                        return DataRow(
                          color:
                              MaterialStateColor.resolveWith((states) => color),
                          onSelectChanged: (selected) {
                            if (selected != null && selected) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Center(
                                      child: Text(registro['nombre'] ?? '')),
                                  content: ColorPickerDialog(
                                    onColorSelected: (selectedColor) {
                                      marcarFila(id, selectedColor);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          cells: [
                            DataCell(Text(registro['id']?.toString() ?? '')),
                            DataCell(Text(registro['marca_temporal'] ?? '')),
                            DataCell(Text(registro['nombre'] ?? '')),
                            DataCell(
                                Text(registro['dependencia_licitante'] ?? '')),
                            DataCell(
                                Text(registro['dependencia_usuario'] ?? '')),
                            DataCell(Text(registro['fecha_publicacion'] ?? '')),
                            DataCell(Text(registro['donde_se_publico'] ?? '')),
                            DataCell(
                                Text(registro['fecha_envio_preguntas'] ?? '')),
                            DataCell(Text(
                                registro['hora_limite_envio_preguntas'] ?? '')),
                            DataCell(Text(registro['como_se_entregan'] ?? '')),
                            DataCell(Text(registro['domicilio_correo'] ?? '')),
                            DataCell(Text(
                                registro['fecha_junta_aclaraciones'] ?? '')),
                            DataCell(Text(registro['hora_registro_ja'] ?? '')),
                            DataCell(Text(registro['hora_ja'] ?? '')),
                            DataCell(Text(registro['junta_obligatoria'] ?? '')),
                            DataCell(Text(registro['domicilio_ja'] ?? '')),
                            DataCell(
                                Text(registro['presencial_digital'] ?? '')),
                            DataCell(Text(registro['domicilio'] ?? '')),
                            DataCell(
                                Text(registro['fecha_presentacion'] ?? '')),
                            DataCell(Text(
                                registro['hora_registro_presentacion'] ?? '')),
                            DataCell(Text(registro['hora_apertura'] ?? '')),
                            DataCell(Text(registro['partidas'] ?? '')),
                            DataCell(Text(registro['requiere_preventa'] ?? '')),
                            DataCell(Text(registro['link_carpeta'] ?? '')),
                            DataCell(Text(estatus)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              String formattedDate =
                  DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgregarRegistro(
                    agregarRegistro: agregarRegistro,
                    fechaSeleccionada: formattedDate,
                  ),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ));
  }
}

class ColorPickerDialog extends StatefulWidget {
  final Function(Color) onColorSelected;

  ColorPickerDialog({required this.onColorSelected});

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color _selectedColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('Se ganó'),
              leading: Radio(
                value: Colors.green,
                groupValue: _selectedColor,
                onChanged: (color) {
                  setState(() {
                    _selectedColor = color as Color;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Se perdió'),
              leading: Radio(
                value: Colors.red,
                groupValue: _selectedColor,
                onChanged: (color) {
                  setState(() {
                    _selectedColor = color as Color;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('No se participó'),
              leading: Radio(
                value: Colors.grey,
                groupValue: _selectedColor,
                onChanged: (color) {
                  setState(() {
                    _selectedColor = color as Color;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.onColorSelected(_selectedColor);
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}

class AgregarRegistro extends StatefulWidget {
  final Function agregarRegistro;
  final String fechaSeleccionada;

  AgregarRegistro({
    required this.agregarRegistro,
    required this.fechaSeleccionada,
  });

  @override
  _AgregarRegistroState createState() => _AgregarRegistroState();
}

class _AgregarRegistroState extends State<AgregarRegistro> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fechaPublicacionController;
  late TextEditingController _fechaEnvioPreguntasController;
  late TextEditingController _fechaJuntaAclaracionesController;
  late TextEditingController _fechaPresentacionController;

  late TextEditingController _horaLimiteEnvioPreguntasController;
  late TextEditingController _horaRegistroJAController;
  late TextEditingController _horaJAController;
  late TextEditingController _horaRegistroPresentacionController;
  late TextEditingController _horaAperturaController;

  Map<String, dynamic> registro = {
    'nombreLicitacion': '',
    'dependenciaLicitante': '',
    'dependenciaUsuario': '',
    'fechaPublicacion': '',
    'dondePublicado': '',
    'fechaEnvioPreguntas': '',
    'horaLimiteEnvioPreguntas': '',
    'comoSeEntregan': '',
    'domicilioCorreo': '',
    'fechaJuntaAclaraciones': '',
    'horaRegistroJA': '',
    'horaJA': '',
    'juntaObligatoria': '',
    'domicilioJA': '',
    'presencialOdigital': '',
    'domicilio': '',
    'fechaPresentacion': '',
    'horaRegistroPresentacion': '',
    'horaApertura': '',
    'partidas': '',
    'requierePreventa': '',
    'linkCarpeta': '',
    // Agrega aquí los demás campos del registro
    // ...
  };

  List<String> dondeSePublicoOptions = [
    'COMPRANET',
    'ADMINISTRACION',
    'LICYGOB',
    'LA DEPENDENCIA',
    'TITA',
    'Otros',
  ];
  String? otrosDondeSePublico;
  String? selectedDondeSePublico;

  List<String> requierePreventaOptions = [
    'Sí',
    'No',
  ];
  String? selectRequierePreventa;

  List<String> juntaObligatoriaOptions = [
    'Sí',
    'No',
  ];
  String? selectjuntaObligatoria;

  List<String> tipoJuntaOptions = [
    'Presencial',
    'Digital',
  ];
  String? selectTipoJunta;

  List<String> comoEntreganOptions = [
    'POR CORREO',
    'FISICAS CON USB',
  ];
  String? selectComoEntregan;

  List<String> partidas = [
    'EQUIPO DE COMPUTO',
    'ENERGIA',
    'PROYECCION',
    'SOFTWARE',
    'PAPELERIA',
    'Otros',
  ];
  List<String> selectedPartidas = [];

  @override
  void initState() {
    super.initState();
    _fechaPublicacionController = TextEditingController();
    _fechaEnvioPreguntasController = TextEditingController();
    _fechaJuntaAclaracionesController = TextEditingController();
    _fechaPresentacionController = TextEditingController();

    _horaLimiteEnvioPreguntasController = TextEditingController(text: '00:00');
    _horaRegistroJAController = TextEditingController(text: '00:00');
    _horaJAController = TextEditingController(text: '00:00');
    _horaRegistroPresentacionController = TextEditingController(text: '00:00');
    _horaAperturaController = TextEditingController(text: '00:00');
  }

  @override
  void dispose() {
    _fechaPublicacionController.dispose();
    _fechaEnvioPreguntasController.dispose();
    _fechaJuntaAclaracionesController.dispose();
    _fechaPresentacionController.dispose();
    _horaLimiteEnvioPreguntasController.dispose();
    _horaRegistroJAController.dispose();
    _horaJAController.dispose();
    _horaRegistroPresentacionController.dispose();
    _horaAperturaController.dispose();
    super.dispose();
  }

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      String formattedTime =
          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme(selectedColor: 6).theme(),
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('REGISTRO DE LICITACIONES'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Nombre de la licitación'),
                      onSaved: (value) {
                        registro['nombreLicitacion'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el nombre de la licitación';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Dependencia que licita'),
                      onSaved: (value) {
                        registro['dependenciaLicitante'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la dependencia que licita';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Dependencia usuaria'),
                      onSaved: (value) {
                        registro['dependenciaUsuario'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la dependencia usuaria';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _fechaPublicacionController,
                      decoration: InputDecoration(
                        labelText: 'Fecha de publicación',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(context, _fechaPublicacionController);
                          },
                        ),
                      ),
                    ),
                    DropdownButtonFormField(
                      value: selectedDondeSePublico,
                      decoration:
                          InputDecoration(labelText: 'Donde se publicó'),
                      items: dondeSePublicoOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          if (value == "Otros") {
                            otrosDondeSePublico = "";
                          } else {
                            selectedDondeSePublico = value;
                            otrosDondeSePublico = null;
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Este campo es requerido';
                        }
                        return null;
                      },
                    ),
                    if (otrosDondeSePublico != null) ...[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Especificar'),
                        onSaved: (value) {
                          registro['dondePublicado'] = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un valor';
                          }
                          return null;
                        },
                      ),
                    ],
                    TextFormField(
                      controller: _fechaEnvioPreguntasController,
                      decoration: InputDecoration(
                        labelText: 'Fecha de envío de preguntas',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(
                                context, _fechaEnvioPreguntasController);
                          },
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _horaLimiteEnvioPreguntasController,
                      decoration: InputDecoration(
                        labelText: 'Hora límite de envío de preguntas',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () {
                            _selectTime(
                                context, _horaLimiteEnvioPreguntasController);
                          },
                        ),
                      ),
                    ),
                    DropdownButtonFormField(
                      value: selectComoEntregan,
                      decoration:
                          InputDecoration(labelText: 'COMO SE ENTREGAN'),
                      items: comoEntreganOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectComoEntregan = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Este campo es requerido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Domicilio y/o correo'),
                      onSaved: (value) {
                        registro['domicilioCorreo'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el domicilio y/o correo';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _fechaJuntaAclaracionesController,
                      decoration: InputDecoration(
                        labelText: 'Fecha de junta de aclaraciones',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(
                                context, _fechaJuntaAclaracionesController);
                          },
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _horaRegistroJAController,
                      decoration: InputDecoration(
                        labelText: 'Hora de registro de junta de aclaraciones',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () {
                            _selectTime(context, _horaRegistroJAController);
                          },
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _horaJAController,
                      decoration: InputDecoration(
                        labelText: 'Hora de junta de aclaraciones',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () {
                            _selectTime(context, _horaJAController);
                          },
                        ),
                      ),
                    ),
                    DropdownButtonFormField(
                      value: selectjuntaObligatoria,
                      decoration:
                          InputDecoration(labelText: 'Junta Obligatoria'),
                      items: juntaObligatoriaOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectjuntaObligatoria = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Este campo es requerido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Domicilio JA'),
                      onSaved: (value) {
                        registro['domicilioJA'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el domicilio JA';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField(
                      value: selectTipoJunta,
                      decoration:
                          InputDecoration(labelText: 'ES PRESENCIAL O DIGITAL'),
                      items: tipoJuntaOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectTipoJunta = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Este campo es requerido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Domicilio'),
                      onSaved: (value) {
                        registro['domicilio'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el domicilio';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _fechaPresentacionController,
                      decoration: InputDecoration(
                        labelText: 'Fecha de presentación',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(context, _fechaPresentacionController);
                          },
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _horaRegistroPresentacionController,
                      decoration: InputDecoration(
                        labelText: 'Hora de registro de presentación',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () {
                            _selectTime(
                                context, _horaRegistroPresentacionController);
                          },
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _horaAperturaController,
                      decoration: InputDecoration(
                        labelText: 'Hora de apertura',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () {
                            _selectTime(context, _horaAperturaController);
                          },
                        ),
                      ),
                    ),
                    Text(" "),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sobre las Partidas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.grey[400]!,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              ...List<Widget>.generate(partidas.length,
                                  (index) {
                                final option = partidas[index];
                                if (option == 'Otros') {
                                  return CheckboxListTile(
                                    title: Text(option),
                                    value: selectedPartidas.contains(option),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value != null && value) {
                                          selectedPartidas.add(option);
                                        } else {
                                          selectedPartidas.remove(option);
                                        }
                                      });
                                    },
                                  );
                                }
                                return CheckboxListTile(
                                  title: Text(option),
                                  value: selectedPartidas.contains(option),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value != null && value) {
                                        selectedPartidas.add(option);
                                        selectedPartidas.remove('Otros');
                                      } else {
                                        selectedPartidas.remove(option);
                                      }
                                    });
                                  },
                                );
                              }),
                              if (selectedPartidas.contains('Otros'))
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Otro tipo de partida',
                                  ),
                                  onChanged: (value) {
                                    // Aquí puedes manejar el valor ingresado por el usuario para "Otros"
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    DropdownButtonFormField(
                      value: selectRequierePreventa,
                      decoration:
                          InputDecoration(labelText: 'Requiere preventa'),
                      items: requierePreventaOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectRequierePreventa = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Este campo es requerido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Link carpeta'),
                      onSaved: (value) {
                        registro['linkCarpeta'] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el link de la carpeta';
                        }
                        return null;
                      },
                    ),
                    // Agrega aquí los demás campos del formulario
                    // ...
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registro['fechaPublicacion'] =
                              _fechaPublicacionController.text;
                          registro['fechaEnvioPreguntas'] =
                              _fechaEnvioPreguntasController.text;
                          registro['fechaJuntaAclaraciones'] =
                              _fechaJuntaAclaracionesController.text;
                          registro['fechaPresentacion'] =
                              _fechaPresentacionController.text;
                          registro['horaLimiteEnvioPreguntas'] =
                              _horaLimiteEnvioPreguntasController.text;
                          registro['horaRegistroJA'] =
                              _horaRegistroJAController.text;
                          registro['horaJA'] = _horaJAController.text;
                          registro['horaRegistroPresentacion'] =
                              _horaRegistroPresentacionController.text;
                          registro['horaApertura'] =
                              _horaAperturaController.text;
                          registro['dondePublicado'] = selectedDondeSePublico;
                          registro['presencialOdigital'] = selectTipoJunta;
                          registro['juntaObligatoria'] = selectjuntaObligatoria;
                          registro['requierePreventa'] = selectRequierePreventa;
                          registro['comoSeEntregan'] = selectComoEntregan;
                          registro['partidas'] = selectedPartidas.join(", ");
                          _formKey.currentState!.save();
                          widget.agregarRegistro(registro);
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
