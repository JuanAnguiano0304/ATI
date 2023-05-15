import 'package:ati/admin/admin.dart';
import 'package:ati/screens/view_link/links_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ati/utils/marcas.dart';
import 'package:ati/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

// ignore: must_be_immutable
class MarcasScreen extends StatefulWidget {
  String? name;
  String? email;
  MarcasScreen({super.key, this.name, required this.email});

  @override
  State<MarcasScreen> createState() => _MarcasScreenState();
}

class _MarcasScreenState extends State<MarcasScreen>
    with AutomaticKeepAliveClientMixin {
  String? email1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Links por marcas',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 30,
                    color: Colors.black),
              ),
              IconButton(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  tooltip: 'Recargar',
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.replay)),
              email1 != null
                  ? Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: GradientColors.seaBlue,
                        ),
                      ),
                      child: Tooltip(
                        message: 'Panel admin',
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                              builder: (context) => const Admin(),
                            ))
                                .whenComplete(() {
                              setState(() {});
                            });
                          },
                          child: const Icon(Icons.admin_panel_settings),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          _marcasview(widget.email!)
        ],
      ),
    );
  }

  void _getUser() async {
    try {
      await User.getUser(widget.email!.toString()).then((value) {
        email1 = value.first.email;
        setState(() {});
      });
    } catch (e) {}
  }

  Widget _marcasview(String email) {
    return Flexible(
      child: FutureBuilder(
        future: Marca.getMarca(),
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
                  child: Text('No existen marcas'),
                );
              } else {
                return ResponsiveGridList(
                  horizontalGridSpacing: 5,
                  verticalGridSpacing: 5,
                  horizontalGridMargin: 10,
                  verticalGridMargin: 10,
                  minItemWidth: 200,
                  children: datos.map((e) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LinksScreen(email: email, marca: e.nombre),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: e.direccion,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.image_not_supported),
                              height: 160,
                              fit: BoxFit.contain,
                            ),
                            Text(
                              e.nombre,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                        // child: ListTile(
                        // title: CachedNetworkImage(
                        //   imageUrl: e.direccion,
                        //   placeholder: (context, url) =>
                        //       const CircularProgressIndicator(),
                        //   width: double.maxFinite,
                        //   height: 160,
                        //   fit: BoxFit.contain,
                        // ),
                        //   subtitle: Center(
                        // child: Text(
                        //   e.nombre,
                        //   style: const TextStyle(
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.black,
                        //   ),
                        //   softWrap: true,
                        // ),
                        //   ),
                        // ),
                      ),
                    );
                  }).toList(),
                );
              }
            }
          }
        },
      ),
    );
  }
}
