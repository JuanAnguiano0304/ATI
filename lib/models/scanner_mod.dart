// ignore_for_file: depend_on_referenced_packages, unnecessary_string_interpolations

import 'dart:convert';
import 'package:http/http.dart' as http;

class ScannerModelo {
  String observaciones;
  String np;
  String marca;
  String modelo;
  String digitalizador;
  String sensor;
  String rOptica;
  String fLuz;
  String rEscaneo;
  String eColor;
  String vEscaneo;
  String adf;
  String cTrabajo;
  String voltaje;
  String cEnergia;
  String software;
  String osC;
  String cAlimentador;
  String formatos;
  String twain;
  String sAlimentador;
  String conectividad;
  String puertos;
  String cCaja;
  String certificacion;
  String garantia;

  ScannerModelo({
    this.observaciones = '',
    this.np = '',
    this.marca = '',
    this.modelo = '',
    this.digitalizador = '',
    this.sensor = '',
    this.rOptica = '',
    this.fLuz = '',
    this.rEscaneo = '',
    this.eColor = '',
    this.vEscaneo = '',
    this.adf = '',
    this.cTrabajo = '',
    this.voltaje = '',
    this.cEnergia = '',
    this.software = '',
    this.osC = '',
    this.cAlimentador = '',
    this.formatos = '',
    this.twain = '',
    this.sAlimentador = '',
    this.conectividad = '',
    this.puertos = '',
    this.cCaja = '',
    this.certificacion = '',
    this.garantia = '',
  });

  Map<String, String> toJson() => {
        'observaciones': observaciones,
        'np': np,
        'marca': marca,
        'modelo': modelo,
        'digitalizador': digitalizador,
        'sensor': sensor,
        'rOptica': rOptica,
        'fLuz': fLuz,
        'rEscaneo': rEscaneo,
        'eColor': eColor,
        'vEscaneo': vEscaneo,
        'adf': adf,
        'cTrabajo': cTrabajo,
        'voltaje': voltaje,
        'cEnergia': cEnergia,
        'software': software,
        'osC': osC,
        'cAlimentador': cAlimentador,
        'formatos': formatos,
        'twain': twain,
        'sAlimentador': sAlimentador,
        'conectividad': conectividad,
        'puertos': puertos,
        'cCaja': cCaja,
        'certificacion': certificacion,
        'garantia': garantia,
      };

  static Future<dynamic> guardar(List<Map> scanners, String titulo) async {
    try {
      String enc = jsonEncode(scanners);
      final respuesta = await http.Client().post(
        Uri.http('127.0.0.1:8000', '/api/gscanner',
            {'nombre': '$titulo', 'comparador': 'scanners', 'datos': '$enc'}),
      );
      String status = respuesta.body;
      print(status);
      return status;
    } on Exception catch (e) {
      return 'error';
    }
  }

  static Future<dynamic> listascanner(String busq) async {
    try {
      final respuesta = await http.Client()
          .get(Uri.http('127.0.0.1:8000', '/api/lscanner', {'text': '$busq'}));
      String json = respuesta.body;
      var respuestaJson = jsonDecode(json);
      if (respuestaJson == null || respuestaJson.length == 0) {
        return "Sin datos";
      } else {
        List<Map<String, String>> scanner =
            List.generate(respuestaJson.length, (index) {
          return fromJson(respuestaJson[index]);
        });
        return scanner;
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
      'digitalizador': datos['digitalizador'],
      'sensor': datos['sensor'],
      'rOptica': datos['roptica'],
      'fLuz': datos['fluz'],
      'rEscaneo': datos['rescaneo'],
      'eColor': datos['ecolor'],
      'vEscaneo': datos['vescaneo'],
      'adf': datos['adf'],
      'cTrabajo': datos['ctrabajo'],
      'voltaje': datos['voltaje'],
      'cEnergia': datos['cenergia'],
      'software': datos['software'],
      'osC': datos['osc'],
      'cAlimentador': datos['calimentador'],
      'formatos': datos['formatos'],
      'twain': datos['twain'],
      'sAlimentador': datos['salimentador'],
      'conectividad': datos['conectividad'],
      'puertos': datos['puertos'],
      'cCaja': datos['ccaja'],
      'certificacion': datos['certificacion'],
      'garantia': datos['garantia']
    };
  }

  List<String> columnas = [
    'Observaciones',
    'NP',
    'Marca',
    'Modelo',
    'Tipo de Digitalizador',
    'Tipo de Sensor',
    'Resolución Óptica',
    'Fuente de Luz',
    'Resolución de Escaneo',
    'Escaneo a Color',
    'Velocidad de Escaneo',
    'ADF',
    'Ciclo de Trabajo',
    'Voltaje',
    'Consumo de Energía',
    'Software',
    'S.O Compatible',
    'Capacidad del Alimentador',
    'Formato de Digitalización',
    'Twain',
    'Soporte de Alimentador',
    'Conectividad',
    'Puertos',
    'Contenido de la Caja',
    'Certificación',
    'Garantía'
  ];
}
