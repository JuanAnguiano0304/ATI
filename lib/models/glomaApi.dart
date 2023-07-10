import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final String nombre;
  final double precio;
  final List<Map<String, dynamic>> almacenes;
  final String referencia;
  final String sku;
  final String codigoBarras;
  final String codigoSat;
  final int stock;
  final double precioOferta;
  final double precioSinOferta;
  final String marcaNombre;
  final String categoriaNombre;

  Product({
    required this.nombre,
    required this.precio,
    required this.almacenes,
    required this.referencia,
    required this.sku,
    required this.codigoBarras,
    required this.codigoSat,
    required this.stock,
    required this.precioOferta,
    required this.precioSinOferta,
    required this.marcaNombre,
    required this.categoriaNombre,
  });
}

class GLomaApi extends StatefulWidget {
  @override
  _GlomaState createState() => _GlomaState();
}

class _GlomaState extends State<GLomaApi> {
  late Future<List<Product>> products;
  late TextEditingController searchController;
  String selectedSearchType = 'Palabras clave';

  void performSearch() {
    setState(() {});
    FocusScope.of(context)
        .unfocus(); // Oculta el teclado virtual después de la búsqueda
  }

  @override
  void initState() {
    super.initState();
    products = fetchData();
    searchController = TextEditingController();
  }

  Future<List<Product>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/glomaonline'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final data = jsonData['datos'];

      List<Product> productList = [];
      for (var item in data) {
        List<Map<String, dynamic>> almacenes = [];

        if (item['almacenes'] != null) {
          for (var almacen in item['almacenes']) {
            almacenes.add({
              'stock': almacen['stock'] ?? 0,
              'almacen': almacen['almacen'] ?? '',
              'almacen_clave': almacen['almacen_clave'] ?? '',
            });
          }
        }

        productList.add(
          Product(
            nombre: item['nombre'] ?? '',
            precio: double.parse(item['precio'] ?? '0'),
            almacenes: almacenes,
            referencia: item['referencia'] ?? '',
            sku: item['sku'] ?? '',
            codigoBarras: item['codigo_barras'] ?? '',
            codigoSat: item['codigo_sat'] ?? '',
            stock: int.parse(item['stock'] ?? '0'),
            precioOferta: double.parse(item['precio_oferta'] ?? '0'),
            precioSinOferta: double.parse(item['precio_sin_oferta'] ?? '0'),
            marcaNombre: item['marca_nombre'] ?? '',
            categoriaNombre: item['categoria_nombre'] ?? '',
          ),
        );
      }
      return productList;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  List<Product> filterProducts(List<Product> products, String keyword) {
    if (keyword.isEmpty) {
      return [];
    } else {
      if (selectedSearchType == 'Palabras clave') {
        return products
            .where((product) =>
                product.nombre.toLowerCase().contains(keyword.toLowerCase()) ||
                product.referencia
                    .toLowerCase()
                    .contains(keyword.toLowerCase()) ||
                product.sku.toLowerCase().contains(keyword.toLowerCase()) ||
                product.marcaNombre
                    .toLowerCase()
                    .contains(keyword.toLowerCase()) ||
                product.categoriaNombre
                    .toLowerCase()
                    .contains(keyword.toLowerCase()))
            .toList()
          ..sort((a, b) =>
              b.stock.compareTo(a.stock)); // Ordena por stock descendente
      } else if (selectedSearchType == 'SKU') {
        return products
            .where(
                (product) => product.sku.toLowerCase() == keyword.toLowerCase())
            .toList()
          ..sort((a, b) =>
              b.stock.compareTo(a.stock)); // Ordena por stock descendente
      }
      return [];
    }
  }

  void showWarehousesDialog(List<Map<String, dynamic>> warehouses) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Almacenes'),
          content: Column(
            children: [
              for (var warehouse in warehouses)
                Text(
                  '${warehouse['almacen']}: ${warehouse['stock']}',
                  style: TextStyle(fontSize: 16),
                ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  GradientColors.seaBlue[0],
                ),
              ),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void viewWarehouse(List<Map<String, dynamic>> warehouses) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Almacén'),
          content: Column(
            children: [
              for (var warehouse in warehouses)
                Text(
                  '${warehouse['almacen']}: ${warehouse['stock']}',
                  style: TextStyle(fontSize: 16),
                ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  GradientColors.seaBlue[0],
                ),
              ),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          labelText: 'Buscar en G-Loma',
                        ),
                        onSubmitted: (value) {
                          performSearch();
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButton<String>(
                      value: selectedSearchType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSearchType = newValue!;
                        });
                      },
                      items: <String>['Palabras clave', 'SKU']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: performSearch,
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: products,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Product> productList = snapshot.data!;
                    productList =
                        filterProducts(productList, searchController.text);
                    snapshot.data!.sort((a, b) => b.stock.compareTo(a.stock));

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productList[index].nombre,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Divider(
                                // Agregar un Divider debajo del título
                                color: Colors.black,
                                thickness: 1.0,
                              ),
                              Text(
                                'Precio: \$${productList[index].precio.toStringAsFixed(2)}',
                              ),
                              Text(
                                'Referencia: ${productList[index].referencia}',
                              ),
                              Text('SKU: ${productList[index].sku}'),
                              Text(
                                'Código de Barras: ${productList[index].codigoBarras}',
                              ),
                              Text(
                                'Código SAT: ${productList[index].codigoSat}',
                              ),
                              Text('Stock: ${productList[index].stock}'),
                              Text(
                                'Precio de Oferta: \$${productList[index].precioOferta.toStringAsFixed(2)}',
                              ),
                              Text(
                                'Precio sin Oferta: \$${productList[index].precioSinOferta.toStringAsFixed(2)}',
                              ),
                              Text(
                                'Marca: ${productList[index].marcaNombre}',
                              ),
                              Text(
                                'Categoría: ${productList[index].categoriaNombre}',
                              ),
                              Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  viewWarehouse(productList[index].almacenes);
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
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error al cargar los productos'),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
