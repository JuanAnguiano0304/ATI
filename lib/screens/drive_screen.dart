import 'package:ati/models/user.dart';
import 'package:ati/utils/utilsGoogle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'dart:js' as js;

import 'package:shared_preferences/shared_preferences.dart';

class DriveScreen extends StatefulWidget {
  const DriveScreen({super.key});

  @override
  State<DriveScreen> createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  List<drive.File>? document;
  String query = '';
  bool disableDrive = false;
  TextEditingController q = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: media.width < 600 ? 0 : 200),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  width: 400,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Buscar',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        icon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              query = q.value.text;
                            });
                          },
                        )),
                    controller: q,
                    onFieldSubmitted: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                    onChanged: (value) {
                      query = value;
                    },
                    readOnly: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: GradientColors.seaBlue,
                      ),
                    ),
                    child: Tooltip(
                      message: 'Reingresar si no aparecen los documentos',
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () => _relogin(),
                          icon: const Icon(Icons.account_box),
                          label: const Text('Iniciar sesión')),
                    ),
                  ),
                )
              ],
            ),
            Expanded(child: _viewDocuments()),
          ],
        ),
      ),
    );
  }

  void _relogin() async {
    UserData.cleanToken();
    await Utils().signInWhithGoogle().then((value) {
      setState(() {
        Utils().getDocuments(query);
      });
    });
  }

  Widget _viewDocuments() {
    return FutureBuilder(
        future: Utils().getDocuments(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState.name == 'waiting') {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              document = snapshot.data;
              if (document!.isEmpty) {
                return const Center(
                  child: Text('No existen documentos compartidos'),
                );
              } else {
                return ListView.builder(
                  itemCount: document!.length,
                  itemBuilder: (context, index) {
                    var file = document![index];
                    return InkWell(
                      onTap: () {
                        js.context
                            .callMethod('open', [file.webViewLink!.toString()]);
                      },
                      child: Card(
                        child: ListTile(
                          leading: Image.network(
                            file.iconLink!,
                          ),
                          title: Text(file.name!),
                          subtitle: Text(
                            'última modificación: ${file.modifiedTime!.toString()}',
                            softWrap: true,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              return const Center(
                child: Text('File not Found'),
              );
            }
          }
        });
  }
}
