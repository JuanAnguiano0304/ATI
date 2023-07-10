// ignore_for_file: depend_on_referenced_packages, unnecessary_string_interpolations

import 'dart:convert';
import 'package:http/http.dart' as http;

class InteractivaModelo {
  String observaciones;
  String np;
  String marca;
  String modelo;
  String tPantalla;
  String fIluminacion;
  String resolucion;
  String tPanel;
  String rAspecto;
  String brillo;
  String contrasteNativo;
  String aVision;
  String gColores;
  String vActualizacion;
  String tRespuesta;
  String pColor;
  String tVida;
  String orientacion;
  String tTactil;
  String pTactil;
  String resolucionTactil;
  String tRespuestaTactil;
  String soSoportado;
  String soSoportadoTactil;
  String grosor;
  String dureza;
  String rag;
  String tAnti;
  String so;
  String almacenamiento;
  String vga;
  String hdmi;
  String slot;
  String spdif;
  String powerac;
  String ethernet;
  String rs232;
  String line;
  String usbA;
  String usbB;
  String usbC;
  String microfono;
  String bocina;
  String sensorP;
  String sensorH;
  String sensorA;
  String wifi;
  String software;
  String dimensiones;
  String peso;
  String bisel;
  String vesa;
  String fAlimentacion;
  String cEnergia;
  String caracteristicas;
  String accesorios;

  InteractivaModelo(
      {this.observaciones = '',
      this.np = '',
      this.marca = '',
      this.modelo = '',
      this.tPantalla = '',
      this.fIluminacion = '',
      this.resolucion = '',
      this.tPanel = '',
      this.rAspecto = '',
      this.brillo = '',
      this.contrasteNativo = '',
      this.aVision = '',
      this.gColores = '',
      this.vActualizacion = '',
      this.tRespuesta = '',
      this.pColor = '',
      this.tVida = '',
      this.orientacion = '',
      this.tTactil = '',
      this.pTactil = '',
      this.resolucionTactil = '',
      this.tRespuestaTactil = '',
      this.soSoportado = '',
      this.soSoportadoTactil = '',
      this.grosor = '',
      this.dureza = '',
      this.rag = '',
      this.tAnti = '',
      this.so = '',
      this.almacenamiento = '',
      this.vga = '',
      this.hdmi = '',
      this.slot = '',
      this.spdif = '',
      this.powerac = '',
      this.ethernet = '',
      this.rs232 = '',
      this.line = '',
      this.usbA = '',
      this.usbB = '',
      this.usbC = '',
      this.microfono = '',
      this.bocina = '',
      this.sensorP = '',
      this.sensorH = '',
      this.sensorA = '',
      this.wifi = '',
      this.software = '',
      this.dimensiones = '',
      this.peso = '',
      this.bisel = '',
      this.vesa = '',
      this.fAlimentacion = '',
      this.cEnergia = '',
      this.caracteristicas = '',
      this.accesorios = ''});

  Map<String, String> toJson() {
    return {
      'observaciones': observaciones,
      'np': np,
      'marca': marca,
      'modelo': modelo,
      'tPantalla': tPantalla,
      'fIluminacion': fIluminacion,
      'resolucion': resolucion,
      'tPanel': tPanel,
      'rAspecto': rAspecto,
      'brillo': brillo,
      'contrasteNativo': contrasteNativo,
      'aVision': aVision,
      'gColores': gColores,
      'vActualizacion': vActualizacion,
      'tRespuesta': tRespuesta,
      'pColor': pColor,
      'tVida': tVida,
      'orientacion': orientacion,
      'tTactil': tTactil,
      'pTactil': pTactil,
      'resolucionTactil': resolucionTactil,
      'tRespuestaTactil': tRespuestaTactil,
      'soSoportado': soSoportado,
      'soSoportadoTactil': soSoportadoTactil,
      'grosor': grosor,
      'dureza': dureza,
      'rag': rag,
      'tAnti': tAnti,
      'so': so,
      'almacenamiento': almacenamiento,
      'vga': vga,
      'hdmi': hdmi,
      'slot': slot,
      'spdif': spdif,
      'powerac': powerac,
      'ethernet': ethernet,
      'rs232': rs232,
      'line': line,
      'usbA': usbA,
      'usbB': usbB,
      'usbC': usbC,
      'microfono': microfono,
      'bocina': bocina,
      'sensorP': sensorP,
      'sensorH': sensorH,
      'sensorA': sensorA,
      'wifi': wifi,
      'software': software,
      'dimensiones': dimensiones,
      'peso': peso,
      'bisel': bisel,
      'vesa': vesa,
      'fAlimentacion': fAlimentacion,
      'cEnergia': cEnergia,
      'caracteristicas': caracteristicas,
      'accesorios': accesorios,
    };
  }

  static Future<dynamic> guardar(List<Map> interactivas, String titulo) async {
    try {
      String enc = jsonEncode(interactivas);
      final respuesta = await http.Client().post(
        Uri.http('127.0.0.1:8000', '/api/ginteractiva', {
          'nombre': '$titulo',
          'comparador': 'interactivas',
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
      'observaciones': datos['observaciones'],
      'np': datos['np'],
      'marca': datos['marca'],
      'modelo': datos['modelo'],
      'tPantalla': datos['tpantalla'],
      'fIluminacion': datos['filuminacion'],
      'resolucion': datos['resolucion'],
      'tPanel': datos['tpanel'],
      'rAspecto': datos['raspecto'],
      'brillo': datos['brillo'],
      'contrasteNativo': datos['contrastenativo'],
      'aVision': datos['avision'],
      'gColores': datos['gcolores'],
      'vActualizacion': datos['vactualizacion'],
      'tRespuesta': datos['trespuesta'],
      'pColor': datos['pcolor'],
      'tVida': datos['tvida'],
      'orientacion': datos['orientacion'],
      'tTactil': datos['ttactil'],
      'pTactil': datos['ptactil'],
      'resolucionTactil': datos['resoluciontactil'],
      'tRespuestaTactil': datos['trespuestatactil'],
      'soSoportado': datos['sosoportado'],
      'soSoportadoTactil': datos['sosoportadotactil'],
      'grosor': datos['grosor'],
      'dureza': datos['dureza'],
      'rag': datos['rag'],
      'tAnti': datos['tanti'],
      'so': datos['so'],
      'almacenamiento': datos['almacenamiento'],
      'vga': datos['vga'],
      'hdmi': datos['hdmi'],
      'slot': datos['slot'],
      'spdif': datos['spdif'],
      'powerac': datos['powerac'],
      'ethernet': datos['ethernet'],
      'rs232': datos['rs232'],
      'line': datos['line'],
      'usbA': datos['usba'],
      'usbB': datos['usbb'],
      'usbC': datos['usbc'],
      'microfono': datos['microfono'],
      'bocina': datos['bocina'],
      'sensorP': datos['sensorp'],
      'sensorH': datos['sensorh'],
      'sensorA': datos['sensora'],
      'wifi': datos['wifi'],
      'software': datos['software'],
      'dimensiones': datos['dimensiones'],
      'peso': datos['peso'],
      'bisel': datos['bisel'],
      'vesa': datos['vesa'],
      'fAlimentacion': datos['falimentacion'],
      'cEnergia': datos['cenergia'],
      'caracteristicas': datos['caracteristicas'],
      'accesorios': datos['accesorios'],
    };
  }

  static Future<dynamic> listainteractiva(String busq) async {
    try {
      final respuesta = await http.Client().get(
          Uri.http('127.0.0.1:8000', '/api/linteractiva', {'text': '$busq'}));
      String json = respuesta.body;
      var respuestaJson = jsonDecode(json);
      if (respuestaJson == null || respuestaJson.length == 0) {
        return "Sin datos";
      } else {
        List<Map<String, String>> interactiva =
            List.generate(respuestaJson.length, (index) {
          return fromJson(respuestaJson[index]);
        });
        return interactiva;
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
    'Tamaño de pantalla',
    'Fuente de iluminacion',
    'Resolución',
    'Tipo de panel',
    'Relación de aspecto',
    'Brillo',
    'Contraste nativo',
    'Angulo de visión',
    'Gama de color',
    'Velocidad de actualización',
    'Tiempo de respuesta',
    'Produndidad de color',
    'Tiempo de vida/Tiempo de operación',
    'Orientacion',
    'Tecnología táctil',
    'Puntos táctiles',
    'Resolución táctil',
    'Tiemp de respuesta táctil',
    'SO soportado',
    'SO soportado táctil',
    'Grosor',
    'Dureza',
    'Recubrimiento AG',
    'Tecnología anti-gérmenes',
    'SO',
    'Memoria/Almacenamiento',
    'VGA',
    'HDMI',
    'Slot',
    'SPDIF',
    'Power AC',
    'Ethernet',
    'RS232',
    'Line in',
    'USB-A',
    'USB-B',
    'USB-C',
    'Microfono',
    'Bocina',
    'Sensor de particulas',
    'Sensor de humedad',
    'Sensor de aire',
    'WI-FI/NFC',
    'Software',
    'Dimensiones',
    'Peso',
    'Bisel',
    'Montaje Vesa',
    'Fuente de alimentación',
    'Consumo de energía',
    'Características',
    'Accesorios'
  ];
}
