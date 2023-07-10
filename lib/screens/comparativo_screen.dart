import 'package:ati/models/comparativos.dart';
import 'package:ati/widgets/cardComparativos.dart';
import 'package:flutter/material.dart';

class ComparativoScreen extends StatefulWidget {
  const ComparativoScreen({Key? key}) : super(key: key);

  @override
  State<ComparativoScreen> createState() => _ComparativoScreenState();
}

class _ComparativoScreenState extends State<ComparativoScreen> {
  String busq = "";

  void handleCardDeletion() {
    // Lógica para eliminar el CardComparativos
    // Puedes usar el índice del elemento o cualquier otro identificador único
    // Por ejemplo:
    // setState(() {
    //   // Eliminar el elemento de la lista de comparativos
    // });
  }

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
                icon: const Icon(Icons.search_outlined),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: ComparativoModelo.listaComparativos(busq),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasError || snapshot.data == 'Error') {
                  return const Center(
                    child: Text('Ocurrió un error'),
                  );
                } else {
                  var snap = snapshot.data;
                  if (snap.length > 0) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      itemBuilder: (context, index) {
                        return CardComparativos(
                          nombre: snap[index]['nombre'],
                          id: snap[index]['id'].toString(),
                          comparador: snap[index]['comparador'],
                          onDelete:
                              handleCardDeletion, // Pasar la función de eliminación al constructor
                        );
                      },
                      itemCount: snap.length,
                    );
                  } else {
                    return const Center(child: Text('Sin datos'));
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
