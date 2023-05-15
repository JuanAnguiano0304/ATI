// ignore_for_file: depend_on_referenced_packages, unnecessary_string_interpolations

import 'dart:convert';
import 'package:http/http.dart' as http;

class PantallaModelo {
  String np;
  String marca;
  String modelo;
  String tPantalla;
  String resolucion;
  String luzFondo;
  String pqi;
  String hdmi;
  String colores;
  String aVisualizacion;
  String altavoces;
  String pSalida;
  String audioBT;
  String codecAudio;
  String so;
  String tDigital;
  String sAnalogico;
  String fAlimentacion;
  String cEnergia;
  String puertos;
  String conectividad;
  String accesorios;
  String certificacion;
  String garantia;

  PantallaModelo({
    this.np = '',
    this.marca = '',
    this.modelo = '',
    this.tPantalla = '',
    this.resolucion = '',
    this.luzFondo = '',
    this.pqi = '',
    this.hdmi = '',
    this.colores = '',
    this.aVisualizacion = '',
    this.altavoces = '',
    this.pSalida = '',
    this.audioBT = '',
    this.codecAudio = '',
    this.so = '',
    this.tDigital = '',
    this.sAnalogico = '',
    this.fAlimentacion = '',
    this.cEnergia = '',
    this.puertos = '',
    this.conectividad = '',
    this.accesorios = '',
    this.certificacion = '',
    this.garantia = '',
  });

  Map<String, String> toJson() => {
        'np': np,
        'marca': marca,
        'modelo': modelo,
        'tPantalla': tPantalla,
        'resolucion': resolucion,
        'luzFondo': luzFondo,
        'pqi': pqi,
        'hdmi': hdmi,
        'colores': colores,
        'aVisualizacion': aVisualizacion,
        'altavoces': altavoces,
        'pSalida': pSalida,
        'audioBT': audioBT,
        'codecAudio': codecAudio,
        'so': so,
        'tDigital': tDigital,
        'sAnalogico': sAnalogico,
        'fAlimentacion': fAlimentacion,
        'cEnergia': cEnergia,
        'puertos': puertos,
        'conectividad': conectividad,
        'accesorios': accesorios,
        'certificacion': certificacion,
        'garantia': garantia
      };

  static Future<dynamic> guardar(
      List<Map> pantallas, String titulo, String mejor) async {
    try {
      String enc = jsonEncode(pantallas);
      final respuesta = await http.Client().post(
        Uri.https(
            'www.apibuscador.tecnologiaintegrada.mx', '/public/api/gpantalla', {
          'nombre': '$titulo',
          'mejor': '$mejor',
          'comparador': 'pantallas',
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
      'tPantalla': datos['tpantalla'],
      'resolucion': datos['resolucion'],
      'luzFondo': datos['luzfondo'],
      'pqi': datos['pqi'],
      'hdmi': datos['hdmi'],
      'colores': datos['colores'],
      'aVisualizacion': datos['avisualizacion'],
      'altavoces': datos['altavoces'],
      'pSalida': datos['psalida'],
      'audioBT': datos['audiobt'],
      'codecAudio': datos['codecaudio'],
      'so': datos['so'],
      'tDigital': datos['tdigital'],
      'sAnalogico': datos['sanalogico'],
      'fAlimentacion': datos['falimentacion'],
      'cEnergia': datos['cenergia'],
      'puertos': datos['puertos'],
      'conectividad': datos['conectividad'],
      'accesorios': datos['accesorios'],
      'certificacion': datos['certificacion'],
      'garantia': datos['garantia'],
    };
  }

  static Future<dynamic> listapantalla(String busq) async {
    try {
      final respuesta = await http.Client().get(Uri.https(
          'www.apibuscador.tecnologiaintegrada.mx',
          '/public/api/lpantalla',
          {'text': '$busq'}));
      String json = respuesta.body;
      var respuestaJson = jsonDecode(json);
      if (respuestaJson == null || respuestaJson.length == 0) {
        return "Sin datos";
      } else {
        List<Map<String, String>> pantalla =
            List.generate(respuestaJson.length, (index) {
          return fromJson(respuestaJson[index]);
        });
        return pantalla;
      }
    } on Exception catch (e) {
      return 'Error';
    }
  }

  List<String> columnas = [
    'NP',
    'Marca',
    'Modelo',
    'Tamaño Pantalla',
    'Resolución',
    'Luz de Fondo',
    'PQI',
    'HDMI',
    'Colores',
    'Ángulo de Visualización',
    'Altavoces',
    'Potencia de Salida',
    'Audio Bluetooth',
    'Codec de Audio',
    'Sistema Operativo',
    'Transmisión Digital',
    'Sintonizador Análogico',
    'Fuente de Alimentación',
    'Consumo de Energía',
    'Puertos',
    'Conectividad',
    'Accesorios',
    'Certificación',
    'Garantía',
  ];
}
