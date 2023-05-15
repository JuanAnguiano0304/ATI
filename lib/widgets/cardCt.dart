import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardCt extends StatelessWidget {
  final String parte;
  final String nombre;
  final String desc;
  final String precio;
  final String imagen;
  final String existencia;
  final String gdl;
  const CardCt(
      {super.key,
      required this.parte,
      required this.nombre,
      required this.desc,
      required this.precio,
      required this.existencia,
      required this.imagen,
      required this.gdl});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Color.fromARGB(255, 144, 133, 133),
        ),
      ),
      child: ListTile(
        title: SizedBox(
          height: 170,
          child: CachedNetworkImage(
            imageUrl: imagen,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.image_not_supported),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              nombre,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const Divider(
              color: Colors.black,
            ),
            Row(
              children: [
                const Text(
                  'Número de parte: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SelectableText(
                  parte,
                  style: const TextStyle(color: Colors.black),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Descripción: ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              desc,
              style: const TextStyle(color: Colors.black),
              softWrap: true,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Text(
                  'Precio: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SelectableText(
                  '\$$precio MXN',
                  style: const TextStyle(color: Colors.black),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Text(
                  'Existencia GDL: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SelectableText(
                  gdl == 'null' ? '0' : gdl,
                  style: const TextStyle(color: Colors.black),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  'Existencia total: ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SelectableText(
                  existencia == 'null' ? '0' : existencia,
                  style: const TextStyle(color: Colors.black),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
