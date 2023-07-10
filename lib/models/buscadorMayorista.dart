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
  final String etiqueta;

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
    required this.etiqueta,
  });
}

class CombinedSearch extends StatefulWidget {
  @override
  _CombinedSearchState createState() => _CombinedSearchState();
}

class _CombinedSearchState extends State<CombinedSearch> {
  late Future<List<Product>> products;
  late TextEditingController searchController;
  int currentPage = 1;
  int totalPages = 1;

  void performSearch() {
    setState(() {
      currentPage =
          1; // Reiniciar la página actual al realizar una nueva búsqueda
      products = searchData();
    });
    FocusScope.of(context).unfocus();
  }

  Future<List<Product>> searchData() async {
    final searchText = searchController.text.trim();
    final filteredProducts = await fetchData(); // Obtener todos los productos

    if (searchText.isEmpty) {
      // Si no se ha ingresado ningún texto de búsqueda, retornar todos los productos
      return filteredProducts;
    }

    // Filtrar productos por palabras clave (nombre o referencia)
    return filteredProducts
        .where((product) =>
            product.nombre.toLowerCase().contains(searchText.toLowerCase()) ||
            product.referencia
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            product.sku.toLowerCase().contains(searchText.toLowerCase()) ||
            product.marcaNombre
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            product.categoriaNombre
                .toLowerCase()
                .contains(searchText.toLowerCase()))
        .toList();
  }

  Future<List<Product>> fetchData() async {
    final exelResponse =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/glomaonline'));
    final glomaResponse =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/exelonline'));

    if (exelResponse.statusCode == 200 && glomaResponse.statusCode == 200) {
      final exelJsonData = json.decode(exelResponse.body);
      final glomaJsonData = json.decode(glomaResponse.body);

      final exelData = exelJsonData['datos'];
      final glomaData = glomaJsonData['datos'];

      List<Product> productList = [];

      for (var item in exelData) {
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
            etiqueta: 'G-LOMA',
          ),
        );
      }

      for (var item in glomaData) {
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
            etiqueta: 'EXEL',
          ),
        );
      }

      return productList;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void goToNextPage() {
    if (currentPage < totalPages) {
      setState(() {
        currentPage++;
      });
    }
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    products = fetchData();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Ingrese su búsqueda.',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                      onSubmitted: (value) {
                        performSearch();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                IconButton(
                  onPressed: () {
                    performSearch();
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: products,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No se encontraron productos'));
                } else {
                  // Sort products by stock in descending order
                  snapshot.data!.sort((a, b) => b.stock.compareTo(a.stock));

                  // Pagination
                  final itemsPerPage = 12;
                  final totalItems = snapshot.data!.length;
                  totalPages = (totalItems / itemsPerPage).ceil();

                  final startIndex = (currentPage - 1) * itemsPerPage;
                  final endIndex = startIndex + itemsPerPage;
                  final visibleProducts = snapshot.data!.sublist(startIndex,
                      endIndex > totalItems ? totalItems : endIndex);

                  return SingleChildScrollView(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: visibleProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final product = visibleProducts[index];
                        return Card(
                          child: InkWell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.nombre,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(' '),
                                Text(
                                  product.etiqueta,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('SKU: ${product.sku}'),
                                Text('Stock: ${product.stock}'),
                                Text(
                                    'Precio: \$${product.precio.toStringAsFixed(2)}'),
                                Text('Referencia: ${product.referencia}'),
                                Text(
                                    'Código de barras: ${product.codigoBarras}'),
                                Text('Código SAT: ${product.codigoSat}'),
                                Text(
                                    'Precio de oferta: \$${product.precioOferta.toStringAsFixed(2)}'),
                                Text(
                                    'Precio sin oferta: \$${product.precioSinOferta.toStringAsFixed(2)}'),
                                Text('Nombre de marca: ${product.marcaNombre}'),
                                Text(
                                    'Nombre de categoría: ${product.categoriaNombre}'),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    viewWarehouse(product.almacenes);
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
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: goToPreviousPage,
                style: ElevatedButton.styleFrom(
                  primary: GradientColors.seaBlue[0],
                  onPrimary: Colors.white,
                ),
                child: Icon(Icons.arrow_back),
              ),
              SizedBox(width: 8.0),
              Text('$currentPage de $totalPages'),
              SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: goToNextPage,
                style: ElevatedButton.styleFrom(
                  primary: GradientColors.seaBlue[0],
                  onPrimary: Colors.white,
                ),
                child: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Combined Search',
    home: CombinedSearch(),
  ));
}
