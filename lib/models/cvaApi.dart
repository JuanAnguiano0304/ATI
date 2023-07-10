// ignore_for_file: depend_on_referenced_packages, file_names, unnecessary_string_interpolations, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class ApiCva {
  static Future<dynamic> cva(String busq, String query) async {
    //Validación de que se haya realizado una búsqueda
    if (busq != '' && query != '') {
      try {
        final respuesta = await http.Client().get(Uri.https(
          'www.apibuscador.tecnologiaintegrada.mx',
          '/public/api/cva',
          {
            'cliente': '21943',
            'query': '$query', //Búsqueda
            'clave':
                '$busq', //Parametro a utilizar de la función busqCVA de funcionalidad.dart
          },
        )); //Se utliza https por los certificados y seguridad con las que cuenta el servidor.
        String stat = respuesta.statusCode.toString();
        //Verificación del status de la respuesta, para verificar que no haya dado error por el tiempo de respuesta.
        if (stat == '200' && stat != '500') {
          final Xml2Json myTransformer =
              Xml2Json(); //Inicialización de la funcionalidad de la conversión
          myTransformer.parse(respuesta.body.toString());
          var json = myTransformer.toParker(); //Parseo del XML a JSON
          Map data = jsonDecode(json);
          var datos;
          if (data['articulos'] != null) {
            // Obtener la lista de productos
            List productos = data['articulos']['item'];
            // Ordenar la lista por existencia de forma descendente
            productos.sort(
                (a, b) => int.parse(b['ExsTotal']) - int.parse(a['ExsTotal']));
            datos = productos;
          } else {
            datos = 'No Existe';
          }
          return datos;
        } else {
          return 'Ocurrio un problema con el tiempo de respuesta';
        }
      } on Exception catch (e) {
        return 'error';
      }
    } else {
      return 'Sin búsqueda';
    }
  }
}
