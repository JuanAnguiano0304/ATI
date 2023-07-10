// ignore_for_file: depend_on_referenced_packages, unnecessary_string_interpolations

import 'dart:convert';

import 'package:ati/models/impresora_mod.dart';
import 'package:ati/models/laptops_mod.dart';
import 'package:ati/models/monitor_mod.dart';
import 'package:ati/models/pantalla_mod.dart';
import 'package:ati/models/pc_mod.dart';
import 'package:ati/models/proyector_mod.dart';
import 'package:ati/models/scanner_mod.dart';
import 'package:ati/models/interactiva_mod.dart';
import 'package:http/http.dart' as http;

class ComparativoModelo {
  String id;
  String nombre;
  String comparador;

  ComparativoModelo({this.id = '', this.nombre = '', this.comparador = ''});

  static Future<dynamic> listaComparativos(String busq) async {
    try {
      final respuesta = await http.Client().get(Uri.http(
          '127.0.0.1:8000', '/api/viewcomparativos', {'text': '$busq'}));
      String respbody = respuesta.body.toString();
      List datos = jsonDecode(respbody);
      return datos;
    } catch (e) {
      return 'Error';
    }
  }

  Map<String, dynamic> columnas = {
    'impresoras': ImpresoraModelo().columnas,
    'laptops': LaptopModelo().columnas,
    'monitors': MonitorModelo().columnas,
    'pantallas': PantallaModelo().columnas,
    'pcs': PcModelo().columnas,
    'proyectors': ProyectorModelo().columnas,
    'scanners': ScannerModelo().columnas,
    'interactivas': InteractivaModelo().columnas
  };

  static Future<List<Map>> comparativoPdf(String tabla, String id) async {
    try {
      final respuesta = await http.Client().get(
        Uri.http('127.0.0.1:8000', '/api/comp$tabla', {
          'id': '$id',
        }),
      );
      String respbody = respuesta.body.toString();
      List datos = jsonDecode(respbody);
      List<Map> resp = [];
      resp.addAll(datos.map((e) {
        return e;
      }));
      return resp;
    } catch (e) {
      return [];
    }
  }
}
