// ignore_for_file: depend_on_referenced_packages, unnecessary_string_interpolations

import 'dart:convert';
import 'package:http/http.dart' as http;

class MonitorModelo {
  String observaciones;
  String np;
  String marca;
  String modelo;
  String tPantalla;
  String tAreaActiva;
  String panel;
  String rAspecto;
  String resolucion;
  String aVisualizacion;
  String tRespuesta;
  String colores;
  String factualizacion;
  String brillo;
  String contrasteE;
  String gColores;
  String antirreflejante;
  String curvatura;
  String inclinacion;
  String camara;
  String microfono;
  String altavoces;
  String touch;
  String cEnergia;
  String alimentacion;
  String aEnergia;
  String dimensiones;
  String peso;
  String certificaciones;
  String soC;
  String puertos;
  String accesorios;
  String garantia;

  MonitorModelo(
      {this.observaciones = '',
      this.np = '',
      this.marca = '',
      this.modelo = '',
      this.tPantalla = '',
      this.tAreaActiva = '',
      this.panel = '',
      this.rAspecto = '',
      this.resolucion = '',
      this.aVisualizacion = '',
      this.tRespuesta = '',
      this.colores = '',
      this.factualizacion = '',
      this.brillo = '',
      this.contrasteE = '',
      this.gColores = '',
      this.antirreflejante = '',
      this.curvatura = '',
      this.inclinacion = '',
      this.camara = '',
      this.microfono = '',
      this.altavoces = '',
      this.touch = '',
      this.cEnergia = '',
      this.alimentacion = '',
      this.aEnergia = '',
      this.dimensiones = '',
      this.peso = '',
      this.certificaciones = '',
      this.soC = '',
      this.puertos = '',
      this.accesorios = '',
      this.garantia = ''});

  Map<String, String> toJson() => {
        'observaciones': observaciones,
        'np': np,
        'marca': marca,
        'modelo': modelo,
        'tPantalla': tPantalla,
        'tAreaActiva': tAreaActiva,
        'panel': panel,
        'rAspecto': rAspecto,
        'resolucion': resolucion,
        'aVisualizacion': aVisualizacion,
        'tRespuesta': tRespuesta,
        'colores': colores,
        'factualizacion': factualizacion,
        'brillo': brillo,
        'contrasteE': contrasteE,
        'gColores': gColores,
        'antirreflejante': antirreflejante,
        'curvatura': curvatura,
        'inclinacion': inclinacion,
        'camara': camara,
        'microfono': microfono,
        'altavoces': altavoces,
        'touch': touch,
        'cEnergia': cEnergia,
        'alimentacion': alimentacion,
        'aEnergia': aEnergia,
        'dimensiones': dimensiones,
        'peso': peso,
        'certificaciones': certificaciones,
        'soC': soC,
        'puertos': puertos,
        'accesorios': accesorios,
        'garantia': garantia
      };

  static Future<dynamic> guardar(List<Map> monitors, String titulo) async {
    try {
      String enc = jsonEncode(monitors);
      final respuesta = await http.Client().post(
        Uri.http('127.0.0.1:8000', '/api/gmonitor',
            {'nombre': '$titulo', 'comparador': 'monitors', 'datos': '$enc'}),
      );
      String status = respuesta.body;
      return status;
    } on Exception catch (e) {
      return 'error';
    }
  }

  static Map<String, String> fromJson(Map datos) {
    return {
      'observaciones': datos['observaciones'],
      'np': datos['np'],
      'marca': datos['marca'],
      'modelo': datos['modelo'],
      'tPantalla': datos['tpantalla'],
      'tAreaActiva': datos['tareaactiva'],
      'panel': datos['panel'],
      'rAspecto': datos['rAspecto'],
      'resolucion': datos['resolucion'],
      'aVisualizacion': datos['avisualizacion'],
      'tRespuesta': datos['trespuesta'],
      'colores': datos['colores'],
      'factualizacion': datos['factualizacion'],
      'brillo': datos['brillo'],
      'contrasteE': datos['contraste'],
      'gColores': datos['gcolores'],
      'antirreflejante': datos['antirreflejante'],
      'curvatura': datos['curvatura'],
      'inclinacion': datos['inclinacion'],
      'camara': datos['camara'],
      'microfono': datos['microfono'],
      'altavoces': datos['altavoces'],
      'touch': datos['touch'],
      'cEnergia': datos['cenergia'],
      'alimentacion': datos['alimentacion'],
      'aEnergia': datos['aenergia'],
      'dimensiones': datos['dimensiones'],
      'peso': datos['peso'],
      'certificaciones': datos['certificaciones'],
      'soC': datos['soc'],
      'puertos': datos['puertos'],
      'accesorios': datos['accesorios'],
      'garantia': datos['garantia'],
    };
  }

  static Future<dynamic> listamonitor(String busq) async {
    try {
      final respuesta = await http.Client()
          .get(Uri.http('127.0.0.1:8000', '/api/lmonitor', {'text': '$busq'}));
      String json = respuesta.body;
      var respuestaJson = jsonDecode(json);
      if (respuestaJson == null || respuestaJson.length == 0) {
        return "Sin datos";
      } else {
        List<Map<String, String>> monitor =
            List.generate(respuestaJson.length, (index) {
          return fromJson(respuestaJson[index]);
        });
        return monitor;
      }
    } on Exception catch (e) {
      return 'Error';
    }
  }

  List<String> columnas = [
    'Observaciones',
    'NP',
    'Marca',
    'Modelo',
    'T. Pantalla',
    'T. Área Activa',
    'Panel',
    'Relación de Aspecto',
    'Resolución',
    'Ángulo de Visualización',
    'Tiempo de Respuesta',
    'Soporte de Colores',
    'Frecuencia de Actualización',
    'Brillo',
    'Contraste',
    'Gama de Colores',
    'Antirreflejante',
    'Curvatura',
    'Inclinación',
    'Cámara',
    'Microfóno',
    'Altavoces',
    'Touch',
    'Consumo de Energía',
    'Alimentación de Energía',
    'Adaptador de Energía',
    'Dimensiones',
    'Peso',
    'Certificaciones',
    'Compatibilidad S.O.',
    'Puertos',
    'Accesorios',
    'Garantía'
  ];
}
