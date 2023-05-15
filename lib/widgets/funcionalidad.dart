// ignore_for_file: unused_catch_clause, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Funcionalidades {
  static Future<List<Map>> links(String busq) async {
    try {
      final respuesta = await http.Client().post(Uri.https(
          'www.apibuscador.tecnologiaintegrada.mx',
          '/public/api/lweb',
          {'text': busq}));
      var result = jsonDecode(respuesta.body.toString());
      List<Map<String, String>> links = List.generate(result.length, (index) {
        return {
          'id': result[index]['id'].toString(),
          'titulo': result[index]['titulo'],
          'link': result[index]['link'],
          'activo': result[index]['activo']
        };
      });
      return links;
    } on Exception catch (e) {
      return [];
    }
  }

  static Future<String> gact(
      String id, String titulo, String link, String activo) async {
    try {
      final respuesta = await http.Client().post(Uri.https(
          'www.apibuscador.tecnologiaintegrada.mx',
          '/public/api/gweb',
          {'id': id, 'titulo': titulo, 'link': link, 'activo': activo}));
      String resp = respuesta.body;
      return resp;
    } on Exception catch (e) {
      return 'Error';
    }
  }

  List itemsComparativa() {
    return [
      'Comparativos',
      'Desktop',
      'Proyector',
      'Laptops',
      'Monitores',
      'Impresoras',
      'Scanners',
      'Pantallas'
    ];
  }

  List busqCVA() {
    return [
      ['Número de Producto', 'codigo'],
      ['Código CVA', 'clave'],
      ['Marca', 'marca'],
      ['Grupo', 'grupo'],
      ['Búsqueda Génerica', 'desc']
    ];
  }

  DataRow filas(int e, List<Map<String, String>> comparativa) {
    return DataRow(
      //fila para la tabla
      cells: comparativa[e]
          .keys
          .map(
            (a) => DataCell(
              TextFormField(
                initialValue: comparativa[e][a],
                validator: (value) {
                  //validación para que no se encuentre vacio.
                  if (value!.isEmpty) {
                    return 'No debe estar vacio';
                  }
                  return null;
                },
                expands:
                    true, //Hacer que la celda pueda expandirse a medida que el texto crece.
                minLines: null,
                maxLines: null,
                onSaved: (newValue) {
                  comparativa[e][a] =
                      newValue!; //Asignación del valor correspondiente al índice y llave de la lista del modelo asociado.
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
