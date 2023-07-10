// ignore_for_file: depend_on_referenced_packages

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiCt {
  static Map<String, String> fromJson(Map datos) {
    double precioMx = 0;
    int sumExis = 0;
    if (datos['moneda'] == 'USD') {
      precioMx = datos['precio'] * datos['tipoCambio'];
    }
    String clave = datos['clave'];
    Map exis = datos['existencia'];
    for (var lugares in exis.keys) {
      int dat = datos['existencia']['$lugares'];
      sumExis += dat;
    }
    return {
      'numParte': datos['numParte'],
      'nombre': datos['nombre'],
      'descripcion': datos['descripcion_corta'],
      'precio': datos['moneda'] == 'USD'
          ? (precioMx).toStringAsFixed(2)
          : datos['precio'].toString(),
      'imagen': 'http://static.ctonline.mx/imagenes/$clave/$clave'
          '_full.jpg',
      'exis': '$sumExis',
      'gdl': datos['existencia']['GDL'].toString()
    };
  }

  static Future<dynamic> buscador(String busq, String filter) async {
    if (busq != '') {
      try {
        final respuesta = await http.Client().get(Uri.https(
            'www.apibuscador.tecnologiaintegrada.mx', '/public/api/ctonline'));
        var datos = json.decode(respuesta.body);
        List<Map> lista = [];

        if (filter == 'Desc') {
          for (var i = 0; i < datos.length; i++) {
            String datbusq = datos[i]['descripcion_corta'];
            if (datbusq.toLowerCase().contains(busq.toLowerCase())) {
              lista.add(fromJson(datos[i]));
            }
          }
        } else {
          for (var i = 0; i < datos.length; i++) {
            String databusq = datos[i]['numParte'];
            if (databusq.toLowerCase().contains(busq.toLowerCase())) {
              lista.add(fromJson(datos[i]));
              break;
            }
          }
        }

        // Ordenar la lista por existencias en orden descendente
        lista.sort(
            (a, b) => int.parse(b['exis']).compareTo(int.parse(a['exis'])));

        return lista;
      } catch (e) {
        return 'error';
      }
    } else {
      return 'Sin búsqueda';
    }
  }
}
