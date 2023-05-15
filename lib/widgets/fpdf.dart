import 'dart:convert';
import 'package:ati/utils/utilsGoogle.dart';
import 'package:ati/widgets/msgScaffold.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show AnchorElement;

class FPDF {
  pw.TableRow indiv(String col, String val1) {
    //Creación de la tabla cuando la cantidad de productos sea impar, asignandole solo 2 columnas en total
    return pw.TableRow(
      verticalAlignment: pw.TableCellVerticalAlignment.full,
      children: [
        pw.Container(
          color: PdfColors.amber,
          child: pw.Text(
            col,
            softWrap: true,
          ),
          width: 40,
          padding: const pw.EdgeInsets.all(10),
        ),
        pw.Container(
          child: pw.Text(
            val1,
            softWrap: true,
          ),
          padding: const pw.EdgeInsets.all(10),
        ),
      ],
    );
  }

  pw.TableRow multi(String col, String val1, String val2) {
    //Creación de la tabla cuando el número de los productos es par y se muestran 2 productos al mismo tiempo.
    return pw.TableRow(
      verticalAlignment: pw.TableCellVerticalAlignment.full,
      children: [
        pw.Container(
          color: PdfColors.amber,
          child: pw.Text(
            col,
            softWrap: true,
          ),
          width: 40,
          padding: const pw.EdgeInsets.all(10),
        ),
        pw.Container(
          width: 90,
          child: pw.Text(
            val1,
            softWrap: true,
          ),
          padding: const pw.EdgeInsets.all(10),
        ),
        pw.Container(
          width: 90,
          child: pw.Text(
            val2,
            softWrap: true,
          ),
          padding: const pw.EdgeInsets.all(10),
        )
      ],
    );
  }

  Future<void> pdf(BuildContext context, bool option, String titulo,
      String mejor, List<String> column, List<Map> equi) async {
    final font = await PdfGoogleFonts.poppinsBold(); //Fuente para el PDF.
    List<pw.Widget> items = []; //filas
    int cC = -1;
    for (int f = 0; f < equi.length; f += 2) {
      //Verificación de que la lista de elementos es par y se mostrarán 2 elementos por tabla.
      if (f == 0) {
        items.add(
          pw.Padding(
            child: pw.Text(
              'Comparativa: $titulo',
              style: pw.TextStyle(font: font, fontSize: 20),
              softWrap: true,
            ),
            padding: const pw.EdgeInsets.all(10),
          ),
        );
        items.add(
          pw.Padding(
            child: pw.Text(
              'Equipo superior: $mejor',
              style: pw.TextStyle(font: font, fontSize: 16),
              softWrap: true,
            ),
            padding: const pw.EdgeInsets.all(10),
          ),
        );
      }
      if ((f + 1) % 2 != 0 && (f + 1) == equi.length) {
        //Verificación de que es el ultimo elemento de la lista de los productos y es impar el total.
        items.add(
          pw.Table(
              border: pw.TableBorder.all(),
              children: equi[f].keys.map((e) {
                cC++;
                return indiv(column[cC], equi[f][e].toString());
              }).toList()),
        );
      } else {
        items.add(
          pw.Table(
              border: pw.TableBorder.all(),
              children: equi[f].keys.map((e) {
                cC++;
                return multi(column[cC], equi[f][e].toString(),
                    equi[f + 1][e].toString());
              }).toList()),
        );
      }
      cC = -1;
      if ((f + 2) < equi.length ||
          ((f + 1) < equi.length && equi.length % 2 != 0)) {
        //Verificar si todavía existen elementos en la lista de productos para generar otra página
        items.add(pw.NewPage());
      }
    }
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      //Configuración horizontal de las hojas.
      orientation: pw.PageOrientation.landscape,
      pageFormat: PdfPageFormat.a4.landscape,
      build: (context) => items,
    ));
    final List<int> bytes = await pdf.save(); //Creación del archivo
    if (option == true) {
      //Verifcación si se desea subir el archivo a Drive
      Utils().upload(bytes, titulo).whenComplete(() {
        MsgScaffold().mensaje(context, 'Guardado en Drive',
            const Color.fromARGB(255, 14, 228, 10), 150.0);
      });
    } else {
      AnchorElement(
          //Descarga del PDF sin subirlo a Drive.
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', '$titulo.pdf')
        ..click();
    }
  }
}
