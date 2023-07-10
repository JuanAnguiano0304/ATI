import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String authToken =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImNiZDA5OGEzMWU3NGY3Nzc0NThiNzQwN2IxZDRmNzIzYzE0MTRmOGM0MmZjYzI0NTc5NGRlOTRmMWE1ZGY2NjMyMDkxYTA0OWY4OWQ4ZTlhIn0.eyJhdWQiOiI1WGNGRXNWa1F2NTdqY01ITGR5bGtzM1ROVXlhdHk2cSIsImp0aSI6ImNiZDA5OGEzMWU3NGY3Nzc0NThiNzQwN2IxZDRmNzIzYzE0MTRmOGM0MmZjYzI0NTc5NGRlOTRmMWE1ZGY2NjMyMDkxYTA0OWY4OWQ4ZTlhIiwiaWF0IjoxNjgzNjczNjkxLCJuYmYiOjE2ODM2NzM2OTEsImV4cCI6MTcxNTIwOTY5MSwic3ViIjoiIiwic2NvcGVzIjpbXX0.MnMJ8kXUzewuclehZ5MPRS1A8GXXDOK8T-aZoU9s4c97a543ODQpcgRYQ1mvmUZ8WeEJzcL8yDfrgTyD8WjLL0BVt7DtLHYvJV0WEmbf0cxnDRwbRE0wamW1pfVo9HkCef8xa0VfwDvF3Xuhp-YpK1H1LIlM-Uf8j1olUKyWjF_NvPb51BA3sa-vdJN9v8TTd3V6PGhbW54A_bTxOHF5QclQwwdsulwYjuaSivXb7MNQh7UhvxgxXlYjJ3s-11owvxjuGNyQd1CuYvdQk_rLS4EEfRR-zMEm0Ko5DQpk4ZoBVA_y1DXn_ObFivolrFSHuqPyISKakR84QBJwf0hrq1sx3ppe3jGhAuTAGdTNDGTKmI35CXw8lssj2QXolL3pdzZUrNVeGKjQ55DHZw7ba_X9uz3GyxRg7FeX9xCwpIMqtn5muAksF5kebDLeUN1WCgZ5Uvtp-bz7wkr8PbyBkMmcQrbs5MVhw9bFoYMOth4hjWpJanRUHefjW94mo5_TwPxiVwVsN9FshZRUGRJm-YahaRAs9cwFrZAw83ofIQEDlbckRveSbTOgHysTtSrSnUiAnC8B8EawYZfUqXFWXG0L6XgeGqewbLkMRFOJvazLHnAYT3pV01UibqlpOFurMj5fDrO5BAJiLvpESKDhueTghUZECFYl4yvLDu1zB80';

class Product {
  final String title;
  final String brand;
  final double price;
  final List<String> features;
  final String model;
  final int totalExistence;
  final String coverImage;
  final double specialPrice;
  final double discountPrice;
  final String satKey;

  Product({
    required this.title,
    required this.brand,
    required this.price,
    required this.features,
    required this.model,
    required this.totalExistence,
    required this.coverImage,
    required this.specialPrice,
    required this.discountPrice,
    required this.satKey,
  });
}

class ProductSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar productos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                navigateToSearchScreen(context);
              },
              child: const Text('Buscar'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToSearchScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SyscomBuscadorScreen(),
      ),
    );
  }
}

class SyscomBuscadorScreen extends StatefulWidget {
  @override
  _ProductSearchFormScreenState createState() =>
      _ProductSearchFormScreenState();
}

class _ProductSearchFormScreenState extends State<SyscomBuscadorScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Product> searchResults = [];
  String _searchType = 'Palabra clave';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar en Syscom',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        String searchQuery = _searchController.text;
                        if (searchQuery.isNotEmpty) {
                          performProductSearch(searchQuery);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: _searchType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    style: TextStyle(color: Colors.black),
                    onChanged: (String? newValue) {
                      setState(() {
                        _searchType = newValue!;
                      });
                    },
                    items: <String>[
                      'Palabra clave',
                      'Categoría',
                      'Marca',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    String searchQuery = _searchController.text;
                    if (searchQuery.isNotEmpty) {
                      performProductSearch(searchQuery);
                    }
                  },
                ),
                IconButton(
                  tooltip:
                      'Advertencia: Algunos precios descuentos suelen ser diferentes al de la página. (Esto es un problema de parte de SYSCOM)',
                  onPressed: null,
                  icon: Icon(
                    Icons.error,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : searchResults.isEmpty
                      ? Center(
                          child: Text('Sin resultados'),
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final availableWidth = constraints.maxWidth;
                            final itemWidth = (availableWidth - 30.0) /
                                3; // Calcula el ancho del cuadro (considerando el espacio entre ellos)

                            return SingleChildScrollView(
                              child: Wrap(
                                spacing:
                                    10.0, // Espacio horizontal entre los cuadros
                                runSpacing:
                                    10.0, // Espacio vertical entre los cuadros
                                children: List.generate(searchResults.length,
                                    (index) {
                                  Product product = searchResults[index];
                                  return GestureDetector(
                                    onTap: () {
                                      // Manejar el evento de pulsación en el producto (searchResults[index])
                                    },
                                    child: Container(
                                      width: itemWidth, // Ancho del cuadro
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 100, // Altura de la imagen
                                            width: double
                                                .infinity, // Ancho máximo de la imagen
                                            child: Image.network(
                                              product.coverImage,
                                              fit: BoxFit
                                                  .cover, // Ajustar la imagen al contenedor
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.title,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Divider(
                                                  // Agregar un Divider debajo del título
                                                  color: Colors.black,
                                                  thickness: 1.0,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style,
                                                    children: [
                                                      TextSpan(
                                                        text: 'Marca: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              '${product.brand}\n'),
                                                      TextSpan(
                                                          text:
                                                              '\n'), // Espacio adicional
                                                      TextSpan(
                                                        text: 'Modelo: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              '${product.model}\n'),
                                                      TextSpan(text: '\n'),
                                                      TextSpan(
                                                        text: 'Codigo sat: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              '${product.satKey}\n'),
                                                      TextSpan(text: '\n'),
                                                      TextSpan(
                                                        text: 'Precio: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'MXN ${product.price.toStringAsFixed(2)}\n',
                                                      ),
                                                      TextSpan(text: '\n'),
                                                      TextSpan(
                                                        text:
                                                            'Precio Especial: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'MXN ${product.specialPrice.toStringAsFixed(2)}\n',
                                                      ),
                                                      TextSpan(text: '\n'),
                                                      TextSpan(
                                                        text:
                                                            'Precio Descuentos: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'MXN ${product.discountPrice.toStringAsFixed(2)}\n',
                                                      ),
                                                      TextSpan(text: '\n'),
                                                      TextSpan(
                                                        text:
                                                            'Existencia Total: ',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              '${product.totalExistence}\n'),
                                                      TextSpan(text: '\n'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void performProductSearch(String searchQuery) {
    String baseUrl = 'https://developers.syscom.mx/api/v1';
    String endpoint = '/productos';
    String tipoCambioUrl = 'https://developers.syscom.mx/api/v1/tipocambio';

    // Construir los parámetros de búsqueda
    Map<String, String> queryParams = {
      'busqueda': searchQuery,
    };
    setState(() {
      isLoading = true;
    });

    // Realizar la solicitud HTTP GET para obtener el tipo de cambio
    http.get(Uri.parse(tipoCambioUrl),
        headers: {'Authorization': 'Bearer $authToken'}).then((response) {
      if (response.statusCode == 200) {
        var tipoCambioJson = jsonDecode(response.body);
        if (tipoCambioJson != null && tipoCambioJson['normal'] != null) {
          // Obtener el tipo de cambio normal y preferencial como números decimales
          double tipoCambioNormal =
              double.tryParse(tipoCambioJson['normal']) ?? 0.0;
          double tipoCambioPreferencial =
              double.tryParse(tipoCambioJson['preferencial']) ?? 0.0;

          // Realizar la solicitud HTTP GET para obtener los productos
          Uri uri = Uri.parse(baseUrl + endpoint);
          uri = uri.replace(queryParameters: queryParams);

          http.get(uri, headers: {'Authorization': 'Bearer $authToken'}).then(
            (response) {
              if (response.statusCode == 200) {
                var jsonResponse = jsonDecode(response.body);
                if (jsonResponse != null && jsonResponse['productos'] != null) {
                  List<Product> results = [];

                  for (var productData in jsonResponse['productos']) {
                    List<String> features = [];
                    if (productData['caracteristicas'] != null) {
                      for (var feature in productData['caracteristicas']) {
                        if (feature != null && feature['nombre'] != null) {
                          features.add(feature['nombre']);
                        }
                      }
                    }

                    double price = productData['precios']['precio_lista'] !=
                            null
                        ? double.tryParse(productData['precios']['precio_lista']
                                .toString()) ??
                            0.0
                        : 0.0;

                    // Calcular el precio en MXM utilizando el tipo de cambio normal
                    double priceMXM = price * tipoCambioNormal;

                    String model = productData['modelo'] ?? '';
                    int totalExistence = productData['total_existencia'] ?? 0;
                    String coverImage = productData['img_portada'] ?? '';
                    double specialPrice =
                        productData['precios']['precio_especial'] != null
                            ? double.tryParse(productData['precios']
                                        ['precio_especial']
                                    .toString()) ??
                                0.0
                            : 0.0;

                    double specialPriceMXM = specialPrice * tipoCambioNormal;

                    double discountPrice =
                        productData['precios']['precio_descuento'] != null
                            ? double.tryParse(productData['precios']
                                        ['precio_descuento']
                                    .toString()) ??
                                0.0
                            : 0.0;

                    // Calcular el precio de descuento en MXM utilizando el tipo de cambio preferencial
                    double discountPriceMXM =
                        discountPrice * tipoCambioPreferencial;

                    String satKey = productData['sat_key'] ?? '';

                    Product product = Product(
                      title: productData['titulo'] ?? '',
                      brand: productData['marca'] ?? '',
                      price: priceMXM,
                      features: features,
                      model: model,
                      totalExistence: totalExistence,
                      coverImage: coverImage,
                      specialPrice: specialPriceMXM,
                      discountPrice: discountPriceMXM,
                      satKey: satKey,
                    );

                    results.add(product);
                  }

                  // Ordenar los resultados por existencia total en orden descendente
                  results.sort(
                      (a, b) => b.totalExistence.compareTo(a.totalExistence));

                  setState(() {
                    searchResults = results;
                    isLoading =
                        false; // Set isLoading to false after receiving search results
                  });
                }
              } else {
                print(
                    'Error en la solicitud de productos: ${response.statusCode}');
                setState(() {
                  isLoading = false; // Set isLoading to false in case of error
                });
              }
            },
          ).catchError((error) {
            print('Error en la solicitud de productos: $error');
            setState(() {
              isLoading = false; // Set isLoading to false in case of error
            });
          });
        } else {
          print('Error en la obtención del tipo de cambio');
          setState(() {
            isLoading = false; // Set isLoading to false in case of error
          });
        }
      } else {
        print(
            'Error en la solicitud de tipo de cambio: ${response.statusCode}');
        setState(() {
          isLoading = false; // Set isLoading to false in case of error
        });
      }
    }).catchError((error) {
      print('Error en la solicitud de tipo de cambio: $error');
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    });
  }
}
