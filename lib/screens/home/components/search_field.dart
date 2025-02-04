import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shop_app/models/producto.dart';
import 'package:shop_app/services/api_service.dart';

class SearchField extends StatefulWidget {
  final String? selectedCategory; // Recibimos la categoría seleccionada

  const SearchField({Key? key, this.selectedCategory}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  List<Producto> searchResults = [];
  bool isLoading = false;
  String message = '';
  final ApiService _apiService = ApiService();

  void _onSearchChanged(String query) async {
    setState(() {
      isLoading = true;
      message = '';
    });

    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      return;
    }

    try {
      final results = await _apiService.searchProducts(query);

      if (widget.selectedCategory != null && widget.selectedCategory != 'Todas las categorías') {
        // Buscar el codtipoproducto de la categoría seleccionada
        final selectedCategoryCode = widget.selectedCategory;

        final filteredResults = results.where((producto) {
          // Compara codtipoproducto del producto con la categoría seleccionada
          return producto.codtipoproducto == selectedCategoryCode;
        }).toList();

        if (filteredResults.isEmpty) {
          setState(() {
            message = 'No se encontraron productos para esta categoría';
            searchResults = [];
          });
        } else {
          setState(() {
            searchResults = filteredResults;
          });
        }
      } else {
        // Mostrar todos los productos si no hay filtro
        setState(() {
          searchResults = results;
        });
      }
    } catch (e) {
      setState(() {
        searchResults = [];
        isLoading = false;
        message = 'Error al cargar los productos';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            hintText: "Buscar producto",
            prefixIcon: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.search),
          ),
        ),
        if (message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(message, style: TextStyle(color: Colors.red)),
          ),
        if (searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                )
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final producto = searchResults[index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('Costo: \$${producto.costo}'),
                  onTap: () {
                    print('Seleccionado: ${producto.nombre}');
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}