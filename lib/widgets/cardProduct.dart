// ignore_for_file: avoid_web_libraries_in_flutter, file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

class CardProduct extends StatelessWidget {
  final String titulo;
  final String link;
  final String imagen;
  final String pagina;
  final String snippet;
  const CardProduct(
      {Key? key,
      required this.titulo,
      required this.link,
      required this.imagen,
      required this.pagina,
      required this.snippet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        js.context.callMethod('open', [link]);
      },
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: CachedNetworkImage(
                imageUrl: imagen,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.image_not_supported),
                height: 190,
                width: 190,
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(titulo),
                  Text(
                    snippet,
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    pagina,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
