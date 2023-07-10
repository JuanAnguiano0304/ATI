// ignore_for_file: depend_on_referenced_packages, unnecessary_string_interpolations

import 'dart:convert';
import 'package:http/http.dart' as http;

class PcModelo {
  String observaciones;
  String np;
  String marca;
  String modelo;
  String procesador;
  String graficos;
  String memoriaIntegrada;
  String slotMemoria;
  String memoriaMax;
  String storage;
  String lectorSD;
  String uniOpt;
  String audio;
  String wlanBT;
  String teclado;
  String altavoz;
  String energia;
  String dimension;
  String peso;
  String puertos;
  String certific;
  String pruebMil;
  String so;
  String garantia;

  PcModelo(
      {this.observaciones = '',
      this.np = '',
      this.marca = '',
      this.modelo = '',
      this.procesador = '',
      this.graficos = '',
      this.memoriaIntegrada = '',
      this.slotMemoria = '',
      this.memoriaMax = '',
      this.storage = '',
      this.lectorSD = '',
      this.uniOpt = '',
      this.audio = '',
      this.wlanBT = '',
      this.teclado = '',
      this.altavoz = '',
      this.energia = '',
      this.dimension = '',
      this.peso = '',
      this.puertos = '',
      this.certific = '',
      this.pruebMil = '',
      this.so = '',
      this.garantia = ''});

  Map<String, String> toJson() => {
        "observaciones": observaciones,
        "np": np,
        'marca': marca,
        'modelo': modelo,
        "procesador": procesador,
        "graficos": graficos,
        "memoriaIntegrada": memoriaIntegrada,
        "slotMemoria": slotMemoria,
        "memoriaMax": memoriaMax,
        "storage": storage,
        "lectorSD": lectorSD,
        "uniOpt": uniOpt,
        "audio": audio,
        "wlanBT": wlanBT,
        "teclado": teclado,
        "altavoz": altavoz,
        "energia": energia,
        "dimension": dimension,
        "peso": peso,
        "puertos": puertos,
        "certific": certific,
        "pruebMil": pruebMil,
        "so": so,
        'garantia': garantia
      };

  static Future<dynamic> guardar(List<Map> pcs, String titulo) async {
    try {
      String enc = jsonEncode(pcs);
      final respuesta = await http.Client().post(
        Uri.http('127.0.0.1:8000', '/api/gpc',
            {'nombre': '$titulo', 'comparador': 'pcs', 'datos': '$enc'}),
      );
      String status = respuesta.body;
      return status;
    } on Exception catch (e) {
      return 'error';
    }
  }

  static Future<dynamic> listaPc(String busq) async {
    try {
      final respuesta = await http.Client()
          .get(Uri.http('127.0.0.1:8000', '/api/lpcs', {'text': '$busq'}));

      String json = respuesta.body;
      var respuestaJson = jsonDecode(json);
      if (respuestaJson == null || respuestaJson.length == 0) {
        return "Sin datos";
      } else {
        List<Map<String, String>> pc =
            List.generate(respuestaJson.length, (index) {
          return fromJson(respuestaJson[index]);
        });
        return pc;
      }
    } on Exception catch (e) {
      return 'Error';
    }
  }

  static Map<String, String> fromJson(Map datos) {
    return {
      'observaciones': datos['observaciones'],
      'np': datos['np'],
      'marca': datos['marca'],
      'modelo': datos['modelo'],
      'procesador': datos['procesador'],
      'graficos': datos['graficos'],
      'memoriaIntegrada': datos['memoriaintegrada'],
      'slotMemoria': datos['slotmemoria'],
      'memoriaMax': datos['memoriamax'],
      'storage': datos['storage'],
      'lectorSD': datos['lectorsd'],
      'uniOpt': datos['uniopt'],
      'audio': datos['audio'],
      'wlanBT': datos['wlanbt'],
      'teclado': datos['teclado'],
      'altavoz': datos['altavoz'],
      'energia': datos['energia'],
      'dimension': datos['dimension'],
      'peso': datos['peso'],
      'puertos': datos['puertos'],
      'certific': datos['certific'],
      'pruebMil': datos['pruebmil'],
      'so': datos['so'],
      'garantia': datos['garantia']
    };
  }

  List<String> columnas = [
    'Observaciones',
    'NP',
    'Marca',
    'Modelo',
    'Procesador',
    'Gráficos',
    'Memoria Integrada',
    'Slots de Memoria',
    'Memoria Máxima',
    'Almacenamiento',
    'Lector SD',
    'Unidad Óptica',
    'Chip de Audio',
    'Wlan y BT',
    'Teclado',
    'Altavoces',
    'Fuente de Alimentación',
    'Dimensiones',
    'Peso',
    'Puertos',
    'Certificaciones',
    'Pruebas militares',
    'O.S.',
    'Garantía'
  ];
}
