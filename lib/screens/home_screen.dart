// ignore_for_file: avoid_web_libraries_in_flutter, unused_import

import 'package:ati/models/user.dart';
import 'package:ati/screens/buscadorCt.dart';
import 'package:ati/screens/buscadorP_screen.dart';
import 'package:ati/screens/buscador_screen.dart';
import 'package:ati/screens/comparador_screen.dart';
import 'package:ati/screens/drive_screen.dart';
import 'package:ati/utils/utilsGoogle.dart';
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:googleapis/drive/v3.dart' as drive;

import 'view_link/marcas_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  String? user;
  String? email;
  HomeScreen({Key? key, this.user, this.email}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return DefaultTabController(
      initialIndex: 0,
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              children: [
                Text(widget.user!,
                    softWrap: true,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        backgroundColor: Color.fromARGB(0, 202, 202, 235))),
                IconButton(
                    tooltip: 'Cerrar sesión',
                    splashRadius: 20,
                    onPressed: () {
                      UserData.cleanToken();
                      UserData.cleanDisplayName();
                      Utils().signInOut();
                      setState(() {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      });
                    },
                    icon: const Icon(Icons.logout))
              ],
            )
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: GradientColors.seaBlue,
              ),
            ),
          ),
          title: Text(
            media.width >= 439 ? 'ATI Tecnología Integrada' : 'ATI',
          ),
          centerTitle: media.width < 600 ? false : true,
          toolbarHeight: 30,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: SizedBox(
              height: 40,
              child: TabBar(
                indicatorColor: Colors.red,
                tabs: [
                  Tab(
                    // icon: Icon(Icons.search),
                    text: media.width >= 810
                        ? 'Buscador general'
                        : media.width >= 455
                            ? 'Buscador'
                            : 'Busc.',
                  ),
                  Tab(
                    // icon: Icon(Icons.saved_search),
                    text: media.width >= 810 ? 'Buscador CVA' : 'CVA',
                  ),
                  Tab(
                    // icon: Icon(Icons.saved_search),
                    text: media.width >= 810 ? 'Buscador CT' : 'CT',
                  ),
                  Tab(
                    // icon: Icon(Icons.description),
                    text: media.width >= 810 ? 'Carpeta compartida' : 'Drive',
                  ),
                  Tab(
                    // icon: Icon(Icons.table_chart),
                    text: media.width >= 810 ? 'Tablas comparativas' : 'Tablas',
                  ),
                  Tab(
                    // icon: Icon(Icons.storage),
                    text: media.width >= 810 ? 'Bodega de links' : 'Links',
                  )
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            const BuscadorScreen(),
            const BuscadorProveedor(),
            const CTonline(),
            const DriveScreen(),
            const ComparadorScreen(),
            MarcasScreen(name: widget.user!, email: widget.email!),
          ],
        ),
      ),
    );
  }
}
