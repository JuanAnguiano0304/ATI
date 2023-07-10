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
    final pchResponse =
        await http.post(Uri.parse('http://127.0.0.1:8000/api/pchonline'),
            body: jsonEncode({
              'customer': '60503',
              'key': '182385',
              'sku': searchController.text.trim(),
              'palabras_clave': searchController.text.trim(),
            }));

    if (exelResponse.statusCode == 200 &&
        glomaResponse.statusCode == 200 &&
        pchResponse.statusCode == 200) {
      final exelJsonData = json.decode(exelResponse.body);
      final glomaJsonData = json.decode(glomaResponse.body);
      final pchJsonData = json.decode(pchResponse.body);

      final exelData = exelJsonData['datos'];
      final glomaData = glomaJsonData['datos'];
      final pchData = pchJsonData['data'];

      final List<Product> productList = [];

      for (var i = 0; i < exelData.length; i++) {
        final product = Product(
          nombre: exelData[i]['nombre'],
          precio: double.parse(exelData[i]['precio']),
          almacenes: List<Map<String, dynamic>>.from(exelData[i]['almacenes']),
          referencia: exelData[i]['referencia'],
          sku: exelData[i]['sku'],
          codigoBarras: exelData[i]['codigo_barras'],
          codigoSat: exelData[i]['codigo_sat'],
          stock: int.parse(exelData[i]['stock']),
          precioOferta: double.parse(exelData[i]['precio_oferta']),
          precioSinOferta: double.parse(exelData[i]['precio_sin_oferta']),
          marcaNombre: exelData[i]['marca_nombre'],
          categoriaNombre: exelData[i]['categoria_nombre'],
          etiqueta: exelData[i]['etiqueta'],
        );

        productList.add(product);
      }

      for (var i = 0; i < glomaData.length; i++) {
        final product = Product(
          nombre: glomaData[i]['nombre'],
          precio: double.parse(glomaData[i]['precio']),
          almacenes: List<Map<String, dynamic>>.from(glomaData[i]['almacenes']),
          referencia: glomaData[i]['referencia'],
          sku: glomaData[i]['sku'],
          codigoBarras: glomaData[i]['codigo_barras'],
          codigoSat: glomaData[i]['codigo_sat'],
          stock: int.parse(glomaData[i]['stock']),
          precioOferta: double.parse(glomaData[i]['precio_oferta']),
          precioSinOferta: double.parse(glomaData[i]['precio_sin_oferta']),
          marcaNombre: glomaData[i]['marca_nombre'],
          categoriaNombre: glomaData[i]['categoria_nombre'],
          etiqueta: glomaData[i]['etiqueta'],
        );

        productList.add(product);
      }

      for (var i = 0; i < pchData.length; i++) {
        final product = Product(
          nombre: pchData[i]['nombre'],
          precio: double.parse(pchData[i]['precio']),
          almacenes: List<Map<String, dynamic>>.from(pchData[i]['almacenes']),
          referencia: pchData[i]['referencia'],
          sku: pchData[i]['sku'],
          codigoBarras: pchData[i]['codigo_barras'],
          codigoSat: pchData[i]['codigo_sat'],
          stock: int.parse(pchData[i]['stock']),
          precioOferta: double.parse(pchData[i]['precio_oferta']),
          precioSinOferta: double.parse(pchData[i]['precio_sin_oferta']),
          marcaNombre: pchData[i]['marca_nombre'],
          categoriaNombre: pchData[i]['categoria_nombre'],
          etiqueta: pchData[i]['etiqueta'],
        );

        productList.add(product);
      }

      return productList;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    products = fetchData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Combined Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: performSearch,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: products,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final productList = snapshot.data!;
                  if (productList.isEmpty) {
                    return Center(
                      child: Text('No se encontraron resultados.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      final product = productList[index];
                      return ListTile(
                        title: Text(product.nombre),
                        subtitle: Text('Precio: \$${product.precio}'),
                        trailing: Text('Stock: ${product.stock}'),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error al cargar los datos.'),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CombinedSearch(),
    theme: ThemeData(
      appBarTheme: AppBarTheme(),
    ),
  ));
}
