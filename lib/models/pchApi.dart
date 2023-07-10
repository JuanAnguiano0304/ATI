import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:http/http.dart' as http;

class PchController extends StatefulWidget {
  @override
  _PchControllerState createState() => _PchControllerState();
}

enum SearchOption { SKU, PalabrasClave }

class _PchControllerState extends State<PchController> {
  List<Map<String, dynamic>> productos = [];
  String error = '';
  bool isLoading = false; // Estado de carga
  TextEditingController searchTermController = TextEditingController();
  SearchOption searchOption = SearchOption.SKU;

  Future<void> fetchProductos(String searchTerm) async {
    setState(() {
      productos = [];
      error = '';
      isLoading = true; // Activar carga
    });

    final url = 'http://127.0.0.1:8000/api/pchonline';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'customer': '60503',
          'key': '182385',
          if (searchOption == SearchOption.SKU) 'sku': searchTerm,
          if (searchOption == SearchOption.PalabrasClave)
            'palabras_clave': searchTerm,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 200) {
        final productosData = data['data']['productos'];
        if (productosData is List<dynamic> && productosData.isNotEmpty) {
          List<Map<String, dynamic>> filteredProductos = [];

          for (var producto in productosData) {
            if (searchOption == SearchOption.SKU) {
              if (producto['sku'].toString().toLowerCase() ==
                  searchTerm.toLowerCase()) {
                filteredProductos.add(producto);
              }
            } else if (searchOption == SearchOption.PalabrasClave) {
              if (producto['descripcion']
                  .toString()
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase())) {
                filteredProductos.add(producto);
              }
            }
          }

          // Ordenar los productos por stock de forma descendente
          filteredProductos.sort((a, b) {
            final inventarioA = a['inventario'].cast<Map<String, dynamic>>();
            final inventarioB = b['inventario'].cast<Map<String, dynamic>>();

            int stockA = 0;
            int stockB = 0;

            for (var item in inventarioA) {
              stockA += item['cantidad'] as int;
            }

            for (var item in inventarioB) {
              stockB += item['cantidad'] as int;
            }

            return stockB.compareTo(stockA);
          });

          setState(() {
            productos = filteredProductos;
            error = '';
            isLoading = false; // Desactivar carga
          });
        } else {
          setState(() {
            error = 'Error en la respuesta: datos de productos inválidos';
            isLoading = false; // Desactivar carga
          });
        }
      } else {
        setState(() {
          error = 'Error en la solicitud: ${data['message']}';
          isLoading = false; // Desactivar carga
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error en la solicitud: $e';
        isLoading = false; // Desactivar carga
      });
    }
  }

  void showInventario(List<Map<String, dynamic>> inventario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InventarioPage(inventario: inventario),
      ),
    );
  }

  void showAlmacen(String almacen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlmacenPage(almacen: almacen),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: searchTermController,
                        onSubmitted: (value) {
                          String searchTerm = searchTermController.text;
                          fetchProductos(searchTerm);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Buscar en PCH Mayoreo',
                          hintText: searchOption == SearchOption.SKU
                              ? 'Ingrese el SKU'
                              : 'Ingrese las palabras clave',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black),
                  ),
                  child: DropdownButton<SearchOption>(
                    value: searchOption,
                    onChanged: (value) {
                      setState(() {
                        searchOption = value!;
                      });
                    },
                    items: SearchOption.values.map((option) {
                      return DropdownMenuItem<SearchOption>(
                        value: option,
                        child: Text(option == SearchOption.SKU
                            ? 'SKU'
                            : 'Palabras Clave'),
                      );
                    }).toList(),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String searchTerm = searchTermController.text;
                    fetchProductos(searchTerm);
                  },
                  icon: Icon(Icons.search),
                ),
                IconButton(
                  tooltip:
                      'Advertencia: Algunos productos tienen precios en dolares(US)',
                  onPressed: null,
                  icon: Icon(
                    Icons.error,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                error,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          if (productos.isNotEmpty)
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  final inventario =
                      producto['inventario'].cast<Map<String, dynamic>>();
                  int stock = 0;
                  for (var item in inventario) {
                    stock += item['cantidad'] as int;
                  }
                  return GestureDetector(
                    onTap: () {
                      String almacen = producto['almacen'];
                      showAlmacen(almacen);
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${producto['descripcion']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(
                              // Agregar un Divider debajo del título
                              color: Colors.black,
                              thickness: 1.0,
                            ),
                            SizedBox(height: 8.0),
                            Text('Sku: ${producto['sku']}'),
                            Text(
                                'Sku Fabricante: ${producto['skuFabricante']}'),
                            Text('Marca: ${producto['marca']}'),
                            Text('ID de Marca: ${producto['id_marca']}'),
                            Text('ID de Serie: ${producto['id_serie']}'),
                            Text('Precio: \$${producto['precio']}'),
                            Text('Promo: ${producto['promo']}'),
                            Text('Linea: ${producto['linea']}'),
                            Text('Stock: $stock'),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                showInventario(inventario);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  GradientColors.seaBlue[0],
                                ),
                              ),
                              child: Text('Ver Almacén'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class InventarioPage extends StatelessWidget {
  final List<Map<String, dynamic>> inventario;

  InventarioPage({required this.inventario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: GradientColors.seaBlue,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: inventario.length,
        itemBuilder: (context, index) {
          final item = inventario[index];
          return ListTile(
            title: Text('${item['almacen']}'),
            subtitle: Text('Cantidad: ${item['cantidad']}'),
          );
        },
      ),
    );
  }
}

class AlmacenPage extends StatelessWidget {
  final String almacen;

  AlmacenPage({required this.almacen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Almacén'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: GradientColors.seaBlue,
            ),
          ),
        ),
      ),
      body: Center(
        child: Text(almacen),
      ),
    );
  }
}
