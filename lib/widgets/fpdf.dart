import 'dart:convert';
import 'dart:typed_data';
import 'package:ati/utils/utilsGoogle.dart';
import 'package:ati/widgets/msgScaffold.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show AnchorElement;
import 'package:http/http.dart' as http;

class FPDF {
  pw.TableRow indiv(String col, String val1) {
    // Creación de la tabla cuando la cantidad de productos sea impar, asignándole solo 2 columnas en total
    return pw.TableRow(
      verticalAlignment: pw.TableCellVerticalAlignment.full,
      children: [
        pw.Container(
          color: PdfColors.grey500,
          child: pw.Text(
            col,
            softWrap: true,
            textAlign: pw.TextAlign.right, // Alineación a la derecha
          ),
          width: 100,
          padding: const pw.EdgeInsets.all(1.5),
        ),
        pw.Container(
          color: null,
          child: pw.Text(
            val1,
            softWrap: true,
          ),
          padding: const pw.EdgeInsets.all(1.5),
        ),
      ],
    );
  }

  pw.TableRow multi(String col, String val1, String val2, {String? val3}) {
    // Creación de la tabla cuando el número de los productos es par y se muestran 2 o 3 productos al mismo tiempo.
    return pw.TableRow(
      verticalAlignment: pw.TableCellVerticalAlignment.full,
      children: [
        pw.Container(
          color: PdfColors.grey200,
          child: pw.Text(
            col,
            softWrap: true,
            textAlign: pw.TextAlign.right, // Alineación a la derecha
          ),
          width: 135,
          padding: const pw.EdgeInsets.all(2.8),
        ),
        pw.Container(
          width: 200,
          child: pw.Text(
            val1,
            softWrap: true,
          ),
          padding: const pw.EdgeInsets.all(1.5),
        ),
        pw.Container(
          width: 200,
          color: (val3 != null && val3.toLowerCase() == 'no cumple')
              ? PdfColors.red200
              : (val3 != null && val3.toLowerCase() == 'superior')
                  ? PdfColors.lightGreen200
                  : (val3 != null && val3.toLowerCase() == 'similar')
                      ? PdfColors.blue200
                      : (val3 != null && val3.toLowerCase() == 'cumple')
                          ? PdfColors.yellow200
                          : null,
          child: pw.Text(
            val2,
            softWrap: true,
          ),
          padding: const pw.EdgeInsets.all(1.5),
        ),
        if (val3 != null)
          pw.Container(
            width: 90,
            color: (val3 != null && val3.toLowerCase() == 'no cumple')
                ? PdfColors.red200
                : (val3 != null && val3.toLowerCase() == 'superior')
                    ? PdfColors.lightGreen200
                    : (val3 != null && val3.toLowerCase() == 'similar')
                        ? PdfColors.blue200
                        : (val3 != null && val3.toLowerCase() == 'cumple')
                            ? PdfColors.yellow200
                            : null,
            child: pw.Text(
              val3,
              softWrap: true,
            ),
            padding: const pw.EdgeInsets.all(1.5),
          ),
      ],
    );
  }

  Future<void> pdf(BuildContext context, bool option, String titulo,
      String mejor, List<String> column, List<Map> equi) async {
    final font = await PdfGoogleFonts.poppinsBold(); //Fuente para el PDF.
    List<pw.Widget> items = []; // Filas
    int cC = -1;

    // Obtiene la imagen desde una URL
    final response = await http.get(Uri.parse(
        'https://i.postimg.cc/VkJ86T94/e3a287fc-e42d-45e6-b410-80f6ec7f964d.jpg'));
    final Uint8List imageData = response.bodyBytes;
    final logoImage = pw.MemoryImage(imageData);

    for (int f = 0; f < equi.length; f += 3) {
      if (f == 0) {
        items.add(
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Container(
                color: PdfColors.blue200,
                width: 15,
                height: 15,
              ),
              pw.SizedBox(width: 5),
              pw.Text(
                'Similar',
                softWrap: true,
              ),
              pw.SizedBox(width: 10),
              pw.Container(
                color: PdfColors.red200,
                width: 15,
                height: 15,
              ),
              pw.SizedBox(width: 5),
              pw.Text(
                'No cumple',
                softWrap: true,
              ),
              pw.SizedBox(width: 10),
              pw.Container(
                color: PdfColors.lightGreen200,
                width: 15,
                height: 15,
              ),
              pw.SizedBox(width: 5),
              pw.Text(
                'Superior',
                softWrap: true,
              ),
              pw.Container(
                color: PdfColors.yellow200,
                width: 15,
                height: 15,
              ),
              pw.SizedBox(width: 5),
              pw.Text(
                'Cumple',
                softWrap: true,
              ),
            ],
          ),
        );
      }
      if ((f + 2) < equi.length) {
        items.add(
          pw.Table(
            border: pw.TableBorder.all(width: 1.9),
            children: [
              ...equi[f].keys.map((e) {
                cC++;
                return multi(
                  column[cC],
                  equi[f][e].toString(),
                  equi[f + 1][e].toString(),
                  val3: equi[f + 2][e].toString(),
                );
              }).toList(),
            ],
          ),
        );
      } else if ((f + 1) < equi.length) {
        items.add(
          pw.Table(
            border: pw.TableBorder.all(width: 1.9),
            children: [
              ...equi[f].keys.map((e) {
                cC++;
                return multi(
                  column[cC],
                  equi[f][e].toString(),
                  equi[f + 1][e].toString(),
                );
              }).toList(),
            ],
          ),
        );
      } else {
        items.add(
          pw.Table(
            border: pw.TableBorder.all(width: 1.9),
            children: [
              ...equi[f].keys.map((e) {
                cC++;
                return indiv(column[cC], equi[f][e].toString());
              }).toList(),
            ],
          ),
        );
      }
      cC = -1;
      if ((f + 3) < equi.length ||
          ((f + 1) < equi.length && equi.length % 3 != 0)) {
        items.add(pw.Table(
            border: pw.TableBorder.all(),
            children: [pw.TableRow(children: [])]));
      }
    }
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        orientation: pw.PageOrientation.portrait,
        pageFormat: PdfPageFormat.a4,
        footer: (pw.Context context) {
          final int pageIndex = context.pageNumber;
          final int pageCount = context.pagesCount;
          final bool isLastPage = pageIndex == pageCount;

          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 20.0),
            child: pw.Text(
              isLastPage
                  ? 'Página $pageIndex de $pageCount'
                  : 'Página $pageIndex de $pageCount',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          );
        },
        build: (context) => [
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Comparativa: $titulo',
                      style: pw.TextStyle(font: font, fontSize: 20),
                    ),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                    top: 10), // Ajusta el valor según tus necesidades
                child: pw.Container(
                  height: 100,
                  width: 100,
                  child: pw.Image(logoImage),
                ),
              ),
            ],
          ),
          ...items,
        ],
      ),
    );
    final List<int> bytes = await pdf.save();
    if (option == true) {
      Utils().upload(bytes, titulo).whenComplete(() {
        MsgScaffold().mensaje(
          context,
          'Guardado en Drive',
          const Color.fromARGB(255, 14, 228, 10),
          150.0,
        );
      });
    } else {
      AnchorElement(
        href:
            'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}',
      )
        ..setAttribute('download', '$titulo.pdf')
        ..click();
    }
  }
}
