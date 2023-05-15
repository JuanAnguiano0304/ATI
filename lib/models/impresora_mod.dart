// ignore_for_file: depend_on_referenced_packages, unnecessary_string_interpolations

import 'dart:convert';
import 'package:http/http.dart' as http;

class ImpresoraModelo {
  String np;
  String marca;
  String modelo;
  String color;
  String tImpresion;
  String vImpresion;
  String rImpresion;
  String ctMensual;
  String iDobleCara;
  String eMultiprop;
  String cEntrada;
  String cSalida;
  String sImpresion;
  String puertos;
  String conectividad;
  String cSO;
  String sIncluido;
  String cCaja;
  String certificacion;
  String garantia;

  ImpresoraModelo(
      {this.np = '',
      this.marca = '',
      this.modelo = '',
      this.color = '',
      this.tImpresion = '',
      this.vImpresion = '',
      this.rImpresion = '',
      this.ctMensual = '',
      this.iDobleCara = '',
      this.eMultiprop = '',
      this.cEntrada = '',
      this.cSalida = '',
      this.sImpresion = '',
      this.puertos = '',
      this.conectividad = '',
      this.cSO = '',
      this.sIncluido = '',
      this.cCaja = '',
      this.certificacion = '',
      this.garantia = ''});

  Map<String, String> toJson() => {
        'np': np,
        'marca': marca,
        'modelo': modelo,
        'color': color,
        'tImpresion': tImpresion,
        'vImpresion': vImpresion,
        'rImpresion': rImpresion,
        'ctMensual': ctMensual,
        'iDobleCara': iDobleCara,
        'eMultiprop': eMultiprop,
        'cEntrada': cEntrada,
        'cSalida': cSalida,
        'sImpresion': sImpresion,
        'puertos': puertos,
        'conectividad': conectividad,
        'cSO': cSO,
        'sIncluido': sIncluido,
        'cCaja': cCaja,
        'certificacion': certificacion,
        'garantia': garantia,
      };

  List<String> columnas = [
    'NP',
    'Marca',
    'Modelo',
    'Color',
    'Tecnología de Impresión',
    'Velocidad de Impresión',
    'Resolución de Impresión',
    'Ciclo de trabajo Mensual',
    'Impresión Doble Cara',
    'Entrada Multipropósito',
    'Capacidad de Entrada',
    'Capacidad de Salida',
    'Soporte de Impresión',
    'Puertos',
    'Conectividad',
    'Compatibilidad S.O.',
    'Software Incluido',
    'Contenido de la Caja',
    'Certificaciones',
    'Garantía'
  ];

  static Future<dynamic> guardar(
      List<Map> impresoras, String titulo, String mejor) async {
    try {
      String enc = jsonEncode(impresoras);
      final respuesta = await http.Client().post(
        Uri.https('www.apibuscador.tecnologiaintegrada.mx',
            '/public/api/gimpresora', {
          'nombre': '$titulo',
          'mejor': '$mejor',
          'comparador': 'impresoras',
          'datos': '$enc'
        }),
      );
      String status = respuesta.body;
      return status;
    } on Exception catch (e) {
      return 'error';
    }
  }

  static Future<dynamic> listaimpresora(String busq) async {
    try {
      final respuesta = await http.Client().get(Uri.https(
          'www.apibuscador.tecnologiaintegrada.mx',
          '/public/api/limpresora',
          {'text': '$busq'}));
      String json = respuesta.body;
      var respuestaJson = jsonDecode(json);
      if (respuestaJson == null || respuestaJson.length == 0) {
        return "Sin datos";
      } else {
        List<Map<String, String>> impresora =
            List.generate(respuestaJson.length, (index) {
          return fromJson(respuestaJson[index]);
        });
        return impresora;
      }
    } on Exception catch (e) {
      return [];
    }
  }

  static Map<String, String> fromJson(Map datos) {
    return {
      'np': datos['np'],
      'marca': datos['marca'],
      'modelo': datos['modelo'],
      'color': datos['color'],
      'tImpresion': datos['timpresion'],
      'vImpresion': datos['vimpresion'],
      'rImpresion': datos['rimpresion'],
      'ctMensual': datos['ctmensual'],
      'iDobleCara': datos['idoblecara'],
      'eMultiprop': datos['emultiprop'],
      'cEntrada': datos['centrada'],
      'cSalida': datos['csalida'],
      'sImpresion': datos['simpresion'],
      'puertos': datos['puertos'],
      'conectividad': datos['conectividad'],
      'cSO': datos['cso'],
      'sIncluido': datos['sincluido'],
      'cCaja': datos['ccaja'],
      'certificacion': datos['certificacion'],
      'garantia': datos['garantia'],
    };
  }
}
