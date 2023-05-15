// ignore_for_file: depend_on_referenced_packages, unnecessary_string_interpolations

import 'dart:convert';
import 'package:http/http.dart' as http;

class LaptopModelo {
  String np;
  String marca;
  String modelo;
  String procesador;
  String graficos;
  String ram;
  String maxmemoria;
  String almacenamiento;
  String audio;
  String altavoces;
  String camara;
  String microfono;
  String bateria;
  String lBateria;
  String aCorriente;
  String pantalla;
  String touch;
  String teclado;
  String dimensiones;
  String peso;
  String so;
  String ethernet;
  String wlanBt;
  String puertos;
  String seguridad;
  String huella;
  String certificados;
  String pruebMil;
  String garantia;

  LaptopModelo({
    this.np = '',
    this.marca = '',
    this.modelo = '',
    this.procesador = '',
    this.graficos = '',
    this.ram = '',
    this.maxmemoria = '',
    this.almacenamiento = '',
    this.audio = '',
    this.altavoces = '',
    this.camara = '',
    this.microfono = '',
    this.bateria = '',
    this.lBateria = '',
    this.aCorriente = '',
    this.pantalla = '',
    this.touch = '',
    this.teclado = '',
    this.dimensiones = '',
    this.peso = '',
    this.so = '',
    this.ethernet = '',
    this.wlanBt = '',
    this.puertos = '',
    this.seguridad = '',
    this.huella = '',
    this.certificados = '',
    this.pruebMil = '',
    this.garantia = '',
  });

  Map<String, String> toJson() => {
        'np': np,
        'marca': marca,
        'modelo': modelo,
        'procesador': procesador,
        'graficos': graficos,
        'ram': ram,
        'maxmemoria': maxmemoria,
        'almacenamiento': almacenamiento,
        'audio': audio,
        'altavoces': altavoces,
        'camara': camara,
        'microfono': microfono,
        'bateria': bateria,
        'lBateria': lBateria,
        'aCorriente': aCorriente,
        'pantalla': pantalla,
        'touch': touch,
        'teclado': teclado,
        'dimensiones': dimensiones,
        'peso': peso,
        'so': so,
        'ethernet': ethernet,
        'wlanBt': wlanBt,
        'puertos': puertos,
        'seguridad': seguridad,
        'huella': huella,
        'cerficados': certificados,
        'pruebMil': pruebMil,
        'garantia': garantia
      };

  static Future<dynamic> guardar(
      List<Map> laptops, String titulo, String mejor) async {
    try {
      String enc = jsonEncode(laptops);
      final respuesta = await http.Client().post(
        Uri.https(
            'www.apibuscador.tecnologiaintegrada.mx', '/public/api/glaptop', {
          'nombre': '$titulo',
          'mejor': '$mejor',
          'comparador': 'laptops',
          'datos': '$enc'
        }),
      );
      String status = respuesta.body;
      return status;
    } on Exception catch (e) {
      return 'error';
    }
  }

  static Map<String, String> fromJson(Map datos) {
    return {
      'np': datos['np'],
      'marca': datos['marca'],
      'modelo': datos['modelo'],
      'procesador': datos['procesador'],
      'graficos': datos['graficos'],
      'ram': datos['ram'],
      'maxmemoria': datos['maxmemoria'],
      'almacenamiento': datos['almacenamiento'],
      'audio': datos['audio'],
      'altavoces': datos['altavoces'],
      'camara': datos['camara'],
      'microfono': datos['microfono'],
      'bateria': datos['bateria'],
      'lBateria': datos['lbateria'],
      'aCorriente': datos['acorriente'],
      'pantalla': datos['pantalla'],
      'touch': datos['touch'],
      'teclado': datos['teclado'],
      'dimensiones': datos['dimensiones'],
      'peso': datos['peso'],
      'so': datos['so'],
      'ethernet': datos['ethernet'],
      'wlanBt': datos['wlanbt'],
      'puertos': datos['puertos'],
      'seguridad': datos['seguridad'],
      'huella': datos['huella'],
      'certificados': datos['certificados'],
      'pruebMil': datos['pruebmil'],
      'garantia': datos['garantia'],
    };
  }

  static Future<dynamic> listalaptop(String busq) async {
    try {
      final respuesta = await http.Client().get(Uri.https(
          'www.apibuscador.tecnologiaintegrada.mx',
          '/public/api/llaptop',
          {'text': '$busq'}));
      String json = respuesta.body;
      var respuestaJson = jsonDecode(json);
      if (respuestaJson == null || respuestaJson.length == 0) {
        return "Sin datos";
      } else {
        List<Map<String, String>> laptop =
            List.generate(respuestaJson.length, (index) {
          return fromJson(respuestaJson[index]);
        });
        return laptop;
      }
    } on Exception catch (e) {
      return 'Error';
    }
  }

  List<String> columnas = [
    'NP',
    'Marca',
    'Modelo',
    'Procesador',
    'Gráficos',
    'RAM',
    'Max. Memoria',
    'Almacenamiento',
    'Chip de Audio',
    'Altavoces',
    'Cámara',
    'Micrófono',
    'Batería',
    'Vida de la Batería',
    'Adaptador de Corriente',
    'Pantalla',
    'Touch',
    'Teclado',
    'Dimensiones',
    'Peso',
    'Sistema Operativo',
    'Ethernet',
    'Wlan y BT',
    'Puertos',
    'Chip de Seguridad',
    'Lector de Huella',
    'Certificaciones',
    'Certificación Militar',
    'Garantía'
  ];
}
