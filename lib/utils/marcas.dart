import 'dart:convert';
import 'package:http/http.dart' as http;

class Marca {
  final int id;
  final String nombre;
  final String direccion;

// constructor method
  Marca({required this.nombre, required this.id, required this.direccion});

  // constructor method
  static Marca fromJson(Map<String, dynamic> datos) {
    return Marca(
        nombre: datos['nombre'],
        id: datos['id'],
        direccion: datos['direccion']);
  }

  // We make the request to the database to obtain all the marcas
  static Future getMarcas() async {
    try {
      final url = Uri.https(
        'apibuscador.tecnologiaintegrada.mx',
        '/public/api/marcas',
      );

      final response = await http.get(url);
      String json = response.body.toString();
      List<dynamic> responseJson = await jsonDecode(json);
      List<Map<String, dynamic>> marcaJson =
          responseJson.cast<Map<String, dynamic>>();

      return marcaJson.toList();
    } on Exception catch (e) {
      return [];
    }
  }

// This function performs the registration of data to the database
  static Future<bool> register(String nombre, var img) async {
    try {
      var envio = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://apibuscador.tecnologiaintegrada.mx/public/api/marcas'));
      envio.fields['nombre'] = nombre;
      envio.files
          .add(http.MultipartFile.fromBytes('imagen', img, filename: 'imagen'));
      var response = await envio.send();
      var respuesta = await http.Response.fromStream(response);
      return respuesta.body == 'OK';
    } on Exception catch (e) {
      return false;
    }
  }

// This function performs data updates
  static Future update(int id, String txt, var imagen) async {
    try {
      var envio = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://apibuscador.tecnologiaintegrada.mx/public/api/actMarca/$id'));
      envio.fields['nombre'] = txt;
      if (imagen != null) {
        envio.files.add(
            http.MultipartFile.fromBytes('imagen', imagen, filename: 'imagen'));
      }
      var response = await envio.send();
      var respuesta = await http.Response.fromStream(response);
      return respuesta.statusCode;
    } on Exception catch (e) {
      return false;
    }
  }

  // We make the request to the database to obtain first the marca
  static Future<List<Marca>> getMarca() async {
    try {
      final url = Uri.https(
        'apibuscador.tecnologiaintegrada.mx',
        '/public/api/marcas',
      );
      final response = await http.get(url);
      String json = response.body.toString();
      List<dynamic> responseJson = await jsonDecode(json);
      List<Map<String, dynamic>> marcaJson =
          responseJson.cast<Map<String, dynamic>>();
      List<Marca> marca = List.generate(marcaJson.length, (index) {
        return fromJson(marcaJson[index]);
      });
      return marca;
    } on Exception catch (e) {
      return [];
    }
  }

  // this funtion destroy register
  static Future destroy(int id) async {
    try {
      final respuesta = await http.Client().delete(Uri.https(
          'apibuscador.tecnologiaintegrada.mx', '/public/api/marcas/$id'));
      return respuesta.statusCode;
    } on Exception catch (e) {
      return false;
    }
  }
}
