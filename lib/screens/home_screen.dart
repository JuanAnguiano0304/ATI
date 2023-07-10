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
import 'package:ati/models/syscomApi.dart';
import 'package:ati/models/pchApi.dart';
import 'package:ati/models/exelApi.dart';
import 'package:ati/models/glomaApi.dart';
import 'package:ati/models/dataApi.dart';
import 'package:ati/models/intcomexApi.dart';
import 'package:ati/models/buscadorMayorista.dart';

import 'package:ati/screens/formularioLicitacion.dart';
import 'package:ati/models/formularioLicitaciones.dart';

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
  Widget? selectedSearchScreen;
  bool showSelectedSearchScreen = false;

  @override
  void initState() {
    super.initState();
    // Inicialmente se muestra el buscador general
    selectedSearchScreen = _buildSelectedSearchScreen();
  }

  void resetSelectedSearchScreen() {
    setState(() {
      showSelectedSearchScreen = false;
      selectedSearchScreen = _buildSelectedSearchScreen();
    });
  }

  void showSelectedSearchScreenTab() {
    setState(() {
      showSelectedSearchScreen = true;
    });
  }

  Widget _buildSelectedSearchScreen() {
    return Column(
      children: [
        _buildListTile('Buscador CVA', const BuscadorProveedor(), Icons.search),
        _buildListTile('Buscador CT', const CTonline(), Icons.search),
        _buildListTile('Buscador Syscom', SyscomBuscadorScreen(), Icons.search),
        _buildListTile('Buscador PCH', PchController(), Icons.search),
        _buildListTile('Buscador EXEL', ExelApi(), Icons.search),
        _buildListTile('Buscador DataComponents', DataScreen(), Icons.search),
        _buildListTile('Buscador G-Loma', GLomaApi(), Icons.search),
        _buildListTile('Buscador INTCOMEX', IntcomexScreen(), Icons.search),
        _buildListTile('Buscador INGRAM', DataScreen(), Icons.search),
      ],
    );
  }

  Widget _buildListTile(String title, Widget screen, IconData icon) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          setState(() {
            showSelectedSearchScreen = true;
            selectedSearchScreen = screen;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return DefaultTabController(
      initialIndex: 0,
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              children: [
                Text(
                  widget.user!,
                  softWrap: true,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    backgroundColor: Color.fromARGB(0, 202, 202, 235),
                    fontFamily: 'Roboto',
                  ),
                ),
                IconButton(
                  tooltip: 'Cerrar sesión',
                  splashRadius: 20,
                  onPressed: () {
                    UserData.cleanToken();
                    UserData.cleanDisplayName();
                    Utils().signInOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  icon: const Icon(Icons.logout),
                ),
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
          title: Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(15), // Redondear la imagen del logo
                child: Image.network(
                  'https://i.postimg.cc/GmvdqH3W/326133312-681398487015865-904546752635516144-n.jpg',
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                media.width >= 439 ? 'ATI Tecnología Integrada' : 'ATI',
                style: TextStyle(
                  fontFamily: 'Roboto', // Utilizar una fuente moderna
                ),
              ),
            ],
          ),
          centerTitle: media.width >= 600,
          toolbarHeight: 30,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: SizedBox(
              height: 40,
              child: TabBar(
                indicatorColor: Colors.red,
                onTap: (index) {
                  if (index == 1) {
                    resetSelectedSearchScreen();
                  }
                },
                tabs: [
                  Tab(
                    child: Text(
                      media.width >= 810 ? 'Buscador general' : 'Buscador',
                    ),
                  ),
                  Tab(
                    text: 'Buscadores Mayoristas',
                  ),
                  Tab(
                    text: 'Buscador general mayoristas',
                  ),
                  Tab(
                    child: Text(
                      media.width >= 810 ? 'Carpeta compartida' : 'Drive',
                    ),
                  ),
                  Tab(
                    child: Text(
                      media.width >= 810 ? 'Tablas comparativas' : 'Tablas',
                    ),
                  ),
                  Tab(
                    text: 'Licitaciones',
                  ),
                  Tab(
                    child: Text(
                      media.width >= 810 ? 'Bodega de links' : 'Links',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            const BuscadorScreen(),
            showSelectedSearchScreen
                ? Column(
                    children: [
                      Expanded(child: selectedSearchScreen!),
                    ],
                  )
                : selectedSearchScreen!,
            CombinedSearch(),
            const DriveScreen(),
            const ComparadorScreen(),
            RegistroTable(),
            MarcasScreen(name: widget.user!, email: widget.email!),
          ],
        ),
      ),
    );
  }
}
