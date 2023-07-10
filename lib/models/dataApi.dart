import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataScreen extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<DataScreen> {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  String selectedSearchType = 'Palabras Clave';
  List<String> searchTypes = ['Palabras Clave', 'Código DCM'];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    run();
  }

  Future<void> run() async {
    try {
      final url = 'http://127.0.0.1:8000/api/productos';

      final headers = {
        'Content-Type': 'application/json',
      };

      final requestData = {
        "servicio": "OutCatalogos",
        "metodo": "getListaProductos",
        "dataIn": {
          "itemCat": "PRODUCTOS",
          "limit": "9999999999999",
          "init": "0",
          "order": "0",
          "search": "",
          "especial": "",
          "itemImgsT": "4"
        }
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final itemList = jsonData['data'] as Map<String, dynamic>;

        final List<dynamic> fetchedProducts = itemList.values.toList();

        setState(() {
          products = fetchedProducts;
          filteredProducts = products;
          sortProductsByInventory(); // Ordenar los productos por inventario
        });
      } else {
        throw Exception('Error en la solicitud');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void sortProductsByInventory() {
    filteredProducts.sort((a, b) => b['inventario'].compareTo(a['inventario']));
  }

  void filterProducts(String keyword) {
    setState(() {
      if (selectedSearchType == 'Palabras Clave') {
        filteredProducts = products
            .where((product) => product['descripcionEnEspanyol']
                .toLowerCase()
                .contains(keyword.toLowerCase()))
            .toList();
      } else if (selectedSearchType == 'Código DCM') {
        filteredProducts = products
            .where((product) => product['codigoDCM']
                .toLowerCase()
                .contains(keyword.toLowerCase()))
            .toList();
      }

      sortProductsByInventory(); // Ordenar los productos por inventario
    });
  }

  void changeSearchType(String type) {
    setState(() {
      selectedSearchType = type;
      filterProducts('');
    });
  }

  void showProductDetails(dynamic product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product['descripcionEnEspanyol']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Código DCM: ${product['codigoDCM']}'),
                Text('ID Marca: ${product['id_marca']}'),
                Text('Marca: ${product['Marca']}'),
                Text('Modelo: ${product['modelo']}'),
                Text('Precio: ${product['precio']}'),
                Text('Inventario: ${product['inventario']}'),
                Text('Resumen: ${product['resumen']}'),
                Text('Features: ${product['features']}'),
                Text('Especificaciones: ${product['especificaciones']}'),
                Text('Dimensiones: ${product['dimensiones']}'),
                Text('Peso: ${product['peso']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
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

  void performSearch() {
    final keyword = _searchController.text;
    filterProducts(keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => performSearch(),
                    decoration: InputDecoration(
                      labelText: 'Buscar en DataComponents',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButton<String>(
                    value: selectedSearchType,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        changeSearchType(newValue);
                      }
                    },
                    items: searchTypes.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: performSearch,
                ),
                IconButton(
                  tooltip: 'Advertencia: Todos los precios son en dolares(US)',
                  onPressed: null,
                  icon: Icon(
                    Icons.error,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (BuildContext context, int index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () => showProductDetails(product),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['descripcionEnEspanyol'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 8.0),
                          Divider(
                            color: Colors.black,
                            thickness: 1.0,
                          ),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: 'Código DCM: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '${product['codigoDCM']}'),
                              ],
                            ),
                          ),
                          Text(' '),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: 'ID Marca: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '${product['id_marca']}'),
                              ],
                            ),
                          ),
                          Text(' '),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: 'Marca: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '${product['Marca']}'),
                              ],
                            ),
                          ),
                          Text(' '),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: 'Modelo: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '${product['modelo']}'),
                              ],
                            ),
                          ),
                          Text(' '),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: 'Precio: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '\$${product['precio']}'),
                              ],
                            ),
                          ),
                          Text(' '),
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: 'Inventario: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: '${product['inventario']}'),
                              ],
                            ),
                          ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () => showProductDetails(product),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                GradientColors.seaBlue[0],
                              ),
                            ),
                            child: Text('Ver detalles'),
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
