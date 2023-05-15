import 'package:ati/models/ctApi.dart';
import 'package:ati/widgets/listaCt.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CTonline extends StatefulWidget {
  const CTonline({super.key});

  @override
  State<CTonline> createState() => _CTonlineState();
}

//5,232,215
class _CTonlineState extends State<CTonline>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String busq = '';
  String filtro = 'NP';
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Container(
                width: 450,
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar en CTonline',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  onChanged: (value) {
                    busq = value;
                  },
                ),
              ),
              Flexible(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    value: filtro,
                    onChanged: (value) {
                      filtro = value!;
                      setState(() {});
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'NP',
                        child: Text('Número de producto'),
                      ),
                      DropdownMenuItem(
                        value: 'Desc',
                        child: Text('Descripción corta'),
                      ),
                    ],
                    buttonStyleData: ButtonStyleData(
                      width: 190,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black)),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.search_rounded)),
            ],
          ),
          FutureBuilder(
            future: ApiCt.buscador(busq, filtro),
            builder: (context, snapshot) {
              if (snapshot.connectionState.name == 'waiting') {
                return SizedBox(
                  height: (MediaQuery.of(context).size.height - 144),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                if (snapshot.hasError) {
                  return SizedBox(
                    height: (MediaQuery.of(context).size.height - 144),
                    child: const Center(
                      child: Text('Ha ocurrido un error'),
                    ),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data.length > 0) {
                    // return ListaCt(datos: snapshot.data);
                    if (snapshot.data == 'Sin búsqueda') {
                      return SizedBox(
                          height: (MediaQuery.of(context).size.height - 144),
                          child: Center(child: Text(snapshot.data)));
                    } else {
                      return ListaCt(datos: snapshot.data);
                    }
                  } else {
                    return SizedBox(
                      height: (MediaQuery.of(context).size.height - 144),
                      child: const Center(
                        child: Text('Sin resultados'),
                      ),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
