import 'dart:convert';

import 'package:http/http.dart' as http;

class User {
  int id;
  String nombre;
  String email;

  // constructor method
  User({
    required this.id,
    required this.nombre,
    required this.email,
  });

  // constructor method
  static User fromJson(Map<String, dynamic> user) {
    return User(
      id: user['id'],
      nombre: user['name'],
      email: user['email'],
    );
  }

  // We make the request to the database to obtain all the User
  static Future<List<User>> getUser(String email) async {
    try {
      final url = email == ''
          ? Uri.https(
              'apibuscador.tecnologiaintegrada.mx', '/public/api/allUser')
          : Uri.https('apibuscador.tecnologiaintegrada.mx', '/public/api/user',
              {'email': email});
      final response = await http.get(url);

      String json = response.body.toString();
      List<dynamic> responseJson = jsonDecode(json);
      List<Map<String, dynamic>> userJson =
          responseJson.cast<Map<String, dynamic>>();
      List<User> user = List.generate(userJson.length, (index) {
        return fromJson(userJson[index]);
      });
      return user;
    } catch (e) {
      return [];
    }
  }

// This function performs the registration of data to the database
  static Future<Object> regiterUser(String name, String email) async {
    try {
      final url =
          Uri.https('apibuscador.tecnologiaintegrada.mx', '/public/api/user', {
        'name': name,
        'email': email,
      });
      final response = await http.post(url);
      return response.statusCode;
    } catch (e) {
      return 'Error';
    }
  }

// This function performs data updates
  static Future update(int id, String nombre, String email) async {
    try {
      final respuesta = await http.Client().put(Uri.https(
        'apibuscador.tecnologiaintegrada.mx',
        '/public/api/user/$id',
        {
          'name': nombre,
          'email': email,
        },
      ));

      return respuesta.statusCode;
    } on Exception catch (e) {
      return false;
    }
  }

  // this funtion destroy register
  static Future<Object> deleteUser(int id) async {
    try {
      final url = Uri.https(
          'apibuscador.tecnologiaintegrada.mx', '/public/api/user/$id');
      final response = await http.delete(url);
      return response.statusCode;
    } catch (e) {
      return [];
    }
  }
}
