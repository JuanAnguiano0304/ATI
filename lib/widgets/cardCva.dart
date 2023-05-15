// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardCVA extends StatelessWidget {
  final String imagen;
  final String descripcion;
  final String existencia;
  final String garantia;
  final String precio;
  final String precioDesc;
  final String moneda;
  final String monedaDesc;
  final String cCva;
  final String np;
  const CardCVA({
    super.key,
    required this.imagen,
    required this.descripcion,
    required this.existencia,
    required this.garantia,
    required this.precio,
    required this.precioDesc,
    required this.moneda,
    required this.monedaDesc,
    required this.cCva,
    required this.np,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
        subtitle: SizedBox(
          child: SelectionArea(
            child: Column(
              children: [
                Text(
                  descripcion,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                  softWrap: true,
                ),
                const Divider(
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Código CVA:\n$cCva',
                      style: const TextStyle(color: Colors.black),
                      softWrap: true,
                    ),
                    Text(
                      'Código fabricante:\n$np',
                      style: const TextStyle(color: Colors.black),
                      softWrap: true,
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Disponibilidad Total: $existencia',
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      garantia == 'SG'
                          ? 'Garantia: $garantia'
                          : 'Garantia: $garantia año/s',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Precio: \$$precio',
                      style: const TextStyle(color: Colors.black),
                      softWrap: true,
                    ),
                    Text(
                      precioDesc == 'Sin Descuento'
                          ? 'P. descuento: $precioDesc'
                          : 'P. descuento: \$$precioDesc',
                      style: const TextStyle(color: Colors.black),
                      softWrap: true,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
