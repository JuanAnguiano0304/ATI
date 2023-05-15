import 'package:ati/models/comparativos.dart';
import 'package:ati/widgets/cardComparativos.dart';
import 'package:flutter/material.dart';

class ComparativoScreen extends StatefulWidget {
  const ComparativoScreen({super.key});

  @override
  State<ComparativoScreen> createState() => _ComparativoScreenState();
}

class _ComparativoScreenState extends State<ComparativoScreen> {
  String busq = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 30, left: 30, bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
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
                  onSubmitted: (value) {
                    busq = value;
                    setState(() {});
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.search_outlined))
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: ComparativoModelo.listaComparativos(busq),
            builder: (context, snapshot) {
              if (snapshot.connectionState.name == 'waiting') {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasError || snapshot.data == 'Error') {
                  return const Center(
                    child: Text('Ocurrio un error'),
                  );
                } else {
                  var snap = snapshot.data;
                  if (snap.length > 0) {
                    return ListView.builder(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        itemBuilder: (context, index) {
                          return CardComparativos(
                            nombre: snap[index]['nombre'],
                            mejor: snap[index]['mejor'],
                            id: snap[index]['id'].toString(),
                            comparador: snap[index]['comparador'],
                          );
                        },
                        itemCount: snap.length);
                  } else {
                    return const Center(child: Text('Sin Datos'));
                  }
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
