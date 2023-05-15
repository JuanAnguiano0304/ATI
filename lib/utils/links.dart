import 'dart:convert';
import 'package:http/http.dart' as http;

class Link {
  final int? id;
  final String marca;
  final String link;
  final String estatus;
  final String descripcion;
  // constructor method
  Link(
      {required this.id,
      required this.marca,
      required this.estatus,
      required this.descripcion,
      required this.link});

  // constructor method
  static Link fromJson(Map<String, dynamic> datos) {
    return Link(
      id: datos['id'],
      marca: datos['marca'],
      estatus: datos['estatus'],
      descripcion: datos['descripcion'],
      link: datos['link'],
    );
  }

  // We make the request to the database to obtain all the links
  static Future<List<Link>> getLinks(
      String txt, String status, String marca) async {
    try {
      final url = txt == '' && status == ''
          ? Uri.https(
              'apibuscador.tecnologiaintegrada.mx',
              '/public/api/detalles',
            )
          : Uri.https(
              'apibuscador.tecnologiaintegrada.mx',
              '/public/api/detalles',
              {'estatus': status, 'txt': txt, 'marca': marca});
      final response = await http.get(url);
      String json = response.body.toString();
      List<dynamic> responseJson = await jsonDecode(json);
      List<Map<String, dynamic>> linkJson =
          responseJson.cast<Map<String, dynamic>>();
      List<Link> link = List.generate(linkJson.length, (index) {
        return fromJson(linkJson[index]);
      });
      return link;
    } on Exception catch (e) {
      print('esto causo el error: $e');
      return [];
    }
  }

// This function performs the registration of data to the database
  static Future<bool> register(
      String marca, String descripcion, String link) async {
    try {
      final respuesta = await http.Client().post(Uri.https(
          'apibuscador.tecnologiaintegrada.mx', '/public/api/detalles', {
        'marca': marca,
        'descripcion': descripcion,
        'url': link,
      }));

      return respuesta.body == 'OK';
    } on Exception catch (e) {
      print('ERROR: $e');
      return false;
    }
  }

// This function performs data updates
  static Future update(int id, String descripcion, String link) async {
    try {
      final respuesta = await http.Client().put(Uri.https(
          'apibuscador.tecnologiaintegrada.mx', '/public/api/detalles/$id', {
        'descripcion': descripcion,
        'url': link,
      }));

      return respuesta.statusCode;
    } on Exception catch (e) {
      print('ERROR: $e');
      return false;
    }
  }

  // this funtion destroy register
  static Future destroy(int id) async {
    try {
      final respuesta = await http.Client().put(Uri.https(
          'apibuscador.tecnologiaintegrada.mx', '/public/api/off/$id'));

      return respuesta.statusCode;
    } on Exception catch (e) {
      print('ERROR: $e');
      return false;
    }
  }

  static Future enable(int id) async {
    try {
      final respuesta = await http.Client().put(Uri.https(
          'apibuscador.tecnologiaintegrada.mx', '/public/api/on/$id'));

      return respuesta.statusCode;
    } on Exception catch (e) {
      print('ERROR: $e');
      return false;
    }
  }
}
