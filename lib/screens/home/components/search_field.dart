import 'package:flutter/material.dart';
import '../../../constants.dart';

// Clase Product fuera de la clase SearchField (declarada en el mismo archivo)
class Product {
  final String name;
  final String icon;

  Product({required this.name, required this.icon});

  @override
  String toString() => name;
}

class SearchField extends StatefulWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  // Lista de productos simulada
  List<Product> allProducts = [
    Product(name: "Camiseta", icon: "assets/icons/tshirt.svg"),
    Product(name: "Pantalón", icon: "assets/icons/pants.svg"),
    Product(name: "Zapatos", icon: "assets/icons/shoes.svg"),
    Product(name: "Chaqueta", icon: "assets/icons/jacket.svg"),
    // Añade más productos aquí...
  ];

  // Esta lista contendrá los productos que coinciden con la búsqueda
  List<Product> searchResults = [];

  // Definimos el borde para el campo de búsqueda
  final searchOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          child: TextFormField(
            onChanged: (value) {
              // Filtra los productos que contienen el texto en cualquier parte del nombre
              setState(() {
                searchResults = allProducts
                    .where((product) =>
                        product.name.toLowerCase().contains(value.toLowerCase()))
                    .toList();
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: searchOutlineInputBorder,
              focusedBorder: searchOutlineInputBorder,
              enabledBorder: searchOutlineInputBorder,
              hintText: "Buscar producto",
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        // Mostrar los resultados de la búsqueda si los hay
        if (searchResults.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(searchResults[index].name),
                onTap: () {
                  // Aquí puedes hacer algo cuando el usuario seleccione un producto
                  print("Producto seleccionado: ${searchResults[index].name}");
                },
              );
            },
          ),
        // Si no hay resultados, mostrar mensaje
        if (searchResults.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "No se encontraron productos",
              style: TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
