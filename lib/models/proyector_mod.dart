// ignore_for_file: depend_on_referenced_packages, unnecessary_string_interpolations

import 'dart:convert';
import 'package:http/http.dart' as http;

class ProyectorModelo {
  String observaciones;
  String np;
  String marca;
  String modelo;
  String sisProy;
  String lumens;
  String resNativ;
  String resAspNativ;
  String contraste;
  String color;
  String fLuz;
  String vidaLuz;
  String interfaces;
  String audio;
  String fAliment;
  String cEnergia;
  String ruido;
  String accesor;
  String dimensiones;
  String peso;
  String dProyeccion;
  String seguridad;
  String keystone;
  String zoom;
  String tempOper;
  String lente;
  String certificaciones;
  String garantia;

  ProyectorModelo(
      {this.observaciones = '',
      this.np = '',
      this.marca = '',
      this.modelo = '',
      this.sisProy = '',
      this.lumens = '',
      this.resNativ = '',
      this.resAspNativ = '',
      this.contraste = '',
      this.color = '',
      this.fLuz = '',
      this.vidaLuz = '',
      this.interfaces = '',
      this.audio = '',
      this.fAliment = '',
      this.cEnergia = '',
      this.ruido = '',
      this.accesor = '',
      this.dimensiones = '',
      this.peso = '',
      this.dProyeccion = '',
      this.seguridad = '',
      this.keystone = '',
      this.zoom = '',
      this.tempOper = '',
      this.lente = '',
      this.certificaciones = '',
      this.garantia = ''});

  Map<String, String> toJson() => {
        'observaciones': observaciones,
        'np': np,
        'marca': marca,
        'modelo': modelo,
        'sisProy': sisProy,
        'lumens': lumens,
        'resNativ': resNativ,
        'resAspNativ': resAspNativ,
        'contraste': contraste,
        'color': color,
        'fLuz': fLuz,
        'vidaLuz': vidaLuz,
        'interfaces': interfaces,
        'audio': audio,
        'fAliment': fAliment,
        'cEnergia': cEnergia,
        'ruido': ruido,
        'accesor': accesor,
        'dimensiones': dimensiones,
        'peso': peso,
        'dProyeccion': dProyeccion,
        'seguridad': seguridad,
        'keystone': keystone,
        'zoom': zoom,
        'tempOper': tempOper,
        'lente': lente,
        'certificaciones': certificaciones,
        'garantia': garantia,
      };

  static Future<dynamic> guardar(List<Map> proyectors, String titulo) async {
    try {
      String enc = jsonEncode(proyectors);
      final respuesta = await http.Client().post(
        Uri.http('127.0.0.1:8000', '/api/gproyector',
            {'nombre': '$titulo', 'comparador': 'proyectors', 'datos': '$enc'}),
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
      'sisProy': datos['sisproy'],
      'lumens': datos['lumens'],
      'resNativ': datos['resnativ'],
      'resAspNativ': datos['resaspnativ'],
      'contraste': datos['contraste'],
      'color': datos['color'],
      'fLuz': datos['fluz'],
      'vidaLuz': datos['vidaluz'],
      'interfaces': datos['interfaces'],
      'audio': datos['audio'],
      'fAliment': datos['faliment'],
      'cEnergia': datos['cenergia'],
      'ruido': datos['ruido'],
      'accesor': datos['accesor'],
      'dimensiones': datos['dimensiones'],
      'peso': datos['peso'],
      'dProyeccion': datos['dproyeccion'],
      'seguridad': datos['seguridad'],
      'keystone': datos['keystone'],
      'zoom': datos['zoom'],
      'tempOper': datos['tempoper'],
      'lente': datos['lente'],
      'certificaciones': datos['certificaciones'],
      'garantia': datos['garantia'],
    };
  }

  static Future<dynamic> listaproyector(String busq) async {
    try {
      final respuesta = await http.Client().get(
          Uri.http('127.0.0.1:8000', '/api/lproyector', {'text': '$busq'}));
      String json = respuesta.body;
      var respuestaJson = jsonDecode(json);
      if (respuestaJson == null || respuestaJson.length == 0) {
        return "Sin datos";
      } else {
        List<Map<String, String>> proyector =
            List.generate(respuestaJson.length, (index) {
          return fromJson(respuestaJson[index]);
        });
        return proyector;
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
    'Sistema de Proyección',
    'Lúmenes',
    'Resolución Nativa',
    'Aspecto Nativo',
    'Contraste',
    'Reproducción de Color',
    'Fuente de Luz',
    'Vida Útil de la Fuente de Luz',
    'Interfaces',
    'Audio',
    'Fuente de Alimentación',
    'Consumo de Energía',
    'Ruido Acústico',
    'Accesorios',
    'Dimensiones',
    'Peso',
    'Distancia de Proyección',
    'Seguridad',
    'Keystone',
    'Zoom',
    'Temperatura de Operación',
    'Lente',
    'Certificaciones',
    'Garantía'
  ];
}
