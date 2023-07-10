import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class IntcomexScreen extends StatefulWidget {
  @override
  _IntcomexScreenState createState() => _IntcomexScreenState();
}

class _IntcomexScreenState extends State<IntcomexScreen> {
  final String apiKey = "2ae0c12f-36ef-4530-9483-090787f3dcf1";
  final String usuarioAcceso = "66266749-8a82-4767-9b8f-db16e44c3288";
  final String catalogUrl = "https://intcomex-prod.apigee.net/v1/getcatalog";
  final String inventoryUrl =
      "https://intcomex-prod.apigee.net/v1/getinventory";
  final String priceUrl = "https://intcomex-prod.apigee.net/v1/getpricelist";

  late String token;
  List<Product> products = [];
  List<Product> filteredProducts = [];

  final TextEditingController searchController = TextEditingController();
  final TextEditingController skuController =
      TextEditingController(); // Controlador para el campo de SKU
  late String selectedSearchType;
  late String keyword;

  @override
  void initState() {
    super.initState();
    generateToken();
    selectedSearchType = 'Palabras clave';
    keyword = '';
  }

  Future<void> generateToken() async {
    String marcaDeTiempoUtc =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());
    String claveFirma = "$apiKey,$usuarioAcceso,$marcaDeTiempoUtc";
    List<int> bytes = utf8.encode(claveFirma);
    Digest firma = sha256.convert(bytes);
    String token =
        "apiKey=$apiKey&utcTimeStamp=$marcaDeTiempoUtc&signature=${hex.encode(firma.bytes)}";

    setState(() {
      this.token = token;
    });

    await searchProducts();
    await fetchInventory();
    await fetchPrice();
  }

  Future<void> searchProducts() async {
    var response = await http.get(
      Uri.parse(catalogUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);

      List<Product> productList = [];
      for (var productData in data) {
        if (productData['Sku'] != null &&
            productData['Description'] != null &&
            productData['Type'] != null) {
          var category = productData['Category'];
          var brand = productData['Brand'];

          productList.add(
            Product(
              sku: productData['Sku'],
              description: productData['Description'],
              type: productData['Type'],
              categoryId: category != null ? category['CategoryId'] : '',
              categoryDescription:
                  category != null ? category['Description'] : '',
              manufacturerId: brand != null ? brand['ManufacturerId'] : '',
              brandId: brand != null ? brand['BrandId'] : '',
              brandDescription: brand != null ? brand['Description'] : '',
              mpn: productData['Mpn'] ?? '',
              inStock: 0,
              price: 0.0,
            ),
          );
        }
      }

      setState(() {
        products = productList;
        filteredProducts = productList;
      });
    }
  }

  void sortProductsByStock() {
    setState(() {
      filteredProducts.sort((a, b) => b.inStock.compareTo(a.inStock));
    });
  }

  Future<void> fetchInventory() async {
    var response = await http.get(
      Uri.parse(inventoryUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);

      for (var productData in data) {
        if (productData['Sku'] != null && productData['InStock'] != null) {
          var sku = productData['Sku'];
          var inStock = productData['InStock'];

          var index = products.indexWhere((product) => product.sku == sku);
          if (index != -1) {
            setState(() {
              products[index].inStock = inStock;
            });
          }
        }
        sortProductsByStock(); // Llamada a la función de ordenamiento
      }
    }
  }

  Future<void> fetchPrice() async {
    var response = await http.get(
      Uri.parse(priceUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);

      for (var productData in data) {
        if (productData['Sku'] != null && productData['Price'] != null) {
          var sku = productData['Sku'];
          var priceData = productData['Price'];
          var price = priceData['UnitPrice'].toDouble();

          var index = products.indexWhere((product) => product.sku == sku);
          if (index != -1) {
            setState(() {
              products[index].price = price;
            });
          }
        }
      }
    }
  }

  void setSelectedSearchType(String value) {
    setState(() {
      selectedSearchType = value;
    });
  }

  void search() {
    String searchTerm = searchController.text.toLowerCase();
    String skuTerm = skuController.text.toLowerCase();
    setState(() {
      keyword = searchTerm;
      if (selectedSearchType == 'SKU' && skuTerm.isNotEmpty) {
        filteredProducts = products.where((product) {
          return product.sku.toLowerCase().contains(skuTerm);
        }).toList();
      } else {
        filteredProducts = products.where((product) {
          return product.sku.toLowerCase().contains(searchTerm) ||
              product.description.toLowerCase().contains(searchTerm);
        }).toList();
      }
      sortProductsByStock(); // Llamada a la función de ordenamiento
    });
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
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Ingrese su búsqueda',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => search(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButton<String>(
                    value: selectedSearchType,
                    onChanged: (value) => setSelectedSearchType(value!),
                    items: <String>[
                      'Palabras clave',
                      'SKU'
                    ] // Agregar 'SKU' como opción
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                IconButton(
                  onPressed: search,
                  icon: Icon(Icons.search),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 2 / 2,
              children: List.generate(filteredProducts.length, (index) {
                Product product = filteredProducts[index];
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          '${product.description}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              // Agregar un Divider debajo del título
                              color: Colors.black,
                              thickness: 1.0,
                            ),
                            Text(' ',
                                style: TextStyle(
                                    color: Colors
                                        .black)), // Texto vacío con color negro
                            Text('SKU: ${product.sku}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('MPN: ${product.mpn}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('Tipo: ${product.type}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('Categoría ID: ${product.categoryId}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text(
                                'Categoría Descripción: ${product.categoryDescription}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('Fabricante ID: ${product.manufacturerId}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('Marca ID: ${product.brandId}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text(
                                'Marca Descripción: ${product.brandDescription}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('Stock: ${product.inStock}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('Precio: ${product.price}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String sku;
  final String description;
  final String type;
  final String categoryId;
  final String categoryDescription;
  final String manufacturerId;
  final String brandId;
  final String brandDescription;
  final String mpn;
  int inStock;
  double price;

  Product({
    required this.sku,
    required this.description,
    required this.type,
    required this.categoryId,
    required this.categoryDescription,
    required this.manufacturerId,
    required this.brandId,
    required this.brandDescription,
    required this.mpn,
    this.inStock = 0,
    this.price = 0.0,
  });
}
