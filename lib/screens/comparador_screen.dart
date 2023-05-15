import 'package:ati/screens/comparativo_screen.dart';
import 'package:ati/screens/computadora_screen.dart';
import 'package:ati/screens/impresora_screen.dart';
import 'package:ati/screens/laptop_screen.dart';
import 'package:ati/screens/monitor_screen.dart';
import 'package:ati/screens/pantalla_screen.dart';
import 'package:ati/screens/proyector_screen.dart';
import 'package:ati/screens/scanner_screen.dart';
import 'package:ati/widgets/funcionalidad.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class ComparadorScreen extends StatefulWidget {
  const ComparadorScreen({super.key});

  @override
  State<ComparadorScreen> createState() => _ComparadorScreenState();
}

class _ComparadorScreenState extends State<ComparadorScreen> {
  String selectedValue = 'Comparativos';
  final TextEditingController textEditingController = TextEditingController();
  Widget tablas() {
    if (selectedValue == 'Desktop') {
      return const Computadora();
    }
    if (selectedValue == 'Proyector') {
      return const Proyector();
    }
    if (selectedValue == 'Laptops') {
      return const LaptopScreen();
    }
    if (selectedValue == 'Monitores') {
      return const MonitorScreen();
    }
    if (selectedValue == 'Impresoras') {
      return const ImpresoraScreen();
    }
    if (selectedValue == 'Scanners') {
      return const ScannerScreen();
    }
    if (selectedValue == 'Pantallas') {
      return const PantallaScreen();
    } else {
      return const ComparativoScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: tablasCom(),
          ),
          Expanded(child: tablas()),
        ],
      ),
    );
  }

  DropdownButtonHideUnderline tablasCom() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        buttonStyleData: ButtonStyleData(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black26,
            ),
          ),
        ),
        hint: const Text('Plantillas'),
        value: selectedValue,
        isExpanded: true,
        items: Funcionalidades()
            .itemsComparativa()
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          selectedValue = value.toString();
          setState(() {});
        },
        dropdownSearchData: DropdownSearchData(
          searchController: textEditingController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: textEditingController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Busca un producto',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return (item.value.toString().contains(searchValue));
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            textEditingController.clear();
          }
        },
      ),
    );
  }
}
