// ignore_for_file: unnecessary_string_interpolations

import 'package:ati/utils/links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

class LinkOff extends StatefulWidget {
  const LinkOff({super.key});

  @override
  State<LinkOff> createState() => _LinkOffState();
}

class _LinkOffState extends State<LinkOff> with AutomaticKeepAliveClientMixin {
  String query = '';
  List<Link> _links = [];

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
        title: const Text('Desactivados'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(
            left: media.width < 600 ? 0 : 200,
            right: media.width < 600 ? 0 : 200),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: Link.getLinks(query, 'OFF', ''),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _links = snapshot.data!;
                    return ListView.builder(
                      itemCount: _links.length,
                      itemBuilder: (context, i) {
                        Link p = _links[i];
                        return ListTile(
                          leading: const Icon(Icons.disabled_visible),
                          title: Text("${p.descripcion}"),
                          subtitle: Text("${p.link}"),
                          trailing: IconButton(
                            tooltip: 'Activar',
                            icon: const Icon(
                              Icons.edit_attributes_outlined,
                              color: Color.fromARGB(255, 0, 255, 0),
                            ),
                            onPressed: () async {
                              try {
                                Link.enable(p.id!).whenComplete(() {
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
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
